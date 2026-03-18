import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/note.dart';
import '../services/note_service.dart';

class NoteDetailScreen extends StatefulWidget {
  final Note note;

  const NoteDetailScreen({super.key, required this.note});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  Future<void> _openPdf() async {
    if (widget.note.pdfUrl == null || widget.note.pdfUrl!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bu nota ait PDF linki yok")),
      );
      return;
    }

    final uri = Uri.parse(widget.note.pdfUrl!);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("PDF açılamadı")));
    }
  }

  void _editNote() {
    final titleController = TextEditingController(text: widget.note.title);
    final contentController = TextEditingController(text: widget.note.content);

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Notu Güncelle"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Başlık"),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: "İçerik"),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("İptal"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),

            ElevatedButton(
              child: const Text("Kaydet"),
              onPressed: () async {
                await NoteService.update(
                  widget.note.id,
                  titleController.text,
                  contentController.text,
                  pdfUrl: widget.note.pdfUrl,
                );

                if (mounted) {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final note = widget.note;

    return Scaffold(
      appBar: AppBar(
        title: Text(note.title),

        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: _editNote),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Text(note.content),

            const SizedBox(height: 30),

            if (note.pdfUrl != null && note.pdfUrl!.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _openPdf,
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text("PDF'yi Aç"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
