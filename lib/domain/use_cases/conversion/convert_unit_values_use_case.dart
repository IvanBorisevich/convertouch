import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_single_value_conversion_model.dart';
import 'package:convertouch/domain/use_cases/conversion/convert_single_value_use_case.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

class ConvertUnitValuesUseCase
    extends UseCase<InputConversionModel, List<ConversionUnitValueModel>> {
  final ConvertSingleValueUseCase convertSingleValueUseCase;

  const ConvertUnitValuesUseCase({
    required this.convertSingleValueUseCase,
  });

  @override
  Future<Either<ConvertouchException, List<ConversionUnitValueModel>>> execute(
    InputConversionModel input,
  ) async {
    try {
      List<ConversionUnitValueModel> convertedUnitValues = [];

      for (var tgtUnit in input.targetUnits) {
        var unitValue = ObjectUtils.tryGet(
          await convertSingleValueUseCase.execute(
            InputSingleValueConversionModel(
              unitGroup: input.unitGroup,
              srcItem: input.sourceUnitValue,
              tgtUnit: tgtUnit,
              params: input.params,
            ),
          ),
        );
        convertedUnitValues.add(unitValue);
      }

      return Right(convertedUnitValues);
    } catch (e, stackTrace) {
      return Left(
        InternalException(
          message: "Error when converting unit values",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }
}
