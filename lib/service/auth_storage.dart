import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  static const _storage = FlutterSecureStorage();
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _expiresInKey = 'expires_in';
  static const _tokenTimestampKey = 'token_timestamp';

  /// Salva os tokens e tempo de expiração
  /// /// Salva os tokens e o tempo de expiração
  static Future<void> saveAuthData(Map<String, dynamic> response) async {
    final now = DateTime.now().millisecondsSinceEpoch;

    await _storage.write(key: _accessTokenKey, value: response['access_token']);
    await _storage.write(
      key: _refreshTokenKey,
      value: response['refresh_token'],
    );
    await _storage.write(
      key: _expiresInKey,
      value: response['expires_in'].toString(),
    );
    await _storage.write(key: _tokenTimestampKey, value: now.toString());
  }

  /// Recupera o token de acesso
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  /// Recupera o refresh token
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  /// Recupera o tempo de expiração
  static Future<int?> getExpiresIn() async {
    final expiresIn = await _storage.read(key: _expiresInKey);
    return expiresIn != null ? int.tryParse(expiresIn) : null;
  }

  /// Recupera o timestamp do último token salvo
  static Future<int?> getTokenTimestamp() async {
    final timestamp = await _storage.read(key: _tokenTimestampKey);
    return timestamp != null ? int.tryParse(timestamp) : null;
  }

  /// Remove os dados (logout)
  static Future<void> clearAuthData() async {
    await _storage.deleteAll();
  }
}
