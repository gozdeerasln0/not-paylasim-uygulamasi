import 'package:flutter/material.dart';

import '../models/note.dart';
import '../services/note_service.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    final List<Note> favs = NoteService.getFavorites();

    return Scaffold(
      appBar: AppBar(title: const Text("Favoriler"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: favs.isEmpty
            ? const Center(child: Text("Favori not yok."))
            : ListView.builder(
                itemCount: favs.length,
                itemBuilder: (context, i) {
                  final n = favs[i];
                  return Card(
                    child: ListTile(
                      title: Text(n.title),
                      subtitle: Text(n.content),
                      trailing: IconButton(
                        icon: const Icon(Icons.star),
                        onPressed: () {
                          setState(() {
                            NoteService.toggleFavorite(n.id);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
