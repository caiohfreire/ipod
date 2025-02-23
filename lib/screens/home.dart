import 'package:flutter/material.dart';

import 'package:ipod/service/auth_service.dart';
import 'package:ipod/components/cover.dart';
import 'package:ipod/components/player_control.dart';

class HomeScreen extends StatefulWidget {
  final String accessToken;
  const HomeScreen({super.key, required this.accessToken});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _accessToken;

  @override
  void initState() {
    super.initState();
    _accessToken = widget.accessToken;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child:
            _accessToken == null
                ? CircularProgressIndicator(color: Colors.green)
                : Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Cover(accessToken: _accessToken!),
                    Spacer(),
                    PlayerControl(),
                  ],
                ),
      ),
    );
  }
}
