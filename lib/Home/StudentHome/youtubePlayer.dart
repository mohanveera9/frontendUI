import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Player extends StatefulWidget {
  final String videoId;
  const Player({super.key, required this.videoId});

  @override
  State<Player> createState() => _YoutubeplayerState();
}

class _YoutubeplayerState extends State<Player> {

  late final YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: widget.videoId,
    flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: true,
    ),
);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Player'),),
      body: YoutubePlayer(controller: _controller),
    );
  }
}