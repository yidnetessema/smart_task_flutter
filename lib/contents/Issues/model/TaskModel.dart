
import 'package:flutter/cupertino.dart';

class TaskModel {

  int totalSize =  0;
  int offset = -1;
  List<Task> tasks = [];

  TaskModel();

  TaskModel.fromJson(Map<String, dynamic> json){
    totalSize = json['totalElements'];
    offset = json['offset'];

    // if(json['subcategories'] != null){
    //   thirdParties = [];
    //
    //   json['subcategories'].forEach((v) {
    //     thirdParties.add(ThirdParty.fromJson(v));
    //   });
    // }

    if(json['tasks'] != null){
      tasks = [];

      json['tasks'].forEach((v) {


        tasks.add(Task.fromJson(v));
        debugPrint("Total ${tasks.length}");

      });


    }
  }
}

class Task {
  int? id;
  String? title;
  String? taskStatus;
  String? taskPriority;
  String? status;
  String? createdAt;
  String? updatedAt;
  bool isMore = false;
  String? description;
  String? dueDate;
  String? createdBy;

  Task({this.id, this.title, this.taskStatus, this.taskPriority,  this.status, this.createdAt, this.updatedAt});

  Task.fromJson(Map<String, dynamic> json){

    id = json["id"] ;
    title = json['title'];
    taskStatus= json['task_status'];
    taskPriority = json['task_priority'];
    dueDate = json['due_date'];
    description = json['description'];
    createdBy = json['created_by'];
  }
}