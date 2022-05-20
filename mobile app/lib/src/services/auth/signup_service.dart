import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:verdhale/src/models/auth/signup_model.dart';
import 'package:verdhale/src/services/api.dart';
import 'package:verdhale/src/utils/secure_storage.dart';

class SignUpService {
  //final baseUrl = "http://localhost:3000/api";
  final baseUrl = API.baseUrl;
  Future<Map<String, dynamic>> registerUser({
    required endpoint,
    required fullname,
    required email,
    required password,
  }) async {
    SignUpModel user = SignUpModel(
      fullname: fullname,
      email: email,
      password: password,
    );

    http.Response response = await http.post(
      Uri.parse(baseUrl + endpoint),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
      },
      body: jsonEncode(
        user.toJson(),
      ),
    );

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      return responseBody;
    }

    throw response;
  }

  Future uploadProfileImage({required imagePath, required endpoint}) async {
    final token = await SecureStorage.storage.read(key: "token");
    http.MultipartRequest request = http.MultipartRequest(
      "PATCH",
      Uri.parse(baseUrl + endpoint),
    );

    request.files.add(await http.MultipartFile.fromPath("image", imagePath));
    request.headers.addAll({
      "content-type": "multipart/form-data",
      "X-auth-token": "$token",
    });
    var response = await request.send();
    return response;
  }
}
