import 'package:azeri/domain/entities/Muzic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../widgets/audio_player_widget.dart';

class PlayMuzic extends StatelessWidget {
  PlayMuzic({this.muzic, this.onPressed});

  final Muzic muzic;
  final onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(muzic.Name.toString()),
      ),
      body: AudioPlayerWidget(
        url: muzic.Link,
        isAsset: false,
      ),
    );
  }
}
