import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/note_service.dart';
import 'note_detail_screen.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  String _query = "";
  final TextEditingController _searchController = TextEditingController();

  List<Note> _applyFilter(List<Note> all) {
    if (_query.trim().isEmpty) return all;

    final q = _query.toLowerCase();
    return all.where((n) {
      return n.title.toLowerCase().contains(q) ||
          n.content.toLowerCase().contains(q);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notları Listele"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Ara (başlık / içerik)...",
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
            const SizedBox(height: 12),

            // 🔥 Firestore’dan gelen notları canlı dinle
            Expanded(
              child: StreamBuilder<List<Note>>(
                stream: NoteService.watch(),
                initialData: NoteService.getAll(),
                builder: (context, snapshot) {
                  final all = snapshot.data ?? const <Note>[];
                  final notes = _applyFilter(all);

                  if (notes.isEmpty) {
                    return const Center(child: Text("Hiç not yok."));
                  }

                  return ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, i) {
                      final n = notes[i];

                      return Card(
                        child: ListTile(
                          title: Text(n.title),
                          subtitle: Text(
                            n.content,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => NoteDetailScreen(note: n),
                              ),
                            );
                            // Stream zaten güncelliyor; setState şart değil.
                          },
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  n.isFavorite ? Icons.star : Icons.star_border,
                                ),
                                onPressed: () async {
                                  await NoteService.toggleFavorite(n.id);
                                  // setState gerekmez, stream günceller
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  final ok = await showDialog<bool>(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text("Not silinsin mi?"),
                                      content: const Text(
                                        "Bu işlem geri alınamaz.",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: const Text("İptal"),
                                        ),
                                        ElevatedButton(
                                          onPressed: () =>
                                              Navigator.pop(context, true),
                                          child: const Text("Sil"),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (ok == true) {
                                    await NoteService.delete(n.id);
                                    // setState gerekmez, stream günceller
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
