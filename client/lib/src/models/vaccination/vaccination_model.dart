class VaccinationModel {
  VaccinationModel({
    required this.hospital,
    required this.date,
    required this.time,
    required this.location,
  });

  final String hospital;
  final String date;
  final String time;
  final String location;

  Map<String, String> toJson() => {
        "hospital": hospital,
        "date": date,
        "time": time,
        "location": location,
      };

  VaccinationModel.fromJson(json)
      : hospital = json["hospital"],
        location = json["location"],
        date = json["date"],
        time = json["time"];
}
