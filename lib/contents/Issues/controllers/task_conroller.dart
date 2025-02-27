
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:smart_task_frontend/contents/Issues/model/TaskModel.dart';
import 'package:smart_task_frontend/cubit/app_cubits.dart';

import 'package:smart_task_frontend/contents/account/pages/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_task_frontend/contents/account/repositories/account_repository.dart';

import 'package:http/http.dart' as http;
import 'package:smart_task_frontend/utilis/string_validator.dart';

import '../../../database/task/task.dart';

class TaskController {

  final GlobalKey<FormFieldState> emailFieldKey = GlobalKey<FormFieldState>();

  GlobalKey<FormState> informationFormKey = GlobalKey();
  final GlobalKey<FormState> phoneFieldKey = GlobalKey();
  String phoneFieldErrorText = "";
  final GlobalKey<FormFieldState> passwordFieldKey = GlobalKey();

  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController titleController = TextEditingController();
  TextEditingController taskStatusController = TextEditingController();
  TextEditingController taskPriorityController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  late int sendingProgressStatus = 0;
  late bool finished = false;
  late bool registeringUser = false;
  late String message = '';
  late bool signUpHit = false;
  late bool validEmail = false;

  int signUpLevel = 4;
  int signUpCurrentLevel = 0;
  bool isLoading = false;

  String otp = '';

  late String reference = '';


  TaskModel _taskModel = TaskModel();
  late List<Task> _taskList;

  TaskModel get taskModel => _taskModel;
  List<Task> get taskList => _taskList;

  int actionMode = 0;

  int id = 0;

  String? validateTitle(String? text) {
    if (text == null || text.isEmpty) {
      return "Please enter your title";
    }
    return null;
  }

  String? validateDescription(String? text) {
    if (text == null || text.isEmpty) {
      return "Please enter description";
    }
    return null;
  }

  String? validatePhoneNumber(String? text) {
    if (text == null || text.isEmpty) {
      return "Please enter your phone number";
    }
    return null;
  }

  String? validatePassword(String? text) {
    if (text == null || text.isEmpty) {
      return "Please enter password";
    } else if (text.length < 8) {
      return "Password must be at least 8 digit long";
    }
    return null;
  }

  String? validateEmail(String? text) {
    if (text == null || text.isEmpty) {
      return "Please enter email";
    } else if (StringValidator.isEmail(text)) {
      return "Please enter valid email";
    }
    return null;
  }

  String? validateTaskPriority(String? text) {
    if (text == null || text.isEmpty) {
      return "Please select priority";
    }
    return null;
  }

  String? validateDueDate(String? text) {

    List<dynamic> validators = List.empty(growable: true);

    if (text == null || text.isEmpty) {
      return "Please select due date";
    }
    return null;
  }

  // Future<Map<String, dynamic>> registerUser(Map<String, Object> request) async {
  //
  //    var response = await http
  //        .post(
  //        Endpoints.register,
  //        headers: <String, String>{
  //          'Content-Type': 'application/json',
  //          'Accept': 'application/json; charset=utf-8'
  //        },
  //        body: jsonEncode(request)
  //    ).catchError((error) {
  //
  //      debugPrint("Test error $error");
  //    });
  //
  //    return jsonDecode(response.body);
  //
  //
  // }

  Future<void> sendEmailVerification(String email,BuildContext context) async {

    Map<String, Object> request = {
      'email': email
    };

    var response = await AccountRepository().sendEmailVerification(request);

    if(response.statusCode == 200){

      Map<String,dynamic> res = response.body;

      if(res['status'] == 'SUCCESS'){
        signUpCurrentLevel++;
        reference = res['reference'].toString();
        validEmail = true;
      }else{
        validEmail = false;
        message = res['message'].toString();


        BlocProvider.of<AppCubits>((context))
            .emitError(res['message'] != null
            ? res['message'].toString()
            : "Something went wrong while trying to login user!");


      }

    }

  }

  Future<void> verifyPhoneNumber(String phone,BuildContext context) async {

    Map<String, Object> request = {
      'phone': phone
    };

    var response = await AccountRepository().sendPhoneVerification(request);

    if(response.statusCode == 200){

      Map<String, dynamic> res = response.body;

      if(res['status'] == 'SUCCESS'){
        signUpCurrentLevel++;
        reference = res['reference'].toString();
        validEmail = true;
        signUpHit = false;
      }else{
        validEmail = false;
        message = res['message'].toString();

        BlocProvider.of<AppCubits>((context))
            .emitError(res['message'] != null
            ? res['message'].toString()
            : "Something went wrong!");


      }

    }

  }


  Future<bool> registerTask(BuildContext context) async {

    signUpHit = true;
    bool saved = false;

    if(informationFormKey.currentState!.validate()){
        signUpCurrentLevel++;

        try {
          Map<String, Object> request = {
            "title": titleController.text,
            "task_priority": taskPriorityController.text,
            "task_status": "TODO",
            "due_date": dueDateController.text,
            "description": descriptionController.text
          };

          debugPrint("Action mode $actionMode");
          if(actionMode == 0){
            await TaskDb().insertTask(request);

          }else{
            debugPrint("Update");
            await TaskDb().updateTaskById(id, request);
          }

          saved = true;

        }catch(e,stackTrace){
          saved = false;
        }
        signUpHit = false;
      }

    return saved;


  }

  Future<TaskModel> getTasks(int offset, int amount,String taskPriority,String taskStatus,String q) async{
    const int maxAttempts = 3;
    int attempt = 0;

    _taskModel = TaskModel();

    int countTaskInDb = await TaskDb().getTotalData();


    while (attempt < maxAttempts) {

      if(offset == 0 && countTaskInDb > 0){

        Map<String, dynamic> taskJson = await TaskDb().getTasks(offset,10,taskPriority,taskStatus,q);

        if(taskJson['status'] == 'SUCCESS'){

          _taskModel = TaskModel.fromJson(taskJson);

          return _taskModel;
        }

      }

      Map<String, dynamic> taskJson = await TaskDb().getTasks(offset,10,taskPriority,taskStatus,q);


      if(taskJson['status'] == 'SUCCESS'){


        TaskModel.fromJson(taskJson).tasks.forEach((t){

          bool exists = _taskModel.tasks.any((existingTask) => existingTask.id == t.id);

          if(!exists){
            _taskModel.tasks
                .add(t);
          }

        });

        return _taskModel;
      }

      attempt++;


      if (attempt < maxAttempts) {
        await Future.delayed(Duration(seconds: 1));
      }
    }

    return _taskModel;

  }

  Future<Map<String, dynamic>> getTaskById(int id) async {


    Map<String, dynamic> taskJson = await TaskDb().getTaskById(id);

    return taskJson;

  }

  Future<void> deleteTaskById(int id) async {

    await TaskDb().deleteTaskById(id);
  }



  void goToLoginScreen(BuildContext context){
    Navigator.of(context, rootNavigator: true).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginPage(autoLogin: false),
      ),
    );
  }

  void emitWelcome(BuildContext context){
    BlocProvider.of<AppCubits>((context)).emitWelcome();
  }

}