
import 'package:get/get.dart';
import 'package:smart_task_frontend/contents/Issues/controllers/task_conroller.dart';

import '../api/helper/api_client.dart';
import '../data/endpoints.dart';

Future<Map<String, Map<String, String>>?> init() async {
  // Core

  Get.lazyPut(() => ApiClient(appBaseUrl: Endpoints.baseEndPoint));

  Get.lazyPut(() => TaskController());

  return null;

}
