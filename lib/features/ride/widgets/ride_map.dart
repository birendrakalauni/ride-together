import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:ride_together/app/core/constants/app_colors.dart';
import 'package:ride_together/app/core/utils/rider_status.dart';
import 'package:ride_together/features/ride/controllers/live_ride_controller.dart';
import 'package:ride_together/features/ride/widgets/rider_marker.dart';

class RideMap extends StatelessWidget {
  const RideMap({
    super.key,
    required this.controller,
    required this.mapController,
    required this.onMapReady,
  });

  final LiveRideController controller;
  final MapController mapController;
  final VoidCallback onMapReady;

  static const LatLng _defaultCenter = LatLng(27.7172, 85.3240);

  List<Marker> _buildMarkers() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final markers = <Marker>[];

    for (final rider in controller.riders) {
      if (rider.isMe) continue;

      final location = rider.location;
      if (location == null) continue;

      // final member = controller.members[rider.userId];

      markers.add(
        Marker(
          point: LatLng(location.latitude, location.longitude),
          width: 150,
          height: 76,
          child: RiderMarker(
            name: rider.name,
            isCurrentUser: false,
            isLeader: rider.isLeader,
            heading: location.speed > 1 ? location.heading : 0,
          ),
        ),
      );
    }
    final position = controller.currentPosition.value;
    if (position != null) {
      markers.add(
        Marker(
          point: LatLng(position.latitude, position.longitude),
          width: 150,
          height: 76,
          child: RiderMarker(
            name: 'You',
            isCurrentUser: true,
            isLeader: controller.members[uid]?.role == 'leader',
            status: RiderStatus.online,
            heading: position.speed > 1 ? position.heading : 0,
          ),
        ),
      );
    }
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: _defaultCenter,
          initialZoom: 13,
          onMapReady: onMapReady,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.ride_together',
          ),
          Obx(() => MarkerLayer(markers: _buildMarkers())),

          SimpleAttributionWidget(
            source: Text(
              '',
              style: TextStyle(
                color: AppColors.darkNavy,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: Colors.white.withValues(alpha: 0.85),
          ),
        ],
      ),
    );
  }
}
