import 'dart:convert';


import 'package:http/http.dart' as http;

import '../../data/endpoints.dart';
import 'package:smart_task_frontend/database/user/user.dart' as user_database;

class Register {
  Future<Map<String, dynamic>> registerUser(
      String phoneNumber, String password) async {
    Map<String, dynamic> responseMap = {"status": 200};

    var response = await http
        .post(
          Endpoints.appUser,
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
          body: jsonEncode({'phone_number': phoneNumber, 'pin': password}),
        )
        .catchError((error) => {
              responseMap = {
                "status": "FAILURE",
                "message": "Something went wrong. Please, check your internet connection."
              }
            });

    if (response.statusCode == 200) {
      responseMap = await json.decode(response.body);
    } else {
      responseMap = {
        "status": "FAILURE",
        "message": "Something went wrong while trying to register user!"
      };
    }
    return responseMap;
  }

  Future<Map<String, dynamic>> verifyUser(
      String phoneNumber, String otp, String referenceCode
      ) async {
    Map<String, dynamic> responseMap = {};

    var response = await http.put(
      Endpoints.appUser,
      headers: <String, String> {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'reference_code': referenceCode, 'verification_code': otp, 'phone_number': phoneNumber, 'action': 'VERIFY'}),
    ).catchError((error) => {
      responseMap = {
        "status": "FAILURE",
        "message": "Something went wrong. Please, check your internet connection."
      }
    });

    if (response.statusCode == 200) {
      responseMap = await json.decode(response.body);
    } else {
      responseMap = {
        "status": "FAILURE",
        "message": "Something went wrong. Please, check your internet connection."
      };
    }
    return responseMap;
  }

  Future<Map<String, dynamic>> sendOtp(
      String phoneNumber
      ) async {
    Map<String, dynamic> responseMap = {};

    var response = await http.put(
      Endpoints.appUser,
      headers: <String, String> {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'phone_number': phoneNumber, 'action': 'RESEND'}),
    ).catchError((error) => {
      responseMap = {
        "status": "FAILURE",
        "message": "Something went wrong. Please, check your internet connection."
      }
    });

    if (response.statusCode == 200) {
      responseMap = await json.decode(response.body);
    } else {
      responseMap = {
        "status": "FAILURE",
        "message": "Something went wrong. Please, check your internet connection."
      };
    }
    return responseMap;
  }

  Future<Map<String, dynamic>> fetchSecurityQuestions() async {
    Map<String, dynamic> responseMap = {};

    Map? user = await user_database.User().getUser();
    var response = await http.get(
      Endpoints.securityQuestionRandom,
      headers: {'Content-Type': 'application/json', 'Authorization':"Bearer ${user!['token']}"},
    );

    print(response.body);

    if (response.statusCode == 200) {
      responseMap = await json.decode(response.body);
    } else {
      responseMap = {
        "status": "FAILURE",
        "message": "Something went wrong. Please, check your internet connection."
      };
    }
    return responseMap;
  }

  Future<Map<String, dynamic>> registerLayerTwo(Map<String, dynamic> request) async {
    Map<String, dynamic> responseMap = {};

    Map? user = await user_database.User().getUser();
    var response = await http.post(
      Endpoints.appUserCore,
      headers: {'Content-Type': 'application/json', 'Authorization':"Bearer ${user!['token']}"},
      body: jsonEncode(request)
    );
    print(response.body);
    if (response.statusCode == 200) {
      responseMap = await json.decode(response.body);
    } else if (response.statusCode == 401) {
      responseMap = {
        "status": "FAILURE",
        "message": "User unauthorized!"
      };
  } else {
      responseMap = {
        "status": "FAILURE",
        "message": "Something went wrong. Please, check your internet connection."
      };
    }
    return responseMap;
  }
}
