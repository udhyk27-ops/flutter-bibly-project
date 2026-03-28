import 'package:flutter/material.dart';
import '../main.dart';
import '../widgets/top_bar.dart';
import '../widgets/today_verse_card.dart';
import '../widgets/main_menu_grid.dart';
import '../widgets/recent_section.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/weekly_reading.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  int _recentKey = 0;

  @override
  void didPopNext() {
    // 다른 화면에서 홈으로 돌아올 때 호출
    setState(() => _recentKey++);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

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
                    const SizedBox(height: 10),
                    const TodayVerseCard(),
                    const SizedBox(height: 10),
                    WeeklyReadingWidget(
                      checkedDays: const {}, // 기능 구현 전: 빈 Set
                      // 구현 후: ReadingService.checkedDaysThisWeek() 등 주입
                    ),
                    const SizedBox(height: 10),
                    const MainMenuGrid(),
                    const SizedBox(height: 20),
                    RecentSection(key: ValueKey(_recentKey)),
                    const SizedBox(height: 10),
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