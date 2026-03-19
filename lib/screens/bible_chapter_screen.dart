import 'package:flutter/material.dart';
import '../services/bible_api_service.dart';
import 'bible_reading_screen.dart';

/// 장 그리드 + API
class BibleChapterScreen extends StatefulWidget {
  final BibleBookModel book;
  const BibleChapterScreen({super.key, required this.book});

  @override
  State<BibleChapterScreen> createState() => _BibleChapterScreenState();
}

class _BibleChapterScreenState extends State<BibleChapterScreen> {
  List<BibleChapterModel> _chapters = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadChapters();
  }

  Future<void> _loadChapters() async {
    try {
      final chapters = await BibleApiService.getChapters(
        BibleApiService.bibleIdKo,
        widget.book.id,
      );
      setState(() {
        _chapters  = chapters;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error     = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 바
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back_ios, size: 18, color: cs.primary),
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
                        widget.book.nameLong,
                        style: TextStyle(fontSize: 11, color: cs.secondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '장 선택',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: cs.secondary,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator(color: cs.primary))
                  : _error != null
                  ? Center(
                  child: Text(_error!,
                      style: TextStyle(color: cs.secondary)))
                  : GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemCount: _chapters.length,
                itemBuilder: (context, index) {
                  final chapter = _chapters[index];
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BibleReadingScreen(
                          book:    widget.book,
                          chapter: chapter,
                        ),
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        chapter.number,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: cs.primary,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}