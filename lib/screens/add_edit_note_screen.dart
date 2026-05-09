import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/notes_provider.dart';

class AddEditNoteScreen extends StatefulWidget {
  final Note? note;

  const AddEditNoteScreen({Key? key, this.note}) : super(key: key);

  @override
  _AddEditNoteScreenState createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _content;

  @override
  void initState() {
    super.initState();
    _title = widget.note?.title ?? '';
    _content = widget.note?.content ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'إضافة ملاحظة' : 'تعديل ملاحظة'),
        centerTitle: true,
        actions: [
          if (widget.note != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                Provider.of<NotesProvider>(context, listen: false)
                    .deleteNote(widget.note!.id!);
                Navigator.pop(context);
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(
                  labelText: 'العنوان',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال عنوان للملاحظة';
                  }
                  return null;
                },
                onSaved: (value) => _title = value!,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TextFormField(
                  initialValue: _content,
                  decoration: const InputDecoration(
                    labelText: 'المحتوى',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال محتوى للملاحظة';
                    }
                    return null;
                  },
                  onSaved: (value) => _content = value!,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      
                      final newNote = Note(
                        id: widget.note?.id,
                        title: _title,
                        content: _content,
                        date: DateTime.now(),
                      );
                      
                      if (widget.note == null) {
                        await Provider.of<NotesProvider>(context, listen: false)
                            .addNote(newNote);
                      } else {
                        await Provider.of<NotesProvider>(context, listen: false)
                            .updateNote(newNote);
                      }
                      
                      Navigator.pop(context);
                    }
                  },
                  child: Text(widget.note == null ? 'إضافة' : 'تحديث'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
