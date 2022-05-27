import 'package:equatable/equatable.dart';

abstract class MusicEvent extends Equatable {
  const MusicEvent();

  @override
  List<Object> get props => [];
}

class GetMusic extends MusicEvent {
  final String page;

  const GetMusic(this.page);

  @override
  List<Object> get props => [page];
}
