class RecentReadModel {
  final String bookName;
  final String bookEnglishName;
  final String bookId;
  final String bookNameLong;
  final String bookGenre;
  final int    bookNumber;
  final int    totalChapters;
  final int    chapter;
  final int    timestamp;

  RecentReadModel({
    required this.bookName,
    required this.bookEnglishName,
    required this.bookId,
    required this.bookNameLong,
    required this.bookGenre,
    required this.bookNumber,
    required this.totalChapters,
    required this.chapter,
    required this.timestamp,
  });

  factory RecentReadModel.fromJson(Map<String, dynamic> j) => RecentReadModel(
    bookName:        j['bookName'],
    bookEnglishName: j['bookEnglishName'],
    bookId:          j['bookId']       ?? '',
    bookNameLong:    j['bookNameLong'] ?? '',
    bookGenre:       j['bookGenre']    ?? '',
    bookNumber:      j['bookNumber'],
    totalChapters:   j['totalChapters'],
    chapter:         j['chapter'],
    timestamp:       j['timestamp'],
  );

  Map<String, dynamic> toJson() => {
    'bookName':        bookName,
    'bookEnglishName': bookEnglishName,
    'bookId':          bookId,
    'bookNameLong':    bookNameLong,
    'bookGenre':       bookGenre,
    'bookNumber':      bookNumber,
    'totalChapters':   totalChapters,
    'chapter':         chapter,
    'timestamp':       timestamp,
  };
}