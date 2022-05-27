import 'package:azeri/data/model/MuzicModel.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../exception.dart';

abstract class RemoteDataSource {
  Future<MuzicModel> getMuzic(String page);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  RemoteDataSourceImpl();

  @override
  Future<MuzicModel> getMuzic(String page) async {
    final response = await http.get(Uri.parse(Urls.Url(page)));
    if (response.statusCode == 200) {
      return MuzicModel(Body: response.body);
    } else {
      throw ServerException();
    }
  }
}
