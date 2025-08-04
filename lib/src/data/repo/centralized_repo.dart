import 'package:ag/ag.dart';

import '../../entities/auth_response.dart';
import '../api/centralized_auth_api.dart';
import '../local/centralized_local.dart';

abstract class CentralizedAuthRepository {
  Future<BaseResult<AuthResponse>> login({
    required Map<String, dynamic> request,
  });

  Future<bool> logOut();

  Future<void> setToken(String token);

  Future<String?> fetchToken();

  Future<bool> isLoggedIn();
}

class CentralizedAuthRepositoryImpl extends BaseRepository implements CentralizedAuthRepository {
  CentralizedAuthRepositoryImpl({
    required CentralizedAuthApi centralizedAuthApi,
    required CentralizedAuthLocal centralizedAuthLocal,
  })  : _centralizedAuthApi = centralizedAuthApi,
        _centralizedAuthLocal = centralizedAuthLocal;

  final CentralizedAuthApi _centralizedAuthApi;
  final CentralizedAuthLocal _centralizedAuthLocal;

  @override
  Future<BaseResult<AuthResponse>> login({
    required Map<String, dynamic> request,
  }) async {
    try {
      return await safeApiCall(
        _centralizedAuthApi.login(request: request),
        mapper: (data) {
          return AuthResponse.fromJson(data);
        },
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  @override
  Future<bool> logOut() async {
    try {
      return await _centralizedAuthLocal.doLogout();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  @override
  Future<void> setToken(String token) async {
    try {
      await _centralizedAuthLocal.setAuthResponse(token);
    } catch (error, _) {
      // LogUtils.e(error.toString());
    }
  }

  @override
  Future<String?> fetchToken() async {
    try {
      return await _centralizedAuthLocal.fetchAuthResponse();
    } catch (error, _) {
      return null;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return await _centralizedAuthLocal.fetchAuthResponse() != null;
  }
}
