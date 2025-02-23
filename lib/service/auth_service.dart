import 'dart:convert';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;

class SpotifyAuthService {
  static const String clientId = '456138f0b3dd460f9538a165f80871b4';
  static const String clientSecret = '8d67b7a9c6324227a5316da281a79ce9';
  static const String redirectUri = 'myapp://callback';
  static const String authEndpoint = 'https://accounts.spotify.com/authorize';
  static const String tokenEndpoint = 'https://accounts.spotify.com/api/token';
  static const String currentTrackEndpoint =
      'https://api.spotify.com/v1/me/player/currently-playing';

  /// Inicia o fluxo de autenticação do Spotify
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

  /// Troca o código de autorização pelo token de acesso
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
      return data['access_token']; // Retorna o token de acesso
    } else {
      return null;
    }
  }

  /// Obtém as informações sobre a música atual
  Future<Map<String, dynamic>?> getCurrentTrack(String accessToken) async {
    final response = await http.get(
      Uri.parse(currentTrackEndpoint),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Retorna o JSON da música atual
    } else {
      return null; // Caso não tenha nenhuma música tocando
    }
  }
}
