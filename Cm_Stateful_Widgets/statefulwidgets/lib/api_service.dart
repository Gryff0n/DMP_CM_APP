import 'dart:convert';
import 'package:http/http.dart' as http;
import 'book.dart';

const String apiKey = 'AIzaSyBuBKQuSQZwzfK-B7h1MTc9tkjpyPVBG1g'; // ne la commite pas sur Git

Future<List<Book>> fetchBooks(String query) async {
  final url = Uri.https(
    'www.googleapis.com',
    '/books/v1/volumes',
    {'q': query, 'key': apiKey},
  );
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = json.decode(response.body);
    final List<dynamic> items = jsonData['items'] ?? [];
    return items.map((item) => Book.fromJson(item)).toList();
  } else {
    throw Exception(
        'Échec du chargement des livres (HTTP ${response.statusCode})');
  }
}