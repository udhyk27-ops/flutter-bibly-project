import 'dart:convert';
import 'package:http/http.dart' as http;

class AiService {
  static const String _apiKey = 'YOUR_ANTHROPIC_API_KEY';
  static const String _url    = 'https://api.anthropic.com/v1/messages';

  static Future<String> askVerse(String verseText) async {
    final res = await http.post(
      Uri.parse(_url),
      headers: {
        'Content-Type':      'application/json',
        'x-api-key':         _apiKey,
        'anthropic-version': '2023-06-01',
      },
      body: jsonEncode({
        'model':      'claude-sonnet-4-20250514',
        'max_tokens': 500,
        'messages': [
          {
            'role':    'user',
            'content': '''
다음 성경 구절을 쉽고 간결하게 해석해주세요. 
3~4문장으로 핵심 의미와 묵상 포인트를 설명해주세요.

구절: "$verseText"
''',
          },
        ],
        'system': '당신은 성경 전문가입니다. 구절의 역사적 배경과 신학적 의미를 쉬운 말로 설명해주세요. 존댓말로 답변하세요.',
      }),
    );

    if (res.statusCode != 200) throw Exception('AI 서비스 오류');

    final data    = jsonDecode(utf8.decode(res.bodyBytes));
    final content = data['content'] as List;
    return content
        .where((c) => c['type'] == 'text')
        .map((c) => c['text'] as String)
        .join();
  }
}