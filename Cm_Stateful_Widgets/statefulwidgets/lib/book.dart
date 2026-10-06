class Book {
  final String id;
  final String title;
  final String authors;
  final String description;
  final String thumbnail;

  Book({
    required this.id,
    required this.title,
    required this.authors,
    required this.description,
    required this.thumbnail,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['volumeInfo']['title'] ?? 'No Title',
      authors: (json['volumeInfo']['authors'] as List<dynamic>?)?.join(', ') ??
          'No Authors',
      description: json['volumeInfo']['description'] ?? 'No Description',
      thumbnail: json['volumeInfo']['imageLinks']?['thumbnail'] ?? '',
    );
  }
}