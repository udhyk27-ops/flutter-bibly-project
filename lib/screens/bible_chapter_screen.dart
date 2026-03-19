import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../core/app_router.dart';
import '../services/bible_api_service.dart';
import 'bible_reading_screen.dart';

class BibleChapterScreen extends StatefulWidget {
  final BibleBookModel book;
  const BibleChapterScreen({super.key, required this.book});

  @override
  State<BibleChapterScreen> createState() => _BibleChapterScreenState();
}

class _BibleChapterScreenState extends State<BibleChapterScreen> {
  late FixedExtentScrollController _scrollController;
  int _selectedChapter = 1;

  @override
  void initState() {
    super.initState();
    _scrollController = FixedExtentScrollController(initialItem: 0);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 상단 바
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back_ios,
                        size: 18, color: cs.primary),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.book.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: cs.primary,
                        ),
                      ),
                      Text(
                        '${widget.book.englishName} · 총 ${widget.book.totalChapters}장',
                        style: TextStyle(fontSize: 11, color: cs.secondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Spacer(),

            // 선택된 장 표시
            Text(
              '${_selectedChapter}장',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w600,
                color: cs.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.book.name,
              style: TextStyle(fontSize: 14, color: cs.secondary),
            ),

            const SizedBox(height: 32),

            // 스크롤 휠
            SizedBox(
              height: 260,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 선택 영역 하이라이트
                  Container(
                    height: 52,
                    margin: const EdgeInsets.symmetric(horizontal: 80),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),

                  // 휠
                  ListWheelScrollView.useDelegate(
                    controller: _scrollController,
                    itemExtent: 52,
                    diameterRatio: 1.8,
                    perspective: 0.003,
                    physics: const FixedExtentScrollPhysics(),
                    onSelectedItemChanged: (index) {
                      setState(() => _selectedChapter = index + 1);
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: widget.book.totalChapters,
                      builder: (context, index) {
                        final chapter    = index + 1;
                        final isSelected = chapter == _selectedChapter;
                        return Center(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 150),
                            style: TextStyle(
                              fontSize: isSelected ? 22 : 17,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              color: isSelected
                                  ? cs.primary
                                  : cs.secondary.withOpacity(0.5),
                            ),
                            child: Text('$chapter장'),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // 읽기 시작 버튼
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  AppRouter.slide(page: BibleReadingScreen(
                    book: widget.book,
                    chapterNumber: _selectedChapter,
                  )),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: cs.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.menu_book_outlined,
                          size: 18, color: cs.onPrimary),
                      const SizedBox(width: 8),
                      Text(
                        '${_selectedChapter}장 읽기',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: cs.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}