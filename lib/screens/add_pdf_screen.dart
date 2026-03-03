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

  bool _picked = false;
  String _fakeFileName = "";

  @override
  void dispose() {
    _titleController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _pickPdfSimulated() {
    // PDF seçiyormuş gibi yapıyoruz
    setState(() {
      _picked = true;
      _fakeFileName =
          "ders_notlari_${DateTime.now().millisecondsSinceEpoch}.pdf";
      if (_titleController.text.trim().isEmpty) {
        _titleController.text = "PDF Notu";
      }
    });
  }

  void _save() {
    if (!_picked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Önce PDF seç (simülasyon)")),
      );
      return;
    }

    final title = _titleController.text.trim();
    final tagsRaw = _tagsController.text.trim();

    final content =
        """
📄 Dosya: $_fakeFileName
🏷️ Etiketler: ${tagsRaw.isEmpty ? "-" : tagsRaw}
"""
            .trim();

    final note = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.isEmpty ? "PDF Notu" : title,
      content: content,
      isFavorite: false,
    );

    NoteService.add(note);

    Navigator.pop(context); // geri dön
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PDF Ekle (Simülasyon)"),
        centerTitle: true,
        actions: [IconButton(icon: const Icon(Icons.check), onPressed: _save)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _pickPdfSimulated,
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text("PDF Seç (Simülasyon)"),
            ),
            const SizedBox(height: 12),
            if (_picked)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(),
                ),
                child: Text("Seçilen dosya: $_fakeFileName"),
              ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: "Başlık",
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
