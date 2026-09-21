import 'package:flutter/material.dart';

class PopularRides extends StatelessWidget {
  const PopularRides({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          PopularRideCard(
            title: 'Pokhara to Jomsom',
            location: "Pokhara",
            riders: '5/10',
            imageUrl:
                'assets/images/Muktinath.jpg',
          ),

          SizedBox(width: 14,),
          PopularRideCard(title: 'Kathmandu to Chitlang', location: 'Chitlang', riders: '6/8', imageUrl: 'assets/images/ktmtoChitlang.jpg')
        ],
      ),
    );
  }
}

class PopularRideCard extends StatelessWidget {
  final String title;
  final String location;
  final String riders;
  final String imageUrl;

  const PopularRideCard({
    super.key,
    required this.title,
    required this.location,
    required this.riders,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 135,
            width: double.infinity,
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
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172B3A),
                  ),
                ),
                const SizedBox(height: 6),

                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Color(0xFF087F6E),
                    ),
                    const SizedBox(width: 4),

                    Text(
                      location,
                      style: TextStyle(fontSize: 12, color: Color(0xFF718096)),
                    ),
                    const Spacer(),

                    const Icon(
                      Icons.people_outline,
                      size: 16,
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
        ],
      ),
    );
  }
}
