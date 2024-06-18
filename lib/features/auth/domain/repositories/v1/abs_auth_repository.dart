import 'package:erps/core/models/token.dart';
import 'package:erps/features/auth/data/models/user.dart';
import 'package:erps/features/auth/domain/entities/v1/login_entity.dart';
import 'package:erps/features/auth/domain/entities/v1/register_entity.dart';

abstract class AbsAuthRepository {
  Future<Token> register(RegisterEntity register);

  Future<Token> login(LoginEntity login);

  Future<Token> refreshToken();

  Future<Token> emailConfirmationToken();

  Future<bool> verifyEmailConfirmation(String token, String code);

  Future<Token> changeEmailToken(String newEmail);

  Future<bool> changeEmail(
      String email, String newEmail, String token, String code);

  Future<Token> changePhoneNumberToken(String newPhoneNumber);

  Future<bool> changePhoneNumber(
      String phoneNumber, String newPhoneNumber, String token, String code);

  Future<Token> resetPasswordToken(String email);

  Future<bool> resetPassword(
      String email, String newPassword, String token, String code);

  Future<bool> changePassword(String currentPassword, String newPassword);

  Future<User> me();
}
