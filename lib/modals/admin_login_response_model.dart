class LoginResponseDataModel {
  String message='';
  int id = 0;
  String name = '';
  String email = '';
  String token = '';

  LoginResponseDataModel();

  factory LoginResponseDataModel.fromJson(Map<String, dynamic> json) {
    LoginResponseDataModel adminLoginResponse =
    LoginResponseDataModel();
    adminLoginResponse.message = json["message"];
    adminLoginResponse.id = json["user"]["id"];
    adminLoginResponse.name = json["user"]["name"];
    adminLoginResponse.email = json["user"]["email"];
    adminLoginResponse.token = json["token"];

    return adminLoginResponse;
  }
}
