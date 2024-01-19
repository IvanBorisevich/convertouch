import 'package:convertouch/data/dao/refreshable_value_dao.dart';
import 'package:convertouch/data/translators/refreshable_value_translator.dart';
import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/refreshable_value_model.dart';
import 'package:convertouch/domain/repositories/refreshable_value_repository.dart';
import 'package:either_dart/either.dart';

class RefreshableValueRepositoryImpl extends RefreshableValueRepository {
  final RefreshableValueDao refreshableValueDao;

  const RefreshableValueRepositoryImpl(this.refreshableValueDao);

  @override
  Future<Either<Failure, RefreshableValueModel?>> get(int unitId) async {
    try {
      final result = await refreshableValueDao.get(unitId);
      return Right(RefreshableValueTranslator.I.toModel(result));
    } catch (e) {
      return Left(
        DatabaseFailure(
          "Error when fetching a refreshable value by unit id = $unitId: $e",
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<RefreshableValueModel>>> getList(
    List<int> unitIds,
  ) async {
    // TODO: implement getOfGroupFromDb
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> updateAll(
    List<RefreshableValueModel> values,
  ) async {
    // TODO: implement updateAll
    throw UnimplementedError();
  }
}
