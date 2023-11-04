import 'package:flutter/material.dart';
import 'package:memoz/constants/colors.dart';
import '../db/database_provider.dart';
import '../main.dart';
import '../models/note_model.dart';

class AddNotePage extends StatefulWidget {
  final Note? note;

  AddNotePage({Key? key, this.note}) : super(key: key);

  @override
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final DatabaseProvider databaseProvider = DatabaseProvider();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      titleController.text = widget.note!.title;
      contentController.text = widget.note!.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: memoz_colors.ttSecondaryColor,
      appBar: AppBar(
        backgroundColor: memoz_colors.ttPrimaryColor,
        title: Text(
          'Add/Edit Note',
          style: TextStyle(
            color: memoz_colors.ttSecondaryColor,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          if (widget.note != null)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Confirm Deletion'),
                      content: Text('Are you sure you want to delete this note?'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Delete'),
                          onPressed: () {
                            databaseProvider.deleteNote(widget.note?.id ?? 0);
                            Navigator.of(context).pop();
                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                              builder: (context) => NotesList(),
                            ));
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16), // Add some spacing
            TextField(
              controller: contentController,
              maxLines: null, // Allow multiple lines
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(labelText: 'Content'),
            ),
            ElevatedButton(
              onPressed: () {
                final title = titleController.text;
                final content = contentController.text;
                if (title.isNotEmpty || content.isNotEmpty) {
                  final note = Note(
                    title: title,
                    content: content,
                  );
                  if (widget.note == null) {
                    databaseProvider.createNote(note);
                  } else {
                    note.id = widget.note!.id;
                    databaseProvider.updateNote(note);
                  }
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => NotesList(),
                  ));
                }
              },
              child: Text('Save'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(memoz_colors.ttPrimaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
