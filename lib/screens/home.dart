import 'package:flutter/material.dart';

import 'package:ipod/components/cover.dart';
import 'package:ipod/components/player_control.dart';

class HomeScreen extends StatefulWidget {
  final String accessToken;
  const HomeScreen({super.key, required this.accessToken});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String _accessToken;

  @override
  void initState() {
    super.initState();
    _accessToken =
        widget.accessToken; // Atribui o valor do token passado via construtor
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child:
            _accessToken.isEmpty
                ? CircularProgressIndicator(
                  color: Colors.green,
                ) // Aguarda o carregamento
                : Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Cover(
                      accessToken: _accessToken,
                    ), // Passa o accessToken para o Cover
                    Spacer(),
                    PlayerControl(
                      accessToken: _accessToken,
                    ), // Passa o accessToken para o PlayerControl
                  ],
                ),
      ),
    );
  }
}
