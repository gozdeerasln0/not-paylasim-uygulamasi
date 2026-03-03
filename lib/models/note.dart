class Note {
  final String id;
  final String title;
  final String content;
  bool isFavorite;

  Note({
    required this.id,
    required this.title,
    required this.content,
    this.isFavorite = false,
  });
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'isFavorite': isFavorite,
  };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    id: json['id'] as String,
    title: json['title'] as String,
    content: json['content'] as String,
    isFavorite: (json['isFavorite'] as bool?) ?? false,
  );
}
