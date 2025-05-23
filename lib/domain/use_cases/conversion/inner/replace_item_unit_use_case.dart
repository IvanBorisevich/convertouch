import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_item_unit_replace_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/repositories/list_value_repository.dart';
import 'package:convertouch/domain/use_cases/conversion/inner/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

abstract class ReplaceItemUnitUseCase<T extends ConversionItemValueModel>
    extends UseCase<InputItemUnitReplaceModel<T>, T> {
  final ListValueRepository listValueRepository;
  final CalculateDefaultValueUseCase calculateDefaultValueUseCase;

  const ReplaceItemUnitUseCase({
    required this.listValueRepository,
    required this.calculateDefaultValueUseCase,
  });

  @override
  Future<Either<ConvertouchException, T>> execute(
    InputItemUnitReplaceModel<T> input,
  ) async {
    try {
      ValueModel? newValue = await _validateValue(input);
      ValueModel? newDefaultValue = await _calculateDefaultValue(input);

      return Right(
        _buildNewItem(
          item: input.item,
          newUnit: input.newUnit,
          newValue: newValue,
          newDefaultValue: newDefaultValue,
        ),
      );
    } catch (e, stackTrace) {
      return Left(ConvertouchException(
        message: "Error when replacing the item unit; $e",
        stackTrace: stackTrace,
        dateTime: DateTime.now(),
      ));
    }
  }

  Future<ValueModel?> _validateValue(InputItemUnitReplaceModel<T> input) async {
    if (input.newUnit.listType != null) {
      bool belongsToList = ObjectUtils.tryGet(
        await listValueRepository.belongsToList(
          value: input.item.value?.raw,
          listType: input.newUnit.listType!,
          coefficient: input.newUnit.coefficient,
        ),
      );

      return belongsToList ? input.item.value : null;
    } else {
      return input.item.value;
    }
  }

  Future<ValueModel?> _calculateDefaultValue(
    InputItemUnitReplaceModel<T> input,
  ) async {
    ValueModel? defaultValue;
    if (input.item.defaultValue != null && input.newUnit.listType == null) {
      defaultValue = input.item.defaultValue;
    }

    return defaultValue ??
        ObjectUtils.tryGet(
          await calculateDefaultValueUseCase.execute(input.newUnit),
        );
  }

  T _buildNewItem({
    required T item,
    required UnitModel newUnit,
    required ValueModel? newValue,
    required ValueModel? newDefaultValue,
  });
}

class ReplaceUnitInConversionItemUseCase
    extends ReplaceItemUnitUseCase<ConversionUnitValueModel> {
  const ReplaceUnitInConversionItemUseCase({
    required super.listValueRepository,
    required super.calculateDefaultValueUseCase,
  });

  @override
  ConversionUnitValueModel _buildNewItem({
    required ConversionUnitValueModel item,
    required UnitModel newUnit,
    required ValueModel? newValue,
    required ValueModel? newDefaultValue,
  }) {
    return ConversionUnitValueModel(
      unit: newUnit,
      value: newValue ?? (newUnit.listType != null ? newDefaultValue : null),
      defaultValue: newUnit.listType != null ? null : newDefaultValue,
    );
  }
}

class ReplaceUnitInParamUseCase
    extends ReplaceItemUnitUseCase<ConversionParamValueModel> {
  const ReplaceUnitInParamUseCase({
    required super.listValueRepository,
    required super.calculateDefaultValueUseCase,
  });

  @override
  ConversionParamValueModel _buildNewItem({
    required ConversionParamValueModel item,
    required UnitModel newUnit,
    required ValueModel? newValue,
    required ValueModel? newDefaultValue,
  }) {
    return ConversionParamValueModel(
      param: item.param,
      unit: newUnit,
      value: newValue ?? (newUnit.listType != null ? newDefaultValue : null),
      defaultValue: newDefaultValue,
      calculated: item.calculated,
    );
  }
}
