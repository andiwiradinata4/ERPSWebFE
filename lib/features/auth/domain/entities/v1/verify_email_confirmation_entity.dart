import 'package:equatable/equatable.dart';

class VerifyEmailConfirmationEntity extends Equatable {
  final String accessToken;
  final String code;

  const VerifyEmailConfirmationEntity({required this.accessToken, required this.code});

  Map<String, dynamic> toJson() => {"AccessToken": accessToken, "Code": code};

  @override
  // TODO: implement props
  List<Object?> get props => [accessToken, code];
}
