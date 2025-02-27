

import 'package:get/get_connect/http/src/response/response.dart';

import '../../../api/helper/api_client.dart';
import '../../../data/endpoints.dart';

class TaskRepository {

  ApiClient apiClient = ApiClient(appBaseUrl: Endpoints.baseEndPoint);

  Future<Response> registerTask(Map<String, Object> requestJSON){
    return apiClient.postData('${Endpoints.baseEndPoint}/task',requestJSON);
  }
}
