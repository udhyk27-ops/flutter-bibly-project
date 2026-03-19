import 'package:flutter/material.dart';
import '../widgets/top_bar.dart';
import '../widgets/today_verse_card.dart';
import '../widgets/main_menu_grid.dart';
import '../widgets/recent_section.dart';
import '../widgets/bottom_nav.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const TopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const TodayVerseCard(),
                    const SizedBox(height: 20),
                    const MainMenuGrid(),
                    const SizedBox(height: 20),
                    const RecentSection(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            const BottomNav(activeIndex: 0),
          ],
        ),
      ),
    );
  }
}