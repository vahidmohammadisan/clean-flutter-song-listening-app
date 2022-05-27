import 'package:azeri/data/model/MuzicModel.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/Muzic.dart';

abstract class MuzicState extends Equatable {
  const MuzicState();

  @override
  List<Object?> get props => [];
}

class MuzicEmpty extends MuzicState {}

class MuzicLoading extends MuzicState {}

class MuzicError extends MuzicState {
  final String message;

  const MuzicError(this.message);

  @override
  List<Object?> get props => [message];
}

class MuzicData extends MuzicState {
  final MuzicModel muzic;

  const MuzicData(this.muzic);

  @override
  List<Object?> get props => [muzic];
}
