class LogInModel {
  LogInModel({
    required this.email,
    required this.password,
    this.image,
  });

  final String email;
  final String password;
  final String? image;

  Map<String, String> toJson() => {
        "email": email,
        "password": password,
      };
}
