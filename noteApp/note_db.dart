import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';


import 'note_model.dart';

class DatabaseHelper {

  static DatabaseHelper _databaseHelper;    // Singleton DatabaseHelper
  static Database _database;                // Singleton Database

  String dogTable = 'dog_table';
  String colId = 'id';
  String colName = 'name';
  String colage = 'age';

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {

    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {

    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    String path = join(await getDatabasesPath(), 'dogs.db');
    // Open/create the database at a given path
    var notesDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {

    await db.execute('CREATE TABLE $dogTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT, '
        '$colage INTEGER)');
  }

  // Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getDogMapList() async {
    Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $dog
    var result = await db.query(dogTable);
    return result;
  }

  // Insert Operation: Insert a Note object to database
  Future<int> insertDog(Dog dog) async {
    Database db = await this.database;
    var result = await db.insert(dogTable, dog.toMap());
    return result;
  }

  // Update Operation: Update a Note object and save it to database
  Future<int> updateDog(Dog dog) async {
    var db = await this.database;
    var result = await db.update(dogTable, dog.toMap(), where: '$colId = ?', whereArgs: [dog.id]);
    return result;
  }

  // Delete Operation: Delete a Note object from database
  Future<int> deleteDog(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $dogTable WHERE $colId = $id');
    return result;
  }

  // Get number of Note objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $dogTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
  Future<List<Dog>> getDogList() async {

    var noteMapList = await getDogMapList(); // Get 'Map List' from database
    int count = noteMapList.length;         // Count the number of map entries in db table

    List<Dog> dogList = List<Dog>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      dogList.add(Dog.fromMapObject(noteMapList[i]));
    }

    return dogList;
  }

}
