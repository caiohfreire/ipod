import 'package:flutter/material.dart';

import 'package:ipod/screens/home.dart';
import 'package:ipod/screens/spotify_login.dart';
import 'package:ipod/service/auth_storage.dart';

void main() {
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MainPage());
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String? _accessToken;

  @override
  void initState() {
    super.initState();
    _loadAccessToken();
  }

  // Carrega o accessToken do armazenamento seguro
  Future<void> _loadAccessToken() async {
    final token = await AuthStorage.getAccessToken();
    if (token != null) {
      setState(() {
        _accessToken = token;
      });
    }
  }

  void _onLoginSuccess(String accessToken) {
    setState(() {
      _accessToken = accessToken;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child:
            _accessToken != null
                ? HomeScreen(accessToken: _accessToken!)
                : SpotifyLoginScreen(onLoginSuccess: _onLoginSuccess),
      ),
    );
  }
}
