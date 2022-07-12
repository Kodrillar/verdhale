class FreeServiceModel {
  FreeServiceModel({required this.image, required this.url});
  String image;
  String url;

  FreeServiceModel.fromJson(json)
      : image = json["image"],
        url = json["url"];
}
