import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/use_case/GetMusicUseCase.dart';
import 'music_event.dart';
import 'music_state.dart';

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  final GetMusicUseCase _getMusic;

  MusicBloc(this._getMusic) : super(MusicEmpty()) {
    on<GetMusic>(
      (event, emit) async {
        final query = event.page;

        emit(MusicLoading());

        final result = await _getMusic.execute(query);
        result.fold((failure) => emit(MusicError(failure.message)),
            (data) => emit(MusicData(data)));
      },
      transformer: debounce(Duration(milliseconds: 1500)),
    );
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}
