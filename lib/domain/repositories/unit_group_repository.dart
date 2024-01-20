import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:either_dart/either.dart';

abstract class UnitGroupRepository {
  const UnitGroupRepository();

  Future<Either<Failure, List<UnitGroupModel>>> getAll();

  Future<Either<Failure, List<UnitGroupModel>>> search(
    String searchString,
  );

  Future<Either<Failure, int>> add(UnitGroupModel unitGroup);

  Future<Either<Failure, UnitGroupModel?>> get(int unitGroupId);

  Future<Either<Failure, void>> remove(List<int> unitGroupIds);
}
