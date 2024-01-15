import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  User? getCurrentUser() {
    return firebaseAuth.currentUser;
  }

  Future<UserCredential> signInWithEmailPassword(String email, password) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      firebaseFirestore.collection("Users").doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': userCredential.user!.email,
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<UserCredential> signUpWithEmailPassword(String email, password) async {
    try {
      // create user in firestore authentication
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // save user info in firestore database

      firebaseFirestore.collection("Users").doc(userCredential.user!.uid).set(
        {
          'uid': userCredential.user!.uid,
          'email': userCredential.user!.email,
        },
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> signOut() async {
    return await firebaseAuth.signOut();
  }
}
