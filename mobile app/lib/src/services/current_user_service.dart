import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:verdhale/src/services/api.dart';
import 'package:verdhale/src/utils/secure_storage.dart';

class CurrentUserService {
  final baseUrl = API.baseUrl;

  Future getCurrentUser({required endpoint}) async {
    final token = await SecureStorage.storage.read(key: "token");
    http.Response response = await http.get(
      Uri.parse(
        baseUrl + endpoint,
      ),
      headers: {
        "x-auth-token": "$token",
        "accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw response;
  }
}
