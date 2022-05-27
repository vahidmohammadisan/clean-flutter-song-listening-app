import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayer/audioplayer.dart';
import 'package:azeri/domain/entities/Music.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

class PlayMusic extends StatelessWidget {
  PlayMusic({this.music, this.onPressed});

  final Music music;
  final onPressed;

  @override
  Widget build(BuildContext context) {
    return AudioApp(music);
  }
}

enum PlayerState { stopped, playing, paused }

enum DownloadState { Downloaded, Downloading, Download }

typedef void OnError(Exception exception);

class AudioApp extends StatefulWidget {
  AudioApp(this.music);

  Music music;

  @override
  _AudioAppState createState() => _AudioAppState(music);
}

class _AudioAppState extends State<AudioApp> {
  _AudioAppState(this.music);

  Music music;
  Duration duration;
  Duration position;
  AudioPlayer audioPlayer;
  String localFilePath;
  PlayerState playerState = PlayerState.stopped;

  get isPlaying => playerState == PlayerState.playing;

  get isPaused => playerState == PlayerState.paused;

  DownloadState downloadState = DownloadState.Download;

  get isDownloaded => downloadState == DownloadState.Downloaded;

  get isDownloading => downloadState == DownloadState.Downloading;

  get durationText =>
      duration != null ? duration.toString().split('.').first : '';

  get positionText =>
      position != null ? position.toString().split('.').first : '';
  bool isMuted = false;
  StreamSubscription _positionSubscription;
  StreamSubscription _audioPlayerStateSubscription;

  @override
  void initState() {
    super.initState();
    initAudioPlayer();
  }

  @override
  void dispose() {
    _positionSubscription.cancel();
    _audioPlayerStateSubscription.cancel();
    audioPlayer.stop();
    super.dispose();
  }

  void initAudioPlayer() {
    audioPlayer = AudioPlayer();
    _positionSubscription = audioPlayer.onAudioPositionChanged
        .listen((p) => setState(() => position = p));
    _audioPlayerStateSubscription =
        audioPlayer.onPlayerStateChanged.listen((s) {
      if (s == AudioPlayerState.PLAYING) {
        setState(() => duration = audioPlayer.duration);
      } else if (s == AudioPlayerState.STOPPED) {
        onComplete();
        setState(() {
          position = duration;
        });
      }
    }, onError: (msg) {
      setState(() {
        playerState = PlayerState.stopped;
        duration = Duration(seconds: 0);
        position = Duration(seconds: 0);
      });
    });
    if (!kIsWeb) checkFileIsExist();
  }

  Future play() async {
    if (!kIsWeb && isDownloaded) {
      _playLocal();
    } else {
      await audioPlayer.play(music.Link);
      setState(() {
        playerState = PlayerState.playing;
      });
    }
  }

  Future _playLocal() async {
    await audioPlayer.play(localFilePath, isLocal: true);
    setState(() => playerState = PlayerState.playing);
  }

  Future pause() async {
    await audioPlayer.pause();
    setState(() => playerState = PlayerState.paused);
  }

  Future stop() async {
    await audioPlayer.stop();
    setState(() {
      playerState = PlayerState.stopped;
      position = Duration();
    });
  }

  Future mute(bool muted) async {
    await audioPlayer.mute(muted);
    setState(() {
      isMuted = muted;
    });
  }

  Future checkFileIsExist() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${music.Name}.mp3');
    if (await file.exists()) {
      setState(() {
        downloadState = DownloadState.Downloaded;
      });
      setState(() {
        localFilePath = file.path;
      });
    }
  }

  void onComplete() {
    setState(() => playerState = PlayerState.stopped);
  }

  Future<Uint8List> _loadFileBytes(String url, {OnError onError}) async {
    Uint8List bytes;
    try {
      bytes = await readBytes(Uri.parse(url));
    } on ClientException {
      rethrow;
    }
    return bytes;
  }

  Future _loadFile() async {
    if (!kIsWeb && isDownloaded) return;
    final bytes = await _loadFileBytes(music.Link,
        onError: (Exception exception) =>
            print('_loadFile => exception $exception'));

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${music.Name}.mp3');

    await file.writeAsBytes(bytes);
    if (await file.exists()) {
      setState(() {
        localFilePath = file.path;
      });
      setState(() {
        downloadState = DownloadState.Downloaded;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: Text('${music.Name.split("Yeni")[0]}\n ${music.Signer}'),
          actions: [
            IconButton(
              iconSize: 22.0,
              icon: const Icon(
                Icons.share,
                color: Colors.white,
              ),
              onPressed: () {
                if (localFilePath != null) {
                  Share.shareFiles([localFilePath], text: music.Name);
                } else {
                  Share.share(music.Link, subject: music.Name);
                }
              },
            )
          ],
        ),
        body: Center(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    iconSize: 200.0,
                    icon: Icon(
                      Icons.audio_file,
                      color: (isDownloaded) ? Colors.amber : Colors.grey,
                    )),
                Material(child: _buildPlayer()),
                //if (!kIsWeb)
                //  localFilePath != null ? Text(localFilePath) : Container(),
                if (!kIsWeb)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            _loadFile();
                            setState(() {
                              downloadState = DownloadState.Downloading;
                            });
                          },
                          child: Text(
                            isDownloaded
                                ? "This audio has Downloaded."
                                : isDownloading
                                    ? "Downloading ... "
                                    : "Download and save, if you want...",
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ));
  }

  Widget _buildPlayer() => Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(
                onPressed: isPlaying ? null : () => play(),
                iconSize: 45.0,
                icon: Icon(Icons.play_arrow),
                color: Colors.amber,
              ),
              IconButton(
                onPressed: isPlaying ? () => pause() : null,
                iconSize: 45.0,
                icon: Icon(Icons.pause),
                color: Colors.amber,
              ),
              IconButton(
                onPressed: isPlaying || isPaused ? () => stop() : null,
                iconSize: 45.0,
                icon: Icon(Icons.stop),
                color: Colors.amber,
              ),
            ]),
            if (duration != null)
              Slider(
                  value: position?.inMilliseconds?.toDouble() ?? 0.0,
                  onChanged: (double value) {
                    return audioPlayer.seek((value / 1000).roundToDouble());
                  },
                  min: 0.0,
                  max: duration.inMilliseconds.toDouble()),
            if (position != null) _buildMuteButtons(),
            if (position != null) _buildProgressView()
          ],
        ),
      );

  Row _buildProgressView() => Row(mainAxisSize: MainAxisSize.min, children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: CircularProgressIndicator(
            value: position != null && position.inMilliseconds > 0
                ? (position?.inMilliseconds?.toDouble() ?? 0.0) /
                    (duration?.inMilliseconds?.toDouble() ?? 0.0)
                : 0.0,
            valueColor: AlwaysStoppedAnimation(Colors.amber),
            backgroundColor: Colors.grey.shade400,
          ),
        ),
        Text(
          position != null
              ? "${positionText ?? ''} / ${durationText ?? ''}"
              : duration != null
                  ? durationText
                  : '',
          style: TextStyle(fontSize: 24.0),
        )
      ]);

  Row _buildMuteButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        if (!isMuted)
          TextButton.icon(
            onPressed: () => mute(true),
            icon: const Icon(
              Icons.headset_off,
              color: Colors.amber,
            ),
            label: const Text('Mute', style: TextStyle(color: Colors.amber)),
          ),
        if (isMuted)
          TextButton.icon(
            onPressed: () => mute(false),
            icon: const Icon(Icons.headset, color: Colors.amber),
            label: const Text('Unmute', style: TextStyle(color: Colors.amber)),
          ),
      ],
    );
  }
}
