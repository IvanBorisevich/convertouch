import 'package:convertouch/domain/model/failure.dart';
import 'package:either_dart/either.dart';

abstract class PreferencesRepository {
  const PreferencesRepository();

  Future<Either<Failure, T?>> get<T>(String key);

  Future<Either<Failure, List<T>?>> getList<T>(String key);

  Future<Either<Failure, bool>> save<T>(String key, T value);

  Future<Either<Failure, bool>> saveList<T>(String key, List<T> value);
}
