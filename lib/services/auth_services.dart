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
  Future<String?> signIn(String email, String password) async {
    try {
      // Sign in the user
      await auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = auth.currentUser;

      if (user != null) {
        // Get the FCM token
        String? fcmToken = await FCMManager.getFCMToken();

        // Update the user's FCM token list in Firestore
        DocumentReference userDocRef =
            firestore.collection('users').doc(user.uid);

        // Add the token to the list (using arrayUnion to avoid duplicates)
        await userDocRef.update({
          'fcmTokens': FieldValue.arrayUnion([fcmToken])
        });

        print('FCM token added to user document');
      }

      return null; // Sign-in success, return null
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
