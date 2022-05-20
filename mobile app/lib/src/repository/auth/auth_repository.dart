import 'dart:convert';

import 'package:verdhale/src/services/auth/login_service.dart';
import 'package:http/http.dart';
import 'package:verdhale/src/services/auth/signup_service.dart';
import 'package:verdhale/src/utils/request_response.dart';

class AuthRepository {
  final LoginService _loginService = LoginService();
  final SignUpService _signUpService = SignUpService();

  Future<Map<String, dynamic>> loginUser(
      {required endpoint, required userEmail, required userPassword}) async {
    return _getRepositoryData(
      getData: () => _loginService.loginUser(
        endpoint: endpoint,
        email: userEmail,
        password: userPassword,
      ),
    );
  }

  Future<Map<String, dynamic>> registerUser({
    required endpoint,
    required userFullname,
    required userEmail,
    required userPassword,
  }) {
    return _getRepositoryData(
      getData: () => _signUpService.registerUser(
        endpoint: endpoint,
        fullname: userFullname,
        email: userEmail,
        password: userPassword,
      ),
    );
  }

  Future uploadProfileImage({required endpoint, required imagePath}) {
    return _getRepositoryData(
      getData: () => _signUpService.uploadProfileImage(
        imagePath: imagePath,
        endpoint: endpoint,
      ),
    );
  }

  Future<T> _getRepositoryData<T>(
      {required Future<T> Function() getData}) async {
    try {
      return await getData();
    } on Response catch (response) {
      var responseBody = RequestResponse.requestResponse(response);
      print(responseBody);
      return jsonDecode(responseBody);

      // rethrow;
    }
  }
}
