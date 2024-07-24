import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skhickens_app/core/utils/constants/constants.dart';

class AuthServices {
  final auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //............ SignIn
  Future<String?> signIn(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = auth.currentUser;
      if (user != null) {
        await _saveUserDataToPreferences(user.uid);
      }
      return null; // Sign-in success, return null
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'An error occurred during sign-in';
    }
  }

  //............ SignUp
  Future<String?> signUp(String email, String password, String userName, String phone) async {
    try {
      await auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = auth.currentUser;
      if (user != null) {
        await _saveUserDataToPreferences(user.uid);
      }
      return null; // Sign-up success, return null
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'An error occurred during sign-up';
    }
  }

  //............ Save To Pref
  Future<void> _saveUserDataToPreferences(String userId) async {
    DocumentSnapshot userDoc = await firestore.collection('users').doc(userId).get();
    if (userDoc.exists) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(UserKey.USERID, userId);
      await prefs.setBool(UserKey.ISUSER, userData[UserKey.ISUSER]);
    }
  }

  //............ LogOut
  Future<void> logOut() async {
    await auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(UserKey.USERID);
    await prefs.remove(UserKey.ISUSER);
  }
}