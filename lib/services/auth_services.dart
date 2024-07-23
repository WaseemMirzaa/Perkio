import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthServices {
  final auth = FirebaseAuth.instance;
  final snap = FirebaseFirestore.instance;

  Future<String?> signIn(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      // Perform additional checks or actions if needed

      return null; // Sign-in success, return null
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('error message ${e.message}');
      }
      return e.message ?? 'An error occurred during sign-in';
    }
  }

  Future<String?> signUp(String email, String password, String userName, String phone) async {
    try {
      await auth.createUserWithEmailAndPassword(email: email, password: password);
      // Perform additional checks or actions if needed

      return null; // Sign-up success, return null
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('error message ${e.message}');
      }
      return e.message ?? 'An error occurred during sign-up';
    }
  }
}