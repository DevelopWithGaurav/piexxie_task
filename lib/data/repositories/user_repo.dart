import 'package:get/get_connect/http/src/response/response.dart';

import '../../app_constant.dart';
import '../api/api_client.dart';

class UserRepo {
  UserRepo({required this.apiClient});

  final ApiClient apiClient;

  Future<Response> getUserList(int offset) async => apiClient.getData('${AppConstants.userUrl}?limit=${offset * 10}');

  Future<Response> getUserDetails(String userID) async => apiClient.getData('${AppConstants.userUrl}/$userID');
}
