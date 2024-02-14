import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:either_dart/either.dart';

abstract class UnitGroupRepository {
  const UnitGroupRepository();

  Future<Either<ConvertouchException, List<UnitGroupModel>>> getAll();

  Future<Either<ConvertouchException, List<UnitGroupModel>>> search(
    String searchString,
  );

  Future<Either<ConvertouchException, UnitGroupModel?>> add(
    UnitGroupModel unitGroup,
  );

  Future<Either<ConvertouchException, UnitGroupModel?>> get(int unitGroupId);

  Future<Either<ConvertouchException, void>> remove(List<int> unitGroupIds);

  Future<Either<ConvertouchException, UnitGroupModel>> update(
    UnitGroupModel unitGroup,
  );
}
