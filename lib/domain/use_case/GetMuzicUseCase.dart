import 'package:azeri/data/model/MuzicModel.dart';
import 'package:azeri/domain/entities/Muzic.dart';
import 'package:dartz/dartz.dart';

import '../../data/failure.dart';
import '../repository/MuzicRepository.dart';

class GetMuzicUseCase {
  final MuzicRepository muzicRepository;

  GetMuzicUseCase(this.muzicRepository);

  Future<Either<Failure, MuzicModel>> execute(String page) =>
      muzicRepository.getMuzic(page);
}
