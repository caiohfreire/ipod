import 'package:flutter/material.dart';

import 'package:ipod/screens/home.dart';
import 'package:ipod/screens/spotify_login.dart';

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
  bool _isAuthenticated = false;

  void _onLoginSuccess() {
    setState(() {
      _isAuthenticated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child:
            _isAuthenticated
                ? HomeScreen() // Exibe a HomeScreen após autenticar
                : SpotifyLoginScreen(onLoginSuccess: _onLoginSuccess),
      ),
    );
  }
}
