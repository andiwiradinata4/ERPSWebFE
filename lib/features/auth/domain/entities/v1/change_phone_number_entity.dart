import 'package:equatable/equatable.dart';

class ChangePhoneNumberEntity extends Equatable {
  final String phoneNumber;
  final String newPhoneNumber;
  final String token;
  final String code;

  const ChangePhoneNumberEntity(
      {required this.phoneNumber,
      required this.newPhoneNumber,
      required this.token,
      required this.code});

  Map<String, dynamic> toJson() => {
        'PhoneNumber': phoneNumber,
        'NewPhoneNumber': newPhoneNumber,
        'Token': token,
        'Code': code
      };

  @override
  List<Object?> get props => [phoneNumber, newPhoneNumber, token, code];
}
