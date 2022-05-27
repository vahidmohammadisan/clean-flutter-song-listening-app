import 'package:azeri/domain/repository/MuzicRepository.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'data/datasource/muzic_remote_datasource.dart';
import 'data/repository/muzic_repository_impl.dart';
import 'domain/use_case/GetMuzicUseCase.dart';
import 'presentation/bloc/muzic_bloc.dart';

final locator = GetIt.instance;

void init() {
  // bloc
  locator.registerFactory<MuzicBloc>(() => MuzicBloc(locator()));

  //usecase
  locator
      .registerLazySingleton<GetMuzicUseCase>(() => GetMuzicUseCase(locator()));

  //repository
  locator.registerLazySingleton<MuzicRepository>(
      () => MuzicRepositoryImpl(remoteDataSource: locator()));

  //data source
  locator.registerLazySingleton<RemoteDataSource>(() => RemoteDataSourceImpl());

  locator.registerLazySingleton(() => http.Client);
}
