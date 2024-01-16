import 'package:convertouch/data/dao/preferences_dao.dart';
import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/repositories/preferences_repository.dart';
import 'package:either_dart/either.dart';

class PreferencesRepositoryImpl extends PreferencesRepository {
  final PreferencesDao preferencesDao;

  const PreferencesRepositoryImpl(this.preferencesDao);

  @override
  Future<Either<Failure, dynamic>> get(String key, Type type) async {
    try {
      switch (type) {
        case int:
          return Right(await preferencesDao.getInt(key));
        case String:
        default:
          return Right(await preferencesDao.getString(key));
      }
    } catch (e) {
      return Left(
        PreferencesFailure("Error when getting preference by key $key: $e"),
      );
    }
  }

  @override
  Future<Either<Failure, dynamic>> getList(String key, Type itemType) async {
    try {
      final strList = await preferencesDao.getStringList(key);
      switch (itemType) {
        case int:
          return Right(
            strList?.map((str) => int.parse(str)).toList(),
          );
        case String:
        default:
          return Right(strList);
      }
    } catch (e) {
      return Left(
        PreferencesFailure("Error when getting preference as list "
            "by key $key: $e"),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> save(String key, dynamic value) async {
    try {
      switch (value.runtimeType) {
        case int:
          return Right(await preferencesDao.saveInt(key, value));
        case String:
        default:
          return Right(await preferencesDao.saveString(key, value));
      }
    } catch (e) {
      return Left(
        PreferencesFailure("Error when saving preference with key $key: $e"),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> saveList(
    String key,
    List<dynamic> value,
    Type itemType,
  ) async {
    try {
      switch (itemType) {
        case int:
          return Right(
            await preferencesDao.saveStringList(
              key,
              value.map((item) => item.toString()).toList(),
            ),
          );
        case String:
        default:
          return Right(
              await preferencesDao.saveStringList(key, value as List<String>));
      }
    } catch (e) {
      return Left(
        PreferencesFailure("Error when saving preference with key $key: $e"),
      );
    }
  }
}
