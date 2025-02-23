import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import 'package:ipod/utils/media_query.utils.dart';

class PlayerControl extends StatefulWidget {
  const PlayerControl({super.key});

  @override
  State<PlayerControl> createState() => _PlayerControlState();
}

class _PlayerControlState extends State<PlayerControl> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: fullWidth(context),
            height: fullHeight(context, percentage: 0.44),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              gradient: LinearGradient(
                colors: [Colors.grey[300]!, Colors.grey[400]!],
                begin: Alignment.center,
                end: Alignment.bottomCenter,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 5,
                  offset: Offset(2, 2),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 45,
            child: Container(
              width: fullWidth(context, percentage: 1),
              height: fullHeight(context, percentage: 0.35),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 140,
            child: Container(
              width: fullWidth(context, percentage: 0.3),
              height: fullWidth(context, percentage: 0.3),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.grey[300]!, Colors.grey[400]!],
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                ),
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Botão Shuffle
          Positioned(
            top: fullHeight(context, percentage: 0.08),
            child: GestureDetector(
              onTap: () {
                print('Play/Pause');
              },
              child: Icon(Ionicons.shuffle, size: 35, color: Colors.grey[500]),
            ),
          ),

          // Botão Play/Pause
          Positioned(
            top: fullHeight(context, percentage: 0.33),
            child: GestureDetector(
              onTap: () {
                print('Play/Pause');
              },
              child: Icon(Ionicons.pause, size: 30, color: Colors.grey[500]),
            ),
          ),

          // Botão Anterior
          Positioned(
            left: fullWidth(context, percentage: 0.2),
            top: fullHeight(context, percentage: 0.2),
            child: GestureDetector(
              onTap: () {
                print('Anterior');
              },
              child: Icon(
                Ionicons.play_back,
                size: 30,
                color: Colors.grey[500],
              ),
            ),
          ),

          // Botão Próximo
          Positioned(
            right: fullWidth(context, percentage: 0.2),
            top: fullHeight(context, percentage: 0.2),
            child: GestureDetector(
              onTap: () {
                print('Próximo');
              },
              child: Icon(
                Ionicons.play_forward,
                size: 30,
                color: Colors.grey[500],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
