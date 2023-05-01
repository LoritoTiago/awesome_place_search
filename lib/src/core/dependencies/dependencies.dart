import 'package:awesome_place_search/src/core/client/http_client.dart';
import 'package:awesome_place_search/src/data/data_sources/get_search_remote_datasource.dart';
import 'package:awesome_place_search/src/data/repositories/get_search_repository.dart';
import 'package:awesome_place_search/src/domain/usecases/use_case.dart';
import 'package:awesome_place_search/src/presentation/bloc/awesome_places_search_bloc.dart';

class Dependencies {
  late AwesomePlacesSearchBloc bloc;

  void initDependencies(String key){
    final dataSource = GetSearchRemoteDataSource(key: key, http: HttpClient());
    final repository = GetSearchRepository(dataSource: dataSource);
    final placeUseCase = GetPlacesUseCase(repository: repository);
    final latLngUseCase = GetLatLngUseCase(repository: repository);
    bloc = AwesomePlacesSearchBloc(
      useCase: placeUseCase,
      latLngUseCase: latLngUseCase,
      key: key,
    );
  }
}