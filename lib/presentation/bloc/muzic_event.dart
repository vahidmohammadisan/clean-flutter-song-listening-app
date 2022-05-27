import 'package:equatable/equatable.dart';

abstract class MuzicEvent extends Equatable {
  const MuzicEvent();

  @override
  List<Object?> get props => [];
}

class GetMuzic extends MuzicEvent {
  final String page;

  const GetMuzic(this.page);

  @override
  List<Object?> get props => [page];
}
