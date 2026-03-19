import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '말씀과 찬양',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: cs.primary,
                ),
              ),
              Text(
                '오늘의 말씀 · 잠 3:5',
                style: TextStyle(
                  fontSize: 12,
                  color: cs.secondary,
                ),
              ),
            ],
          ),
          CircleAvatar(
            radius: 18,
            backgroundColor: cs.surfaceContainerHighest,
            child: Icon(
              Icons.person_outline,
              color: cs.primary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}