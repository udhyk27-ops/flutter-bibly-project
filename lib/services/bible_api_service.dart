import 'dart:convert';
import 'package:http/http.dart' as http;

class BibleApiService {
  static const String _baseUrl = 'https://api.scripture.api.bible/v1';
  static const String _apiKey  = 'YOUR_API_KEY'; // scripture.api.bible 에서 발급

  // 개역개정 bibleId (API에서 조회한 실제 ID로 교체 필요)
  static const String bibleIdKo = 'YOUR_KOREAN_BIBLE_ID';
  static const String bibleIdEn = 'de4e12af7f28f599-02'; // KJV

  static const Map<String, String> _headers = {'api-key': _apiKey};

  // ── 책 목록 ──────────────────────────────────────
  static Future<List<BibleBookModel>> getBooks(String bibleId) async {
    final res = await http.get(
      Uri.parse('$_baseUrl/bibles/$bibleId/books'),
      headers: _headers,
    );
    if (res.statusCode != 200) throw Exception('책 목록 로딩 실패');

    final data = jsonDecode(res.body)['data'] as List;
    return data.map((b) => BibleBookModel.fromJson(b)).toList();
  }

  // ── 장 목록 ──────────────────────────────────────
  static Future<List<BibleChapterModel>> getChapters(
      String bibleId, String bookId) async {
    final res = await http.get(
      Uri.parse('$_baseUrl/bibles/$bibleId/books/$bookId/chapters'),
      headers: _headers,
    );
    if (res.statusCode != 200) throw Exception('장 목록 로딩 실패');

    final data = jsonDecode(res.body)['data'] as List;
    return data
        .where((c) => c['number'] != 'intro') // intro 챕터 제외
        .map((c) => BibleChapterModel.fromJson(c))
        .toList();
  }

  // ── 장 본문 ──────────────────────────────────────
  static Future<BibleContentModel> getChapterContent(
      String bibleId, String chapterId) async {
    final res = await http.get(
      Uri.parse(
          '$_baseUrl/bibles/$bibleId/chapters/$chapterId?content-type=text&include-verse-numbers=true'),
      headers: _headers,
    );
    if (res.statusCode != 200) throw Exception('본문 로딩 실패');

    final data = jsonDecode(res.body)['data'];
    return BibleContentModel.fromJson(data);
  }

  // ── 절 단위 ──────────────────────────────────────
  static Future<List<BibleVerseModel>> getVerses(
      String bibleId, String chapterId) async {
    final res = await http.get(
      Uri.parse(
          '$_baseUrl/bibles/$bibleId/chapters/$chapterId/verses'),
      headers: _headers,
    );
    if (res.statusCode != 200) throw Exception('절 목록 로딩 실패');

    final data = jsonDecode(res.body)['data'] as List;
    return data.map((v) => BibleVerseModel.fromJson(v)).toList();
  }

  // ── 특정 절 본문 ──────────────────────────────────
  static Future<String> getVerseContent(
      String bibleId, String verseId) async {
    final res = await http.get(
      Uri.parse(
          '$_baseUrl/bibles/$bibleId/verses/$verseId?content-type=text'),
      headers: _headers,
    );
    if (res.statusCode != 200) throw Exception('절 로딩 실패');

    final data = jsonDecode(res.body)['data'];
    return data['content'] as String;
  }
}

// ── 모델 ─────────────────────────────────────────────

class BibleBookModel {
  final String id;
  final String name;
  final String nameLong;
  final int? chapters;

  BibleBookModel({
    required this.id,
    required this.name,
    required this.nameLong,
    this.chapters,
  });

  factory BibleBookModel.fromJson(Map<String, dynamic> json) {
    return BibleBookModel(
      id:        json['id'],
      name:      json['name'],
      nameLong:  json['nameLong'] ?? json['name'],
      chapters:  json['chapters']?.length,
    );
  }
}

class BibleChapterModel {
  final String id;
  final String number;
  final String bookId;

  BibleChapterModel({
    required this.id,
    required this.number,
    required this.bookId,
  });

  factory BibleChapterModel.fromJson(Map<String, dynamic> json) {
    return BibleChapterModel(
      id:     json['id'],
      number: json['number'],
      bookId: json['bookId'],
    );
  }
}

class BibleContentModel {
  final String id;
  final String reference;
  final String content;
  final String? nextId;
  final String? previousId;

  BibleContentModel({
    required this.id,
    required this.reference,
    required this.content,
    this.nextId,
    this.previousId,
  });

  factory BibleContentModel.fromJson(Map<String, dynamic> json) {
    return BibleContentModel(
      id:         json['id'],
      reference:  json['reference'],
      content:    json['content'],
      nextId:     json['next']?['id'],
      previousId: json['previous']?['id'],
    );
  }
}

class BibleVerseModel {
  final String id;
  final String reference;
  final String orgId;

  BibleVerseModel({
    required this.id,
    required this.reference,
    required this.orgId,
  });

  factory BibleVerseModel.fromJson(Map<String, dynamic> json) {
    return BibleVerseModel(
      id:        json['id'],
      reference: json['reference'],
      orgId:     json['orgId'],
    );
  }
}