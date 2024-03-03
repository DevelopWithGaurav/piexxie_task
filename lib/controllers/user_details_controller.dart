import 'dart:developer';

import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:piexxie_task/data/models/response/user_model.dart';

import '../data/models/response/response_model.dart';
import '../data/repositories/user_repo.dart';

class UserDetailsController extends GetxController implements GetxService {
  UserDetailsController({required this.userRepo});
  final UserRepo userRepo;

  UserModel latestUser = UserModel();

  Future<ResponseModel> getUserDetails(String userID) async {
    log('getUserDetails CALLED');

    ResponseModel responseModel;

    try {
      final Response response = await userRepo.getUserDetails(userID);

      if (response.statusCode == 200) {
        if (response.body is Map) {
          responseModel = ResponseModel(true, '${response.body}', response.body);
          latestUser = UserModel.fromJson(response.body);
          update();
        } else {
          responseModel = ResponseModel(false, response.statusText ?? '');
        }
      } else {
        responseModel = ResponseModel(false, response.statusText ?? '');
      }
    } catch (e) {
      responseModel = ResponseModel(false, 'CATCH');
      log('++++++++ ${e.toString()} ++++++++', name: 'ERROR AT getUserDetails()');
    }

    return responseModel;
  }
}
