import 'package:flutter/material.dart';
import '../screens/bible_screen.dart';
import '../screens/hymn_screen.dart';
import '../screens/settings_screen.dart';

class BottomNav extends StatelessWidget {
  final int activeIndex;
  const BottomNav({super.key, this.activeIndex = 0});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final items = [
      _NavItem(icon: Icons.home_outlined,       label: '홈'),
      _NavItem(icon: Icons.menu_book_outlined,  label: '성경'),
      _NavItem(icon: Icons.music_note_outlined, label: '찬송가'),
      _NavItem(icon: Icons.settings_outlined,   label: '설정'),
    ];

    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: cs.outline, width: 0.5)),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final isActive = i == activeIndex;
          final color    = isActive ? cs.primary : cs.outline;
          return GestureDetector(
            onTap: () {
              if (isActive) return;
              switch (i) {
                case 0:
                  Navigator.popUntil(context, (r) => r.isFirst);
                case 1:
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const BibleScreen()));
                case 2:
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const HymnScreen()));
                case 3:
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const SettingsScreen()));
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(items[i].icon, color: color, size: 22),
                const SizedBox(height: 3),
                Text(items[i].label,
                    style: TextStyle(fontSize: 10, color: color)),
                if (isActive) ...[
                  const SizedBox(height: 3),
                  Container(
                    width: 4, height: 4,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String   label;
  const _NavItem({required this.icon, required this.label});
}