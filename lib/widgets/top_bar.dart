import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Bibly', style: tt.headlineSmall),
              Text('오늘의 말씀 · 잠 3:5', style: tt.labelMedium),
            ],
          ),
          CircleAvatar(
            radius: 18,
            backgroundColor: cs.surfaceContainerHighest,
            child: Icon(Icons.person_outline, color: cs.primary, size: 20),
          ),
        ],
      ),
    );
  }
}