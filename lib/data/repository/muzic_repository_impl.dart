import 'dart:io';

import 'package:azeri/data/model/MuzicModel.dart';
import 'package:azeri/domain/entities/Muzic.dart';
import 'package:dartz/dartz.dart';

import '../../domain/repository/MuzicRepository.dart';
import '../datasource/muzic_remote_datasource.dart';
import '../exception.dart';
import '../failure.dart';

class MuzicRepositoryImpl implements MuzicRepository {
  MuzicRepositoryImpl({required this.remoteDataSource});

  final RemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, MuzicModel>> getMuzic(String page) async {
    try {
      final result = await remoteDataSource.getMuzic(page);
      return Right(result);
    } on SocketException {
      return const Left(ConnectionFailure('connection failure'));
    } on ServerException {
      return const Left(ServerFailure('server failure'));
    }
  }
}
