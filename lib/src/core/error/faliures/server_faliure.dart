import 'package:awesome_place_search/src/core/error/faliures/i_faliure.dart';

class ServerFailure extends Faliure {
  final String message;
  ServerFailure({required this.message});
}
