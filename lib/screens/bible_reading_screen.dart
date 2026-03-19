import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/bible_api_service.dart';
import '../services/ai_service.dart';

class BibleReadingScreen extends StatefulWidget {
  final BibleBookModel book;
  final int            chapterNumber;

  const BibleReadingScreen({
    super.key,
    required this.book,
    required this.chapterNumber,
  });

  @override
  State<BibleReadingScreen> createState() => _BibleReadingScreenState();
}

class _BibleReadingScreenState extends State<BibleReadingScreen> {
  BibleChapterModel? _chapter;
  bool    _isLoading = true;
  String? _error;

  int     _currentChapter  = 1;
  String? _selectedVerseId;
  String? _selectedText;

  final Map<String, String> _aiAnswers = {};
  final Map<String, bool>   _aiLoading = {};

  double _fontSize   = 17;
  double _lineHeight = 1.85;

  @override
  void initState() {
    super.initState();
    _currentChapter = widget.chapterNumber;
    _loadChapter();
  }

  Future<void> _loadChapter() async {
    setState(() {
      _isLoading       = true;
      _error           = null;
      _selectedVerseId = null;
      _selectedText    = null;
    });
    try {
      final chapter = await BibleApiService.getChapter(
        bookNumber: widget.book.number,
        chapter:    _currentChapter,
      );
      setState(() {
        _chapter   = chapter;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error     = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _goToChapter(int chapter) async {
    if (chapter < 1 || chapter > widget.book.totalChapters) return;
    setState(() => _currentChapter = chapter);
    await _loadChapter();
  }

  Future<void> _askAI(String verseId, String text) async {
    setState(() => _aiLoading[verseId] = true);
    try {
      final answer = await AiService.askVerse(text);
      setState(() {
        _aiAnswers[verseId] = answer;
        _aiLoading[verseId] = false;
      });
    } catch (e) {
      setState(() {
        _aiAnswers[verseId] = '답변을 불러오지 못했어요. 다시 시도해주세요.';
        _aiLoading[verseId] = false;
      });
    }
  }

  void _onVerseTap(String verseId, String text) {
    setState(() {
      if (_selectedVerseId == verseId) {
        _selectedVerseId = null;
        _selectedText    = null;
      } else {
        _selectedVerseId = verseId;
        _selectedText    = text;
      }
    });
  }

  void _showSettingsSheet(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // 로컬 변수로 현재 값 복사 (StatefulBuilder 안에서 관리)
    double localFontSize   = _fontSize;
    double localLineHeight = _lineHeight;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 250),
      transitionBuilder: (context, anim, _, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
          child: child,
        );
      },
      pageBuilder: (context, _, __) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(20)),
            child: SafeArea(
              top: false,
              child: StatefulBuilder(
                builder: (context, setSheet) => Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 핸들
                      Center(
                        child: Container(
                          width: 36,
                          height: 4,
                          decoration: BoxDecoration(
                            color: cs.outline,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '읽기 설정',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: cs.onSurface),
                      ),
                      const SizedBox(height: 20),

                      // 글씨 크기
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('글씨 크기',
                              style: TextStyle(
                                  fontSize: 14, color: cs.onSurface)),
                          Text('${localFontSize.toInt()}px',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: cs.primary)),
                        ],
                      ),
                      _CustomSlider(
                        value: localFontSize,
                        min: 12,
                        max: 26,
                        activeColor: cs.primary,
                        inactiveColor: cs.surfaceContainerHighest,
                        onChanged: (v) {
                          setSheet(() => localFontSize = v);
                          setState(() => _fontSize = v);
                        },
                      ),

                      const SizedBox(height: 8),

                      // 줄 간격
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('줄 간격',
                              style: TextStyle(
                                  fontSize: 14, color: cs.onSurface)),
                          Text(localLineHeight.toStringAsFixed(1),
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: cs.primary)),
                        ],
                      ),
                      _CustomSlider(
                        value: localLineHeight,
                        min: 1.4,
                        max: 2.4,
                        activeColor: cs.primary,
                        inactiveColor: cs.surfaceContainerHighest,
                        onChanged: (v) {
                          setSheet(() => localLineHeight = v);
                          setState(() => _lineHeight = v);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(
              book:          widget.book,
              chapterNumber: _currentChapter,
              onSettingsTap: () => _showSettingsSheet(context),
            ),
            Expanded(
              child: _isLoading
                  ? Center(
                  child: CircularProgressIndicator(color: cs.primary))
                  : _error != null
                  ? _ErrorView(
                error:   _error!,
                onRetry: _loadChapter,
              )
                  : _chapter == null
                  ? const SizedBox()
                  : _VerseList(
                verses:          _chapter!.verses,
                selectedVerseId: _selectedVerseId,
                aiAnswers:       _aiAnswers,
                aiLoading:       _aiLoading,
                fontSize:        _fontSize,
                lineHeight:      _lineHeight,
                onVerseTap:      _onVerseTap,
                onAskAI:         _askAI,
              ),
            ),
            _BottomChapterNav(
              currentChapter: _currentChapter,
              totalChapters:  widget.book.totalChapters,
              onPrev: () => _goToChapter(_currentChapter - 1),
              onNext: () => _goToChapter(_currentChapter + 1),
            ),
          ],
        ),
      ),
    );
  }
}

// ── 커스텀 슬라이더 ────────────────────────────────────
class _CustomSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final Color  activeColor;
  final Color  inactiveColor;
  final ValueChanged<double> onChanged;

  const _CustomSlider({
    required this.value,
    required this.min,
    required this.max,
    required this.activeColor,
    required this.inactiveColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final ratio = ((value - min) / (max - min)).clamp(0.0, 1.0);
        const thumbSize = 20.0;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragUpdate: (details) {
            final newRatio =
            (details.localPosition.dx / width).clamp(0.0, 1.0);
            onChanged(min + newRatio * (max - min));
          },
          onTapDown: (details) {
            final newRatio =
            (details.localPosition.dx / width).clamp(0.0, 1.0);
            onChanged(min + newRatio * (max - min));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SizedBox(
              height: thumbSize,
              width: width,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  // 배경 트랙
                  Positioned(
                    top: (thumbSize - 4) / 2,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: inactiveColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  // 활성 트랙
                  Positioned(
                    top: (thumbSize - 4) / 2,
                    left: 0,
                    child: Container(
                      height: 4,
                      width: width * ratio,
                      decoration: BoxDecoration(
                        color: activeColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  // 썸
                  Positioned(
                    left: (width * ratio - thumbSize / 2)
                        .clamp(0, width - thumbSize),
                    child: Container(
                      width: thumbSize,
                      height: thumbSize,
                      decoration: BoxDecoration(
                        color: activeColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── 상단 바 ──────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final BibleBookModel book;
  final int            chapterNumber;
  final VoidCallback   onSettingsTap;

  const _TopBar({
    required this.book,
    required this.chapterNumber,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios, size: 18, color: cs.primary),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${book.name} $chapterNumber장',
                    style: tt.headlineSmall),
                Text(book.englishName, style: tt.labelMedium),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.star_outline, size: 18, color: cs.primary),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onSettingsTap,
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.text_fields_outlined,
                  size: 18, color: cs.primary),
            ),
          ),
        ],
      ),
    );
  }
}

// ── 절 목록 ──────────────────────────────────────────
class _VerseList extends StatelessWidget {
  final List<BibleVerseModel>    verses;
  final String?                  selectedVerseId;
  final Map<String, String>      aiAnswers;
  final Map<String, bool>        aiLoading;
  final double                   fontSize;
  final double                   lineHeight;
  final Function(String, String) onVerseTap;
  final Function(String, String) onAskAI;

  const _VerseList({
    required this.verses,
    required this.selectedVerseId,
    required this.aiAnswers,
    required this.aiLoading,
    required this.fontSize,
    required this.lineHeight,
    required this.onVerseTap,
    required this.onAskAI,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: verses.length + 1,
      itemBuilder: (context, index) {
        if (index == verses.length) return const SizedBox(height: 40);

        final verse       = verses[index];
        final verseId     = '${verse.verse}';
        final isSelected  = selectedVerseId == verseId;
        final aiAnswer    = aiAnswers[verseId];
        final isAiLoading = aiLoading[verseId] ?? false;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _VerseRow(
              verseNum:   '${verse.verse}',
              text:       verse.text,
              isSelected: isSelected,
              fontSize:   fontSize,
              lineHeight: lineHeight,
              onTap:      () => onVerseTap(verseId, verse.text),
            ),
            if (isSelected)
              _ActionBar(
                verseId: verseId,
                text:    verse.text,
                onAskAI: onAskAI,
              ),
            if (isAiLoading) _AiLoadingBubble(),
            if (aiAnswer != null && !isAiLoading)
              _AiBubble(answer: aiAnswer),
          ],
        );
      },
    );
  }
}

// ── 절 행 ──────────────────────────────────────────
class _VerseRow extends StatelessWidget {
  final String       verseNum;
  final String       text;
  final bool         isSelected;
  final double       fontSize;
  final double       lineHeight;
  final VoidCallback onTap;

  const _VerseRow({
    required this.verseNum,
    required this.text,
    required this.isSelected,
    required this.fontSize,
    required this.lineHeight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 2),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? cs.surfaceContainerHighest
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 28,
              child: Text(
                verseNum,
                style: tt.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: cs.primary,
                  height: lineHeight,
                ),
              ),
            ),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize:   fontSize,
                  color:      cs.onSurface,
                  height:     lineHeight,
                  fontFamily: 'Georgia',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── 액션 바 ──────────────────────────────────────────
class _ActionBar extends StatelessWidget {
  final String               verseId;
  final String               text;
  final Function(String, String) onAskAI;

  const _ActionBar({
    required this.verseId,
    required this.text,
    required this.onAskAI,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 38, bottom: 8),
      child: Row(
        children: [
          _ActionChip(
            label: '복사',
            icon:  Icons.copy_outlined,
            onTap: () {
              Clipboard.setData(ClipboardData(text: text));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('클립보드에 복사됐어요'),
                  backgroundColor:
                  Theme.of(context).colorScheme.primary,
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
          const SizedBox(width: 6),
          _ActionChip(
            label: '하이라이트',
            icon:  Icons.highlight_outlined,
            onTap: () {},
          ),
          const SizedBox(width: 6),
          _ActionChip(
            label:     'AI 질문',
            icon:      Icons.auto_awesome_outlined,
            isPrimary: true,
            onTap:     () => onAskAI(verseId, text),
          ),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final String       label;
  final IconData     icon;
  final bool         isPrimary;
  final VoidCallback onTap;

  const _ActionChip({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isPrimary ? cs.primary : cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 13,
                color: isPrimary ? cs.onPrimary : cs.secondary),
            const SizedBox(width: 4),
            Text(
              label,
              style: tt.labelMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: isPrimary ? cs.onPrimary : cs.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── AI 로딩 버블 ──────────────────────────────────────
class _AiLoadingBubble extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(left: 38, bottom: 12, right: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: const BorderRadius.only(
          topRight:    Radius.circular(12),
          bottomLeft:  Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(
                strokeWidth: 2, color: cs.primary),
          ),
          const SizedBox(width: 8),
          Text('AI가 해석 중이에요...',
              style: TextStyle(fontSize: 12, color: cs.secondary)),
        ],
      ),
    );
  }
}

// ── AI 답변 버블 ──────────────────────────────────────
class _AiBubble extends StatelessWidget {
  final String answer;
  const _AiBubble({required this.answer});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(left: 38, bottom: 16, right: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: const BorderRadius.only(
          topRight:    Radius.circular(12),
          bottomLeft:  Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        border: Border.all(color: cs.outline, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, size: 13, color: cs.primary),
              const SizedBox(width: 4),
              Text(
                'AI 해석',
                style: tt.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600, color: cs.primary),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            answer,
            style: TextStyle(
                fontSize: 13, color: cs.onSurface, height: 1.65),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _MoreBtn(label: '더 자세히', onTap: () {}),
              const SizedBox(width: 6),
              _MoreBtn(label: '원어 보기', onTap: () {}),
              const SizedBox(width: 6),
              _MoreBtn(label: '관련 구절', onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }
}

class _MoreBtn extends StatelessWidget {
  final String       label;
  final VoidCallback onTap;
  const _MoreBtn({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: cs.outline, width: 0.5),
        ),
        child: Text(
          label,
          style: tt.labelMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: cs.onSurface,
          ),
        ),
      ),
    );
  }
}

// ── 하단 장 이동 ──────────────────────────────────────
class _BottomChapterNav extends StatelessWidget {
  final int          currentChapter;
  final int          totalChapters;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const _BottomChapterNav({
    required this.currentChapter,
    required this.totalChapters,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final cs      = Theme.of(context).colorScheme;
    final hasPrev = currentChapter > 1;
    final hasNext = currentChapter < totalChapters;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: cs.outline, width: 0.5)),
      ),
      child: Row(
        children: [
          // 이전 장
          Expanded(
            child: GestureDetector(
              onTap: hasPrev ? onPrev : null,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: hasPrev
                      ? cs.surfaceContainerHighest
                      : cs.surfaceContainerHighest.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_back_ios,
                        size: 14,
                        color: hasPrev ? cs.primary : cs.outline),
                    const SizedBox(width: 4),
                    Text(
                      '${currentChapter - 1}장',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: hasPrev ? cs.primary : cs.outline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // 현재 장
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: cs.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$currentChapter장',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: cs.onPrimary,
              ),
            ),
          ),
          const SizedBox(width: 10),

          // 다음 장
          Expanded(
            child: GestureDetector(
              onTap: hasNext ? onNext : null,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: hasNext
                      ? cs.surfaceContainerHighest
                      : cs.surfaceContainerHighest.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${currentChapter + 1}장',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: hasNext ? cs.primary : cs.outline,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward_ios,
                        size: 14,
                        color: hasNext ? cs.primary : cs.outline),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── 에러 화면 ──────────────────────────────────────────
class _ErrorView extends StatelessWidget {
  final String       error;
  final VoidCallback onRetry;
  const _ErrorView({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wifi_off_outlined, size: 48, color: cs.outline),
          const SizedBox(height: 12),
          Text('불러오기 실패',
              style: TextStyle(fontSize: 15, color: cs.onSurface)),
          const SizedBox(height: 6),
          Text(error,
              style: TextStyle(fontSize: 12, color: cs.secondary),
              textAlign: TextAlign.center),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onRetry,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: cs.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('다시 시도',
                  style: TextStyle(fontSize: 13, color: cs.onPrimary)),
            ),
          ),
        ],
      ),
    );
  }
}
