import 'package:firebase_auth/firebase_auth.dart';
import 'package:princee/helper/helper_function.dart';
import 'package:princee/service/database_service.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // Login function
  Future loginWithUserNameandPassword(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      )).user!;

      // If the user is successfully authenticated, call DatabaseService to update the user data
      return true;
        } on FirebaseAuthException catch (e) {
      // If there's an error during the authentication process, return the error message
      return e.message;
    }
  }

  // Register function
  Future registerUserWithEmailandPassword(
      String fullName, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      )).user!;

      // If the user is successfully registered, call DatabaseService to save user data
      await DatabaseService(uid: user.uid).savingUserData(fullName, email);
      return true;
        } on FirebaseAuthException catch (e) {
      // If there's an error during the registration process, return the error message
      return e.message;
    }
  }

  // Log Out function
  Future signOut() async {
    try {
      // Clear user login status and user data from shared preferences
      await HelperFunction.saveUserLoggedInStatus(false);
      await HelperFunction.saveUserEmailSF("");
      await HelperFunction.saveUserNameSF("");

      // Sign out from Firebase authentication
      await firebaseAuth.signOut();
    } catch (e) {
      // If there's an error during the sign-out process, return null
      return null;
    }
  }
}
