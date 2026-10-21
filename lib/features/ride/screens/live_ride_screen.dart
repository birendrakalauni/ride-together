import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:ride_together/app/core/constants/app_colors.dart';
import 'package:ride_together/features/home/widgets/button_navigation_bar.dart';
import 'package:ride_together/features/ride/controllers/live_ride_controller.dart';
import 'package:ride_together/features/ride/models/rider_entry.dart';
import 'package:ride_together/features/ride/widgets/ride_map.dart';
import 'package:ride_together/features/ride/widgets/rider_list.dart';

class LiveRideScreen extends StatefulWidget {
  const LiveRideScreen({super.key, required this.rideId});

  final String rideId;

  @override
  State<LiveRideScreen> createState() => _LiveRideScreenState();
}

class _LiveRideScreenState extends State<LiveRideScreen> {
  late final LiveRideController controller;
  final MapController mapController = MapController();

  bool _mapReady = false;
  bool _hasFitted = false;

  Worker? _locationsWorker;
  Worker? _positionWorker;

  @override
  void initState() {
    super.initState();

    controller = Get.put(LiveRideController(widget.rideId), tag: widget.rideId);

    _locationsWorker = ever(controller.riderLocations, (_) => _fitOnce());

    _positionWorker = ever(controller.currentPosition, (_) => _fitOnce());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _askToShare();
    });
  }

  @override
  void dispose() {
    _locationsWorker?.dispose();
    _positionWorker?.dispose();
    mapController.dispose();

    Get.delete<LiveRideController>(tag: widget.rideId);

    super.dispose();
  }

  Future<void> _askToShare() async {
    if (!mounted) return;

    final agreed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        icon: Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            color: AppColors.lightGreen,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.location_on_rounded,
            color: AppColors.primaryGreen,
            size: 32,
          ),
        ),
        title: const Text(
          "Share your location",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.darkNavy,
            fontSize: 21,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: const Text(
          'Let your riding group see your live location on the map '
          'while you ride together.\n\n'
          'You can choose not to share, but other riders will not '
          'see your live GPS position.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.secondaryText,
            fontSize: 14,
            height: 1.6,
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.darkNavy,
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Not now'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Share location'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
    if (agreed == true && mounted) {
      await _startSharing();
    }
  }

  Future<void> _startSharing() async {
    final result = await controller.startTracking();

    if (!mounted) return;

    switch (result) {
      case TrackingResult.started:
        break;

      case TrackingResult.gpsDisabled:
        _showSnack(
          'GPS is turned off. turn it on to share your location.',
          actionLabel: 'Settings',
          onAction: () => Geolocator.openLocationSettings(),
        );
        break;

      case TrackingResult.denied:
        _showSnack(
          "Location permission denied. You can still see other riders.",
        );
        break;

      case TrackingResult.deniedForever:
        _showSnack(
          "Location permission is blocked. Enable it in app settings.",
          actionLabel: 'Open settings',
          onAction: () => Geolocator.openAppSettings(),
        );
        break;

      case TrackingResult.failed:
        _showSnack('Could not start location sharing. Please try again.');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.darkNavy,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: 6,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Live Ride',
              style: TextStyle(
                color: AppColors.darkNavy,
                fontSize: 19,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Ride code: ${widget.rideId}',
              style: const TextStyle(
                color: AppColors.secondaryText,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Obx(() {
                final isSharing = controller.isTracking.value;

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: isSharing
                        ? AppColors.lightGreen
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: isSharing
                              ? AppColors.primaryGreen
                              : AppColors.secondaryText,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isSharing ? 'Sharing' : 'Not sharing',
                        style: TextStyle(
                          color: isSharing
                              ? AppColors.primaryGreen
                              : AppColors.secondaryText,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: RideMap(
                        controller: controller,
                        mapController: mapController,
                        onMapReady: () {
                          _mapReady = true;
                          _fitOnce();
                        },
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 12,
                      right: 12,
                      child: Obx(
                        () => _SharingBanner(
                          isSharing: controller.isTracking.value,
                          onEnable: _startSharing,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 12,
                      bottom: 12,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _MapControlButton(
                            icon: Icons.groups_rounded,
                            tooltip: 'Show all riders',
                            onPressed: () => _fitToPoints(_allPoints()),
                          ),

                          const SizedBox(height: 10),

                          _MapControlButton(
                            icon: Icons.my_location_rounded,
                            tooltip: 'My location',
                            isPrimary: true,
                            onPressed: _goToMyLocation,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              decoration: const BoxDecoration(color: AppColors.background),
              child: RiderList(controller: controller, onRiderTap: _onRiderTap),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const ButtonNavigationBar(
        activeItem: BottomNavItem.map,
      ),
    );
  }

  void _fitOnce() {
    if (!_mapReady || _hasFitted) return;

    final points = _allPoints();

    if (points.isEmpty) return;
    _fitToPoints(points);
    _hasFitted = true;
  }

  List<LatLng> _allPoints() {
    final me = controller.currentPosition.value;
    return [
      if (me != null) LatLng(me.latitude, me.longitude),
      for (final rider in controller.riders)
        if (!rider.isMe && rider.location != null)
          LatLng(rider.location!.latitude, rider.location!.longitude),
    ];
  }

  void _fitToPoints(List<LatLng> points) {
    if (points.isEmpty || !_mapReady) return;

    if (points.length == 1) {
      mapController.move(points.first, 16);
      return;
    }

    mapController.fitCamera(
      CameraFit.bounds(
        bounds: LatLngBounds.fromPoints(points),
        padding: const EdgeInsets.all(80),
        maxZoom: 17,
      ),
    );
  }

  void _goToMyLocation() {
    if (!_mapReady) return;

    final me = controller.currentPosition.value;

    if (me == null) {
      _showSnack('Your location is not available yet.');
      return;
    }
    mapController.move(
      LatLng(me.latitude, me.longitude),
      math.max(mapController.camera.zoom, 16).toDouble(),
    );
  }

  void _onRiderTap(RiderEntry rider) {
    if (!_mapReady) return;

    if (rider.isMe) {
      _goToMyLocation();
      return;
    }

    final location = rider.location;
    if (location == null) {
      _showSnack('${rider.name} has not shared a location yet.');
      return;
    }

    mapController.move(
      LatLng(location.latitude, location.longitude),
      math.max(mapController.camera.zoom, 16).toDouble(),
    );
  }

  void _showSnack(
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.darkNavy,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(14),
        ),
        margin: const EdgeInsets.all(16),
        action: actionLabel != null && onAction != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: const Color(0xFF8FE0CC),
                onPressed: onAction,
              )
            : null,
      ),
    );
  }
}

class _SharingBanner extends StatelessWidget {
  final bool isSharing;
  final VoidCallback onEnable;
  const _SharingBanner({required this.isSharing, required this.onEnable});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal:12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSharing
              ? AppColors.primaryGreen.withValues(alpha: 0.15)
              : const Color(0xFFE2E8F0),
        ),
        boxShadow:  [
          BoxShadow(
            color: AppColors.darkNavy.withValues(alpha: 0.10),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isSharing ? AppColors.lightGreen : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              isSharing
                  ? Icons.location_on_rounded
                  : Icons.location_off_rounded,
              color: isSharing
                  ? AppColors.primaryGreen
                  : AppColors.secondaryText,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isSharing
                      ? 'Location sharing active'
                      : 'Location sharing is off',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.darkNavy,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  isSharing
                      ? 'Your group can see your location'
                      : 'Enable sharing to appear on the map',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          if (!isSharing)  const SizedBox(width: 8),
          if (!isSharing)
            FilledButton(
              onPressed: onEnable,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 9,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Enable',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ),
        ],
      ),
    );
  }
}

class _MapControlButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final bool isPrimary;

  const _MapControlButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: isPrimary ? AppColors.primaryGreen : Colors.white,
        borderRadius: BorderRadius.circular(15),
        elevation: 4,
        shadowColor: const Color(0x20000000),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(15),
          child: SizedBox(
            width: 46,
            height: 46,
            child: Icon(
              icon,
              color: isPrimary ? Colors.white : AppColors.darkNavy,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}
