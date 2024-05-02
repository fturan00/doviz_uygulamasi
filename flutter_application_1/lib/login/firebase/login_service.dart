import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<User?> signIn(String email, String password) async {
    var userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<User?> createAccount(
    String email,
    String password,
    String name,
  ) async {
    var userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    await _firebaseFirestore
        .collection("Account")
        .doc(userCredential.user!.uid)
        .set({
      "email": email,
      "password": password,
      "username": name,
    });

    return userCredential.user;
  }
}
