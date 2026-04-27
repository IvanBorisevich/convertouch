import 'package:collection/collection.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/repositories/unit_group_repository.dart';
import 'package:either_dart/src/either.dart';

import '../../model/mock/mock_unit_group.dart';

const _mockUnitGroupsList = [
  lengthGroup,
  clothesSizeGroup,
  temperatureGroup,
  ringSizeGroup,
  massGroup,
  currencyGroup,
];

class MockUnitGroupRepository extends UnitGroupRepository {
  const MockUnitGroupRepository();

  @override
  Future<Either<ConvertouchException, UnitGroupModel>> add(
    UnitGroupModel unitGroup,
  ) async {
    return Right(unitGroup);
  }

  @override
  Future<Either<ConvertouchException, UnitGroupModel?>> get(
    int unitGroupId,
  ) async {
    return Right(
      _mockUnitGroupsList.firstWhereOrNull((unit) => unit.id == unitGroupId),
    );
  }

  @override
  Future<Either<ConvertouchException, void>> remove(
    List<int> unitGroupIds,
  ) async {
    return const Right(null);
  }

  @override
  Future<Either<ConvertouchException, List<UnitGroupModel>>> search({
    String? searchString,
    required int pageNum,
    required int pageSize,
  }) async {
    return const Right(_mockUnitGroupsList);
  }

  @override
  Future<Either<ConvertouchException, UnitGroupModel>> update(
    UnitGroupModel unitGroup,
  ) async {
    return Right(unitGroup);
  }
}
