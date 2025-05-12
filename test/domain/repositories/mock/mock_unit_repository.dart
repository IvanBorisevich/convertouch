import 'package:collection/collection.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:either_dart/src/either.dart';

import '../../model/mock/mock_unit.dart';

const _mockUnitsList = [
  centimeter,
  decimeter,
  meter,
  kilometer,
  europeanClothSize,
  japanClothSize,
  italianClothSize,
  usaClothSize,
  frRingSize,
  ruRingSize,
  usaRingSize,
];

class MockUnitRepository extends UnitRepository {
  const MockUnitRepository();

  @override
  Future<Either<ConvertouchException, UnitModel>> add(UnitModel unit) async {
    return Right(unit);
  }

  @override
  Future<Either<ConvertouchException, UnitModel?>> get(int id) async {
    return Right(
      _mockUnitsList.firstWhereOrNull((unit) => unit.id == id),
    );
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
    String unitGroupName,
    List<String> codes,
  ) async {
    return Right(
      {
        for (var v in _mockUnitsList.where((unit) => codes.contains(unit.code)))
          v.id: v
      },
    );
  }

  @override
  Future<Either<ConvertouchException, List<UnitModel>>> getByIds(
    List<int> ids,
  ) async {
    Map<int, UnitModel> mockUnitsMap = {
      for (var unit in _mockUnitsList) unit.id: unit
    };

    return Right(
      ids.map((id) => mockUnitsMap[id]!).toList(),
    );
  }

  @override
  Future<Either<ConvertouchException, void>> remove(List<int> unitIds) async {
    return const Right(null);
  }

  @override
  Future<Either<ConvertouchException, UnitModel>> update(UnitModel unit) async {
    return Right(unit);
  }

  @override
  Future<Either<ConvertouchException, List<UnitModel>>> searchWithGroupId({
    required int unitGroupId,
    String? searchString,
    required int pageNum,
    required int pageSize,
  }) async {
    return const Right(_mockUnitsList);
  }

  @override
  Future<Either<ConvertouchException, List<UnitModel>>> searchWithParamId({
    required int paramId,
    String? searchString,
    required int pageNum,
    required int pageSize,
  }) async {
    return const Right(_mockUnitsList);
  }
}
