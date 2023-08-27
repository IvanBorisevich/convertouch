import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:either_dart/either.dart';

abstract class UnitGroupRepository {
  const UnitGroupRepository();

  Future<Either<Failure, List<UnitGroupModel>>> fetchUnitGroups();

  Future<Either<Failure, int>> addUnitGroup(UnitGroupModel unitGroup);

  Future<Either<Failure, UnitGroupModel>> getUnitGroup(int unitGroupId);
}