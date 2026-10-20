import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:ride_together/app/data/models/ride_member_model.dart';
import 'package:ride_together/app/data/models/ride_model.dart';
import 'package:ride_together/app/data/repositories/auth_repository.dart';
import 'package:ride_together/app/data/repositories/ride_repository.dart';

class RideController extends GetxController {
  final RideRepository _rideRepository = RideRepository();
  final AuthRepository _authRepository = AuthRepository();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<RideModel?> createRide({
    required String name,
    String? destination,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || isLoading.value) return null;

    errorMessage.value = '';
    if (name.trim().isEmpty) {
      errorMessage.value = 'Please enter a ride name.';
      return null;
    }

    isLoading.value = true;
    try {
      final creatorName = await _authRepository.getUserName(user.uid);
      final trimmedDestination = destination?.trim();

      return await _rideRepository.createRide(
        name: name.trim(),
        destination: (trimmedDestination == null || trimmedDestination.isEmpty)
            ? null
            : trimmedDestination,
        creatorId: user.uid,
        creatorName: creatorName,
      );
    } catch (e) {
      errorMessage.value = 'Failed to create ride. Please try again.';
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<RideModel?> joinRide(String code) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || isLoading.value) return null;

    errorMessage.value = '';
    if (code.trim().isEmpty) {
      errorMessage.value = 'Please enter a ride code.';
      return null;
    }

    isLoading.value = true;
    try {
      final userName = await _authRepository.getUserName(user.uid);
      return await _rideRepository.joinRide(
        rideCode: code.trim().toUpperCase(),
        userId: user.uid,
        userName: userName,
      );
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception', '');
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Stream<RideModel?> listenToRide(String rideId) =>
      _rideRepository.listenToRide(rideId);

  Stream<List<RideMemberModel>> listenToMembers(String rideId) =>
      _rideRepository.listenToMembers(rideId);

  Future<void> startRide(String rideId, {required bool isLeader}) async {
    if (!isLeader) return;
    await _rideRepository.updateRideStatus(rideId, 'active');
  }

  Stream<String?> listenToActiveRideId(String uid) => _rideRepository.listenToActiveRideId(uid);
}
