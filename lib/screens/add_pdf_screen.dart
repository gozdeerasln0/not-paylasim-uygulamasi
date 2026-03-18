import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/note_service.dart';

class AddPdfScreen extends StatefulWidget {
  const AddPdfScreen({super.key});

  @override
  State<AddPdfScreen> createState() => _AddPdfScreenState();
}

class _AddPdfScreenState extends State<AddPdfScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  final TextEditingController _pdfUrlController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _tagsController.dispose();
    _pdfUrlController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    final tagsRaw = _tagsController.text.trim();
    final pdfUrl = _pdfUrlController.text.trim();

    if (pdfUrl.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("PDF linki girmelisin")));
      return;
    }

    final note = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.isEmpty ? "PDF Notu" : title,
      content: "Etiketler: ${tagsRaw.isEmpty ? "-" : tagsRaw}",
      isFavorite: false,
      pdfUrl: pdfUrl,
    );

    await NoteService.add(note);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PDF Linki Ekle"),
        centerTitle: true,
        actions: [IconButton(icon: const Icon(Icons.check), onPressed: _save)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: "Başlık",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _pdfUrlController,
              decoration: const InputDecoration(
                labelText: "PDF Linki",
                hintText: "https://...pdf",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _tagsController,
              decoration: const InputDecoration(
                labelText: "Etiketler (virgülle) ör: BIL314, final",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: const Text("Kaydet"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
