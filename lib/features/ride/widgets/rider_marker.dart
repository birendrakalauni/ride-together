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
    final markerColor = isCurrentUser ? AppColors.primaryGreen : status.color;

    final isOffline = status == RiderStatus.offline && !isCurrentUser;

    return Opacity(
      opacity: isOffline ? 0.55 : 1.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          _buildNameLabel(),
          
          const SizedBox(height: 5),
          Transform.rotate(
            angle: heading * math.pi / 180,
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: markerColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: markerColor.withValues(alpha: 0.30),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                isCurrentUser
                    ? Icons.navigation_rounded
                    : Icons.motorcycle_rounded,
                size: 19,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameLabel() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 130),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.lightGreen, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkNavy.withValues(alpha: 0.12),
            blurRadius: 7,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLeader) ...[
            const Icon(Icons.star_rounded, size: 14, color: Color(0xFFE8A317)),
            const SizedBox(width: 3),
          ],
          Flexible(
            child: Text(
            isCurrentUser ? '$name (You)' : name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.darkNavy,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
