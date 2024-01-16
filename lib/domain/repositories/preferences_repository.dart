import 'package:convertouch/domain/model/failure.dart';
import 'package:either_dart/either.dart';

abstract class PreferencesRepository {
  const PreferencesRepository();

  Future<Either<Failure, dynamic>> get(String key, Type type);

  Future<Either<Failure, dynamic>> getList(String key, Type itemType);

  Future<Either<Failure, bool>> save(String key, dynamic value);

  Future<Either<Failure, bool>> saveList(
    String key,
    List<dynamic> value,
    Type itemType,
  );
}
