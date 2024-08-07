import 'package:equatable/equatable.dart';

class RegisterEntity extends Equatable {
  final String userName;
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String phoneNumber;

  const RegisterEntity(
      {required this.userName,
      required this.email,
      required this.password,
      required this.firstName,
      this.lastName = '',
      required this.phoneNumber});

  Map<String, dynamic> toJson() => {
        "username": userName,
        "Email": email,
        "Password": password,
        "FirstName": firstName,
        "LastName": lastName,
        "PhoneNumber": phoneNumber
      };

  @override
  List<Object?> get props =>
      [userName, email, password, firstName, lastName, phoneNumber];
}
