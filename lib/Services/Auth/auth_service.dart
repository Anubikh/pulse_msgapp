import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Sign In
  Future<UserCredential> signInWithEmailPassword(String email, String password,
      [String? username]) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // If username is not provided, fetch it from Firestore
      if (username == null || username.isEmpty) {
        DocumentSnapshot userDoc = await _firestore
            .collection("Users")
            .doc(userCredential.user!.uid)
            .get();
        if (userDoc.exists) {
          username = userDoc.get("username");
        }
      }

      // Update or ensure the username is stored in Firestore
      await _firestore.collection("Users").doc(userCredential.user!.uid).set({
        "uid": userCredential.user!.uid,
        "email": email,
        "username": username,
      }, SetOptions(merge: true));

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "An error occurred during sign in");
    }
  }

  // Sign Up
  Future<UserCredential> signUpWithEmailPassword(
      String email, String password, String username) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user info in a separate doc
      await _firestore.collection("Users").doc(userCredential.user!.uid).set({
        "uid": userCredential.user!.uid,
        "email": email,
        "username": username,
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "An error occurred during sign up");
    }
  }

  // Sign Out
  Future<void> signOut() async {
    return await _auth.signOut();
  }

  // Get current user
  Future<String?> getCurrentUserUsername() async {
    final user = getCurrentUser();
    if (user != null) {
      final userData = await FirebaseFirestore.instance
          .collection("Users")
          .doc(user.uid)
          .get();
      return userData.data()?['username'];
    } else {
      return null;
    }
  }
}
