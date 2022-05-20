import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:verdhale/src/services/api.dart';
import 'package:verdhale/src/utils/secure_storage.dart';

import '../../utils/secure_storage.dart';

class ProductService {
  final baseUrl = API.baseUrl;
  Future<List<dynamic>> getProducts({required endpoint}) async {
    final token = await SecureStorage.storage.read(key: "token");

    http.Response response = await http.get(
      Uri.parse(baseUrl + endpoint),
      headers: {
        "accept": "application/json; charset=utf-8",
        "X-auth-token": "$token",
      },
    );

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      // print(response.body);
      return responseBody;
    }

    throw response;
  }
}
