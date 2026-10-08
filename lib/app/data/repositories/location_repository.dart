import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ride_together/app/core/constants/firebase_paths.dart';
import 'package:ride_together/app/data/models/rider_location_model.dart';

class LocationRepository {
  final DatabaseReference _databaseReference = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: FirebasePaths.databaseUrl,
  ).ref();

  Future<void> updateLocation(
    String rideId,
    RiderLocationModel location,
  ) async {
    await _databaseReference
        .child('${FirebasePaths.rideLocations(rideId)}/${location.userId}')
        .set(location.toMap());
  }

  Stream<List<RiderLocationModel>> listenToRideLocations(String rideId) {
    return _databaseReference
        .child(FirebasePaths.rideLocations(rideId))
        .onValue
        .map((event) {
          final value = event.snapshot.value;
          if (value == null) return <RiderLocationModel>[];
          final map = Map<dynamic, dynamic>.from(value as Map);
          return map.values
              .map(
                (v) =>
                    RiderLocationModel.fromMap(Map<dynamic, dynamic>.from(v)),
              )
              .toList();
        });
  }

  Future<void> removeLocation(String rideId, String userId) async {
    await _databaseReference
        .child('${FirebasePaths.rideLocations(rideId)}/$userId')
        .remove();
  }

  Future<void> clearRideLocations(String rideId) async {
    await _databaseReference
        .child(FirebasePaths.rideLocations(rideId))
        .remove();
  }
}
