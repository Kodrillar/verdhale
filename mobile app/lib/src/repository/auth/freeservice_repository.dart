import 'package:verdhale/src/models/free_service_model.dart';
import 'package:verdhale/src/services/freeservice_service.dart';

import 'package:http/http.dart';
import 'package:verdhale/src/utils/request_response.dart';

class FreeserviceRepository {
  FreeserviceService freeserviceService = FreeserviceService();

  Future<List<FreeServiceModel>> getFreeservice({required endpoint}) async {
    try {
      var freeservices =
          await freeserviceService.getFreeservices(endpoint: endpoint);

      return freeservices
          .map<FreeServiceModel>(FreeServiceModel.fromJson)
          .toList();
    } on Response catch (response) {
      var responseBody = RequestResponse.requestResponse(response);
      return responseBody;
    }
  }
}
