import 'dart:async';

import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

import 'package:ipod/service/spotify_service.dart';
import 'package:ipod/utils/media_query.utils.dart';

class Cover extends StatefulWidget {
  final String accessToken;
  const Cover({super.key, required this.accessToken});

  @override
  State<Cover> createState() => _CoverState();
}

class _CoverState extends State<Cover> {
  late String imageUrl = '';
  late String songName = '';
  late String artistName = '';
  Duration currentProgress = Duration.zero;
  Duration totalDuration = Duration.zero;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateTrackInfo();
    _startTrackUpdateTimer();
  }

  void _startTrackUpdateTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateTrackInfo();
    });
  }

  void _updateTrackInfo() async {
    try {
      final spotifyService = SpotifyService(accessToken: widget.accessToken);
      final trackInfo = await spotifyService.getCurrentPlayingTrack();

      if (trackInfo != null && trackInfo['item'] != null) {
        final item = trackInfo['item'];

        final album = item['album'];
        if (album != null &&
            album['images'] != null &&
            album['images'].isNotEmpty) {
          setState(() {
            imageUrl = album['images'][0]['url'] ?? '';
          });
        } else {
          setState(() {
            imageUrl = '';
          });
        }

        setState(() {
          songName = item['name'] ?? '';
          artistName =
              item['artists'] != null && item['artists'].isNotEmpty
                  ? item['artists'][0]['name'] ?? ''
                  : '';
          totalDuration = Duration(milliseconds: item['duration_ms'] ?? 0);
        });
      } else {
        print("No track is currently playing.");
      }

      final progressInfo = await spotifyService.getTrackProgress();
      if (progressInfo != null) {
        setState(() {
          currentProgress = Duration(
            milliseconds: progressInfo['progress_ms'] ?? 0,
          );
        });
      }
    } catch (e) {
      print("Error fetching track info: $e");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fullWidth(context),
      height: fullHeight(context, percentage: 0.55),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            child:
                imageUrl != ''
                    ? Image.network(imageUrl, fit: BoxFit.cover)
                    : Image.asset(
                      'assets/images/missing_cover.png',
                      fit: BoxFit.cover,
                    ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 120,
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
              songName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Positioned(
            bottom: 65,
            left: 20,
            child: Text(
              artistName,
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
              progress: currentProgress,
              total: totalDuration,
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
