import 'package:flutter/material.dart';
import '../screens/bible_screen.dart';
import '../screens/hymn_screen.dart';
import '../core/app_router.dart';

class MainMenuGrid extends StatelessWidget {
  const MainMenuGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final items = [
      _MenuItem(
        icon: Icons.menu_book_outlined,
        label: '성경',
        sub: '66권 · 구약/신약',
        bgColor: cs.surfaceContainerHighest,
        iconColor: cs.primary,
        labelStyle: tt.titleSmall!,
        subStyle: tt.labelMedium!,
        onTap: () => Navigator.push(
            context, AppRouter.slide(page: const BibleScreen())),
      ),
      _MenuItem(
        icon: Icons.music_note_outlined,
        label: '찬송가',
        sub: '645장 수록',
        bgColor: cs.surfaceContainerHighest,
        iconColor: cs.primary,
        labelStyle: tt.titleSmall!,
        subStyle: tt.labelMedium!,
        onTap: () => Navigator.push(
            context, AppRouter.slide(page: const HymnScreen())),
      ),
      _MenuItem(
        icon: Icons.star_outline,
        label: '즐겨찾기',
        sub: '저장한 구절',
        bgColor: cs.surfaceContainerHighest,
        iconColor: cs.primary,
        labelStyle: tt.titleSmall!,
        subStyle: tt.labelMedium!,
        onTap: () {},
      ),
      _MenuItem(
        icon: Icons.auto_awesome_outlined,
        label: 'AI 질문',
        sub: '말씀 해석·묵상',
        bgColor: cs.primary,
        iconColor: cs.onPrimary,
        labelStyle: tt.titleSmall!.copyWith(color: cs.onPrimary),
        subStyle: tt.labelMedium!.copyWith(
            color: cs.onPrimary.withOpacity(0.7)),
        onTap: () {},
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: items.map((item) => _MenuCard(item: item)).toList(),
    );
  }
}

class _MenuItem {
  final IconData   icon;
  final String     label;
  final String     sub;
  final Color      bgColor;
  final Color      iconColor;
  final TextStyle  labelStyle;
  final TextStyle  subStyle;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.sub,
    required this.bgColor,
    required this.iconColor,
    required this.labelStyle,
    required this.subStyle,
    required this.onTap,
  });
}

class _MenuCard extends StatelessWidget {
  final _MenuItem item;
  const _MenuCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: item.bgColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, color: item.iconColor, size: 24),
            const SizedBox(height: 8),
            Text(item.label, style: item.labelStyle),
            const SizedBox(height: 2),
            Text(item.sub, style: item.subStyle),
          ],
        ),
      ),
    );
  }
}