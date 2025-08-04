import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:utils/utils.dart';

import '../data/repo/centralized_repo.dart';
import '../entities/auth_response.dart';
import '../entities/user_centralized.dart';

class CentralizedService {
  final CentralizedAuthRepository _centralizedAuthRepository;

  CentralizedService(this._centralizedAuthRepository);

  String? lastAttemptedRoute; // Trang cuối cùng trước khi bị redirect

  String?
      loginSuccessAttemptedRoute; // Lưu lại trang cần truy cập khi login thành công

  Future<bool> isLoggedIn() => _centralizedAuthRepository.isLoggedIn();

  Future<bool> logout() => _centralizedAuthRepository.logOut();

  Future<void> setToken(String token) =>
      _centralizedAuthRepository.setToken(token);

  Future<String?> fetchToken() => _centralizedAuthRepository.fetchToken();

  void onLoginSuccess(BuildContext context) {
    if (loginSuccessAttemptedRoute == null) {
      loginSuccessAttemptedRoute = null;
      // Nếu không có lastAttemptedRoute → Login trực tiếp → Pop về trang trước
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).pushReplacementNamed(
            '/'); // Nếu không pop được → Điều hướng về init router
      }
    } else {
      final redirectTo = loginSuccessAttemptedRoute!;
      loginSuccessAttemptedRoute = null;
      Navigator.of(context).pushReplacementNamed(redirectTo);
    }
  }

  Future<AuthResponse?> getAuthResponse() async {
    final tokenAuth = await fetchToken();
    if (tokenAuth == null) return null;
    // final parseToken = JwtDecoder.decode(tokenAuth);
    return AuthResponse.fromJson(jsonDecode(tokenAuth));
  }

  AuthResponse? get user => getAuthResponse() as AuthResponse?;

  Future<UserCentralized?> getUserCentralized() async {
    if (user == null) return null;
    final token = user!.accessToken;
    if (token == null) return null;
    final parseToken = JwtDecoder.decode(token);
    return UserCentralized.fromJson(parseToken);
  }

  UserCentralized? get userCentralized =>
      getUserCentralized() as UserCentralized?;
}
