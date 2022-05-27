import 'package:dartz/dartz.dart';

import '../../data/failure.dart';
import '../../data/model/MusicModel.dart';

abstract class MusicRepository {
  Future<Either<Failure, MusicModel>> getMusic(String page);
}
