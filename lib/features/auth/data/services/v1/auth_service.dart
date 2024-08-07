import 'package:erps/core/domain/repositories/v1/abs_auth_local_repository.dart';
import 'package:erps/core/models/pagination.dart';
import 'package:erps/core/models/token.dart';
import 'package:erps/core/network/http/abstract/abs_http_client.dart';
import 'package:erps/features/auth/data/models/user.dart';
import 'package:erps/features/auth/domain/entities/v1/change_email_entity.dart';
import 'package:erps/features/auth/domain/entities/v1/change_phone_number_entity.dart';
import 'package:erps/features/auth/domain/entities/v1/login_entity.dart';
import 'package:erps/features/auth/domain/entities/v1/register_entity.dart';
import 'package:erps/features/auth/domain/entities/v1/reset_password_entity.dart';
import 'package:erps/features/auth/domain/entities/v1/verify_email_confirmation_entity.dart';
import 'package:erps/features/auth/domain/repositories/v1/abs_auth_repository.dart';
import 'package:erps/features/auth/domain/services/v1/abs_auth_service.dart';

class AuthService implements AbsAuthService {
  final AbsAuthRepository repo;
  final AbsAuthLocalRepository localRepo;
  final AbsHttpClient client;

  AuthService(
      {required this.repo, required this.localRepo, required this.client});

  void setToken(Token token) async {
    setAccessToken(token);
    setRefreshToken(token);
    await localRepo.store(token);
  }

  void setAccessToken(Token token) {
    client.addHeaders({'Authorization': 'Bearer ${token.accessToken}'});
  }

  void setRefreshToken(Token token) {
    client.addHeaders({'RefreshToken': token.refreshToken});
  }

  @override
  Future<User?> initAuthState() async {
    /// read existing accessToken from local storage
    Token? token = await localRepo.get();
    if (token == null) {
      return null;
    }

    /// Add / Update Authorization to HTTP Headers
    setToken(token);

    if (DateTime.now().compareTo(token.validTo) >= 0) {
      try {
        /// try to refresh access token from existing access token
        Token? newToken = await repo.refreshToken();
        setToken(newToken);
      } catch (e) {
        return null;
      }
    }

    /// fetch logged in user
    User user = await repo.me();
    return user;
  }

  @override
  Future<bool> register(RegisterEntity data) async {
    Token token = await repo.register(data);
    if (token.accessToken != '') {
      setToken(token);
      // await localRepo.store(token);
      return true;
    }
    return false;
  }

  @override
  Future<Token> login(LoginEntity data) async {
    Token token = await repo.login(data);
    if (token.accessToken != '') {
      await localRepo.store(token);
      setToken(token);
    }
    return token;
  }

  @override
  Future<Token> refreshToken() async {
    Token data = await repo.refreshToken();
    if (data.accessToken != '') {
      await localRepo.store(data);
      setToken(data);
    }
    return data;
  }

  @override
  Future<Token> emailConfirmationToken() async {
    return await repo.emailConfirmationToken();
  }

  @override
  Future<bool> verifyEmailConfirmation(
      VerifyEmailConfirmationEntity data) async {
    return await repo.verifyEmailConfirmation(data);
  }

  @override
  Future<Token> changeEmailToken(String newEmail) async {
    return await repo.changeEmailToken(newEmail);
  }

  @override
  Future<bool> changeEmail(ChangeEmailEntity data) async {
    return await repo.changeEmail(data);
  }

  @override
  Future<Token> changePhoneNumberToken(String newPhoneNumber) async {
    return await repo.changePhoneNumberToken(newPhoneNumber);
  }

  @override
  Future<bool> changePassword(
      String currentPassword, String newPassword) async {
    return await repo.changePassword(currentPassword, newPassword);
  }

  @override
  Future<bool> changePhoneNumber(ChangePhoneNumberEntity data) async {
    return await repo.changePhoneNumber(data);
  }

  @override
  Future<Token> resetPasswordToken(String email) async {
    return await repo.resetPasswordToken(email);
  }

  @override
  Future<bool> resetPassword(ResetPasswordEntity data) async {
    return await repo.resetPassword(data);
  }

  @override
  Future<User> me() async {
    return await repo.me();
  }

  @override
  deleteToken() {
    localRepo.delete();
  }

  @override
  Future<Pagination<User>> listData(Map<String, String>? queries) async {
    return await repo.listData(queries);
  }
}
