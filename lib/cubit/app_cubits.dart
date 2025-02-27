
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as fire_base;
import 'package:flutter/cupertino.dart';

import 'package:smart_task_frontend/user/models/user.dart' as user_model;
import '../api/account/login.dart';
import '../contents/home/pages/home.dart';
import '../data/endpoints.dart';
import '../database/user/user.dart';
import 'package:http/http.dart' as http;

import 'app_cubit_states.dart';


class AppCubits extends Cubit<AppCubitStates> {
  AppCubits() : super(InitialState()) {
    emit(WelcomeState());
  }

  late var user;

  void loadUser() async {
    emit(LoadingUserState());
    user = await User().getUser();

    if (user != null) {
      int tokenStatusCode = 401;

      try {
        tokenStatusCode = await Login().checkTokenValidity(user['token']);
      } catch (e) {

        emit(UserNotFoundState());
      }
      if (tokenStatusCode == 401) {
        emit(UserNotFoundState());
      } else {
        if (user['status'] == 2) {
          emit(LoadedUserState(user));
        }else {
          emit(UserNotFoundState());
        }
      }
    } else {

      emit(UserNotFoundState());
    }
  }

  void loginUser(String email, String password) async {
    emit(LoadingState());
   Map<String, dynamic> response = {};
      try {
        response = await Login().loginUser(email, password);
      } catch (e) {
        emit(ErrorState("something went wrong while trying to login user!"));
      }
      if (response['id'] != null) {

        user_model.User user = user_model.User.fromJson(response);
        user.name = response['firstName']+ " " + response['lastName'];
        await User().insertUser(user, email);
        emit(LoadedUserState(user.toJson()));

      } else {
        emit(ErrorState(response['message'] != null
            ? response['message'].toString()
            : "Something went wrong while trying to login user!"));
      }

  }

  Future<Map<String, dynamic>> sendEmailVerification(String email) async {

    Map<String, Object> request = {
      'email': email
    };

    Map<String, dynamic> res = <String, dynamic>{};

    var response = await http.post(
        Endpoints.verifyEmail,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json; charset=utf-8'
        },
        body: jsonEncode(request)
    );


    if(response.statusCode == 200){

      res = jsonDecode(response.body);

      if(res['status'] != 'SUCCESS'){
        emit(ErrorState(res['message'] != null
            ? res['message'].toString()
            : "Something went wrong while trying to login user!"));
      }

    }

    return res;

  }

  void loginWithSSO(fire_base.User?  userDetails) async {
    emit(LoadingState());
    Map<String, dynamic> response = {};

    Map<String, dynamic> userInfoMap = {
      "email": userDetails!.email,
      "firstName": userDetails.displayName?.split(" ")[0] ?? '',
      "lastName": userDetails.displayName?.split("")[1] ?? '',
      "imgUrl": userDetails.photoURL ?? '',
      "token": userDetails.uid,
      "status": 1
    };

    user_model.User user = user_model.User.fromJson(userInfoMap);

    await User().insertUser(user, '');
    emit(LoadedUserState(user.toJson()));

  }

  void emitError(String message){
    emit(ErrorState(message));
  }

  void emitWelcome(){
    emit(WelcomeState());
  }

  void logoutUser(BuildContext context) async {
    if(state is LoadedUserState) {
      emit(LoadingUserState());
      user = await User().getUser();
      // await ApiClient(appBaseUrl: Endpoints.baseEndPoint).postData(
      //     "${Endpoints.baseEndPoint}/api/auth/logout",
      //     {'token': user['token']});
      Navigator.of(context)
          .pushNamedAndRemoveUntil(HomePage.routeName, (route) => true);
      emit(UserNotFoundState());
    }
  }

}