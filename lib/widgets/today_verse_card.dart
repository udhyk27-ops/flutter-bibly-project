import 'package:flutter/material.dart';

class TodayVerseCard extends StatelessWidget {
  const TodayVerseCard({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '오늘의 말씀',
            style: TextStyle(
              fontSize: 11,
              color: cs.onPrimary.withOpacity(0.7),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '"너는 마음을 다하여 여호와를 신뢰하고\n네 명철을 의지하지 말라."',
            style: TextStyle(
              fontSize: 15,
              color: cs.onPrimary,
              height: 1.7,
              fontFamily: 'Georgia',
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '잠언 3:5',
            style: TextStyle(
              fontSize: 12,
              color: cs.onPrimary.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}