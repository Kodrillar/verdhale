Map<String, String> endpoints = {
  "registerUser": "/user/signUp",
  "loginUser": "/user/auth",
  "uploadProfileImage": "/user/signUp/upload/profileImage",
  "getFreeservice": "/freeservice/?country=dubai",
  "getCurrentUser": "/user/me",
  "appointment": "/appointment",
  "deleteAppointment": "/appointment/remove",
  "getProducts": "/pharmacy/products/"
};

class API {
  // String baseUrl = "";
  static const baseUrl = "https://verdhale.herokuapp.com/api";

  static Uri getRequestUrl({required String path}) => Uri(
        scheme: "http",
        host: "localhost:3000/api",
        path: endpoints[path],
      );
}
