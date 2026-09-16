import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ride_together/app/core/constants/firebase_paths.dart';
import 'package:ride_together/app/data/models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _databaseReference = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: FirebasePaths.databaseUrl,
  ).ref(); // same for all(Realtime db)

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    ); // actual firebase authentication operation.
  }

  Future<UserCredential> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ); // Firebase creates the authentication account.

    final uid = credential.user!.uid; // firebase creates unique id for the user

    final profile = UserModel(
      id: uid,
      name: name,
      email: email,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    await _databaseReference
        .child('${FirebasePaths.users}/$uid')
        .set(profile.toMap()); // save profile to realtime database

    return credential;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
