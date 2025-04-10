import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_param_set_model.dart';
import 'package:convertouch/domain/repositories/conversion_param_repository.dart';
import 'package:convertouch/domain/repositories/conversion_param_set_repository.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

class CreateConversionParamSetUseCase extends UseCase<
    InputParamSetValuesCreateModel, ConversionParamSetValueModel?> {
  final ConversionParamSetRepository conversionParamSetRepository;
  final ConversionParamRepository conversionParamRepository;

  const CreateConversionParamSetUseCase({
    required this.conversionParamSetRepository,
    required this.conversionParamRepository,
  });

  @override
  Future<Either<ConvertouchException, ConversionParamSetValueModel?>> execute(
    InputParamSetValuesCreateModel input,
  ) async {
    try {
      ConversionParamSetModel? paramSet = input.paramSet ??
          ObjectUtils.tryGet(
            await conversionParamSetRepository.getFirstMandatory(input.groupId),
          );

      if (paramSet == null) {
        return const Right(null);
      }

      List<ConversionParamModel> params = ObjectUtils.tryGet(
        await conversionParamRepository.get(paramSet.id),
      );

      List<ConversionParamValueModel> paramValues = params
          .map(
            (p) => ConversionParamValueModel(
              param: p,
            ),
          )
          .toList();

      var paramSetValues = ConversionParamSetValueModel(
        paramSet: paramSet,
        paramValues: paramValues,
      );

      return Right(paramSetValues);
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
