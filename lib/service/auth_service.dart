import 'dart:convert';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
import 'package:ipod/service/auth_storage.dart';

class SpotifyAuthService {
  final String refreshToken;
  final String accessToken;

  static const String clientId = '456138f0b3dd460f9538a165f80871b4';
  static const String clientSecret = '8d67b7a9c6324227a5316da281a79ce9';
  static const String redirectUri = 'myapp://callback';
  static const String authEndpoint = 'https://accounts.spotify.com/authorize';
  static const String tokenEndpoint = 'https://accounts.spotify.com/api/token';

  SpotifyAuthService({required this.refreshToken, required this.accessToken});

  // Função para iniciar o fluxo de autenticação do Spotify
  Future<String?> authenticate() async {
    final url = Uri.parse(
      '$authEndpoint'
      '?client_id=$clientId'
      '&response_type=code'
      '&redirect_uri=$redirectUri'
      '&scope=user-read-playback-state user-modify-playback-state user-read-currently-playing'
      '&show_dialog=true',
    );

    // Abre o navegador para autenticação do usuário
    final result = await FlutterWebAuth.authenticate(
      url: url.toString(),
      callbackUrlScheme: 'myapp',
    );

    // Extrai o código de autorização da URL
    final code = Uri.parse(result).queryParameters['code'];

    if (code == null) return null;

    // Troca o código pelo token de acesso
    return _getAccessToken(code);
  }

  // Troca o código de autorização pelo token de acesso
  Future<String?> _getAccessToken(String code) async {
    final response = await http.post(
      Uri.parse(tokenEndpoint),
      headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': redirectUri,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await AuthStorage.saveAuthData(data);
      return data['access_token'];
    } else {
      return null;
    }
  }

  // Função para renovar o token de acesso
  Future<String?> refreshAccessToken() async {
    final refreshToken = await AuthStorage.getRefreshToken();

    if (refreshToken == null) {
      print('Refresh Token não encontrado.');
      return null;
    }

    // Renova o token com o refresh token
    final response = await http.post(
      Uri.parse(tokenEndpoint), // Endpoint para renovar o token
      body: {'grant_type': 'refresh_token', 'refresh_token': refreshToken},
      headers: {
        'Authorization':
            'Basic ' + base64Encode(utf8.encode('$clientId:$clientSecret')),
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await AuthStorage.saveAuthData(data); // Salva os dados (token renovado)
      print('Token renovado com sucesso: ${data['access_token']}');
      return data['access_token'];
    } else {
      print('Erro ao renovar o token: ${response.statusCode}');
      return null;
    }
  }

  // Função para obter um token de acesso válido (renovando se necessário)
  Future<String?> getValidAccessToken() async {
    String? accessToken = await AuthStorage.getAccessToken();

    if (accessToken == null) {
      print('Token de acesso não encontrado.');
      return null;
    }

    final isTokenExpired =
        await _isTokenExpired(); // Verifique se o token expirou
    if (isTokenExpired) {
      print('Token expirado. Tentando renovar...');
      return await refreshAccessToken(); // Tenta renovar o token
    }

    return accessToken;
  }

  Future<bool> _isTokenExpired() async {
    final expiresIn = await AuthStorage.getExpiresIn();
    final tokenTimestamp = await AuthStorage.getTokenTimestamp();

    if (expiresIn == null || tokenTimestamp == null) {
      print('Expiração do token ou timestamp não encontrados.');
      return true;
    }

    // Calcula o horário exato de expiração do token
    final tokenExpirationTime = DateTime.fromMillisecondsSinceEpoch(
      tokenTimestamp,
    ).add(Duration(seconds: expiresIn));

    final currentTime = DateTime.now();
    print('Token expira em: $tokenExpirationTime');
    print('Hora atual: $currentTime');

    return currentTime.isAfter(tokenExpirationTime);
  }
}
