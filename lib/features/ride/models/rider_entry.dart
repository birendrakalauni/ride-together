// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ride_together/app/core/utils/rider_status.dart';
import 'package:ride_together/app/data/models/rider_location_model.dart';

class RiderEntry {
  final String userId;
  final String name;
  final bool isLeader;
  final bool isMe;
  final RiderLocationModel? location;
  final double? distanceMeters;
  final RiderStatus status;
  final int secondsSinceUpdate;

  const RiderEntry({
    required this.userId,
    required this.name,
    required this.isLeader,
    required this.isMe,
    required this.location,
    required this.distanceMeters,
    required this.status,
    required this.secondsSinceUpdate,
  });
}
