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
    List<UnitModel> result;
    if (unitGroupId == 1) {
      result = [mockBaseUnit];
    } else if (unitGroupId == 2) {
      result = [mockBaseUnit, mockBaseUnit2];
    } else if (unitGroupId == 3) {
      result = [mockOobBaseUnit];
    } else if (unitGroupId == 4) {
      result = [mockOobBaseUnit, mockOobBaseUnit2];
    } else {
      result = [];
    }
    return Right(result);
  }

  @override
  Future<Either<ConvertouchException, Map<int, UnitModel>>> getByCodesAsMap(
      String unitGroupName, List<String> codes) {
    // TODO: implement getByCodesAsMap
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
  Future<Either<ConvertouchException, UnitModel>> update(UnitModel unit) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<Either<ConvertouchException, List<UnitModel>>> searchWithGroupId({
    required int unitGroupId,
    String? searchString,
    required int pageNum,
    required int pageSize,
  }) {
    // TODO: implement searchWithGroupId
    throw UnimplementedError();
  }

  @override
  Future<Either<ConvertouchException, List<UnitModel>>> searchWithParamId({
    required int paramId,
    String? searchString,
    required int pageNum,
    required int pageSize,
  }) {
    // TODO: implement searchWithParamId
    throw UnimplementedError();
  }
}
