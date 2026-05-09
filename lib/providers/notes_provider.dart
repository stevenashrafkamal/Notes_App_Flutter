import 'package:flutter/foundation.dart';
import '../models/note.dart';
import '../database/database_helper.dart';

class NotesProvider with ChangeNotifier {
  List<Note> _notes = [];

  List<Note> get notes => _notes;

  Future<void> loadNotes() async {
    final notesList = await DatabaseHelper().getNotes();
    _notes = notesList;
    notifyListeners();
  }

  Future<void> addNote(Note note) async {
    await DatabaseHelper().insertNote(note);
    await loadNotes();
  }

  Future<void> updateNote(Note note) async {
    await DatabaseHelper().updateNote(note);
    await loadNotes();
  }

  Future<void> deleteNote(int id) async {
    await DatabaseHelper().deleteNote(id);
    await loadNotes();
  }
}
