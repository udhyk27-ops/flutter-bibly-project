import 'package:flutter/material.dart';
import '../screens/favorite_screen.dart';
import '../screens/creed_screen.dart';
import '../core/app_router.dart';
import '../screens/search_screen.dart';

class MainMenuGrid extends StatelessWidget {
  const MainMenuGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final items = [
      _MenuItem(
        icon: Icons.star_outline,
        label: '즐겨찾기',
        sub: '저장한 구절',
        bgColor: cs.surfaceContainerHighest,
        iconColor: cs.primary,
        labelStyle: tt.titleSmall!,
        subStyle: tt.labelMedium!,
        onTap: () => Navigator.push(
            context, AppRouter.slide(page: const FavoriteScreen())),
      ),
      _MenuItem(
        icon: Icons.chrome_reader_mode_outlined,
        label: '신앙고백',
        sub: '사도신경 · 주기도문 · 십계명',
        bgColor: cs.surfaceContainerHighest,
        iconColor: cs.primary,
        labelStyle: tt.titleSmall!,
        subStyle: tt.labelMedium!,
        onTap: () => Navigator.push(
            context, AppRouter.slide(page: const CreedScreen())),
      ),
      _MenuItem(
        icon: Icons.search_outlined,
        label: '성경 검색',
        sub: '키워드로 구절 찾기',
        bgColor: cs.surfaceContainerHighest,
        iconColor: cs.primary,
        labelStyle: tt.titleSmall!,
        subStyle: tt.labelMedium!,
        onTap: () => Navigator.push(
            context, AppRouter.slide(page: const SearchScreen())),
      ),
    ];

    return Column(
      children: [
        // 상단 2개: 즐겨찾기 · 신앙고백
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _MenuCard(item: items[0])),
              const SizedBox(width: 12),
              Expanded(child: _MenuCard(item: items[1])),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // 하단 1개: 성경 검색 – 전체 너비로 넓게
        _MenuCard(item: items[2], wide: true),
      ],
    );
  }
}

// ────────────────────────────────────────────
// Data model
// ────────────────────────────────────────────
class _MenuItem {
  final IconData     icon;
  final String       label;
  final String       sub;
  final Color        bgColor;
  final Color        iconColor;
  final TextStyle    labelStyle;
  final TextStyle    subStyle;
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

// ────────────────────────────────────────────
// Card widget
// ────────────────────────────────────────────
class _MenuCard extends StatelessWidget {
  final _MenuItem item;
  /// true → 전체 너비, 가로로 넓은 레이아웃
  final bool wide;

  const _MenuCard({required this.item, this.wide = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: item.bgColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: wide ? _wideContent() : _squareContent(),
      ),
    );
  }

  // 일반 카드 (정사각형에 가까운 레이아웃)
  Widget _squareContent() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(item.label, style: item.labelStyle),
          Icon(item.icon, color: item.iconColor, size: 22),
        ],
      ),
      const SizedBox(height: 6),
      Text(item.sub, style: item.subStyle),
    ],
  );

  // 와이드 카드 (아이콘·텍스트 수평 배치)
  Widget _wideContent() => Row(
    children: [
      Icon(item.icon, color: item.iconColor, size: 22),
      const SizedBox(width: 12),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(item.label, style: item.labelStyle),
          const SizedBox(height: 2),
          Text(item.sub, style: item.subStyle),
        ],
      ),
      const Spacer(),
      Icon(Icons.chevron_right,
          color: item.iconColor.withValues(alpha: 0.5), size: 20),
    ],
  );
}