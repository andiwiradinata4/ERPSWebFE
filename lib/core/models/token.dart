import 'package:equatable/equatable.dart';

class Token extends Equatable {
  final int id;
  final String accessToken, refreshToken;
  final int expired;
  const Token(
      {required this.id,
        required this.accessToken,
        required this.refreshToken,
        required this.expired});

  factory Token.fromJson(Map<String, dynamic> json) => Token(
      id: json['id'] ?? 0,
      accessToken: json['access'] ?? '',
      refreshToken: json['refresh'] ?? '',
      expired: int.parse(json['expired']));

  Map<String, dynamic> toJson() => {
    "id": id,
    "access": accessToken,
    "refresh": refreshToken,
    "expired": expired.toString()
  };

  @override
  List<Object?> get props => [id, accessToken, refreshToken, expired];
}
