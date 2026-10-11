import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:ride_together/app/core/constants/app_colors.dart';
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

    for (final rider in controller.riderLocations) {
      if (rider.userId == uid) continue;

      final member = controller.members[rider.userId];

      markers.add(
        Marker(
          point: LatLng(rider.latitude, rider.longitude),
          width: 150,
          height: 76,
          child: RiderMarker(
            name: member?.name ?? 'Rider',
            isCurrentUser: false,
            isLeader: member?.role == 'leader',
            heading: rider.speed > 1 ? rider.heading : 0,
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
            heading: position.speed > 1 ? position.heading : 0,
          ),
        ),
      );
    }
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
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

        Padding(
          padding: const EdgeInsets.all(8),
          child: SimpleAttributionWidget(
            source: Text(
              'OpenStreetMap contributors',
              style: TextStyle(
                color: AppColors.secondaryText,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: Colors.white.withValues(alpha: 0.08),
            alignment: Alignment.bottomRight,
          ),
        ),
      ],
    );
  }
}
