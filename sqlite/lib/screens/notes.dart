import 'package:flutter/material.dart';
import '../models/note.dart';
import '../data/sqlite_helper.dart';
import '../data/shared_prefs.dart';
import './note.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  int settingColor = 0xff1976d2;
  double fontSize = 16;
  SPSettings settings = SPSettings();
  SqliteHelper sqlHelper = SqliteHelper();

  @override
  void initState() {
    settings = SPSettings();
    settings.init().then((value) {
      setState(() {
        settingColor = settings.getColor();
        fontSize = settings.getFontSize();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).notes),
        backgroundColor: Color(settingColor),
      ),
      body: FutureBuilder(
        future: getNotes(),
        builder: (context, snapshot) {
          List<Note> notes =
              snapshot.data == null ? [] : snapshot.data as List<Note>;
          if (notes == null) {
            return Container();
          } else {
            return ReorderableListView(
              onReorder: (oldIndex, newIndex) async {
                final Note note = notes[oldIndex];
                if (oldIndex > newIndex) {
                  await sqlHelper.updatePosition(true, newIndex, oldIndex);
                } else if (oldIndex < newIndex) {
                  // bug fix:removing the item at oldIndex will shorten the list by 1.
                  newIndex -= 1;
                  await sqlHelper.updatePosition(false, oldIndex, newIndex);
                }
                note.position = newIndex;
                await sqlHelper.updateNote(note);
                setState(() {
                  getNotes();
                });
              },
              children: [
                for (final note in notes)
                  Dismissible(
                      key: Key(note.id.toString()),
                      onDismissed: (direction) {
                        sqlHelper.deleteNote(note);
                      },
                      child: Card(
                        key: ValueKey(note.position),
                        child: ListTile(
                          title: Text(note.name),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        NoteScreen(note, false)));
                          },
                        ),
                      ))
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color(settingColor),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        NoteScreen(Note('', '', '', 1), true)));
          },
          child: const Icon(Icons.add)),
    );
  }

  Future<List<Note>> getNotes() async {
    sqlHelper = SqliteHelper();
    List<Note> notes = await sqlHelper.getNotes();
    return notes;
  }
}
