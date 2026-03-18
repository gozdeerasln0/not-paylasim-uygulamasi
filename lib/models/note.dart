class Note {
  final String id;
  final String title;
  final String content;
  final bool isFavorite;
  final String? pdfUrl;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.isFavorite,
    this.pdfUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'isFavorite': isFavorite,
      'pdfUrl': pdfUrl,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      isFavorite: map['isFavorite'] ?? false,
      pdfUrl: map['pdfUrl'],
    );
  }
}
