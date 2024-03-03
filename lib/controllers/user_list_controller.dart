import 'dart:convert';
import 'dart:developer';

import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:piexxie_task/data/repositories/user_repo.dart';

import '../data/models/response/response_model.dart';
import '../data/models/response/user_model.dart';

class UserListController extends GetxController implements GetxService {
  UserListController({required this.userRepo});
  final UserRepo userRepo;

  bool isLoading = false;

  List<UserModel> allUsers = [];

  bool shouldPaginate = true;
  int _page = 1;
  Future<ResponseModel> getUserList(bool paginate) async {
    log('getUserList CALLED');

    ResponseModel responseModel;

    if (paginate) {
      _page++;
    } else {
      shouldPaginate = true;
      _page = 1;
    }

    if (_page != 1 && !shouldPaginate) {
      return ResponseModel(false, 'message');
    }

    isLoading = true;
    update();

    try {
      final Response response = await userRepo.getUserList(_page);

      if (response.statusCode == 200) {
        if (response.body['data'] != null && response.body['data'] is List) {
          responseModel = ResponseModel(true, '${response.body}', response.body);

          if (userModelFromJson(jsonEncode(response.body['data'])).isEmpty) {
            shouldPaginate = false;
          }

          if (_page == 1) {
            allUsers = userModelFromJson(jsonEncode(response.body['data']));
          } else {
            allUsers.addAll(userModelFromJson(jsonEncode(response.body['data'])));
          }
        } else {
          responseModel = ResponseModel(false, response.statusText!);
        }
      } else {
        responseModel = ResponseModel(false, response.statusText!);
      }
    } catch (e) {
      responseModel = ResponseModel(false, 'CATCH');
      log('++++++++ ${e.toString()} ++++++++', name: 'ERROR AT getUserList()');
    }

    isLoading = false;
    update();

    return responseModel;
  }
}
