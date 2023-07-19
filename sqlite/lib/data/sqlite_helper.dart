import 'dart:async';
import '../models/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

class SqliteHelper {
  final String colId = 'id';
  final String colName = 'name';
  final String colDate = 'date';
  final String colNotes = 'notes';
  final String colPosition = 'position';
  final String tableNotes = 'notes'; //Table name

  static Database? _db;
  final int _version = 1;

  static final SqliteHelper _singleton = SqliteHelper._internal();

  SqliteHelper._internal(); // private named constructor

  factory SqliteHelper() {
    return _singleton;
  }

//Open Database
  Future<Database> init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String dbPath = join(dir.path, "notes.db");
    Database dbNotes = await openDatabase(dbPath,
        version: _version, onCreate: _createDb); // onCreate è una callback
    return dbNotes;
    /*
La firma completa di openDatabase è composta da altre callback alla bisogna:
Future<Database> openDatabase (
  {
    int version
    onConfigure,  //First callback: inizialization
    onCreate,     //Database creato la prima volta
    onUpgrade,    // version >  existing version
    onDowngrade,  // version <  existing version
    onOpen,       // Database Open invocata prima return database
    readOnly,     // False by default
    singleInstance // true by default
  }
)

      onCreate, onUpgrade, onDowngrade sonoi mutualmente esclusive, 
      in funzione del numero di versione
    */
  }

  Future<void> _createDb(Database db, int version) async {
    String query = 'CREATE TABLE $tableNotes ($colId INTEGER PRIMARY KEY, '
        '$colName TEXT, $colDate TEXT, $colNotes TEXT, $colPosition INTEGER)';
    await db.execute(query);
  }

  Future<List<Note>> getNotes() async {
    _db ??= await init();

    List<Map<String, dynamic>> noteList =
        await _db!.query(tableNotes, orderBy: colPosition);
    List<Note> notes = [];
    for (var element in noteList) {
      notes.add(Note.fromMap(element));
    }
    return notes;
  }

  Future<int> insertNote(Note note) async {
    note.position = await findPosition();
    int result = await _db!.insert(tableNotes, note.toMap());
    return result;
  }

  Future<int> updateNote(Note note) async {
    int result = await _db!.update(tableNotes, note.toMap(),
        where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  Future<int> deleteNote(Note note) async {
    int result = await _db!
        .delete(tableNotes, where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  Future<int> findPosition() async {
    final String sql = 'SELECT max($colPosition) from $tableNotes';
    List<Map> queryResult = await _db!.rawQuery(sql);
    int? position = queryResult.first.values.first;
    position = (position == null) ? 0 : ++position;
    /*
    if (queryResult.first.values.first != null) {
      position = ++position;
    }
    */
    return position;
  }

  Future updatePosition(bool increment, int start, int end) async {
    String sql;
    if (increment) {
      sql = 'UPDATE $tableNotes set $colPosition = $colPosition + 1 '
          'where $colPosition >= $start and $colPosition <= $end';
    } else {
      sql = 'UPDATE $tableNotes set $colPosition = $colPosition - 1 '
          'where $colPosition >= $start and $colPosition <= $end';
    }
    await _db!.rawUpdate(sql);
  }
}
