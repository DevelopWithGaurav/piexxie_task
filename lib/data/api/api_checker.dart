import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ApiChecker {
  static void checkApi(Response response) {
    if (response.statusCode == 401) {
      log('here 401');
      Fluttertoast.showToast(msg: 'Unauthenticated');
      // Get.find<AuthController>().clearSharedData().then((value) {
      //   navigatorKey.currentState!.pushAndRemoveUntil(getCustomRoute(child: const SplashScreen()), (route) => false);
      // });
    } else if (response.statusCode == 429) {
      Fluttertoast.showToast(msg: 'Too many requests!');
      // Get.find<AuthController>().clearSharedData();
      // navigatorKey.currentState!.pushAndRemoveUntil(getCustomRoute(child: const SplashScreen()), (route) => false);
      log('here 429');
    } else {
      log('${response.statusText} : ${response.body ?? ''}');
      if (response.statusText!.contains('Too many connections')) {
        Fluttertoast.showToast(msg: 'Too many connections');
      }
    }
  }
}
