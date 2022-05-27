import 'package:azeri/data/model/MusicModel.dart';
import 'package:dartz/dartz.dart';

import '../../data/failure.dart';
import '../repository/MusicRepository.dart';

class GetMusicUseCase {
  final MusicRepository musicRepository;

  GetMusicUseCase(this.musicRepository);

  Future<Either<Failure, MusicModel>> execute(String page) =>
      musicRepository.getMusic(page);
}
