import 'dart:async';
import 'dart:io' as io;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Notes {
  static Database _db;
  String table = "notes";
  String items = "";

  Future<Database> get db async {
    if (_db == null) {
      _db = await initDataBase();
      return _db;
    } else {
      return _db;
    }
  }

  initDataBase() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = join(directory.path, "test.db");
    var mydb = await openDatabase(dbPath, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE "${table}" ("id"	INTEGER NOT NULL UNIQUE, "note"	TEXT NOT NULL, PRIMARY KEY("id" AUTOINCREMENT))');
    });
    print("${table} table created....");
    return mydb;
  }

  // fun create to insert new note...
  Future<int> creat(Map<String, dynamic> data) async {
    var dbClient = await db;
    int insert = await dbClient.insert(table, data);
    return insert;
  }

  Future<List> retrieve(
      {int id: 0, String sortOrder: "ASC", int lastId}) async {
    var dbClient = await db;
    if (id > 0) {
      return await dbClient.query(table, where: 'id = $id');
    } else {
      if (lastId != null && !lastId.isNaN &&sortOrder=="ASC") {
        return await dbClient.query(table, orderBy: 'id  $sortOrder', limit: 11, where: 'id > $lastId');
      }else if (lastId != null && !lastId.isNaN &&sortOrder=="DESC") {
        return await dbClient.query(table, orderBy: 'id  $sortOrder', limit: 11, where: 'id < $lastId');
      }
      else {
        return await dbClient.query(table,
            orderBy: 'id  $sortOrder', limit: 11);
      }
    }
  }

  Future<int> update({String note: "", int id}) async {
    var dbClient = await db;
    int update = await dbClient
        .rawUpdate('update $table set note = "$note" where id = "$id"');
    return update;
  }

  Future<int> delete({int id}) async {
    var dbClient = await db;
    int delete =
        await dbClient.rawUpdate('delete from $table where id = "$id"');
    return delete;
  }

  Future<int> deleteAll({List checkedItems}) async {
    var dbClient = await db;
    for (var checked in checkedItems) {
      items += "$checked,";
    }
    String selectedIds = items.substring(0, items.length - 1);
    int delete = await dbClient
        .rawUpdate('delete from $table where id in (${selectedIds})');
    return delete;
  }

  Future<int> DeleteUndo(Map<String, dynamic> data) async {
    var dbClient = await db;
    int insert = await dbClient.insert(table, data);
    return insert;
  }
}
