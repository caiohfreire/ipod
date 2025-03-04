import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ipod/service/auth_service.dart';

class SpotifyService {
  final SpotifyAuthService spotifyAuthService;

  SpotifyService({required this.spotifyAuthService});

  static const String _baseUrl = 'https://api.spotify.com/v1/me/player';
  static const String currentlyPlayingEndpoint = '$_baseUrl/currently-playing';
  static const String trackProgressEndpoint = _baseUrl;
  static const String pauseTrackEndpoint = '$_baseUrl/pause';
  static const String playTrackEndpoint = '$_baseUrl/play';
  static const String nextTrackEndpoint = '$_baseUrl/next';
  static const String previousTrackEndpoint = '$_baseUrl/previous';
  static const String shuffleModeEndpoint = '$_baseUrl/shuffle';

  /// Método genérico para requisições HTTP
  Future<http.Response> _sendRequest(
    String url, {
    String method = 'GET',
    Map<String, String>? headers,
    dynamic body,
  }) async {
    final accessToken = await spotifyAuthService.getValidAccessToken();
    headers ??= {};
    headers['Authorization'] = 'Bearer $accessToken';
    headers['Content-Type'] = 'application/json';

    final uri = Uri.parse(url);
    switch (method) {
      case 'GET':
        return await http.get(uri, headers: headers);
      case 'PUT':
        return await http.put(uri, headers: headers, body: body);
      case 'POST':
        return await http.post(uri, headers: headers, body: body);
      default:
        throw Exception('Método HTTP não suportado: $method');
    }
  }

  Future<Map<String, dynamic>?> getCurrentPlayingTrack() async {
    final response = await _sendRequest(currentlyPlayingEndpoint);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    print('Erro ao obter faixa atual: ${response.statusCode}');
    return null;
  }

  Future<Map<String, dynamic>?> getTrackProgress() async {
    final response = await _sendRequest(trackProgressEndpoint);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    if (response.statusCode == 401) {
      await spotifyAuthService.getValidAccessToken();
    }

    print('Erro ao obter progresso da faixa: ${response.statusCode}');
    return null;
  }

  Future<void> pauseTrack() async {
    final response = await _sendRequest(pauseTrackEndpoint, method: 'PUT');

    if (response.statusCode == 204) {
      print('Música pausada com sucesso!');
    } else {
      print('Falha ao pausar a música: ${response.statusCode}');
    }
  }

  Future<void> playTrack() async {
    final response = await _sendRequest(playTrackEndpoint, method: 'PUT');

    if (response.statusCode == 204) {
      print('Música retomada com sucesso!');
    } else {
      print('Falha ao retomar a música: ${response.statusCode}');
    }
  }

  Future<void> nextTrack() async {
    final response = await _sendRequest(nextTrackEndpoint, method: 'POST');

    if (response.statusCode == 204) {
      print('Tocando próxima música!');
    } else {
      print('Falha ao trocar para a próxima música: ${response.statusCode}');
    }
  }

  Future<void> previousTrack() async {
    final response = await _sendRequest(previousTrackEndpoint, method: 'POST');

    if (response.statusCode == 204) {
      print('Tocando música anterior!');
    } else {
      print('Falha ao voltar para a música anterior: ${response.statusCode}');
    }
  }

  Future<void> shuffleMode(bool state) async {
    final response = await _sendRequest(
      '$shuffleModeEndpoint?state=$state',
      method: 'PUT',
    );

    if (response.statusCode == 204) {
      print('Modo shuffle ${state ? 'ativado' : 'desativado'} com sucesso!');
    } else {
      print('Falha ao alterar shuffle mode: ${response.statusCode}');
    }
  }
}
