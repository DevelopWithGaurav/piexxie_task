import 'dart:developer';

import 'package:get/instance_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_constant.dart';
import 'controllers/user_details_controller.dart';
import 'controllers/user_list_controller.dart';
import 'data/api/api_client.dart';
import 'data/repositories/user_repo.dart';

class Init {
  initialize() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    Get.lazyPut<SharedPreferences>(() => sharedPreferences);

    try {
      // repo
      Get.lazyPut(() => ApiClient(appBaseUrl: AppConstants.baseUrl, sharedPreferences: Get.find()));
      Get.lazyPut(() => UserRepo(apiClient: Get.find()));

      // controller
      Get.lazyPut(() => UserListController(userRepo: Get.find()));
      Get.lazyPut(() => UserDetailsController(userRepo: Get.find()));
    } catch (e) {
      log('---- ${e.toString()} ----', name: "ERROR AT initialize()");
    }
  }
}
