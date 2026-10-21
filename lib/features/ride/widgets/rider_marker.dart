import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:ride_together/app/core/constants/app_colors.dart';
import 'package:ride_together/app/core/utils/rider_status.dart';

class RiderMarker extends StatelessWidget {
  const RiderMarker({
    super.key,
    required this.name,
    required this.isCurrentUser,
    required this.isLeader,
    this.status = RiderStatus.online,
    this.heading = 0,
  });

  final String name;
  final bool isCurrentUser;
  final bool isLeader;
  final RiderStatus status;
  final double heading;

  @override
  Widget build(BuildContext context) {
    final markerColor = isCurrentUser
        ? AppColors.primaryGreen
        : AppColors.darkNavy;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 140),
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isCurrentUser
                  ? AppColors.primaryGreen.withValues(alpha: 0.25)
                  : const Color(0xFFE2E8F0),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x18000000),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLeader) ...[
                const Icon(
                  Icons.star_rounded,
                  size: 14,
                  color: Color(0xFFD9A323),
                ),
                const SizedBox(width: 3),
              ],
              Flexible(
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.darkNavy,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: isCurrentUser ? AppColors.lightGreen : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: markerColor, width: 2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Transform.rotate(
            angle: heading * math.pi / 180,
            child: Icon(Icons.navigation_rounded, size: 23, color: markerColor),
          ),
        ),
      ],
    );
  }
}
