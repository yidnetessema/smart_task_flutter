import 'dart:convert';


import '../../data/endpoints.dart';
import 'package:http/http.dart' as http;

class Login {
  Future<Map<String, dynamic>> loginUser(
      String username, String password) async {
    Map<String, dynamic> responseMap = {"status": 200};

    var response = await http
        .post(
      Endpoints.login,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode({'email': username, 'password': password}),
    )
        .catchError((error) => {
      responseMap = {
        "status": "FAILURE",
        "message": "Something went wrong. Please, check your internet connection."
      }
    });

    if (response.statusCode == 200) {
      responseMap = await json.decode(response.body);
    } else if (response.statusCode == 401) {
      responseMap = {
        "status": "FAILURE",
        "message": "Invalid PIN or user!"
      };
    } else {
      responseMap = {
        "status": "FAILURE",
        "message": "Something went wrong. Please, check your internet connection."
      };
    }
    return responseMap;
  }

  Future<int> checkTokenValidity(String token) async {
    var response = await http.get(
      Endpoints.securityQuestionRandom,
      headers: {'Content-Type': 'application/json', 'Authorization':"Bearer $token"},
    );

    return response.statusCode;
  }
}