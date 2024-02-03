import 'package:convertouch/domain/model/exception_model.dart';
import 'package:either_dart/either.dart';

abstract class PreferencesRepository {
  const PreferencesRepository();

  Future<Either<ConvertouchException, T?>> get<T>(String key);

  Future<Either<ConvertouchException, List<T>?>> getList<T>(String key);

  Future<Either<ConvertouchException, Map<String, dynamic>>> getMap(
    List<String> keys,
  );

  Future<Either<ConvertouchException, bool>> save(String key, dynamic value);

  Future<Either<ConvertouchException, bool>> saveList(
    String key,
    List<dynamic> value,
  );

  Future<Either<ConvertouchException, void>> saveMap(
    Map<String, dynamic> prefsMap,
  );
}
