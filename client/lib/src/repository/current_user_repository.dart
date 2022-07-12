import 'dart:convert';

import 'package:http/http.dart';
import 'package:verdhale/src/models/current_user_model.dart';
import 'package:verdhale/src/services/current_user_service.dart';
import 'package:verdhale/src/utils/request_response.dart';

class CurrentUserRepository {
  final CurrentUserService _currentUserService = CurrentUserService();

  Future getCurrentUser({required endpoint}) async {
    try {
      var currentUserData =
          await _currentUserService.getCurrentUser(endpoint: endpoint);
      return CurrentUserModel.fromJson(currentUserData);
    } on Response catch (response) {
      var responseBody = RequestResponse.requestResponse(response);
      return jsonDecode(responseBody);
    }
  }
}
