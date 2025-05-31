import 'dart:developer';

import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_param_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_default_value_calculation_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/repositories/dynamic_value_repository.dart';
import 'package:convertouch/domain/repositories/list_value_repository.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

class CalculateDefaultValueUseCase<T extends IdNameItemModel>
    extends UseCase<InputDefaultValueCalculationModel<T>, ValueModel?> {
  final DynamicValueRepository dynamicValueRepository;
  final ListValueRepository listValueRepository;

  const CalculateDefaultValueUseCase({
    required this.dynamicValueRepository,
    required this.listValueRepository,
  });

  @override
  Future<Either<ConvertouchException, ValueModel?>> execute(
    InputDefaultValueCalculationModel<T> input,
  ) async {
    try {
      T item = input.item;

      if (item is! UnitModel && item is! ConversionParamModel) {
        return const Right(null);
      }

      ConvertouchListType? resultListType = input.replacingUnit?.listType;

      if (item is UnitModel) {
        resultListType ??= item.listType;
      } else if (item is ConversionParamModel) {
        resultListType ??= input.currentParamUnit?.listType ?? item.listType;
      }

      UnitModel? resultUnit = input.replacingUnit;

      if (item is UnitModel) {
        resultUnit ??= item;
      } else if (item is ConversionParamModel) {
        resultUnit ??= input.currentParamUnit ?? item.defaultUnit;
      }

      return Right(
        await _calculateDefaultValue(
          listType: resultListType,
          unit: resultUnit,
        ),
      );
    } catch (e, stackTrace) {
      log("Error when calculating a source default value: $e");
      return Left(
        InternalException(
          message: "Error when calculating a source default value "
              "for the item ${input.item}",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }

  Future<ValueModel?> _calculateDefaultValue({
    required ConvertouchListType? listType,
    required UnitModel? unit,
  }) async {
    if (listType != null) {
      String? newValue = ObjectUtils.tryGet(
        await listValueRepository.getDefault(
          listType: listType,
          unit: unit,
        ),
      )?.value;

      return ValueModel.any(newValue);
    }

    if (unit != null) {
      var dynamicValue = ObjectUtils.tryGet(
        await dynamicValueRepository.get(unit.id),
      );

      String? srcDefaultValueStr = dynamicValue != null &&
              dynamicValue.value != null &&
              dynamicValue.value!.isNotEmpty
          ? dynamicValue.value
          : unit.valueType.defaultValueStr;

      return ValueModel.any(srcDefaultValueStr);
    }

    return null;
  }
}
