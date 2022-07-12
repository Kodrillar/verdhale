import 'dart:convert';

import 'package:http/http.dart';
import 'package:verdhale/src/models/appointment_model.dart';
import 'package:verdhale/src/services/appointment_service.dart';
import 'package:verdhale/src/utils/request_response.dart';

class AppointmentRepository {
  final AppointmentService _appointmentService = AppointmentService();

  Future addAppointment({
    required String endpoint,
    required String date,
    required String email,
    required String time,
    required String aid,
  }) async {
    try {
      await _appointmentService.addAppointment(
        endpoint: endpoint,
        email: email,
        aid: aid,
        date: date,
        time: time,
      );
    } on Response catch (response) {
      var responseBody = RequestResponse.requestResponse(response);
      return jsonDecode(responseBody);
    }
  }

  Future getAppointment({required endpoint}) async {
    try {
      var appointmentData =
          await _appointmentService.getAppointment(endpoint: endpoint);

      return appointmentData
          .map<AppointmentModel>(AppointmentModel.fromJson)
          .toList();
    } on Response catch (response) {
      var responseBody = RequestResponse.requestResponse(response);
      return jsonDecode(responseBody);
    }
  }
}
