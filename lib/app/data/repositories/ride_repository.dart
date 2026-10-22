import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ride_together/app/core/constants/firebase_paths.dart';
import 'package:ride_together/app/data/models/ride_member_model.dart';
import 'package:ride_together/app/data/models/ride_model.dart';

class RideRepository {
  final DatabaseReference _databaseReference = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: FirebasePaths.databaseUrl,
  ).ref();

  Future<String> _generateUniqueRideCode() async {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = Random();

    while (true) {
      final code = List.generate(
        6,
        (_) => chars[random.nextInt(chars.length)],
      ).join();
      final snapshot = await _databaseReference
          .child('${FirebasePaths.rides}/$code')
          .get();

      if (!snapshot.exists) return code;
    }
  }

  Future<RideModel> createRide({
    required String name,
    String? destination,
    required String creatorId,
    required String creatorName,
  }) async {
    final code = await _generateUniqueRideCode();
    final now = DateTime.now().millisecondsSinceEpoch;

    final ride = RideModel(
      id: code,
      name: name,
      destination: destination,
      createdBy: creatorId,
      status: 'waiting',
      createdAt: now,
    );

    await _databaseReference
        .child('${FirebasePaths.rides}/$code')
        .set(ride.toMap());

    await _databaseReference
        .child('${FirebasePaths.rides}/$code/members/$creatorId')
        .set({'name': creatorName, 'role': 'leader', 'joinedAt': now});

    await _databaseReference
        .child('${FirebasePaths.users}/$creatorId/activeRideId')
        .set(code);

    return ride;
  }

  Future<RideModel> joinRide({
    required String rideCode,
    required String userId,
    required String userName,
  }) async {
    final rideSnapshot = await _databaseReference
        .child('${FirebasePaths.rides}/$rideCode')
        .get();

    if (!rideSnapshot.exists) {
      throw Exception('Ride not found. Check the code and try again.');
    }

    final ride = RideModel.fromMap(
      rideCode,
      Map<String, dynamic>.from(rideSnapshot.value as Map),
    );

    if (ride.status == 'ended') {
      throw Exception('This ride has already ended.');
    }

    final memberSnapshot = await _databaseReference
        .child('${FirebasePaths.rides}/$rideCode/members/$userId')
        .get();
    if (memberSnapshot.exists) {
      throw Exception('You are already joined this ride.');
    }

    await _databaseReference
        .child('${FirebasePaths.rides}/$rideCode/members/$userId')
        .set({
          'name': userName,
          'role': 'member',
          'joinedAt': DateTime.now().millisecondsSinceEpoch,
        });
    await _databaseReference
        .child('${FirebasePaths.users}/$userId/activeRideId')
        .set(rideCode);
    return ride;
  }

  Stream<RideModel?> listenToRide(String rideId) {
    return _databaseReference
        .child('${FirebasePaths.rides}/$rideId')
        .onValue
        .map((event) {
          final value = event.snapshot.value;

          if (value == null) return null;

          return RideModel.fromMap(
            rideId,
            Map<String, dynamic>.from(value as Map),
          );
        });
  }

  Stream<List<RideMemberModel>> listenToMembers(String rideId) {
    return _databaseReference
        .child('${FirebasePaths.rides}/$rideId/members')
        .onValue
        .map((event) {
          final value = event.snapshot.value;
          if (value == null) return <RideMemberModel>[];
          final map = Map<String, dynamic>.from(value as Map);
          return map.entries
              .map(
                (e) => RideMemberModel.fromMap(
                  e.key,
                  Map<String, dynamic>.from(e.value as Map),
                ),
              )
              .toList();
        });
  }

  Future<void> updateRideStatus(String rideId, String status) async {
    final updates = <String, dynamic>{'status': status};

    if (status == 'active') {
      updates['startedAt'] = DateTime.now().microsecondsSinceEpoch;
    } else if (status == 'ended') {
      updates['endedAt'] = DateTime.now().microsecondsSinceEpoch;
    }
    await _databaseReference
        .child('${FirebasePaths.rides}/$rideId')
        .update(updates);
  }

  Stream<String?> listenToActiveRideId(String userId) {
    return _databaseReference
        .child('${FirebasePaths.users}/$userId/activeRideId')
        .onValue
        .map((event) => event.snapshot.value as String?);
  }

  Future<void> endRide(String rideId) async {
    final now = DateTime.now().microsecondsSinceEpoch;
    await _databaseReference.update({
      '${FirebasePaths.rides}/$rideId/status': 'ended',
      '${FirebasePaths.rides}/$rideId/endedAt': now,
      FirebasePaths.rideLocations(rideId): null,
    });
  }

  Future<void> clearActiveRide(String userId) async {
    await _databaseReference
        .child('${FirebasePaths.users}/$userId/activeRideId')
        .remove();
  }
}
