import 'package:flutter/material.dart';

class ActiveRideCard extends StatelessWidget {
  const ActiveRideCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: const Color(0xFFE7F5F2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.map_outlined,
              color: Color(0xFF087F6E),
              size: 30,
            ),
          ),
          const SizedBox(width: 16),

          const Expanded(
            child: Text(
              "You don't have an active ride.",
              style: TextStyle(fontSize: 13, color: Color(0xFF718096)),
            ),
          ),
        ],
      ),
    );
  }
}
