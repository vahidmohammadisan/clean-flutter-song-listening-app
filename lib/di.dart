import 'package:azeri/domain/repository/MusicRepository.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'data/datasource/music_remote_datasource.dart';
import 'data/repository/music_repository_impl.dart';
import 'domain/use_case/GetMusicUseCase.dart';
import 'presentation/bloc/music_bloc.dart';

final locator = GetIt.instance;

void init() {
  // bloc
  locator.registerFactory<MusicBloc>(() => MusicBloc(locator()));

  //usecase
  locator
      .registerLazySingleton<GetMusicUseCase>(() => GetMusicUseCase(locator()));

  //repository
  locator.registerLazySingleton<MusicRepository>(
      () => MusicRepositoryImpl(remoteDataSource: locator()));

  //data source
  locator.registerLazySingleton<RemoteDataSource>(() => RemoteDataSourceImpl());

  locator.registerLazySingleton(() => http.Client);
}
