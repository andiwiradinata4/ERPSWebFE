import 'package:erps/core/models/pagination.dart';
import 'package:erps/core/models/token.dart';
import 'package:erps/features/auth/data/models/user.dart';
import 'package:erps/features/auth/domain/entities/v1/change_email_entity.dart';
import 'package:erps/features/auth/domain/entities/v1/change_phone_number_entity.dart';
import 'package:erps/features/auth/domain/entities/v1/login_entity.dart';
import 'package:erps/features/auth/domain/entities/v1/register_entity.dart';
import 'package:erps/features/auth/domain/entities/v1/reset_password_entity.dart';
import 'package:erps/features/auth/domain/entities/v1/verify_email_confirmation_entity.dart';

abstract class AbsAuthRepository {
  Future<Token> register(RegisterEntity data);

  Future<Token> login(LoginEntity data);

  Future<Token> refreshToken();

  Future<Token> emailConfirmationToken();

  Future<bool> verifyEmailConfirmation(VerifyEmailConfirmationEntity data);

  Future<Token> changeEmailToken(String newEmail);

  Future<bool> changeEmail(ChangeEmailEntity data);

  Future<Token> changePhoneNumberToken(String newPhoneNumber);

  Future<bool> changePhoneNumber(ChangePhoneNumberEntity data);

  Future<Token> resetPasswordToken(String email);

  Future<bool> resetPassword(ResetPasswordEntity data);

  Future<bool> changePassword(String currentPassword, String newPassword);

  Future<User> me();

  Future<User> getDetail(String id);

  Future<Pagination<User>> listData(Map<String, String>? query);

  Future<bool> delete(String id);

}
