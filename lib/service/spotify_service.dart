import 'dart:convert';
import 'package:http/http.dart' as http;

class SpotifyService {
  final String accessToken;

  SpotifyService({required this.accessToken});

  Future<Map<String, dynamic>?> getCurrentPlayingTrack() async {
    final url = Uri.parse(
      'https://api.spotify.com/v1/me/player/currently-playing',
    );
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }

  Future<Map<String, dynamic>?> getTrackProgress() async {
    final url = Uri.parse('https://api.spotify.com/v1/me/player');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }
}
