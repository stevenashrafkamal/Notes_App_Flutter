import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/notes_provider.dart';
import 'add_edit_note_screen.dart';
import 'note_detail_screen.dart'; // ✅ استدعاء شاشة التفاصيل الجديدة

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<NotesProvider>(context, listen: false).loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ملاحظاتي'),
        centerTitle: true,
      ),
      body: Consumer<NotesProvider>(
        builder: (context, notesProvider, child) {
          if (notesProvider.notes.isEmpty) {
            return const Center(
              child: Text(
                'لا توجد ملاحظات\nاضغط على + لإنشاء ملاحظة جديدة',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: notesProvider.notes.length,
            itemBuilder: (context, index) {
              final note = notesProvider.notes[index];
              return Dismissible(
                key: Key(note.id.toString()),
                background: Container(color: Colors.red),
                onDismissed: (direction) {
                  notesProvider.deleteNote(note.id!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('تم حذف "${note.title}"')),
                  );
                },
                child: ListTile(
                  title: Text(
                    note.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    note.content,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    '${note.date.day}/${note.date.month}/${note.date.year}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoteDetailScreen(note: note), // ✅ يفتح شاشة التفاصيل
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditNoteScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
