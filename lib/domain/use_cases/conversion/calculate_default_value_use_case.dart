import 'dart:developer';

import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_param_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/repositories/dynamic_value_repository.dart';
import 'package:convertouch/domain/repositories/list_value_repository.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

class CalculateDefaultValueUseCase<T extends IdNameItemModel>
    extends UseCase<T, ValueModel?> {
  final DynamicValueRepository dynamicValueRepository;
  final ListValueRepository listValueRepository;

  const CalculateDefaultValueUseCase({
    required this.dynamicValueRepository,
    required this.listValueRepository,
  });

  @override
  Future<Either<ConvertouchException, ValueModel?>> execute(
    T input,
  ) async {
    if (input is! UnitModel && input is! ConversionParamModel) {
      return const Right(null);
    }

    try {
      ConvertouchListType? listType;
      UnitModel? unit;

      if (input is UnitModel) {
        listType = input.listType;
        unit = input;
      } else if (input is ConversionParamModel) {
        listType = input.listType;
        unit = input.defaultUnit;
      }

      if (unit == null) {
        return const Right(null);
      }

      return Right(
        await _calculateDefaultValue(
          listType: listType,
          unit: unit,
        ),
      );
    } catch (e, stackTrace) {
      log("Error when calculating a source default value: $e");
      return Left(
        InternalException(
          message: "Error when calculating a source default value "
              "for the unit ${input.name}",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }

  Future<ValueModel?> _calculateDefaultValue({
    required ConvertouchListType? listType,
    required UnitModel unit,
  }) async {
    if (listType != null) {
      String? newValueStr = ObjectUtils.tryGet(
        await listValueRepository.getDefault(
          listType: listType,
        ),
      )?.itemName;

      var newValue = ValueModel.any(newValueStr);
      return unit.coefficient != null && newValue?.numVal != null
          ? ValueModel.any((newValue!.numVal! / unit.coefficient!).round())
          : newValue;
    } else {
      var dynamicValue = ObjectUtils.tryGet(
        await dynamicValueRepository.get(unit.id),
      );

      String? srcDefaultValueStr = dynamicValue != null
          ? dynamicValue.value
          : unit.valueType.defaultValueStr;

      return ValueModel.any(srcDefaultValueStr);
    }
  }
}
