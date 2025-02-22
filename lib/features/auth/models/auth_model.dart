class AuthModel {
  final String? token;
  final String? username;
  final String? email;
  final String? password;

  AuthModel({
    this.token,
    this.username,
    this.email,
    this.password,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      token: json['token'],
      username: json['username'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
    };
  }

  AuthModel copyWith({
    String? token,
    String? username,
    String? email,
    String? password,
  }) {
    return AuthModel(
      token: token ?? this.token,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
