import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/use_case/GetMuzicUseCase.dart';
import 'muzic_event.dart';
import 'muzic_state.dart';

class MuzicBloc extends Bloc<MuzicEvent, MuzicState> {
  final GetMuzicUseCase _getMuzic;

  MuzicBloc(this._getMuzic) : super(MuzicEmpty()) {
    on<GetMuzic>(
      (event, emit) async {
        final query = event.page;

        emit(MuzicLoading());

        final result = await _getMuzic.execute(query);
        result.fold((failure) => emit(MuzicError(failure.message)),
            (data) => emit(MuzicData(data)));
      },
      transformer: debounce(Duration(milliseconds: 1500)),
    );
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}
