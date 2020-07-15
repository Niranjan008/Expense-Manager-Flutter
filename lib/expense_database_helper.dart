import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelpers {

  static final _databaseName = "ExpenseManagerDatabas.db";
  static final _databaseVersion = 5;

  static final table = 'expense_table';
  static final columnMonth = 'monthexp';
  static final columnId = '_id';
  static final columnExpenseAmount = 'expenseamount';
  static final columnDate = 'expensedate';
  static final columnCategory = 'category';
  static final columnCattype ='cattype';
  static final columnSubtype ='subcattype';
  static final columnPaytype ='paytype';
  static final columnDescription = 'description';
  // make this a singleton class
  DatabaseHelpers._privateConstructor();

  static final DatabaseHelpers instance = DatabaseHelpers._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    print(path);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnExpenseAmount TEXT NOT NULL,
            $columnDate TEXT NOT NULL,
            $columnCategory TEXT NOT NULL,
            $columnMonth INTEGER NOT NULL,
            $columnCattype INTEGER NOT NULL,
            $columnSubtype TEXT,
            $columnPaytype TEXT NOT NULL,
            $columnDescription TEXT NOT NULL
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
  Future<List> getpayreport(month,mon1) async{
    Database db = await instance.database;
    return await db.rawQuery('SELECT paytype,sum(expenseamount) from expense_table where monthexp >= $month and monthexp <= $mon1 and cattype = 1 group by paytype');
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }
  Future<List<Map<String,dynamic>>> getCategoryWiseExpense(month,month1) async{
    Database db = await instance.database;
    return await db.rawQuery('SELECT category,sum(expenseamount) from $table where monthexp >= $month and monthexp <= $month1 and cattype = 1 group by category order by category ');
  }
  Future<List<Map<String,dynamic>>> getSubCategoryWiseExpense(int month,String category,int mon1) async{
    Database db = await instance.database;
    print(category);
    return await db.rawQuery('SELECT category,sum(expenseamount) from $table where cattype = 2 and monthexp >= $month and monthexp <= $mon1 and subcattype = "$category"  group by category order by category ');
    //return await db.rawQuery('SELECT category,sum(expenseamount) from $table where monthexp = $month and cattype = 1 group by category order by category ');
  }
  Future<List<Map<String,dynamic>>> getTotalExpense(month,month1) async{
    Database db = await instance.database;
    return await db.rawQuery('SELECT sum(expenseamount) from $table where monthexp >= $month and monthexp <= $month1 and cattype = 1');
  }
  Future<List<Map<String,dynamic>>> getTotalExpensesub(month,String cat,mon1) async{
    Database db = await instance.database;
    return await db.rawQuery('SELECT sum(expenseamount) from $table where monthexp >= $month and monthexp <= $mon1 and subcattype = "$cat" and cattype =2');
  }
  Future<List<Map<String,dynamic>>> getAllExpense(mo) async{
    Database db = await instance.database;
    return await db.rawQuery('SELECT * from expense_table where cattype=2 and monthexp = $mo');
  }
  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
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
}
