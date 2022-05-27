import 'package:azeri/data/model/MusicModel.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../exception.dart';

abstract class RemoteDataSource {
  Future<MusicModel> getMusic(String page);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  RemoteDataSourceImpl();

  @override
  Future<MusicModel> getMusic(String page) async {
    final response = await http.get(Uri.parse(Urls.Url(page)));
    if (response.statusCode == 200) {
      return MusicModel(Body: response.body);
    } else {
      throw ServerException();
    }
  }
}
