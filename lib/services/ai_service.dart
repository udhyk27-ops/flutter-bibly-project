import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../model/bible_story_model.dart';

class AiService {
  static const String _apiKey = 'YOUR_GEMINI_API_KEY';

  static GenerativeModel _model({int maxTokens = 500}) =>
      GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: _apiKey,
        generationConfig: GenerationConfig(maxOutputTokens: maxTokens),
      );

  // ── 구절 해석
  static Future<String> askVerse(String verseText) async {
    final prompt = '''
      당신은 성경 전문가입니다. 구절의 역사적 배경과 신학적 의미를 쉬운 말로 설명해주세요. 존댓말로 답변하세요.
      
      다음 성경 구절을 쉽고 간결하게 해석해주세요.
      3~4문장으로 핵심 의미와 묵상 포인트를 설명해주세요.
      
      구절: "$verseText"
    ''';

    final response = await _model()
        .generateContent([Content.text(prompt)]);

    if (response.text == null) throw Exception('AI 서비스 오류');
    return response.text!.trim();
  }

  // ── 성경 이야기 카드
  static Future<BibleStoryModel> getBibleStory(String bookName) async {
    final prompt = '''
      ${bookName}과 관련된 성경 속 잘 알려지지 않은 흥미로운 역사나 이야기를 하나 알려줘.
      반드시 아래 JSON 형식으로만 응답해. 다른 텍스트 없이 JSON만:
      {
        "title": "제목 (15자 이내)",
        "content": "내용 (100자 이내, 흥미롭고 쉽게)",
        "reference": "관련 성경 구절 (예: 창세기 6:4)"
      }
    ''';

    final response = await _model(maxTokens: 300)
        .generateContent([Content.text(prompt)]);

    final text = response.text ?? '';
    final cleaned = text
        .replaceAll(RegExp(r'```json|```'), '')
        .trim();

    final json = jsonDecode(cleaned);
    return BibleStoryModel.fromJson(json);
  }
}