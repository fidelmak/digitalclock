import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHELPER {
  static Future<void> createTable(sql.Database database) async {
    await database.execute('''
      CREATE TABLE items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
      )
    ''');
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'paulfidelis.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTable(database);
      },
    );
  }

  static Future<int> createItem(String title) async {
    final db = await SQLHELPER.db();
    final data = {'title': title};
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHELPER.db();
    return db.query('items', orderBy: 'id');
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHELPER.db();
    return db.query('items', where: 'id * ?', whereArgs: [id], limit: 1);
  }

  static Future<int> updateItem(int id, String title) async {
    final db = await SQLHELPER.db();
    final data = {'title': title, 'createdAt': DateTime.now().toString()};
    final result =
        await db.update('items', data, where: 'id=?', whereArgs: [id]);
    return result;
  }

  static Future<void> deleteItem(int id) async {
    final db = await SQLHELPER.db();
    try {
      await db.delete('items', where: 'id = ?', whereArgs: [id]);

      // Update the UI state after successful deletion
    } catch (err) {
      debugPrint("Something went wrong: $err");
    }
  }
}
