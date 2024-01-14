import 'package:convertouch/domain/model/failure.dart';
import 'package:either_dart/either.dart';

abstract class NetworkDataRepository {
  const NetworkDataRepository();

  Either<Failure, Stream<Object>> fetch(String url);
}