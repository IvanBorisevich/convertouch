import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/refreshable_value_model.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/repositories/refreshable_value_repository.dart';
import 'package:convertouch/domain/repositories/refreshing_job_repository.dart';
import 'package:convertouch/domain/repositories/unit_group_repository.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

class PrepareSourceConversionItemUseCase
    extends UseCase<UnitModel, ConversionItemModel> {
  final UnitGroupRepository unitGroupRepository;
  final RefreshingJobRepository refreshingJobRepository;
  final RefreshableValueRepository refreshableValueRepository;

  const PrepareSourceConversionItemUseCase({
    required this.unitGroupRepository,
    required this.refreshingJobRepository,
    required this.refreshableValueRepository,
  });

  @override
  Future<Either<Failure, ConversionItemModel>> execute(UnitModel input) async {
    UnitModel sourceUnit = input;

    try {
      UnitGroupModel? unitGroup = ObjectUtils.tryGet(
        await unitGroupRepository.get(sourceUnit.unitGroupId),
      );

      return Right(
        ConversionItemModel(
          unit: sourceUnit,
          value: emptyValueModel,
          defaultValue: await _prepareSourceDefaultValue(
            unitGroup!,
            sourceUnit.id!,
          ),
        ),
      );
    } catch (e) {
      return Left(
        InternalFailure(
          "Error when preparing source conversion item "
          "for unit with id = ${sourceUnit.id}",
        ),
      );
    }
  }

  Future<ValueModel> _prepareSourceDefaultValue(
    UnitGroupModel unitGroup,
    int sourceUnitId,
  ) async {
    if (!unitGroup.refreshable) {
      return defaultValueModel;
    }

    RefreshingJobModel? job = ObjectUtils.tryGet(
        await refreshingJobRepository.getByGroupId(unitGroup.id!));

    if (job == null) {
      return emptyValueModel;
    }

    RefreshableDataPart refreshableDataPart = job.refreshableDataPart;

    if (refreshableDataPart != RefreshableDataPart.value) {
      return defaultValueModel;
    }

    RefreshableValueModel? refreshableValue = ObjectUtils.tryGet(
      await refreshableValueRepository.get(sourceUnitId),
    );

    return refreshableValue != null && refreshableValue.value != null
        ? ValueModel(strValue: refreshableValue.value!)
        : emptyValueModel;
  }
}
