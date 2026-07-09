class InfoArticle {
  final String id;
  final String title;
  final String body;
  final String? footnote;

  const InfoArticle({
    required this.id,
    required this.title,
    required this.body,
    this.footnote,
  });
}
