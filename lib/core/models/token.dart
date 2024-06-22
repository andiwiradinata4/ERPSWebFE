import 'package:equatable/equatable.dart';
import 'package:erps/core/utils/date_util.dart';

class Token extends Equatable {
  final String userName;
  final String email;
  final String accessToken;
  final DateTime validFrom, validTo;
  final String refreshToken;
  final String issuer;
  final String audience;
  final String code;

  const Token(
      {required this.userName,
      required this.email,
      required this.accessToken,
      required this.validFrom,
      required this.validTo,
      required this.refreshToken,
      required this.issuer,
      required this.audience,
      required this.code});

  factory Token.fromJson(Map<String, dynamic> json) => Token(
      userName: json['UserName'] ?? '',
      email: json['Email'] ?? '',
      accessToken: json['AccessToken'] ?? '',
      validFrom: DateUtil().parse(json['ValidFrom']) ?? DateTime.utc(2000),
      validTo: DateUtil().parse(json['ValidTo']) ?? DateTime.utc(2000),
      refreshToken: json['RefreshToken'] ?? '',
      issuer: json['Issuer'] ?? '',
      audience: json['Audience'] ?? '',
      code: json['Code'] ?? '');

  Map<String, dynamic> toJson() => {
        "UserName": userName,
        "Email": email,
        "AccessToken": accessToken,
        "ValidFrom":
            validFrom.toString(),
        "ValidTo": validTo.toString(),
        "RefreshToken": refreshToken,
        "Issuer": issuer,
        "Audience": audience,
        "Code": code
      };

  @override
  List<Object?> get props => [
        userName,
        email,
        accessToken,
        validFrom,
        validTo,
        refreshToken,
        issuer,
        audience,
        code
      ];
}
