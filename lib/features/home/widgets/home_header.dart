import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final VoidCallback onProfileTap;

  const HomeHeader({
    super.key,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
         Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'ride',
                  style: TextStyle(
                    fontSize: 28,
                    fontFamily: 'serif',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: 'Together',
                  style: TextStyle(
                    fontSize: 28,
                    fontFamily: 'serif',
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E8B57),
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: onProfileTap,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                ),
              ],
            ),
            child: const Icon(
              Icons.person_outline,
              color: Color(0xFF172B3A),
            ),
          ),
        ),
      ],
    );
  }
}