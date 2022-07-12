class CurrentUserModel {
  CurrentUserModel({
    required this.email,
    required this.image,
    required this.fullname,
  });

  final String email;
  final String image;
  final String fullname;

  CurrentUserModel.fromJson(json)
      : email = json["email"],
        image = json["image"],
        fullname = json["fullname"];
}
