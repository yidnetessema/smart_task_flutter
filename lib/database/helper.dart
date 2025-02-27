import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Helper {

  dynamic getConnection() async {
    WidgetsFlutterBinding.ensureInitialized();

    return openDatabase(
      join(await getDatabasesPath(), 'inkomoko_st.db'),
      onCreate: (db, version) async {
        try {
          await createUserTable(db);
          await createTaskTable(db);
        } catch (ex) {
        }
      },
      onUpgrade: (db, oldVersion, newVersion) async {
      },
      version: 1,
    );
  }


  Future<void> createUserTable(Database db) async {

    try {
      await db.execute("CREATE TABLE user ("
          "id INTEGER NOT NULL primary key AUTOINCREMENT, "
          "name varchar(255) NOT NULL, "
          "email varchar(100) NOT NULL, "
          "phoneNumber varchar(100), "
          "token text,"
          "status int(11) NOT NULL,"
          "imgUrl text,"
          "createdAt varchar(30))");

    } catch (ex) {
      ex.toString();
      debugPrint("Error while creating ${ex.toString()}");

    }
  }

  Future<void> createTaskTable(Database db) async {

    try {
      await db.execute("CREATE TABLE task ("
          "id INTEGER NOT NULL primary key AUTOINCREMENT, "
          "title varchar(255) NOT NULL, "
          "task_priority varchar(30) NOT NULL, "
          "task_status varchar(30) NOT NULL, "
          "due_date varchar(30), "
          "status int(11) NOT NULL DEFAULT 1,"
          "description varchar(300) NOT NULL, "
          "created_by varchar(100) NOT NULL, "
          "created_at varchar(30))");

    } catch (ex) {
      ex.toString();
      debugPrint("Error while creating ${ex.toString()}");

    }
  }
}
