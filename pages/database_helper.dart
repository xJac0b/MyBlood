import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:external_path/external_path.dart';

class DatabaseHelper {
  static const _databaseName = "Database.db";
  static const _databaseVersion = 2;

  static const table = 'results';
  static const SECRET_KEY = "tajnykluczszyfr";
  static const columnId = 'id';
  static const columnName = 'name';
  static const columnDate = 'date';
  static const columnSex = 'sex';

  static const List<String> columnsResults = [
    "`Leukocyty/WBC`",
    "`Hemoglobina/HGB`",
    "`MCV`",
    "`MCHC`",
    "`RDW-SD`",
    "`PDW`",
    "`P-LCR`",
    "`Neutrofile/NEUT#`",
    "`Limfocyty/LYMPH#`",
    "`Monocyty/MONO#`",
    "`Eoznofile/EO#`",
    "`IG#`",
    "`Bazofile/BASO#`",
    "`NRBC#`",
    "`Erytrocyty/RBC`",
    "`Hematokryt/HCT`",
    "`MCH`",
    "`Płytki Krwi/PLT`",
    "`RDW-CV`",
    "`MPV`",
    "`PCT`",
    "`Neutrofile/NEUT%`",
    "`Limfocyty/LYMPH%`",
    "`Monocyty/MONO%`",
    "`Eozynofile/EO%`",
    "`IG%`",
    "`Bazofile/BASO%`",
    "`NRBC%`",
  ];
  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static late Database _database;
  Future<Database> get database async {
    await askForWritePermission();
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    var path = await getPersistentDbPath();
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER NOT NULL PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnDate DATE NOT NULL,
            $columnSex TEXT CHECK($columnSex IN ('M','F')) NOT NULL,
            ${columnsResults[0]} DOUBLE(8,3),
            ${columnsResults[1]} DOUBLE(8,3),
            ${columnsResults[2]} DOUBLE(8,3),
            ${columnsResults[3]} DOUBLE(8,3),
            ${columnsResults[4]} DOUBLE(8,3),
            ${columnsResults[5]} DOUBLE(8,3),
            ${columnsResults[6]} DOUBLE(8,3),
            ${columnsResults[7]} DOUBLE(8,3),
            ${columnsResults[8]} DOUBLE(8,3),
            ${columnsResults[9]} DOUBLE(8,3),
            ${columnsResults[10]} DOUBLE(8,3),
            ${columnsResults[11]} DOUBLE(8,3),
            ${columnsResults[12]} DOUBLE(8,3),
            ${columnsResults[13]} DOUBLE(8,3),
            ${columnsResults[14]} DOUBLE(8,3),
            ${columnsResults[15]} DOUBLE(8,3),
            ${columnsResults[16]} DOUBLE(8,3),
            ${columnsResults[17]} DOUBLE(8,3),
            ${columnsResults[18]} DOUBLE(8,3),
            ${columnsResults[19]} DOUBLE(8,3),
            ${columnsResults[20]} DOUBLE(8,3),
            ${columnsResults[21]} DOUBLE(8,3),
            ${columnsResults[22]} DOUBLE(8,3),
            ${columnsResults[23]} DOUBLE(8,3),
            ${columnsResults[24]} DOUBLE(8,3),
            ${columnsResults[25]} DOUBLE(8,3),
            ${columnsResults[26]} DOUBLE(8,3),
            ${columnsResults[27]} DOUBLE(8,3)
          )
          ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int?> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<String> getPersistentDbPath() async {
    return await createPersistentDbDirecotry();
  }

  Future<String> createPersistentDbDirecotry() async {
    var externalDirectoryPath =
        await ExternalPath.getExternalStoragePublicDirectory(
            ExternalPath.DIRECTORY_DOCUMENTS);
    var persistentDirectory = "$externalDirectoryPath/my_blood_db";
    return "$persistentDirectory/$_databaseName";
  }

  Future<Directory> createDirectory(String path) async {
    return await (new Directory(path).create());
  }

  Future<bool> askForWritePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }
    status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      status = await Permission.manageExternalStorage.request();
    }
    status = await Permission.accessMediaLocation.status;
    if (!status.isGranted) {
      status = await Permission.accessMediaLocation.request();
    }
    status = await Permission.mediaLibrary.status;
    if (!status.isGranted) {
      status = await Permission.mediaLibrary.request();
    }
    return status.isGranted;
  }
}
