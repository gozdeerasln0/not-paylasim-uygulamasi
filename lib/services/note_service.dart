import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/note.dart';

class NoteService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static final List<Note> _notes = [];
  static StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _sub;
  static final StreamController<List<Note>> _controller =
      StreamController<List<Note>>.broadcast();

  static Stream<List<Note>> watch() => _controller.stream;

  static List<Note> getAll() => List.unmodifiable(_notes);

  static List<Note> getFavorites() =>
      _notes.where((n) => n.isFavorite).toList(growable: false);

  static bool get isLoggedIn => _auth.currentUser != null;

  static CollectionReference<Map<String, dynamic>> _col(String uid) {
    return _db.collection('users').doc(uid).collection('notes');
  }

  static Future<void> init() async {
    if (!isLoggedIn) return;
    await _startListening(_auth.currentUser!.uid);
  }

  static Future<void> signUp(String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _startListening(cred.user!.uid);
  }

  static Future<void> signIn(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _startListening(cred.user!.uid);
  }

  static Future<void> signOut() async {
    await _sub?.cancel();
    _sub = null;
    _notes.clear();
    _controller.add(getAll());
    await _auth.signOut();
  }

  static Future<void> _startListening(String uid) async {
    await _sub?.cancel();

    _sub = _col(uid).orderBy('createdAt', descending: true).snapshots().listen((
      snap,
    ) {
      final list = snap.docs
          .map((d) {
            final data = d.data();

            return Note(
              id: d.id,
              title: (data['title'] ?? '') as String,
              content: (data['content'] ?? '') as String,
              isFavorite: (data['isFavorite'] ?? false) as bool,
              pdfUrl: data['pdfUrl'] as String?,
            );
          })
          .toList(growable: false);

      _notes
        ..clear()
        ..addAll(list);

      _controller.add(getAll());
    });
  }

  static Future<void> add(Note note) async {
    final uid = _auth.currentUser!.uid;

    await _col(uid).add({
      'title': note.title,
      'content': note.content,
      'isFavorite': note.isFavorite,
      'pdfUrl': note.pdfUrl,
      'createdAt': Timestamp.now(),
    });
  }

  static Future<void> update(
    String id,
    String newTitle,
    String newContent, {
    String? pdfUrl,
  }) async {
    final uid = _auth.currentUser!.uid;

    await _col(uid).doc(id).update({
      'title': newTitle,
      'content': newContent,
      'pdfUrl': pdfUrl,
    });
  }

  static Future<void> toggleFavorite(String id) async {
    final uid = _auth.currentUser!.uid;
    final ref = _col(uid).doc(id);
    final doc = await ref.get();

    if (!doc.exists) return;

    final current = (doc.data()?['isFavorite'] ?? false) as bool;
    await ref.update({'isFavorite': !current});
  }

  static Future<void> delete(String id) async {
    final uid = _auth.currentUser!.uid;
    await _col(uid).doc(id).delete();
  }
}
