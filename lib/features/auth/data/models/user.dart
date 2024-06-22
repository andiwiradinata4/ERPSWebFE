import 'package:equatable/equatable.dart';
import 'package:erps/core/utils/date_util.dart';

class User extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final String userName;
  final String normalizedUsername;
  final String email;
  final String normalizedEmail;
  final bool emailConfirmed;
  final String passwordHash;
  final String securityStamp;
  final String concurrencyStamp;
  final String phoneNumber;
  final bool phoneNumberConfirmed;
  final bool twoFactorEnabled;
  final bool lockoutEnabled;
  final int accessFailedCount;

  const User(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.birthDate,
      required this.userName,
      this.normalizedUsername = '',
      required this.email,
      this.normalizedEmail = '',
      this.emailConfirmed = false,
      this.passwordHash = '',
      this.securityStamp = '',
      this.concurrencyStamp = '',
      required this.phoneNumber,
      this.phoneNumberConfirmed = false,
      this.twoFactorEnabled = false,
      this.lockoutEnabled = false,
      this.accessFailedCount = 0});

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json['Id'] ?? '',
      firstName: json['FirstName'] ?? '',
      lastName: json['LastName'] ?? '',
      birthDate: DateUtil().parse(json['BirthDate']) ?? DateTime.now(),
      userName: json['UserName'] ?? '',
      normalizedUsername: json['NormalizedUsername'] ?? '',
      email: json['Email'] ?? '',
      normalizedEmail: json['NormalizedEmail'] ?? '',
      emailConfirmed: json['EmailConfirmed'] ?? false,
      passwordHash: json['PasswordHash'] ?? '',
      securityStamp: json['SecurityStamp'] ?? '',
      concurrencyStamp: json['ConcurrencyStamp'] ?? '',
      phoneNumber: json['PhoneNumber'] ?? '',
      phoneNumberConfirmed: json['PhoneNumberConfirmed'] ?? false,
      twoFactorEnabled: json['TwoFactorEnabled'] ?? false,
      lockoutEnabled: json['LockoutEnabled'] ?? false,
      accessFailedCount: json['AccessFailedCount'] ?? '');

  Map<String, dynamic> toJson() => {
        'Id': id,
        'FirstName': firstName,
        'LastName': lastName,
        'BirthDate': birthDate.toString(),
        'UserName': userName,
        'NormalizedUsername': normalizedUsername,
        'Email': email,
        'NormalizedEmail': normalizedEmail,
        'EmailConfirmed': emailConfirmed,
        'PasswordHash': passwordHash,
        'SecurityStamp': securityStamp,
        'ConcurrencyStamp': concurrencyStamp,
        'PhoneNumber': phoneNumber,
        'PhoneNumberConfirmed': phoneNumberConfirmed,
        'TwoFactorEnabled': twoFactorEnabled,
        'LockoutEnabled': lockoutEnabled,
        'AccessFailedCount': accessFailedCount
      };

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        birthDate,
        userName,
        normalizedUsername,
        email,
        normalizedEmail,
        emailConfirmed,
        passwordHash,
        securityStamp,
        concurrencyStamp,
        phoneNumber,
        phoneNumberConfirmed,
        twoFactorEnabled,
        lockoutEnabled,
        accessFailedCount
      ];
}
