import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import '../../../database/user/user.dart' as user_data;

import 'package:http/http.dart' as Http;

import '../account/login.dart';
import 'error_response.dart';

class ApiClient extends GetxService {
  final String appBaseUrl;

  // final SharedPreferences sharedPreferences;
  static const String noInternetMessage =
      'Connection to API server failed due to internet connection';
  final int timeoutInSeconds = 10;

  // late String token;
  late Map<String, String> _mainHeaders;

  ApiClient({required this.appBaseUrl}) {
    try {} catch (e) {}
    updateHeader(
        // token
        );
  }

  void updateHeader() async {
    var user = await user_data.User().getUser();
    String token = user['token'] ?? '';
    _mainHeaders = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json; charset=utf-8',
    };
    if(token.isNotEmpty) {
      _mainHeaders['Authorization'] = 'Bearer $token';
    }
  }

  Future<Response> getData(String uri) async {
    var user = await user_data.User().getUser();
    String token = user['token'] ?? '';
    dynamic mainHeaders = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json; charset=UTF-8'
    };

    if (token.isNotEmpty) {
      mainHeaders['Authorization'] = 'Bearer $token';
    }

    try {
      Http.Response response = await Http.get(
        Uri.parse(uri),
        headers: mainHeaders,
      );
      if (response.statusCode == 401) {
        var user = await user_data.User().getUser();
        dynamic mainHeaders = {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json; charset=UTF-8'
        };
        token = user['token'] ?? '';
        if (token.isNotEmpty) {
          mainHeaders['Authorization'] = 'Bearer $token';
        }

        response = await Http.get(
          Uri.parse(uri),
          headers: mainHeaders,
        );
      }
      return handleResponse(response, uri);
    } catch (e) {
      return const Response(statusCode: 500, statusText: noInternetMessage);
    }
  }

  Future<Response> postData(String uri, dynamic body) async {
    var user = await user_data.User().getUser();
    String token = user['token'] ?? '';
    dynamic mainHeaders = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json; charset=UTF-8',
    };
    if (token.isNotEmpty) {
      mainHeaders['Authorization'] = 'Bearer $token';
    }
    try {
      Http.Response response = await Http.post(Uri.parse(uri),
          headers: mainHeaders, body: jsonEncode(body));

      if (response.statusCode == 401) {
        var user = await user_data.User().getUser();
        dynamic mainHeaders = {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json; charset=UTF-8',
        };
        token = user['token'] ?? '';
        if (token.isNotEmpty) {
          mainHeaders['Authorization'] = 'Bearer $token';
        }
        response = await Http.post(Uri.parse(uri),
            headers: mainHeaders, body: jsonEncode(body));
      }
      return handleResponse(response, uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> putData(String uri, dynamic body) async {
    var user = await user_data.User().getUser();
    String token = user['token'] ?? '';
    dynamic mainHeaders = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json; charset=UTF-8',
    };

    if (token.isNotEmpty) {
      mainHeaders['Authorization'] = 'Bearer $token';
    }

    try {
      Http.Response response = await Http.put(Uri.parse(uri),
          headers: mainHeaders, body: jsonEncode(body));

      if (response.statusCode == 401) {
        var user = await user_data.User().getUser();
        dynamic mainHeaders = {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json; charset=UTF-8',
        };
        token = user['token'] ?? '';
        if (token.isNotEmpty) {
          mainHeaders['Authorization'] = 'Bearer $token';
        }
        response = await Http.put(Uri.parse(uri),
            headers: mainHeaders, body: jsonEncode(body));
      }
      return handleResponse(response, uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Response handleResponse(Http.Response response, String uri) {
    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (e) {}
    Response response0 = Response(
      body: body ?? response.body,
      bodyString: response.body.toString(),
      request: Request(
          headers: response.request!.headers,
          method: response.request!.method,
          url: response.request!.url),
      headers: response.headers,
      statusCode: response.statusCode,
      statusText: response.reasonPhrase,
    );
    if (response0.statusCode != 200 &&
        response0.body != null &&
        response0.body is! String) {
      if (response0.body.toString().startsWith('{errors: [{code:')) {
        ErrorResponse errorResponse = ErrorResponse.fromJson(response0.body);
        response0 = Response(
            statusCode: response0.statusCode,
            body: response0.body,
            statusText: errorResponse.errors[0].message);
      } else if (response0.body.toString().startsWith('{message')) {
        response0 = Response(
            statusCode: response0.statusCode,
            body: response0.body,
            statusText: response0.body['message']);
      }
    } else if (response0.statusCode != 200 && response0.body == null) {
      response0 = const Response(statusCode: 0, statusText: noInternetMessage);
    }

    return response0;
  }
}
