

import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_task_frontend/cubit/app_cubits.dart';

import 'package:smart_task_frontend/data/endpoints.dart';
import 'package:smart_task_frontend/contents/account/pages/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_task_frontend/contents/account/repositories/account_repository.dart';

import 'package:http/http.dart' as http;
import 'package:smart_task_frontend/utilis/string_validator.dart';


class RegisterController {

  final GlobalKey<FormFieldState> emailFieldKey = GlobalKey<FormFieldState>();

  GlobalKey<FormState> informationFormKey = GlobalKey();
  final GlobalKey<FormState> phoneFieldKey = GlobalKey();
  String phoneFieldErrorText = "";
  final GlobalKey<FormFieldState> passwordFieldKey = GlobalKey();

  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  TextEditingController genderController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();

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

  String? validateFirstName(String? text) {
    if (text == null || text.isEmpty) {
      return "Please enter your first name";
    }
    return null;
  }

  String? validateLastName(String? text) {
    if (text == null || text.isEmpty) {
      return "Please enter your last name";
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

  String? validateGender(String? text) {
    if (text == null || text.isEmpty) {
      return "Please select your gender";
    }
    return null;
  }

  String? validateBirthDate(String? text) {

    List<dynamic> validators = List.empty(growable: true);

    if (text == null || text.isEmpty) {
      return "Please select your birth date";
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


  registerUser(BuildContext context) async {

    signUpHit = true;


    if(signUpCurrentLevel == 0){
      if(emailFieldKey.currentState!.validate()) {
        await sendEmailVerification(emailController.text,context);
        // signUpHit = false;
      }
      return;
    }

    if(signUpCurrentLevel == 2){
      if(informationFormKey.currentState!.validate()){
        signUpCurrentLevel++;
        signUpHit = false;
      }
      return;
    }

    if(signUpCurrentLevel == 3){


      if(phoneFieldKey.currentState!.validate() && phoneNumberController.text.length > 0){
       await verifyPhoneNumber(phoneNumberController.text, context);
      }
      return;
    }

    if(signUpCurrentLevel == 4){
      if(passwordFieldKey.currentState!.validate()){
        signUpCurrentLevel++;
        signUpHit = false;
      }else{
        return;
      }
    }



    try {
      Map<String, Object> request = {
        "firstName": firstNameController.text,
        "lastName": lastNameController.text,
        "email": emailController.text,
        "gender": genderController.text,
        "birthDate": birthDateController.text,
        "phoneNumber": phoneNumberController.text,
        "password": passwordController.text,
      };

      // var req =  await http
      //     .post(
      //     Endpoints.register,
      //     headers: <String, String>{
      //       'Content-Type': 'application/json',
      //       'Accept': 'application/json; charset=utf-8'
      //     },
      //     body: jsonEncode(request)
      // ).catchError((error) {
      //   debugPrint("Test error $error");
      // });

      var req = await AccountRepository().registerUser(request);

      debugPrint("Test response "+req.statusCode.toString());

      if(req.statusCode == 200){

        Map<String, dynamic> response = req.body;

        finished = true;

        if (response['responseStatus'] == 'SUCCESS') {
          sendingProgressStatus = 1;
        } else {
          // sendingProgressStatus = 2;

          BlocProvider.of<AppCubits>((context))
              .emitError(response['message'] != null
              ? response['message'].toString()
              : "Something went wrong!");

        }

        message = "${response['message']}";

      }



    }catch(e,stackTrace){
      debugPrint("Error $stackTrace");
    }

  }

  verifyEmailOtp() async {

    isLoading = true;

    // debugPrint("Otp $otp reference $reference email "+emailController.text)

    Map<String, Object> request = {
      'otp': otp,
      'reference': reference,
      'email': emailController.text
    };

    var response = await AccountRepository().verifyEmailOtp(request);

    if(response.statusCode == 200){

      Map<String, dynamic> res = response.body;

      if(res['status'] == 'SUCCESS'){
        debugPrint("Response  $res");

        signUpCurrentLevel++;
      }

    }

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