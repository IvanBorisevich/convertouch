import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/repositories/conversion_param_repository.dart';
import 'package:convertouch/domain/repositories/conversion_param_set_repository.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

class CreateInitialParamSetUseCase
    extends UseCase<int, ConversionParamSetValueBulkModel?> {
  final ConversionParamSetRepository conversionParamSetRepository;
  final ConversionParamRepository conversionParamRepository;

  const CreateInitialParamSetUseCase({
    required this.conversionParamSetRepository,
    required this.conversionParamRepository,
  });

  @override
  Future<Either<ConvertouchException, ConversionParamSetValueBulkModel?>>
      execute(int input) async {
    int convGroupId = input;

    try {
      List<ConversionParamSetModel> paramSets =
          await _getParamSets(convGroupId);

      List<ConversionParamSetValueModel> paramSetValues = [];
      bool mandatoryParamSetExist = false;

      for (ConversionParamSetModel paramSet in paramSets) {
        if (paramSet.mandatory) {
          mandatoryParamSetExist = true;
        }

        List<ConversionParamModel> params = ObjectUtils.tryGet(
          await conversionParamRepository.get(paramSet.id),
        );

        List<ConversionParamValueModel> paramValues = params
            .map(
              (p) => ConversionParamValueModel(
                param: p,
                unit: p.defaultUnit,
              ),
            )
            .toList();

        paramSetValues.add(
          ConversionParamSetValueModel(
            paramSet: paramSet,
            paramValues: paramValues,
          ),
        );
      }

      bool otherParamSetsExist = ObjectUtils.tryGet(
        await conversionParamSetRepository.checkIfOthersExist(convGroupId),
      );

      return Right(
        ConversionParamSetValueBulkModel(
          paramSetValues: paramSetValues,
          paramSetsCanBeAdded: otherParamSetsExist,
          paramSetsCanBeRemovedInBulk: mandatoryParamSetExist,
        ),
      );
    } catch (e, stackTrace) {
      return Left(
        InternalException(
          message: "Error when creating an initial param set",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }

  Future<List<ConversionParamSetModel>> _getParamSets(int groupId) async {
    ConversionParamSetModel? mandatoryParamSet = ObjectUtils.tryGet(
      await conversionParamSetRepository.getMandatory(groupId),
    );

    return mandatoryParamSet != null ? [mandatoryParamSet] : [];
  }
}
