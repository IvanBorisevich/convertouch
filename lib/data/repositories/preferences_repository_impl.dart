import 'dart:developer';

import 'package:convertouch/data/dao/preferences_dao.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/repositories/preferences_repository.dart';
import 'package:either_dart/either.dart';

class PreferencesRepositoryImpl extends PreferencesRepository {
  final PreferencesDao preferencesDao;

  const PreferencesRepositoryImpl(this.preferencesDao);

  @override
  Future<Either<ConvertouchException, T?>> get<T>(String key) async {
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
        PreferencesException(
          message: "Error when getting preference by key $key: $e",
        ),
      );
    }
  }

  @override
  Future<Either<ConvertouchException, List<T>?>> getList<T>(String key) async {
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
        PreferencesException(
          message: "Error when getting preference as list by key = $key: $e",
        ),
      );
    }
  }

  @override
  Future<Either<ConvertouchException, Map<String, dynamic>>> getMap(
    List<String> keys,
  ) async {
    try {
      return Right(
        {for (var k in keys) k: await preferencesDao.get(k)},
      );
    } catch (e) {
      return Left(
        PreferencesException(
          message: "Error when getting preferences map: $e",
        ),
      );
    }
  }

  @override
  Future<Either<ConvertouchException, bool>> save(
    String key,
    dynamic value,
  ) async {
    try {
      switch (value.runtimeType) {
        case int:
          return Right(await preferencesDao.saveInt(key, value as int));
        case double:
          return Right(await preferencesDao.saveDouble(key, value as double));
        case bool:
          return Right(await preferencesDao.saveBool(key, value as bool));
        case String:
          return Right(await preferencesDao.saveString(key, value as String));
        default:
          log("Cannot save value of type ${value.runtimeType}");
          return const Right(false);
      }
    } catch (e) {
      return Left(
        PreferencesException(
          message: "Error when saving preference with key $key: $e",
        ),
      );
    }
  }

  @override
  Future<Either<ConvertouchException, bool>> saveList(
    String key,
    List<dynamic> value,
  ) async {
    try {
      return Right(
        await preferencesDao.saveStringList(
          key,
          value.map((item) => item.toString()).toList(),
        ),
      );
    } catch (e) {
      return Left(
        PreferencesException(
          message: "Error when saving preference as list with key = $key: $e",
        ),
      );
    }
  }

  @override
  Future<Either<ConvertouchException, void>> saveMap(
    Map<String, dynamic> prefsMap,
  ) async {
    try {
      for (MapEntry entry in prefsMap.entries) {
        await save(entry.key, entry.value);
      }
      return const Right(null);
    } catch (e) {
      return Left(
        PreferencesException(
          message: "Error when saving preferences map: $e",
        ),
      );
    }
  }
}
