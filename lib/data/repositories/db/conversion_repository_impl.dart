import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/repositories/conversion_repository.dart';
import 'package:convertouch/domain/repositories/unit_group_repository.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

class ConversionRepositoryImpl extends ConversionRepository {
  final UnitGroupRepository unitGroupRepository;

  const ConversionRepositoryImpl({
    required this.unitGroupRepository,
  });

  @override
  Future<Either<ConvertouchException, ConversionModel>> get(
    int unitGroupId,
  ) async {
    try {
      UnitGroupModel? unitGroup = ObjectUtils.tryGet(
        await unitGroupRepository.get(unitGroupId),
      );
      return Right(
        ConversionModel.noItems(unitGroup ?? UnitGroupModel.none),
      );
    } catch (e, stackTrace) {
      return Left(
        DatabaseException(
          message: "Error when getting a conversion",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }

  @override
  Future<Either<ConvertouchException, void>> remove(
    List<int> unitGroupIds,
  ) async {
    return const Right(null);
  }

  @override
  Future<Either<ConvertouchException, ConversionModel>> upsert(
    ConversionModel conversion,
  ) async {
    return Right(conversion);
  }
}
