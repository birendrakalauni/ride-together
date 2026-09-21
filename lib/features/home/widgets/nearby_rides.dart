
import 'package:flutter/material.dart';

class NearbyRides extends StatelessWidget {
  const NearbyRides({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          NearbyRideCard(
            title: 'Nagarkot Morning Ride',
            location: 'Nagarkot',
            riders: '4/7',
            imageUrl:
                'https://images.unsplash.com/photo-1500534623283-312aade485b7',
          ),

          SizedBox(width: 10),

          NearbyRideCard(
            title: 'Dhulikhel Ride',
            location: 'Dhulikhel',
            riders: '2/4',
            imageUrl:
                'https://images.unsplash.com/photo-1500534623283-312aade485b7',
          ),
        ],
      ),
    );
  }
}

class NearbyRideCard extends StatelessWidget {
  final String title;
  final String location;
  final String riders;
  final String imageUrl;

  const NearbyRideCard({
    super.key,
    required this.title,
    required this.location,
    required this.riders,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: const Color(0xFFE7F5F2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return const Icon(
                  Icons.image_outlined,
                  size: 40,
                  color: Colors.grey,
                );
              },
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172B3A),
                  ),
                ),

                const SizedBox(height: 5),

                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 15,
                      color: Color(0xFF718096),
                    ),

                    const SizedBox(width: 3),

                    Expanded(
                      child: Text(
                        location,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF718096),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    const Icon(
                      Icons.people_outline,
                      size: 15,
                      color: Color(0xFF718096),
                    ),

                    const SizedBox(width: 3),

                    Text(
                      riders,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF718096),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 6),

          const Icon(
            Icons.chevron_right,
            color: Color(0xFF718096),
          ),
        ],
      ),
    );
  }
}