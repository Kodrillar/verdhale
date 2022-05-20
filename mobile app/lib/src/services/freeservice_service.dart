import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:verdhale/src/services/api.dart';

class FreeserviceService {
  final baseUrl = API.baseUrl;

  Future getFreeservices({required endpoint}) async {
    http.Response response = await http.get(
      Uri.parse(
        baseUrl + endpoint,
      ),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw response;
  }
}
