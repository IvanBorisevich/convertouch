import 'package:convertouch/domain/model/exception_model.dart';
import 'package:either_dart/either.dart';

abstract class PreferencesRepository {
  const PreferencesRepository();

  Future<Either<ConvertouchException, T?>> get<T>(String key);

  Future<Either<ConvertouchException, List<T>?>> getList<T>(String key);

  Future<Either<ConvertouchException, bool>> save<T>(String key, T value);

  Future<Either<ConvertouchException, bool>> saveList<T>(String key, List<T> value);
}
