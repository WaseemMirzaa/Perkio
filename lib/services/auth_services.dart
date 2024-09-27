// ignore_for_file: unused_local_variable, unused_catch_clause

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:swipe_app/core/utils/constants/constants.dart';
import 'package:swipe_app/models/user_model.dart';

class AuthServices {
  final auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //............ SignIn
  Future<String?> signIn(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = auth.currentUser;
      return null; // Sign-in success, return null
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'An error occurred during sign-in';
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

  //............ LogOut
  Future<void> logOut() async {
    await auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(UserKey.USERID);
    await prefs.remove(UserKey.ROLE);
  }
}
