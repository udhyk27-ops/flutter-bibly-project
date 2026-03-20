import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Bibly',
            style: GoogleFonts.ebGaramond(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
              color: cs.primary,
              letterSpacing: 1.5,
            ),
          ),

          // 아바타 — 구글 로그인 플레이스홀더
          GestureDetector(
            onTap: () {}, // TODO: 구글 로그인
            child: Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                shape: BoxShape.circle,
                border: Border.all(color: cs.outline, width: 0.8),
              ),
              child: Icon(
                Icons.person_outline,
                color: cs.primary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}