import 'package:awesome_place_search/src/core/error/failures/i_failure.dart';

class ServerFailure extends Failure {
  final String message;
  ServerFailure({required this.message});
}
