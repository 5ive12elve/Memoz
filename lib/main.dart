import 'package:flutter/material.dart';
import 'package:memoz/constants/colors.dart';
import 'package:memoz/screens/add_note.dart';
import 'db/database_provider.dart';
import 'models/note_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NotesList(),
    );
  }
}

class NotesList extends StatefulWidget {
  @override
  _NotesListState createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  final DatabaseProvider databaseProvider = DatabaseProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: memoz_colors.ttSecondaryColor,
      appBar: AppBar(
        backgroundColor: memoz_colors.ttPrimaryColor,
        title: Text(
            'Your Notes',
          style: TextStyle(
            color: memoz_colors.ttSecondaryColor,
                fontWeight: FontWeight.w300
          ),
        ),
      ),
      body: FutureBuilder<List<Note>>(
        future: databaseProvider.getNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasData) {
            final notes = snapshot.data!;
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return ListTile(
                  title: Text(note.title),
                  subtitle: Text(note.content),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddNotePage(note: note),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return Text('No notes found.');
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddNotePage(),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: memoz_colors.ttPrimaryColor,
      ),
    );
  }
}
