import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:ride_together/app/data/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<bool> login({required String email, required String password}) async {
    if (isLoading.value) return false;
    errorMessage.value = '';
    isLoading.value = true;

    try {
      await _authRepository.login(
        email: email.trim(),
        password: password,
      ); //request to repo.
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage.value = _mapAuthError(e);
      return false;
    } catch (e) {
      errorMessage.value = 'Something went wrong. Please try again.';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (isLoading.value) return false;
    errorMessage.value = '';

    if (password != confirmPassword) {
      errorMessage.value = 'Passwords do not match.';
      return false;
    }

    if (name.trim().isEmpty) {
      errorMessage.value = 'Please enter your name.';
      return false;
    }

    isLoading.value = true;

    try {
      await _authRepository.register(
        name: name.trim(),
        email: email.trim(),
        password: password,
      ); // call auth repo.
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage.value = _mapAuthError(e);
      return false;
    } catch (e) {
      errorMessage.value = 'Something went wrong. Please try again.';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  //sendPasswordReset
  Future<bool> sendPasswordReset(String email) async {
    if (isLoading.value) return false;
    errorMessage.value = '';
    isLoading.value = true;

    try {
      await _authRepository.sendPasswordResetEmail(email.trim());
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage.value = _mapAuthError(e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with that email.';

      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';

      case 'email-already-in-use':
        return 'An account already exists with that email.';

      case 'invalid-email':
        return 'Please enter a valid email address.';

      case 'weak-password':
        return 'Password should be at least 8 characters.';

      case 'network-request-failed':
        return 'No internet connection';

      default:
        return e.message ?? 'Authentication failed.';
    }
  }
}
