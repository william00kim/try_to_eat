import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:try_to_eat/InnerDatabase/SearchDBDataModel.dart';

class Innerdatabaseclass {

  late Database _database;

  Future<Database?> get database async {
    print("database get 실행됨");
    _database = await initDB();
    return _database;
  }

  initDB() async {
    print("database init 실행됨");
    String path = join(await getDatabasesPath(), 'SearchDB5.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE SearchDBDataModel(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          category TEXT,
          phone TEXT,
          address_name TEXT,
          road_address_name TEXT,
          place_url TEXT,
          x TEXT,
          y TEXT
        )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) {}
    );
  }

  Future<List<Searchdbdatamodel>> getDB() async {
    print("database getDB 실행됨");
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query("SearchDBDataModel");
    if(maps.isEmpty) return [];
    List<Searchdbdatamodel> list = List.generate(maps.length, (index) {
      return Searchdbdatamodel(
        id: maps[index]["id"],
        name: maps[index]["name"],
        category: maps[index]["category"],
        phone: maps[index]["phone"],
        address_name: maps[index]["address_name"],
        road_address_name: maps[index]["road_address_name"],
        place_url: maps[index]["place_url"],
        x: maps[index]["x"],
        y: maps[index]["y"],

      );
    });
    return list;
  }
  
  Future<void> insert(Searchdbdatamodel model) async {
    print("database insert 실행됨");
    final db = await database;
    model.id = await db!.insert("SearchDBDataModel", model.toMap());
  }

  Future<void> updateDB(Searchdbdatamodel model) async {
    print("database updateDB 실행됨");
    final db = await database;
    await db?.update("SearchDBDataModel", model.toMap(),where: "name = ?", whereArgs: [model.name]);
  }

  Future<void> deleteDB(Searchdbdatamodel model) async {
    print("database deleteDB 실행됨");
    final db = await database;
    await db?.delete("SearchDBDataModel", where: "id = ?", whereArgs: [model.id]);
  }

  Future<void> deleteAllDB() async {
    final db = await database;
    await db?.delete("SearchDBDataModel");
  }
}