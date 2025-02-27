
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_task_frontend/cubit/app_cubit_states.dart';
import 'package:smart_task_frontend/cubit/app_cubits.dart';
import 'package:smart_task_frontend/contents/home/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:smart_task_frontend/utilis/string_validator.dart';


import '../../../data/endpoints.dart';
import '../pages/sign_up.dart';


import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart' as fire_base;

class LoginController extends Cubit<AppCubitStates> {

  LoginController() : super(
    InitialState()
  ){
    emit(WelcomeState());
  }

  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late bool finished = false;
  late bool loginUserProcessing = false;
  late String message = '';
  late int sendingProgressStatus = 0;

  bool enable = false;

  late bool signInHit = false;


  fetchData() async {

  }

  String? validateEmail(String? text) {
    if (text == null || text.isEmpty) {
      return "Please enter email";
    } else if (StringValidator.isEmail(text)) {
      return "Please enter valid email";
    }
    return null;
  }

  String? validatePassword(String? text) {
    if (text == null || text.isEmpty) {
      return "Please enter password";
    }
    return null;
  }

  void toggle() {
    enable = !enable;

  }

  void goToRegisterScreen(BuildContext context) {

    Navigator.push(context, 
      MaterialPageRoute(builder: (context) => const SignUpPage()
      )
    );
  }

  void goToForgotPasswordScreen(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const SignUpPage(),
      ),
    );
  }

  Future<void> login(BuildContext context,fire_base.User? userDetail,bool isWithSSO) async {

    signInHit = true;

    if(!isWithSSO) {
      if (formKey.currentState!.validate()) {
        message = "";
        loginUserProcessing = true;
        try {
          Map<String, Object> request = {
            "email": emailController.text,
            "password": passwordController.text
          };

          // Map<String, dynamic> response = {};
          //
          // response = await loginUser(request);

          BlocProvider.of<AppCubits>((context))
                .loginUser(emailController.text, passwordController.text);


          // finished = false;
          // loginUserProcessing = false;
          //
          // message = "${response['message']}";
          //
          // if (response['responseStatus'] == 'SUCCESS') {
          //
          //   sendingProgressStatus = 1;
          //
          //   user_model.User user = user_model.User.fromJson(response);
          //
          //   User().insertUser(user, emailController.text );
          //   emit(LoadedUserState(user.toJson()));
          // } else {
          //   sendingProgressStatus = 2;
          //
          //   emit(LoadingState());
          //
          // }

        } catch (e, stackTrace) {
          // debugPrint("Test response "+stackTrace.toString());

        }

        if (sendingProgressStatus == 1) {
          Navigator.of(context, rootNavigator: true).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        } else {

        }
      } else {}
    }else{
      BlocProvider.of<AppCubits>((context))
          .loginWithSSO(userDetail);
    }

  }

  void validateFields(){

    formKey.currentState!.validate();
  }


  Future<Map<String, dynamic>> loginUser(Map<String, Object> request) async {

    var response = await http
        .post(
        Endpoints.login,
        headers: <String, String> {
          'Content-Type': 'application/json',
          'Accept': 'application/json; charset=utf-8'
        },
        body: jsonEncode(request)
    ).catchError((error) {

    });

    return jsonDecode(response.body);

  }

  @override
  String getTag() {
    return "login_controller";
  }

  void emitWelcome(BuildContext context){
    BlocProvider.of<AppCubits>((context)).emitWelcome();
  }
}
