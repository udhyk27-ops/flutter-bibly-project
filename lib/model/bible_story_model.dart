class BibleStoryModel {
  final String title;
  final String content;
  final String reference;

  BibleStoryModel({
    required this.title,
    required this.content,
    required this.reference,
  });

  factory BibleStoryModel.fromJson(Map<String, dynamic> json) =>
      BibleStoryModel(
        title:     json['title'] ?? '',
        content:   json['content'] ?? '',
        reference: json['reference'] ?? '',
      );
}