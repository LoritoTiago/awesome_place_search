import 'package:awesome_place_search/src/core/client/http_client.dart';
import 'package:awesome_place_search/src/data/data_sources/get_search_remote_datasource.dart';
import 'package:awesome_place_search/src/data/repositories/get_search_repository.dart';

class Dependencies {
  GetSearchRepository? repository;
  String? key;
  String? serverErrorMessage;
  String? keyErrorMessage;

  void initDependencies(String key) {
    final dataSource = GetSearchRemoteDataSource(key: key, http: HttpClient());
    repository = GetSearchRepository(dataSource: dataSource);

    this.key = key;
  }
}
