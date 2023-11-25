import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:typed_data';

class DbHelper {
  DbHelper._();

  static final DbHelper dbHelper = DbHelper._();

  Database? db;

  initDB() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, "demo.db");

    db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        String sql =
            "CREATE TABLE IF NOT EXISTS demo(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, city TEXT, image BLOB);";

        await db.execute(sql);
      },
    );
  }

  Future<int> insertData({
    required String name,
    required String city,
    Uint8List? image,
  }) async {
    await initDB();

    String sql = "INSERT INTO demo(name, city, image) VALUES(?, ?, ?);";
    List args = [name, city, image];

    int id = await db!.rawInsert(sql, args);

    return id;
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    await initDB();

    String sql = "SELECT * FROM demo";

    List<Map<String, dynamic>> allData = await db!.rawQuery(sql);
    return allData;
  }

  Future<int> updateData(
      {String? name, String? city, Uint8List? image, required int id}) async {
    await initDB();

    String sql = "UPDATE demo SET name = ?, city = ?, image = ? WHERE id = ?;";
    List args = [name, city, image, id];

    int item = await db!.rawUpdate(sql, args);

    return item;
  }

  // Future<int> updateData(
  //     {String? name, String? city, Uint8List? image, required int id}) async {
  //   await initDB();
  //   String query =
  //       "UPDATE demo SET name = ?, city = ?, image = ? WHERE id = ?;";
  //   List argy = [name, city, image, id];
  //   int item = await db!.rawUpdate(query, argy);
  //   return item;
  // }

  Future<int> deleteData({required int id}) async {
    await initDB();

    String sql = "DELETE FROM demo WHERE id = ?;";
    List args = [id];

    int item = await db!.rawDelete(sql, args);

    return item;
  }
}

// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
//
// class DbHelper {
//   DbHelper._();
//
//   static final DbHelper dbHelper = DbHelper._();
//
//   Database? db;
//
//   initDB() async {
//     var databasesPath = await getDatabasesPath();
//     String path = join(databasesPath, 'demo.db');
//
//     Database database = await openDatabase(path, version: 1,
//         onCreate: (Database db, int version) async {
//       await db.execute(
//           'CREATE TABLE Test (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, city Text);');
//     });
//   }
//
//   insertData({required name, required city}) async {
//     await initDB();
//
//     String query = "INSERT INTO Test(name, city) VALUES (?, ?)";
//     List args = [name, city];
//
//     db!.rawInsert(query, args);
//   }
// }
