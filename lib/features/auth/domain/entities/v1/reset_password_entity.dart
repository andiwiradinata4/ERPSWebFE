import 'package:equatable/equatable.dart';

class ResetPasswordEntity extends Equatable {
  final String email;
  final String newPassword;
  final String token;
  final String code;

  const ResetPasswordEntity(
      {required this.email,
      required this.newPassword,
      required this.token,
      required this.code});

  Map<String, dynamic> toJson() => {
        "Email": email,
        "NewPassword": newPassword,
        "Token": token,
        "Code": code
      };

  @override
  List<Object?> get props => [email, newPassword, token, code];
}
