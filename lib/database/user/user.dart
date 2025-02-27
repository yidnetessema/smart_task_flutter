
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../helper.dart';
import 'package:smart_task_frontend/user/models/user.dart' as user_model;

class User {
  Future<void> insertUser(user_model.User user, String phoneNumber) async {
    final db = await Helper().getConnection();
    try {


      var userJSON = user.toJson();

      userJSON['phoneNumber'] = phoneNumber;

      await db.insert(
        'user',
        userJSON,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      SharedPreferences.getInstance()
          .then((value) => value.setString("currentUser", user.email));
    } catch (ex,stackTrace) {
      print(
          "================================= ${ex.toString()} -------------------------");
    }
  }
  // Future<Map<String, dynamic>> getUser() async {

  //   try {
  //     SharedPreferences phoneprefs = await SharedPreferences.getInstance();
  //     String userPhone = phoneprefs.getString("currentUser") ?? 'unknown';
  //
  //     user_model.User users = boxUser.get(userPhone);
  //     return users.toMap();
  //   } catch (e) {
  //     return {};
  //   }
  // }

  Future<Map<String, dynamic>> getUser() async {
    final db = await Helper().getConnection();

    Map<String, dynamic> response = <String, dynamic>{};

    try {

      SharedPreferences phoneprefs = await SharedPreferences.getInstance();
      String userEmail = phoneprefs.getString("currentUser") ?? 'unknown';

      List<Map<String, dynamic>> result = await db.query(
        'user',
        where: 'email = ?',
        whereArgs: [userEmail],
      );

      if (result.isNotEmpty) {
        Map<String, dynamic> res =  result.first;

        if(res['icon'] != null){
          response['status'] = 'SUCCESS';
          response['icon'] = res['icon'];

        }

      } else {
        response['status'] = "FAILURE";

      }
    } catch (e,stackTrace) {

      response['status'] = "SUCCESS";

    }

    return response;
  }

}
