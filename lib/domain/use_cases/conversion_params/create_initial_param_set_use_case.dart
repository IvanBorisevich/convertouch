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

    List<ConversionParamSetValueModel> paramSetValues = [];

    try {
      ConversionParamSetModel? mandatoryParamSet = ObjectUtils.tryGet(
        await conversionParamSetRepository.getMandatory(convGroupId),
      );

      if (mandatoryParamSet != null) {
        List<ConversionParamModel> params = ObjectUtils.tryGet(
          await conversionParamRepository.get(mandatoryParamSet.id),
        );

        List<ConversionParamValueModel> paramValues = params
            .map(
              (p) => ConversionParamValueModel(
                param: p,
              ),
            )
            .toList();

        paramSetValues = [
          ConversionParamSetValueModel(
            paramSet: mandatoryParamSet,
            paramValues: paramValues,
          ),
        ];
      }

      bool otherExist = ObjectUtils.tryGet(
        await conversionParamSetRepository.checkIfOthersExist(convGroupId),
      );

      return Right(
        ConversionParamSetValueBulkModel(
          paramSetValues: paramSetValues,
          paramSetsCanBeAdded: otherExist,
          paramSetsCanBeRemovedInBulk: mandatoryParamSet == null,
        ),
      );
    } catch (e, stackTrace) {
      return Left(
        InternalException(
          message: "Error when creating a conversion param set",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }
}
