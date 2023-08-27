import 'package:crm_application/Models/DialModel.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DatabaseHelper {
  static Future<sql.Database> db() async {
    return sql.openDatabase('dialerssss.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  // static Future<sql.Database> ffiDb() async {
  //   return sql.openDatabase('flutterjunction.db', version: 1,
  //       onCreate: (sql.Database database, int version) async {
  //     await createTables(database);
  //   });
  // }

  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE callss(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        callId INTEGER,
        type TEXT,
        name TEXT,
        start_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        end_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        connected INTEGER,
        status INTEGER,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP)""");
  }

  //create new item
  static Future<int> createItem({
    required int callId,
    required String type,
    required String startTime,
    required String endTime,
    required String name,
    required int connected,
  }) async {
    final db = await DatabaseHelper.db();

    final data = DialModel(
      callId: callId,
      type: type,
      startTime: startTime,
      endTime: endTime,
      status: 0,
      createdAt: startTime,
      connected: connected,
      name: name,
    );
    final id = await db.insert('callss', data.toJson(),
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    if (id != null) {
      print('item created in db $id');
    }
    return id;
  }

  //read all items
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await DatabaseHelper.db();
    return db.query('callss', orderBy: "id");
  }

  //Get a single item by id
  //we don't use this method, it is for you if you want it
  // static Future<List<Map<String, dynamic>>> getItem(int id) async {
  //   final db = await DatabaseHelper.db();
  //   return await db.query('items', where: "id=?", whereArgs: [id], limit: 1);
  // }

  //update a single item by id
  static Future<int> updateItem(DialModel dial) async {
    final db = await DatabaseHelper.db();

    var data = dial.toJson();

    final result =
        await db.update('callss', data, where: "id= ?", whereArgs: [dial.id]);
    return result;
  }

  //Delete
  static Future<void> deleteItem(int id) async {
    final db = await DatabaseHelper.db();
    try {
      await db.delete('callss', where: "id = ?", whereArgs: [id]);
    } catch (e) {
      debugPrint('Something went wrong when deleting an item: $e');
    }
  }
}
