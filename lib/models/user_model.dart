class UserModel {
  final String? username;
  final String? name;
  final String? email;
  final String? sub;
  final Map<String, dynamic>? role;
  final dynamic clients;
  final int? iat;
  final int? exp;

  UserModel({
    this.username,
    this.name,
    this.email,
    this.sub,
    this.role,
    this.clients,
    this.iat,
    this.exp,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'],
      name: json['name'],
      email: json['email'],
      sub: json['sub'],
      role: json['role'],
      clients: json['clients'],
      iat: json['iat'],
      exp: json['exp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'name': name,
      'email': email,
      'sub': sub,
      'role': role,
      'clients': clients,
      'iat': iat,
      'exp': exp,
    };
  }
}
