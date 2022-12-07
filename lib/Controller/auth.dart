import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  AuthenticationService(this._firebaseAuth);

  CollectionReference loginCollection =
      FirebaseFirestore.instance.collection('loginAudit');

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> addLoginAudit(
      String name, String email, String phone, String role) {
    return loginCollection.add({
      'date': new DateTime.now().toString(),
      'name': name,
      'email': email,
      'phone': phone,
      'role': role
    });
  }
}
