import 'package:equatable/equatable.dart';

class LoginEntity extends Equatable {
  final String userName;
  final String password;

  const LoginEntity({required this.userName, required this.password});

  Map<String, dynamic> toJson() => {"username": userName, "Password": password};

  @override
  List<Object?> get props => [userName, password];
}
