import 'package:convertouch/domain/entities/failure_entity.dart';
import 'package:convertouch/domain/entities/unit_group_entity.dart';
import 'package:dartz/dartz.dart';

abstract class UnitGroupRepository {
  const UnitGroupRepository();

  Future<Either<List<UnitGroupEntity>, FailureEntity>> fetchUnitGroups();
}