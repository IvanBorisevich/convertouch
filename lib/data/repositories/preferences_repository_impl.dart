import 'package:convertouch/data/dao/preferences_dao.dart';
import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/repositories/preferences_repository.dart';
import 'package:either_dart/either.dart';

class PreferencesRepositoryImpl extends PreferencesRepository {
  final PreferencesDao preferencesDao;

  const PreferencesRepositoryImpl(this.preferencesDao);

  @override
  Future<Either<Failure, T?>> get<T>(String key) async {
    try {
      switch (T) {
        case int:
          return Right((await preferencesDao.getInt(key)) as T?);
        case double:
          return Right((await preferencesDao.getDouble(key)) as T?);
        case bool:
          return Right((await preferencesDao.getBool(key)) as T?);
        case String:
          return Right((await preferencesDao.getString(key)) as T?);
        default:
          return const Right(null);
      }
    } catch (e) {
      return Left(
        PreferencesFailure("Error when getting preference by key $key: $e"),
      );
    }
  }

  @override
  Future<Either<Failure, List<T>?>> getList<T>(String key) async {
    try {
      final strList = await preferencesDao.getStringList(key);
      switch (T) {
        case int:
          return Right(
            strList?.map((str) => int.parse(str) as T).toList(),
          );
        case double:
          return Right(
            strList?.map((str) => double.parse(str) as T).toList(),
          );
        case String:
          return Right(strList?.cast<T>());
        default:
          return const Right(null);
      }
    } catch (e) {
      return Left(
        PreferencesFailure("Error when getting preference as list "
            "by key $key: $e"),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> save<T>(String key, T value) async {
    try {
      switch (T) {
        case int:
          return Right(await preferencesDao.saveInt(key, value as int));
        case double:
          return Right(await preferencesDao.saveDouble(key, value as double));
        case bool:
          return Right(await preferencesDao.saveBool(key, value as bool));
        case String:
          return Right(await preferencesDao.saveString(key, value as String));
        default:
          return const Right(false);
      }
    } catch (e) {
      return Left(
        PreferencesFailure("Error when saving preference with key $key: $e"),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> saveList<T>(String key, List<T> value) async {
    try {
      return Right(
        await preferencesDao.saveStringList(
          key,
          value.map((item) => item.toString()).toList(),
        ),
      );
    } catch (e) {
      return Left(
        PreferencesFailure("Error when saving preference as list "
            "with key $key: $e"),
      );
    }
  }
}
