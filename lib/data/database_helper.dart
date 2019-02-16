import 'dart:async';
import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:emrals/models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE User(id INTEGER PRIMARY KEY, username TEXT, token TEXT, picture TEXT, xp INTEGER, emrals REAL, emrals_address TEXT)");
    // await db.execute(
    //     "CREATE TABLE OfflineReport(id INTEGER PRIMARY KEY, filename TEXT, longitude REAL, latitude REAL)");
  }

  Future<int> saveUser(User user) async {
    var dbClient = await db;
    int res = await dbClient.insert("User", user.toMap());
    return res;
  }

  Future<int> updateUser(User user) async {
    var dbClient = await db;
    int res = await dbClient.update("User", user.toMap());
    return res;
  }

  // Future<int> saveOfflineReport(OfflineReport offlineReport) async {
  //   var dbClient = await db;
  //   int res = await dbClient.insert("OfflineReport", offlineReport.toMap());
  //   return res;
  // }

  Future<int> deleteUsers() async {
    var dbClient = await db;
    int res = await dbClient.delete("User");
    return res;
  }

  Future<bool> isLoggedIn() async {
    var dbClient = await db;
    var res = await dbClient.query("User");
    return res.length > 0 ? true : false;
  }

  Future<User> getUser() async {
    var dbClient = await db;
    var res = await dbClient.query("User");
    return res.isNotEmpty ? User.fromMap(res.first) : null;
  }
}
