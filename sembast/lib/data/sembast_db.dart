import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart' as p;
import './sembast_codec.dart';

class SembastDatabase {
  //create single instance of AppDatabase via the private constructor
  static final SembastDatabase _singleton = SembastDatabase._();
  static const String dbname = 'password.db';
  static const String encryptDb = 'N';
  static const _dbversion = 1;

  // Initialize the encryption codec with a user password
  var codec = getEncryptSembastCodec(password: '[yuki]');

  //getter for class instance
  static SembastDatabase get instance => _singleton;

  //database instance
  Database? _database;

  //private constructor
  SembastDatabase._();

  Future<Database?> get database async {
    //open db if db is null
    _database ??= await _openDatabase();

    //return already opened db
    return _database;
  }

  Future<Database> _openDatabase() async {
    //get application directory
    final directory = await getApplicationDocumentsDirectory();

    //construct path
    final dbPath = p.join(directory.path, dbname);

    //open database
    final Database db;
    if (encryptDb == 'Y') {
      db = await databaseFactoryIo.openDatabase(dbPath,
          codec: codec, version: _dbversion);
    } else {
      db = await databaseFactoryIo.openDatabase(dbPath, version: _dbversion);
    }
    return db;
  }
}
