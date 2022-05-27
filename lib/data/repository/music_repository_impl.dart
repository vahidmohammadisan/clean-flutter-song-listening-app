import 'dart:io';

import 'package:azeri/data/model/MusicModel.dart';
import 'package:azeri/domain/entities/Music.dart';
import 'package:dartz/dartz.dart';

import '../../domain/repository/MusicRepository.dart';
import '../datasource/music_remote_datasource.dart';
import '../exception.dart';
import '../failure.dart';

class MusicRepositoryImpl implements MusicRepository {
  MusicRepositoryImpl({this.remoteDataSource});

  final RemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, MusicModel>> getMusic(String page) async {
    try {
      final result = await remoteDataSource.getMusic(page);
      return Right(result);
    } on SocketException {
      return const Left(ConnectionFailure('connection failure'));
    } on ServerException {
      return const Left(ServerFailure('server failure'));
    }
  }
}
