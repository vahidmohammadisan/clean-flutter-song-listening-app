import 'package:azeri/data/model/MusicModel.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/Music.dart';

abstract class MusicState extends Equatable {
  const MusicState();

  @override
  List<Object> get props => [];
}

class MusicEmpty extends MusicState {}

class MusicLoading extends MusicState {}

class MusicError extends MusicState {
  final String message;

  const MusicError(this.message);

  @override
  List<Object> get props => [message];
}

class MusicData extends MusicState {
  final MusicModel music;

  const MusicData(this.music);

  @override
  List<Object> get props => [music];
}
