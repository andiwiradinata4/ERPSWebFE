import 'package:equatable/equatable.dart';

class VerifyEmailConfirmationEntity extends Equatable {
  final String token;
  final String code;

  const VerifyEmailConfirmationEntity({required this.token, required this.code});

  Map<String, dynamic> toJson() => {"Token": token, "Code": code};

  @override
  // TODO: implement props
  List<Object?> get props => [token, code];
}
