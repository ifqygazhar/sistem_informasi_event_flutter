class AuthModel {
  final String? name;
  final String email;
  final String password;
  final String? passwordConfirmation;

  AuthModel({
    this.name,
    required this.email,
    required this.password,
    this.passwordConfirmation,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
    name: json["name"],
    email: json["email"],
    password: json["password"],
    passwordConfirmation: json["password_confirmation"],
  );

  Map<String, dynamic> toJsonForLogin() => {
    "email": email,
    "password": password,
  };

  Map<String, dynamic> toJsonForRegister() => {
    "name": name,
    "email": email,
    "password": password,
    "password_confirmation": passwordConfirmation,
  };
}
