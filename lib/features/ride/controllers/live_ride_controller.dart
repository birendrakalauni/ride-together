import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:ride_together/app/core/constants/app_constants.dart';
import 'package:ride_together/app/core/services/location_service.dart';
import 'package:ride_together/app/data/models/ride_member_model.dart';
import 'package:ride_together/app/data/models/rider_location_model.dart';
import 'package:ride_together/app/data/repositories/location_repository.dart';
import 'package:ride_together/app/data/repositories/ride_repository.dart';

enum TrackingResult { started, gpsDisabled, denied, deniedForever, failed }

class LiveRideController extends GetxController {
  LiveRideController(this.rideId);
  final String rideId;

  final LocationService _locationService = LocationService();
  final LocationRepository _locationRepository = LocationRepository();
  final RideRepository _rideRepository = RideRepository();

  final RxBool isTracking = false.obs;
  final Rx<Position?> currentPosition = Rx<Position?>(null);
  final RxList<RiderLocationModel> riderLocations = <RiderLocationModel>[].obs;
  final RxMap<String, RideMemberModel> members =
      <String, RideMemberModel>{}.obs;

  StreamSubscription<Position>? _positionSub;
  StreamSubscription<List<RiderLocationModel>>? _locationsSub;
  StreamSubscription<List<RideMemberModel>>? _membersSub;
  Timer? _heartbeat;

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  @override
  void onInit() {
    super.onInit();
    _listenToLocations();
    _listenToMembers();
  }

  void _listenToLocations() {
    _locationsSub?.cancel();
    _locationsSub = _locationRepository
        .listenToRideLocations(rideId)
        .listen(
          (list) => riderLocations.assignAll(list),
          onError: (e) => debugPrint('Location listener error: $e'),
        );
  }

  void _listenToMembers() {
    _membersSub?.cancel();
    _membersSub = _rideRepository
        .listenToMembers(rideId)
        .listen(
          (list) => members.assignAll({for (final m in list) m.userId: m}),
          onError: (e) => debugPrint('Members listener error: $e'),
        );
  }

  Future<TrackingResult> startTracking() async {
    if (isTracking.value) return TrackingResult.started;

    if (!await _locationService.isLocationServiceEnabled()) {
      return TrackingResult.gpsDisabled;
    }

    final permission = await _locationService.requestPermission();

    if (permission == LocationPermission.deniedForever) {
      return TrackingResult.deniedForever;
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.unableToDetermine) {
      return TrackingResult.denied;
    }

    try {
      _handlePosition(await _locationService.getCurrentLocation());

      _positionSub = _locationService.startLocationTracking().listen(
        _handlePosition,
        onError: (e) => debugPrint('Position stream error: $e'),
      );

      _heartbeat = Timer.periodic(
        const Duration(seconds: AppConstants.heartbeatIntervalSeconds),
        (_) {
          final last = currentPosition.value;
          if (last != null) _upload(last);
        },
      );
      isTracking.value = true;
      return TrackingResult.started;
    } catch (e) {
      debugPrint('startTracking failed: $e');
      stopTracking();
      return TrackingResult.failed;
    }
  }

  void stopTracking() {
    _positionSub?.cancel();
    _positionSub = null;
    _heartbeat?.cancel();
    _heartbeat = null;
    isTracking.value = false;
  }

  void _handlePosition(Position position) {
    currentPosition.value = position;
    _upload(position);
  }

  Future<void> _upload(Position p) async {
    final uid = _uid;
    if (uid == null) return;
    try {
      await _locationRepository.updateLocation(
        rideId,
        RiderLocationModel(
          userId: uid,
          latitude: p.latitude,
          longitude: p.longitude,
          accuracy: p.accuracy,
          speed: p.speed,
          heading: p.heading,
          updatedAt: DateTime.now().millisecondsSinceEpoch,
        ),
      );
    } catch (e) {
      debugPrint('Location upload failed: $e');
    }

    @override
    void onClose() {
      stopTracking();
      _locationsSub?.cancel();
      _membersSub?.cancel();
      super.onClose();
    }
  }
}
