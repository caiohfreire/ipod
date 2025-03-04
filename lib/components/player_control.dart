import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ipod/service/auth_service.dart';

import 'package:ipod/service/auth_storage.dart';
import 'package:ipod/service/spotify_service.dart';
import 'package:ipod/utils/media_query.utils.dart';

class PlayerControl extends StatefulWidget {
  final String accessToken; // Adicionando o construtor que recebe o accessToken
  const PlayerControl({super.key, required this.accessToken});

  @override
  State<PlayerControl> createState() => _PlayerControlState();
}

class _PlayerControlState extends State<PlayerControl> {
  late String accessToken;
  bool isPlaying = false;
  bool isShuffleMode = false;
  SpotifyService? spotifyService;
  late SpotifyAuthService spotifyAuthService;

  @override
  void initState() {
    super.initState();
    _initializeAccessToken().then((_) async {
      // Agora criamos o authService com os parâmetros necessários
      String? refreshToken =
          await AuthStorage.getRefreshToken(); // Obtém o refreshToken
      spotifyAuthService = SpotifyAuthService(
        refreshToken: refreshToken ?? '', // Passando o refreshToken
        accessToken: accessToken, // Passando o accessToken
      );
      spotifyService = SpotifyService(spotifyAuthService: spotifyAuthService);
      _getCurrentPlayingState();
    });
  }

  // Função para carregar o token de acesso armazenado
  Future<void> _loadAccessToken() async {
    final token = await AuthStorage.getAccessToken();
    setState(() {
      accessToken = token ?? ''; // Atualiza o estado com o token recuperado
    });
  }

  // Método assíncrono para inicializar o token
  Future<void> _initializeAccessToken() async {
    try {
      final token = await AuthStorage.getAccessToken();
      if (token != null) {
        setState(() {
          accessToken = token;
        });

        // Agora que o token de acesso está disponível, podemos inicializar o spotifyService
        String? refreshToken = await AuthStorage.getRefreshToken();
        spotifyAuthService = SpotifyAuthService(
          refreshToken: refreshToken ?? '',
          accessToken: accessToken,
        );
        spotifyService = SpotifyService(spotifyAuthService: spotifyAuthService);

        // Depois de inicializar, chamamos a função para buscar o estado atual da música
        _getCurrentPlayingState();
      } else {
        throw Exception("Token de acesso não disponível");
      }
    } catch (e) {
      print("Erro ao obter o token: $e");
    }
  }

  Future<void> _getCurrentPlayingState() async {
    if (accessToken.isEmpty || spotifyService == null) return;

    final currentTrack = await spotifyService?.getCurrentPlayingTrack();

    if (currentTrack != null) {
      setState(() {
        isPlaying = currentTrack['is_playing'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final spotifyService = SpotifyService(accessToken: accessToken ?? '');

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
              onTap: () async {
                await spotifyService?.shuffleMode(!isShuffleMode);
                setState(() {
                  isShuffleMode = !isShuffleMode;
                });
              },
              child: Icon(
                Ionicons.shuffle,
                size: 35,
                color: !isShuffleMode ? Colors.grey[500] : Colors.grey[800],
              ),
            ),
          ),

          // Botão Play/Pause
          Positioned(
            top: fullHeight(context, percentage: 0.33),
            child: GestureDetector(
              onTap: () async {
                final currentTrack =
                    await spotifyService?.getCurrentPlayingTrack();

                if (currentTrack != null && currentTrack['is_playing']) {
                  await spotifyService?.pauseTrack();
                  setState(() {
                    isPlaying = false;
                  });
                  print('Música pausada');
                } else {
                  await spotifyService?.playTrack();
                  setState(() {
                    isPlaying = true;
                  });
                  print('Música despausada');
                }
              },
              child: Icon(
                isPlaying ? Ionicons.pause : Ionicons.play,
                size: 30,
                color: Colors.grey[500],
              ),
            ),
          ),

          // Botão Anterior
          Positioned(
            left: fullWidth(context, percentage: 0.2),
            top: fullHeight(context, percentage: 0.2),
            child: GestureDetector(
              onTap: () {
                spotifyService?.previousTrack();
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
                spotifyService?.nextTrack();
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
