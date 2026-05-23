import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_default_value_calculation_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_item_unit_replace_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_param_list_values_init_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/use_cases/common/init_item_list_values_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

abstract class ReplaceItemUnitUseCase<T extends ConversionItemValueModel,
        V extends IdNameItemModel>
    extends UseCase<InputItemUnitReplaceModel<T>, T> {
  final CalculateDefaultValueUseCase calculateDefaultValueUseCase;

  const ReplaceItemUnitUseCase({
    required this.calculateDefaultValueUseCase,
  });
}

class ReplaceUnitInConversionItemUseCase
    extends ReplaceItemUnitUseCase<ConversionUnitValueModel, UnitModel> {
  final InitUnitListValuesUseCase initUnitListValuesUseCase;

  const ReplaceUnitInConversionItemUseCase({
    required super.calculateDefaultValueUseCase,
    required this.initUnitListValuesUseCase,
  });

  @override
  Future<Either<ConvertouchException, ConversionUnitValueModel>> execute(
    InputItemUnitReplaceModel<ConversionUnitValueModel> input,
  ) async {
    try {
      if (input.newUnit.listType != null) {
        return await initUnitListValuesUseCase.execute(
          input.item.copyWith(
            unit: input.newUnit,
          ),
        );
      }

      ValueModel? newDefaultValue = input.item.defaultValue ??
          ObjectUtils.tryGet(
            await calculateDefaultValueUseCase.execute(
              InputDefaultValueCalculationModel(
                item: input.item.unit,
                replacingUnit: input.newUnit,
              ),
            ),
          );

      return Right(
        input.item.copyWith(
          unit: input.newUnit,
          defaultValue: newDefaultValue,
        ),
      );
    } catch (e, stackTrace) {
      return Left(
        ConvertouchException(
          message: "Error when replacing the conversion item unit: $e",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }
}

class ReplaceUnitInParamUseCase extends ReplaceItemUnitUseCase<
    ConversionParamValueModel, ConversionParamModel> {
  final InitParamListValuesUseCase initParamListValuesUseCase;

  const ReplaceUnitInParamUseCase({
    required super.calculateDefaultValueUseCase,
    required this.initParamListValuesUseCase,
  });

  @override
  Future<Either<ConvertouchException, ConversionParamValueModel>> execute(
    InputItemUnitReplaceModel<ConversionParamValueModel> input,
  ) async {
    if (input.item.listType != null || input.newUnit.listType != null) {
      return await initParamListValuesUseCase.execute(
        InputParamListValuesInitModel(
          paramValue: input.item.copyWith(
            unit: input.newUnit,
          ),
        ),
      );
    }

    ValueModel? newDefaultValue = input.item.defaultValue ??
        ObjectUtils.tryGet(
          await calculateDefaultValueUseCase.execute(
            InputDefaultValueCalculationModel(
              item: input.item.param,
              currentParamUnit: input.item.unit,
              replacingUnit: input.newUnit,
            ),
          ),
        );

    return Right(
      input.item.copyWith(
        unit: input.newUnit,
        defaultValue: newDefaultValue,
      ),
    );
  }
}
