import 'package:flutter/material.dart';

class GreetingSection extends StatelessWidget {
  final String displayName;
  const GreetingSection({super.key, required this.displayName});

  String _greeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good Morning,';
    } else if (hour < 17) {
      return 'Good Afternoon,';
    } else {
      return 'Good Evening,';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _greeting(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF718096),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$displayName 👋',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: Color(0xFF172B3A),
          ),
        ),
        const SizedBox(height: 6,),

        const Text('Same roads, better company.\nLet\'s ride together!',
        style: TextStyle(fontSize: 14,
        height: 1.5,
        color: Color(0xFF718096)),)
      ],
    );
  }
}
