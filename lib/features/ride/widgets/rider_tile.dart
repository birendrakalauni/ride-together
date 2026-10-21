import 'package:flutter/material.dart';
import 'package:ride_together/app/core/constants/app_colors.dart';
import 'package:ride_together/app/core/utils/date_utils.dart';
import 'package:ride_together/app/core/utils/distance_utils.dart';
import 'package:ride_together/app/core/utils/rider_status.dart';
import 'package:ride_together/features/ride/models/rider_entry.dart';

class RiderTile extends StatelessWidget {
  final RiderEntry rider;
  final VoidCallback onTap;
  const RiderTile({super.key, required this.rider, required this.onTap});

  String? get _subtitle {
    if (rider.isMe) {
      return rider.status == RiderStatus.online
          ? 'Sharing location'
          : 'Not sharing location';
    }
    if (rider.location == null) {
      return 'Not sharing location';
    }

    if (rider.status == RiderStatus.offline) {
      return 'Location updated recently';
    }
    return 'Last seen ${AppDateUtils.lastSeen(rider.secondsSinceUpdate)}';
  }

  String get _trailing {
    if (rider.isMe) return '';

    if (rider.status == RiderStatus.offline) {
      return 'Offline';
    }

    final distance = rider.distanceMeters;

    return distance == null ? '_ _' : DistanceUtils.formatDistance(distance);
  }

  @override
  Widget build(BuildContext context) {
    final subtitle = _subtitle;
    final isOffline = rider.status == RiderStatus.offline;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightGreen.withValues(alpha: 0.8)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                _buildAvatar(isOffline),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              rider.isMe ? '${rider.name} (You)' : rider.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.darkNavy,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (rider.isLeader) ...[
                            const SizedBox(width: 5),
                            const Icon(
                              Icons.star_rounded,
                              color: Color(0xFFE8A317),
                              size: 17,
                            ),
                          ],
                        ],
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.secondaryText,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 10,),

                _buildTrailing(isOffline),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(bool isOffline) {
    final statusColor = rider.status.color;

    return Stack(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: AppColors.lightGreen,
          child: Text(
            rider.name.trim().isNotEmpty
                ? rider.name.trim()[0].toUpperCase()
                : '?',
            style: const TextStyle(
              color: AppColors.primaryGreen,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrailing(bool isOffline) {
    if (rider.isMe) {
      return const Icon(
        Icons.person_pin_circle_outlined,
        color: AppColors.primaryGreen,
        size: 22,
      );
    }
    if (isOffline) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFFFFEEEE),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          _trailing,
          style: const TextStyle(
            color: Color(0xFFC62828),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.near_me_rounded,
          size: 14,
          color: AppColors.primaryGreen,
        ),
        const SizedBox(width: 4),
        Text(
          _trailing,
          style: const TextStyle(
            color: AppColors.darkNavy,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
