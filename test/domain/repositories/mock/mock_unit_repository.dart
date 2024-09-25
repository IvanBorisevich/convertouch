import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:either_dart/src/either.dart';

import '../../model/mock/mock_unit.dart';

class MockUnitRepository extends UnitRepository {
  const MockUnitRepository();

  @override
  Future<Either<ConvertouchException, UnitModel>> add(UnitModel unit) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future<Either<ConvertouchException, UnitModel?>> get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<Either<ConvertouchException, List<UnitModel>>> getBaseUnits(
    int unitGroupId,
  ) async {
    return const Right([mockBaseUnit]);
  }

  @override
  Future<Either<ConvertouchException, Map<int, UnitModel>>> getByCodesAsMap(
      String unitGroupName, List<String> codes) {
    // TODO: implement getByCodesAsMap
    throw UnimplementedError();
  }

  @override
  Future<Either<ConvertouchException, List<UnitModel>>> getByGroupId(
      int unitGroupId) {
    // TODO: implement getByGroupId
    throw UnimplementedError();
  }

  @override
  Future<Either<ConvertouchException, List<UnitModel>>> getByIds(
      List<int> ids) {
    // TODO: implement getByIds
    throw UnimplementedError();
  }

  @override
  Future<Either<ConvertouchException, void>> remove(List<int> unitIds) {
    // TODO: implement remove
    throw UnimplementedError();
  }

  @override
  Future<Either<ConvertouchException, List<UnitModel>>> search(
      int unitGroupId, String searchString) {
    // TODO: implement search
    throw UnimplementedError();
  }

  @override
  Future<Either<ConvertouchException, UnitModel>> update(UnitModel unit) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
