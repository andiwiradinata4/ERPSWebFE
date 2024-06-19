import 'package:equatable/equatable.dart';

class ChangeEmailEntity extends Equatable {
  final String email;
  final String newEmail;
  final String token;
  final String code;

  const ChangeEmailEntity(
      {required this.email,
      required this.newEmail,
      required this.token,
      required this.code});

  Map<String, dynamic> toJson() =>
      {"Email": email, "NewEmail": newEmail, "Token": token, "Code": code};

  @override
  // TODO: implement props
  List<Object?> get props => [email, newEmail, token, code];
}
