import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreedScreen extends StatefulWidget {
  const CreedScreen({super.key});

  @override
  State<CreedScreen> createState() => _CreedScreenState();
}

class _CreedScreenState extends State<CreedScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _tabs = const ['사도신경', '주기도문', '십계명'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 상단 바
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back_ios,
                        size: 18, color: cs.primary),
                  ),
                  const SizedBox(width: 8),
                  Text('신앙고백', style: tt.headlineSmall),
                ],
              ),
            ),
            Divider(height: 1, thickness: 0.6, color: cs.outline),

            // 탭 바
            Container(
              margin: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: cs.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: cs.onPrimary,
                unselectedLabelColor: cs.secondary,
                labelStyle: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600),
                unselectedLabelStyle:
                const TextStyle(fontSize: 13),
                tabs: _tabs
                    .map((t) => Tab(text: t, height: 36))
                    .toList(),
              ),
            ),
            const SizedBox(height: 4),

            // 탭 콘텐츠
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  _CreedContent(creed: _apostlesCreed),
                  _CreedContent(creed: _lordsPrayer),
                  _CreedContent(creed: _tenCommandments),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── 콘텐츠 뷰 ────────────────────────────────────────
class _CreedContent extends StatelessWidget {
  final _CreedData creed;
  const _CreedContent({required this.creed});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목 + 복사 버튼
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(creed.title,
                  style: tt.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700)),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(
                      ClipboardData(text: creed.fullText));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('클립보드에 복사됐어요'),
                      backgroundColor: cs.primary,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.copy_outlined,
                          size: 13, color: cs.primary),
                      const SizedBox(width: 4),
                      Text('복사',
                          style: TextStyle(
                              fontSize: 12,
                              color: cs.primary,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // 설명
          if (creed.description.isNotEmpty)
            Text(creed.description, style: tt.labelMedium),
          const SizedBox(height: 20),

          // 본문 — 섹션이 있으면 섹션별로, 없으면 한 덩어리로
          if (creed.sections.isNotEmpty)
            ...creed.sections.map((section) => _SectionBlock(
              section: section,
            )),

          if (creed.sections.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: cs.outline, width: 0.5),
              ),
              child: Text(
                creed.fullText,
                style: TextStyle(
                  fontSize: 15,
                  color: cs.onSurface,
                  height: 2.0,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionBlock extends StatelessWidget {
  final _Section section;
  const _SectionBlock({required this.section});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outline, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (section.title.isNotEmpty) ...[
            Row(
              children: [
                Container(
                  width: 4, height: 14,
                  decoration: BoxDecoration(
                    color: cs.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(section.title,
                    style: tt.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: cs.primary)),
              ],
            ),
            const SizedBox(height: 10),
          ],
          Text(
            section.text,
            style: TextStyle(
              fontSize: 15,
              color: cs.onSurface,
              height: 2.0,
            ),
          ),
        ],
      ),
    );
  }
}

// ── 데이터 모델 ──────────────────────────────────────
class _CreedData {
  final String         title;
  final String         description;
  final String         fullText;
  final List<_Section> sections;

  const _CreedData({
    required this.title,
    required this.description,
    required this.fullText,
    this.sections = const [],
  });
}

class _Section {
  final String title;
  final String text;
  const _Section({required this.title, required this.text});
}

// ── 사도신경 ─────────────────────────────────────────
const _apostlesCreed = _CreedData(
  title: '사도신경',
  description: '기독교의 핵심 신앙을 고백하는 신조',
  fullText: '''전능하사 천지를 만드신 하나님 아버지를 내가 믿사오며,
그 외아들 우리 주 예수 그리스도를 믿사오니,
이는 성령으로 잉태하사 동정녀 마리아에게 나시고,
본디오 빌라도에게 고난을 받으사,
십자가에 못 박혀 죽으시고, 장사한 지 사흘 만에
죽은 자 가운데서 다시 살아나시며,
하늘에 오르사, 전능하신 하나님 우편에 앉아 계시다가,
저리로서 산 자와 죽은 자를 심판하러 오시리라.
성령을 믿사오며, 거룩한 공회와,
성도가 서로 교통하는 것과,
죄를 사하여 주시는 것과,
몸이 다시 사는 것과, 영원히 사는 것을 믿사옵나이다.
아멘.''',
  sections: [
    _Section(
      title: '성부 하나님',
      text: '전능하사 천지를 만드신 하나님 아버지를 내가 믿사오며,',
    ),
    _Section(
      title: '성자 예수 그리스도',
      text: '''그 외아들 우리 주 예수 그리스도를 믿사오니,
이는 성령으로 잉태하사 동정녀 마리아에게 나시고,
본디오 빌라도에게 고난을 받으사,
십자가에 못 박혀 죽으시고, 장사한 지 사흘 만에
죽은 자 가운데서 다시 살아나시며,
하늘에 오르사, 전능하신 하나님 우편에 앉아 계시다가,
저리로서 산 자와 죽은 자를 심판하러 오시리라.''',
    ),
    _Section(
      title: '성령 하나님',
      text: '''성령을 믿사오며, 거룩한 공회와,
성도가 서로 교통하는 것과,
죄를 사하여 주시는 것과,
몸이 다시 사는 것과, 영원히 사는 것을 믿사옵나이다.
아멘.''',
    ),
  ],
);

// ── 주기도문 ─────────────────────────────────────────
const _lordsPrayer = _CreedData(
  title: '주기도문',
  description: '마태복음 6:9-13 · 예수님이 가르쳐 주신 기도',
  fullText: '''하늘에 계신 우리 아버지여,
이름이 거룩히 여김을 받으시오며,
나라가 임하시오며,
뜻이 하늘에서 이루어진 것 같이
땅에서도 이루어지이다.
오늘 우리에게 일용할 양식을 주시옵고,
우리가 우리에게 죄 지은 자를 사하여 준 것 같이
우리 죄를 사하여 주시옵고,
우리를 시험에 들게 하지 마시옵고
다만 악에서 구하시옵소서.
나라와 권세와 영광이 아버지께 영원히 있사옵나이다.
아멘.''',
  sections: [
    _Section(
      title: '하나님께 드리는 찬양',
      text: '''하늘에 계신 우리 아버지여,
이름이 거룩히 여김을 받으시오며,
나라가 임하시오며,
뜻이 하늘에서 이루어진 것 같이
땅에서도 이루어지이다.''',
    ),
    _Section(
      title: '우리의 필요를 구함',
      text: '''오늘 우리에게 일용할 양식을 주시옵고,
우리가 우리에게 죄 지은 자를 사하여 준 것 같이
우리 죄를 사하여 주시옵고,
우리를 시험에 들게 하지 마시옵고
다만 악에서 구하시옵소서.''',
    ),
    _Section(
      title: '송영',
      text: '나라와 권세와 영광이 아버지께 영원히 있사옵나이다.\n아멘.',
    ),
  ],
);

// ── 십계명 ───────────────────────────────────────────
const _tenCommandments = _CreedData(
  title: '십계명',
  description: '출애굽기 20:1-17 · 하나님께서 주신 열 가지 계명',
  fullText: '',
  sections: [
    _Section(title: '제1계명', text: '나 외에는 다른 신들을 네게 두지 말라.'),
    _Section(title: '제2계명', text: '너를 위하여 새긴 우상을 만들지 말고 그것들에게 절하지 말며 그것들을 섬기지 말라.'),
    _Section(title: '제3계명', text: '네 하나님 여호와의 이름을 망령되게 부르지 말라.'),
    _Section(title: '제4계명', text: '안식일을 기억하여 거룩하게 지키라.'),
    _Section(title: '제5계명', text: '네 부모를 공경하라 그리하면 네 하나님 여호와가 네게 준 땅에서 네 생명이 길리라.'),
    _Section(title: '제6계명', text: '살인하지 말라.'),
    _Section(title: '제7계명', text: '간음하지 말라.'),
    _Section(title: '제8계명', text: '도둑질하지 말라.'),
    _Section(title: '제9계명', text: '네 이웃에 대하여 거짓 증거하지 말라.'),
    _Section(title: '제10계명', text: '네 이웃의 집을 탐내지 말라. 네 이웃의 아내나 그의 남종이나 그의 여종이나 그의 소나 그의 나귀나 무릇 네 이웃의 소유를 탐내지 말라.'),
  ],
);