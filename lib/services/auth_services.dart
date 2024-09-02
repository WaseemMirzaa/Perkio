// ignore_for_file: unused_local_variable, unused_catch_clause

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:swipe_app/core/utils/constants/app_const.dart';
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
  Future<String?> signUp(UserModel userModel,) async {
    try {
      await auth.createUserWithEmailAndPassword(email: userModel.email!, password: userModel.password!);
      User? user = auth.currentUser;
      if (user != null) {
        await setValue(SharedPrefKey.uid ,user.uid);
      }
      return user!.uid; // Sign-up success, return null
    } on FirebaseAuthException catch (e) {
      return null ;
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