class FavoriteModel {
  final String   bookId;
  final String   bookName;
  final String   bookEnglishName;
  final int      bookNumber;
  final int      chapter;
  final int      totalChapters;
  final String   genre;
  final DateTime savedAt;

  const FavoriteModel({
    required this.bookId,
    required this.bookName,
    required this.bookEnglishName,
    required this.bookNumber,
    required this.chapter,
    required this.totalChapters,
    required this.genre,
    required this.savedAt,
  });

  // 고유 키 — 같은 책+장 중복 방지
  String get key => '${bookId}_$chapter';

  // 홈 화면 표시용 "3/19 11:11"
  String get formattedDate {
    final m  = savedAt.month;
    final d  = savedAt.day;
    final hh = savedAt.hour.toString().padLeft(2, '0');
    final mm = savedAt.minute.toString().padLeft(2, '0');
    return '$m/$d $hh:$mm';
  }

  Map<String, dynamic> toJson() => {
    'bookId':          bookId,
    'bookName':        bookName,
    'bookEnglishName': bookEnglishName,
    'bookNumber':      bookNumber,
    'chapter':         chapter,
    'totalChapters':   totalChapters,
    'genre':           genre,
    'savedAt':         savedAt.millisecondsSinceEpoch,
  };

  factory FavoriteModel.fromJson(Map<String, dynamic> json) => FavoriteModel(
    bookId:          json['bookId']          as String,
    bookName:        json['bookName']        as String,
    bookEnglishName: json['bookEnglishName'] as String,
    bookNumber:      json['bookNumber']      as int,
    chapter:         json['chapter']         as int,
    totalChapters:   json['totalChapters']   as int,
    genre:           json['genre']           as String,
    savedAt:         DateTime.fromMillisecondsSinceEpoch(
        json['savedAt'] as int),
  );
}