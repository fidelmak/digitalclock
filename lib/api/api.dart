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
}
