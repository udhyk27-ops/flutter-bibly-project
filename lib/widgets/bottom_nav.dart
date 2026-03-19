import 'package:flutter/material.dart';
import '../core/app_router.dart';
import '../screens/bible_screen.dart';
import '../screens/hymn_screen.dart';
import '../screens/settings_screen.dart';

class BottomNav extends StatelessWidget {
  final int activeIndex;
  const BottomNav({super.key, this.activeIndex = 0});

  void _onTap(BuildContext context, int index) {
    if (index == activeIndex) return;
    if (index == 0) {
      Navigator.popUntil(context, (r) => r.isFirst);
      return;
    }
    Widget screen;
    switch (index) {
      case 1: screen = const BibleScreen();    break;
      case 2: screen = const HymnScreen();     break;
      case 3: screen = const SettingsScreen(); break;
      default: return;
    }
    Navigator.pushAndRemoveUntil(
      context,
      AppRouter.fade(page: screen),
          (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

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
            behavior: HitTestBehavior.opaque,
            onTap: () => _onTap(context, i),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(items[i].icon, color: color, size: 24),
                  const SizedBox(height: 3),
                  Text(
                    items[i].label,
                    style: tt.labelSmall?.copyWith(color: color),
                  ),
                  if (isActive) ...[
                    const SizedBox(height: 3),
                    Container(
                      width: 4, height: 4,
                      decoration: BoxDecoration(
                          color: color, shape: BoxShape.circle),
                    ),
                  ],
                ],
              ),
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