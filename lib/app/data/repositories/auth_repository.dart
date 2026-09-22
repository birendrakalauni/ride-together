import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

    await credential.user?.updateDisplayName(
      name,
    ); //save name in Firebase Auth.

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

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> googleLogin() async {
    await GoogleSignIn.instance.initialize(
      serverClientId: dotenv.env['GOOGLE_SERVER_CLIENT_ID'],
    );
    final GoogleSignInAccount googleUser = await GoogleSignIn.instance
        .authenticate(); //1. Google authentication

    final GoogleSignInAuthentication googleAuth = googleUser.authentication; //2

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    ); //3. Get Google ID token

    await _auth.signInWithCredential(credential); //4
  }

  Future<UserCredential> signInWithFacebook() async {
    //Trigger the sign in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();
    //Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential('${loginResult.accessToken?.tokenString}');
    //Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }


  Future<String> getUserName(String uid) async {
    final snapshot = await _databaseReference
        .child('${FirebasePaths.users}/$uid')
        .get();

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      return data['name'] ?? 'Rider';
    }
    return 'Rider';
  }
}
