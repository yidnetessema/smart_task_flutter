
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_task_frontend/contents/Issues/model/TaskModel.dart';
import 'package:sqflite/sqflite.dart';

import '../helper.dart';

class TaskDb {
  Future<void> insertTask(Map<String, dynamic> task) async {
    final db = await Helper().getConnection();

    String email = await getTask();
    task['created_by'] = email;

    try {
      await db.insert(
        'task',
        task,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (ex,stackTrace) {
      print(
          "================================= ${ex.toString()} -------------------------");
    }
  }

  Future<String> getTask() async {
    final db = await Helper().getConnection();

    String email = '';
    try {

      SharedPreferences phoneprefs = await SharedPreferences.getInstance();
      email = phoneprefs.getString("currentUser") ?? 'unknown';

    } catch (e,stackTrace) {

    }

    return email;
  }

  Future<Map<String, dynamic>> getTasks(int page, int amount,String taskPriority, String taskStatus, String q) async {
    final db = await Helper().getConnection();

    try{

      // Calculate the offset for pagination
      int offset = page * 10;

      List<Map> tasks = [];

      if(taskPriority == 'ALL'  && taskStatus != 'ALL'){
        tasks = await db.query(
            'task',
            where: 'taskStatus = ? AND status = 1',
            whereArgs: [taskStatus],
            orderBy: 'id DESC',
            limit: amount,
            offset: offset);
      }else if(taskPriority != 'ALL'  && taskStatus == 'ALL'){
        tasks = await db.query(
            'task',
            where: 'taskPriority = ? AND status = 1',
            whereArgs: [taskPriority],
            orderBy: 'id DESC',
            limit: amount,
            offset: offset);
      }else{
        tasks = await db.query(
            'task',
            where: 'status = 1',
            orderBy: 'id DESC',
            limit: amount,
            offset: offset);
      }


      int totalCount = await getTotalData();

      bool isLastPage = (offset + tasks.length) >= totalCount;

      if(tasks.isNotEmpty){

        return {
          'status': 'SUCCESS',
          'tasks': tasks,
          'isLastPage': isLastPage,
          'offset': offset,
          'limit': 10,
          'totalElements': totalCount
        };
      }else{
        return {
          'status': 'FAILURE'
        };
      }
    }catch(e, stackTrace){

      return {
        'status': 'FAILURE'
      };
    }

  }


  Future<Map<String, dynamic>> getTaskById(int id) async {
    final db = await Helper().getConnection();

    try{

      List<Map> tasks = [];

      tasks = await db.query(
          'task',
          where: 'id = ?',
          whereArgs: [id],
          orderBy: 'id DESC');


      if(tasks.isNotEmpty){

        return {
          'status': 'SUCCESS',
          'task': tasks.first
        };
      }else{
        return {
          'status': 'FAILURE'
        };
      }
    }catch(e, stackTrace){

      return {
        'status': 'FAILURE'
      };
    }

  }


  Future<void> updateTaskById(int id,Map<String, dynamic> task) async {
    final db = await Helper().getConnection();

    try {

      await db.update(
        'task',
        {
          'title': task['title'],
          'task_priority': task['task_priority'],
          'due_date': task['due_date'],
          'description': task['description']
        },
        where: 'id = ?',
        whereArgs: [id],
      );

    } catch (e) {
    }
  }

  Future<void> deleteTaskById(int id) async {
    final db = await Helper().getConnection();

    try {

      await db.update(
        'task',
        {
          'status': 0
        },
        where: 'id = ?',
        whereArgs: [id],
      );

    } catch (e) {
    }
  }


  Future<int> getTotalData() async {
    final db = await Helper().getConnection();

    try {
      // Execute raw query to get the total count of rows
      final result = await db.rawQuery('SELECT COUNT(*) as count FROM task where status = 1');

      // Extract the count from the result
      if (result.isNotEmpty) {
        return result.first['count'] as int; // Cast to int
      } else {
        return 0;
      }
    } catch (e) {
      // Handle error
      return 0;
    }
  }

}
