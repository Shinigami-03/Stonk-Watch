import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  Future<List<String>> fetchNotes() async {
    final notesSnapshot = await FirebaseFirestore.instance
        .collection('notes')
        .get();

    final notes = notesSnapshot.docs
        .map((doc) => doc.data()['content'] as String)
        .toList();
    return notes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Notes'),
      ),
      body: FutureBuilder<List<String>>(
        future: fetchNotes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final notes = snapshot.data!;
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return ListTile(
                  title: Text(note),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: NotesPage(),
  ));
}
