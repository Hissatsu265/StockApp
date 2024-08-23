import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;
  User? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> signUp(String email, String password) async {
    setLoading(true);
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } finally {
      setLoading(false);
    }
  }

  User? get currentUser => _auth.currentUser;

  Future<void> sendEmailVerification() async {
    var user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<void> signIn(String email, String password) async {
    setLoading(true);
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } finally {
      setLoading(false);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }
}
