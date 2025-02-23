import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

import 'package:ipod/utils/media_query.utils.dart';

class Cover extends StatefulWidget {
  const Cover({super.key});

  @override
  State<Cover> createState() => _CoverState();
}

class _CoverState extends State<Cover> {
  String imageUrl =
      "https://i.scdn.co/image/ab67616d0000b273bbd45c8d36e0e045ef640411";

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fullWidth(context),
      height: fullHeight(context, percentage: 0.55),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            child: Image.network(imageUrl, fit: BoxFit.cover),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 90,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.80)],
                  stops: [0.0, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 82,
            left: 20,
            child: Text(
              "DtMF",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Positioned(
            bottom: 65,
            left: 20,
            child: Text(
              "Bad Bunny",
              style: TextStyle(
                color: Colors.white.withValues(alpha: 6),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Positioned(
            bottom: 15,
            left: 20,
            right: 20,
            child: ProgressBar(
              progressBarColor: Colors.white,
              progress: Duration(minutes: 2),
              total: Duration(minutes: 4),
              thumbColor: Colors.white,
              thumbGlowColor: Colors.transparent,
              baseBarColor: Colors.white70.withAlpha(60),
              thumbRadius: 4,
              barHeight: 3,
              timeLabelPadding: 6,
              timeLabelTextStyle: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
