
import 'package:get/get.dart';
import 'package:smart_task_frontend/data/endpoints.dart';

import '../../../api/helper/api_client.dart';

class AccountRepository {

  ApiClient apiClient = ApiClient(appBaseUrl: Endpoints.baseEndPoint);

  Future<Response> sendEmailVerification(Map<String, Object> requestJSON){
    return apiClient.postData('${Endpoints.baseEndPoint}/auth/verify-email',requestJSON);
  }

  Future<Response> verifyEmailOtp(Map<String, Object> requestJSON){
    return apiClient.postData('${Endpoints.baseEndPoint}/auth/verify-email-otp',requestJSON);
  }

  Future<Response> sendPhoneVerification(Map<String, Object> requestJSON){
    return apiClient.postData('${Endpoints.baseEndPoint}/auth/verify-phone',requestJSON);
  }

  Future<Response> registerUser(Map<String, Object> requestJSON){
    return apiClient.postData('${Endpoints.baseEndPoint}/auth/register',requestJSON);
  }

}