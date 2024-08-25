import 'package:equatable/equatable.dart';

class RegisterEntity extends Equatable {
  final String userName;
  final String password;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final DateTime birthDate;

  const RegisterEntity(
      {required this.userName,
      required this.email,
      required this.password,
      required this.firstName,
      this.lastName = '',
      required this.phoneNumber,
      required this.birthDate});

  Map<String, dynamic> toJson() => {
        "username": userName,
        "Email": email,
        "Password": password,
        "FirstName": firstName,
        "LastName": lastName,
        "PhoneNumber": phoneNumber,
        "BirthDate": birthDate.toString()
      };

  @override
  List<Object?> get props =>
      [userName, password, firstName, lastName, email, phoneNumber, birthDate];
}
