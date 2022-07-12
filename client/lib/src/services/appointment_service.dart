import 'dart:convert';

import 'package:jitsi_meet/feature_flag/feature_flag.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:http/http.dart' as http;
import 'package:verdhale/src/models/appointment_model.dart';
import 'package:verdhale/src/services/api.dart';
import 'package:verdhale/src/utils/secure_storage.dart';

class AppointmentService {
  final baseUrl = API.baseUrl;

  static createAppointment(
      {required aId, required email, required name}) async {
    try {
      FeatureFlag featureFlag = FeatureFlag();
      featureFlag.welcomePageEnabled = false;
      featureFlag.resolution = FeatureFlagVideoResolution
          .MD_RESOLUTION; // Limit video resolution to 360p

      var options = JitsiMeetingOptions(room: aId)
        ..userEmail = email
        ..userDisplayName = name
        ..userAvatarURL = "https://i.imgur.com/9wzuKtm.jpg" // or .png
        ..audioMuted = true
        ..videoMuted = true;

      await JitsiMeet.joinMeeting(options);
    } catch (error) {
      print("error: $error");
    }
  }

  Future<List<dynamic>> getAppointment({required endpoint}) async {
    final token = await SecureStorage.storage.read(key: "token");
    http.Response response = await http.get(
      Uri.parse(
        baseUrl + endpoint,
      ),
      headers: {
        "x-auth-token": "$token",
        "accept": "application/json; charset=UTF-8",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw response;
  }

  Future addAppointment({
    required endpoint,
    required email,
    required aid,
    required date,
    required time,
  }) async {
    AppointmentModel appointmentModel =
        AppointmentModel(email: email, aid: aid, date: date, time: time);
    final token = await SecureStorage.storage.read(key: "token");
    http.Response response = await http.post(
      Uri.parse(baseUrl + endpoint),
      headers: {
        "x-auth-token": "$token",
        "content-type": "application/json; charset=UTF-8",
      },
      body: jsonEncode(
        appointmentModel.toJson(),
      ),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw response;
  }

//coming soon.. add id row model and route and maybe use req.query
  Future deleteAppointment({required endpoint}) async {
    final token = await SecureStorage.storage.read(key: "token");
    http.Response response = await http.delete(
      Uri.parse(
        baseUrl + endpoint,
      ),
      headers: {
        "x-auth-token": "$token",
      },
    );
  }
}
