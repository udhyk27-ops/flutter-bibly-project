import 'package:flutter/material.dart';

class RecentSection extends StatelessWidget {
  const RecentSection({super.key});

  final _recentItems = const [
    {'title': '요한복음 3장', 'sub': '어제'},
    {'title': '시편 23편', 'sub': '2일 전'},
    {'title': '로마서 8장', 'sub': '3일 전'},
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '최근 읽은',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: cs.primary,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),
        ..._recentItems.map((item) => _RecentRow(item: item)),
      ],
    );
  }
}

class _RecentRow extends StatelessWidget {
  final Map<String, String> item;
  const _RecentRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: cs.outline, width: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item['title']!,
              style: TextStyle(
                fontSize: 14,
                color: cs.onSurface,
              ),
            ),
            Row(
              children: [
                Text(
                  item['sub']!,
                  style: TextStyle(
                    fontSize: 12,
                    color: cs.secondary,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right,
                  size: 16,
                  color: cs.outline,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}