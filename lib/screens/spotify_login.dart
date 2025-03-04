import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:ipod/service/auth_storage.dart';

import 'package:ipod/utils/media_query.utils.dart';
import 'package:ipod/service/auth_service.dart';

class SpotifyLoginScreen extends StatefulWidget {
  final Function(String) onLoginSuccess;
  const SpotifyLoginScreen({super.key, required this.onLoginSuccess});

  @override
  State<SpotifyLoginScreen> createState() => _SpotifyLoginScreenState();
}

class _SpotifyLoginScreenState extends State<SpotifyLoginScreen> {
  String? _accessToken;

  Future<void> _loginToSpotify() async {
    String refreshToken = await AuthStorage.getRefreshToken() ?? '';
    String accessToken = await AuthStorage.getAccessToken() ?? '';

    final authService = SpotifyAuthService(
      refreshToken: refreshToken,
      accessToken: accessToken,
    );

    final token = await authService.authenticate();

    if (token != null) {
      widget.onLoginSuccess(token);
    } else {
      print("Erro ao autenticar com o Spotify");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "iPodfy",
                  style: TextStyle(
                    color: Colors.grey[200],
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "A new way to listen to music the old-school way.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 40),
                Lottie.asset('assets/lottie/spotify_animation.json'),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _loginToSpotify,
                  child: Text("Connect to your Spotify account"),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(
                      fullWidth(context),
                      fullHeight(context, percentage: 0.05),
                    ),
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey[400]!),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
