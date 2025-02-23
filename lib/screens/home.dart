import 'package:flutter/material.dart';
import 'package:ipod/components/cover.dart';
import 'package:ipod/components/player_control.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [Cover(), Spacer(), PlayerControl()],
      ),
    );
  }
}
