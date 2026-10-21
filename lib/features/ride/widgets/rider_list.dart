import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:ride_together/app/core/constants/app_colors.dart';
import 'package:ride_together/features/ride/controllers/live_ride_controller.dart';
import 'package:ride_together/features/ride/models/rider_entry.dart';
import 'package:ride_together/features/ride/widgets/rider_tile.dart';

class RiderList extends StatelessWidget {
  const RiderList({
    super.key,
    required this.controller,
    required this.onRiderTap,
  });

  final LiveRideController controller;
  final void Function(RiderEntry rider) onRiderTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Obx(() {
        final riders = controller.riders;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(riders.length),
            Expanded(
              child: riders.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.only(top: 6, bottom: 16),
                      itemCount: riders.length,
                      itemBuilder: (context, index) {
                        final rider = riders[index];

                        return RiderTile(
                          rider: rider,
                          onTap: () => onRiderTap(rider),
                        );
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildHeader(int riderCount) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.lightGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.groups_rounded,
              color: AppColors.primaryGreen,
              size: 21,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Riders',
                  style: TextStyle(
                    color: AppColors.darkNavy,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Your ride members',
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.lightGreen,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$riderCount ${riderCount == 1 ? 'rider' : 'riders'}',
              style: const TextStyle(
                color: AppColors.primaryGreen,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.groups_outlined,
              size: 44,
              color: AppColors.secondaryText,
            ),
            SizedBox(height: 12),
            Text(
              "No riders to display",
              style: TextStyle(
                color: AppColors.darkNavy,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Ride members will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.secondaryText, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
