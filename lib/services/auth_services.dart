// ignore_for_file: unused_local_variable, unused_catch_clause

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:swipe_app/core/utils/constants/constants.dart';
import 'package:swipe_app/models/user_model.dart';
import 'package:swipe_app/services/fcm_manager.dart';

class AuthServices {
  final auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //............ SignIn
  Future<String?> signIn(String email, String password, bool isUser) async {
    try {
      // Attempt to sign in the user
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Fetch the user document from Firestore to check the role
        DocumentSnapshot userDoc =
            await firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          String userRole = (userDoc.data() as Map<String, dynamic>)['role'];

          // Check the role based on isUser value
          if (isUser) {
            if (userRole == 'business') {
              // isUser is true, role is business - do not authenticate
              return 'User does not have permission to access as a regular user.';
            } else if (userRole == 'user') {
              // isUser is true, role is user - authenticate
              String? fcmToken = await FCMManager.getFCMToken();

              // Update the user's FCM token list in Firestore
              await userDoc.reference.update({
                'fcmTokens': FieldValue.arrayUnion([fcmToken])
              });

              print('FCM token added to user document');
              return null; // Sign-in success, return null
            }
          } else {
            // isUser is false
            if (userRole == 'business') {
              // isUser is false, role is business - authenticate
              String? fcmToken = await FCMManager.getFCMToken();

              // Update the user's FCM token list in Firestore
              await userDoc.reference.update({
                'fcmTokens': FieldValue.arrayUnion([fcmToken])
              });

              print('FCM token added to user document');
              return null; // Sign-in success, return null
            } else if (userRole == 'user') {
              // isUser is false, role is user - do not authenticate
              return 'User does not have permission to access as a business.';
            }
          }
        } else {
          return 'Sign-in failed: User not found.';
        }
      }
      return 'Sign-in failed: User not found.';
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'An error occurred during sign-in';
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow; // Throw the error so it can be handled in the controller
    }
  }

  //............ SignUp
  Future<String?> signUp(UserModel userModel) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userModel.email!,
        password: userModel.password!,
      );
      return userCredential
          .user?.uid; // Return the user's UID on successful sign up
    } on FirebaseAuthException catch (e) {
      // Throw the FirebaseAuthException, so the caller can handle it
      rethrow; // Important: Rethrow the exception so it can be handled by the caller
    } catch (e) {
      // Throw an unknown error exception if something unexpected happens
      throw Exception('Unknown error occurred during sign-up');
    }
  }

  //logout
  Future<void> logOut() async {
    try {
      User? currentUser = auth.currentUser;
      if (currentUser != null) {
        String userId = currentUser.uid;

        DocumentReference userDocRef =
            firestore.collection('users').doc(userId);

        // Directly using the stored FCM token
        String? fcmToken = FCMManager.fcmToken;

        print('Current FCM Token: $fcmToken');

        // Check if the fcmToken is available
        if (fcmToken != null && fcmToken.isNotEmpty) {
          await userDocRef.update({
            'fcmTokens': FieldValue.arrayRemove([fcmToken])
          });
          print('FCM token removed from user document');
        } else {
          print('FCM token is null or empty, cannot remove.');
        }
      }

      // Sign out the user
      await auth.signOut();

      // Clear shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(UserKey.USERID);
      await prefs.remove(UserKey.ROLE);
      print('User signed out successfully');
    } catch (e) {
      print('Error during logout: $e');
    }
  }
}
