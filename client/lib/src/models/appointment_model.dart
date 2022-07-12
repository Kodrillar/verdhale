class AppointmentModel {
  AppointmentModel(
      {required this.email,
      required this.aid,
      required this.date,
      required this.time});

  final String email;
  final String aid;
  final String date;
  final String time;

  Map<String, String> toJson() => {
        "email": email,
        "aid": aid,
        "date": date,
        "time": time,
      };

  AppointmentModel.fromJson(json)
      : email = json["email"],
        aid = json["aid"],
        date = json["date"],
        time = json["time"];
}
