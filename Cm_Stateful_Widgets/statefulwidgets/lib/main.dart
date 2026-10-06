import 'package:flutter/material.dart';
import 'book.dart'; // Importez le modèle Book
import 'api_service.dart'; // Importez le service API

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recherche de livres',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple)),
      home: const BookSearchScreen(),
    );
  }
}

class BookSearchScreen extends StatefulWidget {
  const BookSearchScreen({super.key});

  @override
  State<BookSearchScreen> createState() => _BookSearchScreenState();
}

class _BookSearchScreenState extends State<BookSearchScreen> {
  late Future<List<Book>> futureBooks;
  String searchQuery = 'ed-dbali';

  @override
  void initState() {
    super.initState();
    futureBooks = fetchBooks(searchQuery); // Effectue la recherche initiale
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recherche de livres'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Rechercher un livre',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (query) {
                setState(() {
                  searchQuery = query;
                  futureBooks = fetchBooks(searchQuery);
                });
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Book>>(
                future: futureBooks,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Book book = snapshot.data![index];
                        return ListTile(
                          leading: book.thumbnail.isNotEmpty
                              ? Image.network(book.thumbnail)
                              : const Icon(Icons.book, size: 40),
                          title: Text(book.title),
                          subtitle: Text(book.authors),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text(book.title),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (book.thumbnail.isNotEmpty)
                                      Image.network(book.thumbnail),
                                    const SizedBox(height: 10),
                                    Text('Auteurs: ${book.authors}'),
                                    const SizedBox(height: 10),
                                    Text(book.description),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erreur: ${snapshot.error}'));
                  }

                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}