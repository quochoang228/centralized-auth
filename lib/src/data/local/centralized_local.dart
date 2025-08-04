import 'package:persistent_storage/persistent_storage.dart';

abstract class CentralizedAuthStorageKeys {
  static const userCentralizedLocalKey = '__user_centralized_storage_key__';
}

abstract class CentralizedAuthLocal {
  Future<void> setAuthResponse(String token);

  Future<String?> fetchAuthResponse();

  Future<bool> doLogout();
}

class AuthLocalStorageImpl implements CentralizedAuthLocal {
  const AuthLocalStorageImpl({
    required SharedPreferencesStorage storage,
  }) : _storage = storage;

  final SharedPreferencesStorage _storage;

  /// Sets authToken in Storage.
  @override
  Future<void> setAuthResponse(String token) => _storage.write(
        key: CentralizedAuthStorageKeys.userCentralizedLocalKey,
        value: token,
      );

  /// Fetches authToken from Storage.
  @override
  Future<String?> fetchAuthResponse() async {
    final userLocal = await _storage.read(
        key: CentralizedAuthStorageKeys.userCentralizedLocalKey);
    return userLocal;
  }

  @override
  Future<bool> doLogout() async {
    try {
      await _storage.clear();
      return true;
    } catch (e) {
      return false;
    }
  }
}
