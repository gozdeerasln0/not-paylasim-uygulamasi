import 'package:flutter/material.dart';

import '../services/note_service.dart';
import 'add_note_screen.dart';
import 'favorites_screen.dart';
import 'note_list_screen.dart';
import 'add_pdf_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await NoteService.signOut();
    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Not Paylaşım Sistemi"),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: "Çıkış Yap",
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // NOT EKLE
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddNoteScreen()),
                  );
                },
                child: const Text("Not Ekle"),
              ),
            ),
            const SizedBox(height: 10),

            // NOTLARI LİSTELE
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NoteListScreen()),
                  );
                },
                child: const Text("Notları Listele"),
              ),
            ),
            const SizedBox(height: 10),

            // FAVORİLER
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                  );
                },
                child: const Text("Favoriler"),
              ),
            ),
            const SizedBox(height: 10),

            // PDF Ekle (Simülasyon)
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddPdfScreen()),
                  );
                },
                child: const Text("PDF Ekle (Simülasyon)"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
