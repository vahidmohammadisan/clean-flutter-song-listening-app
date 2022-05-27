import 'package:dartz/dartz.dart';

import '../../data/failure.dart';
import '../../data/model/MuzicModel.dart';

abstract class MuzicRepository {
  Future<Either<Failure, MuzicModel>> getMuzic(String page);
}
