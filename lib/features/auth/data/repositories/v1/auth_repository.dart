import 'dart:convert';
import 'package:erps/core/error/error_response_exception.dart';
import 'package:erps/core/models/token.dart';
import 'package:erps/core/network/http/abstract/abs_http_client.dart';
import 'package:erps/core/network/http/http_status.dart';
import 'package:erps/features/auth/data/models/user.dart';
import 'package:erps/features/auth/domain/entities/v1/change_email_entity.dart';
import 'package:erps/features/auth/domain/entities/v1/change_phone_number_entity.dart';
import 'package:erps/features/auth/domain/entities/v1/login_entity.dart';
import 'package:erps/features/auth/domain/entities/v1/register_entity.dart';
import 'package:erps/features/auth/domain/entities/v1/reset_password_entity.dart';
import 'package:erps/features/auth/domain/entities/v1/verify_email_confirmation_entity.dart';
import 'package:erps/features/auth/domain/repositories/v1/abs_auth_repository.dart';

class AuthRepository implements AbsAuthRepository {
  final AbsHttpClient client;

  AuthRepository({required this.client});

  @override
  Future<Token> register(RegisterEntity data) async {
    final Token token;
    String url = '/api/v1/auth/register';
    try {
      final response = await client.post(url, data.toJson());
      if (HTTPStatus.isSuccess(response.statusCode)) {
        final json = jsonDecode(response.body);
        token = Token.fromJson(json['Data']);
      } else {
        throw (ErrorResponseException.fromHttpResponse(response));
      }
    } catch (e) {
      rethrow;
    }
    return token;
  }

  @override
  Future<Token> login(LoginEntity data) async {
    final Token token;
    String url = '/api/v1/auth/login';
    try {
      final response = await client.post(url, data.toJson());
      if (HTTPStatus.isSuccess(response.statusCode)) {
        final json = jsonDecode(response.body);
        token = Token.fromJson(json['Data']);
      } else {
        throw (ErrorResponseException.fromHttpResponse(response));
      }
    } catch (e) {
      rethrow;
    }
    return token;
  }

  @override
  Future<Token> refreshToken() async {
    final Token token;
    String url = '/api/v1/auth/refresh-token';
    try {
      final response = await client.post(url, {});
      if (HTTPStatus.isSuccess(response.statusCode)) {
        final json = jsonDecode(response.body);
        token = Token.fromJson(json['Data']);
      } else {
        throw (ErrorResponseException.fromHttpResponse(response));
      }
    } catch (e) {
      rethrow;
    }
    return token;
  }

  @override
  Future<Token> emailConfirmationToken() async {
    final Token token;
    String url = '/api/v1/auth/email-confirmation-token';
    try {
      final response = await client.post(url, {});
      if (HTTPStatus.isSuccess(response.statusCode)) {
        final json = jsonDecode(response.body);
        token = Token.fromJson(json['Data']);
      } else {
        throw (ErrorResponseException.fromHttpResponse(response));
      }
    } catch (e) {
      rethrow;
    }
    return token;
  }

  @override
  Future<bool> verifyEmailConfirmation(
      VerifyEmailConfirmationEntity result) async {
    String url = '/api/v1/auth/verify-email-confirmation-token';
    try {
      final response = await client.post(url, result.toJson());
      if (HTTPStatus.isSuccess(response.statusCode)) {
        final json = jsonDecode(response.body);
        return json['Success'] ?? false;
      } else {
        throw (ErrorResponseException.fromHttpResponse(response));
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Token> changeEmailToken(String newEmail) async {
    final Token token;
    String url = '/api/v1/auth/change-email-token';
    try {
      final response = await client.post(url, {'newEmail': newEmail});
      if (HTTPStatus.isSuccess(response.statusCode)) {
        final json = jsonDecode(response.body);
        token = Token.fromJson(json['Data']);
      } else {
        throw (ErrorResponseException.fromHttpResponse(response));
      }
    } catch (e) {
      rethrow;
    }
    return token;
  }

  @override
  Future<bool> changeEmail(ChangeEmailEntity data) async {
    String url = '/api/v1/auth/change-email';
    try {
      final response = await client.post(url, data.toJson());
      if (HTTPStatus.isSuccess(response.statusCode)) {
        final json = jsonDecode(response.body);
        return json['Success'] ?? false;
      } else {
        throw (ErrorResponseException.fromHttpResponse(response));
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Token> changePhoneNumberToken(String newPhoneNumber) async {
    final Token token;
    String url = '/api/v1/auth/change-phone-number-token';
    try {
      final response =
          await client.post(url, {'NewPhoneNumber': newPhoneNumber});
      if (HTTPStatus.isSuccess(response.statusCode)) {
        final json = jsonDecode(response.body);
        token = Token.fromJson(json['Data']);
      } else {
        throw (ErrorResponseException.fromHttpResponse(response));
      }
    } catch (e) {
      rethrow;
    }
    return token;
  }

  @override
  Future<bool> changePhoneNumber(ChangePhoneNumberEntity data) async {
    String url = '/api/v1/auth/change-phone-number';
    try {
      final response = await client.post(url, data.toJson());
      if (HTTPStatus.isSuccess(response.statusCode)) {
        final json = jsonDecode(response.body);
        return json['Success'] ?? false;
      } else {
        throw (ErrorResponseException.fromHttpResponse(response));
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Token> resetPasswordToken(String email) async {
    final Token token;
    String url = '/api/v1/auth/reset-password-token';
    try {
      final response = await client.post(url, {'Email': email});
      if (HTTPStatus.isSuccess(response.statusCode)) {
        final json = jsonDecode(response.body);
        token = Token.fromJson(json['Data']);
      } else {
        throw (ErrorResponseException.fromHttpResponse(response));
      }
    } catch (e) {
      rethrow;
    }
    return token;
  }

  @override
  Future<bool> resetPassword(ResetPasswordEntity data) async {
    String url = '/api/v1/auth/reset-password';
    try {
      final response = await client.post(url, data.toJson());
      if (HTTPStatus.isSuccess(response.statusCode)) {
        final json = jsonDecode(response.body);
        return json['Success'] ?? false;
      } else {
        throw (ErrorResponseException.fromHttpResponse(response));
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> changePassword(
      String currentPassword, String newPassword) async {
    String url = '/api/v1/auth/change-password';
    try {
      final response = await client.post(url,
          {'currentPassword': currentPassword, 'newPassword': newPassword});
      if (HTTPStatus.isSuccess(response.statusCode)) {
        final json = jsonDecode(response.body);
        return json['Success'] ?? false;
      } else {
        throw (ErrorResponseException.fromHttpResponse(response));
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User> me() async {
    final User user;
    String url = '/api/v1/auth/me';
    try {
      final response = await client.get(url);
      if (HTTPStatus.isSuccess(response.statusCode)) {
        final json = jsonDecode(response.body);
        user = User.fromJson(json['Data']);
      } else {
        throw (ErrorResponseException.fromHttpResponse(response));
      }
    } catch (e) {
      rethrow;
    }
    return user;
  }
}
