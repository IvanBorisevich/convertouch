import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_default_value_calculation_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_item_unit_replace_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/repositories/list_value_repository.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

abstract class ReplaceItemUnitUseCase<T extends ConversionItemValueModel,
        V extends IdNameItemModel>
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
      ConvertouchListType? newListType =
          input.newUnit.listType ?? input.item.listType;

      ValueModel? newValue = await _validateValue(
        input: input,
        newListType: newListType,
      );
      ValueModel? newDefaultValue = await _calculateDefaultValue(
        input: input,
        newListType: newListType,
      );

      return Right(
        _buildNewItem(
          item: input.item,
          newUnit: input.newUnit,
          newListType: newListType,
          newValue: newValue,
          newDefaultValue: newDefaultValue,
        ),
      );
    } catch (e, stackTrace) {
      return Left(
        ConvertouchException(
          message: "Error when replacing the item unit; $e",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }

  Future<ValueModel?> _validateValue({
    required InputItemUnitReplaceModel<T> input,
    required ConvertouchListType? newListType,
  }) async {
    if (newListType != null) {
      bool belongsToList = ObjectUtils.tryGet(
        await listValueRepository.belongsToList(
          value: input.item.value?.raw,
          listType: newListType,
          unit: input.newUnit,
        ),
      );

      return belongsToList ? input.item.value : null;
    } else {
      return input.item.value;
    }
  }

  Future<ValueModel?> _calculateDefaultValue({
    required InputItemUnitReplaceModel<T> input,
    required ConvertouchListType? newListType,
  }) async {
    ValueModel? defaultValue;
    if (input.item.defaultValue != null && newListType == null) {
      defaultValue = input.item.defaultValue;
    }

    if (defaultValue != null) {
      return defaultValue;
    }

    return ObjectUtils.tryGet(
      await calculateDefaultValueUseCase.execute(
        getDefaultValueInputModel(input),
      ),
    );
  }

  InputDefaultValueCalculationModel<V> getDefaultValueInputModel(
    InputItemUnitReplaceModel<T> input,
  );

  T _buildNewItem({
    required T item,
    required UnitModel newUnit,
    required ConvertouchListType? newListType,
    required ValueModel? newValue,
    required ValueModel? newDefaultValue,
  });
}

class ReplaceUnitInConversionItemUseCase
    extends ReplaceItemUnitUseCase<ConversionUnitValueModel, UnitModel> {
  const ReplaceUnitInConversionItemUseCase({
    required super.listValueRepository,
    required super.calculateDefaultValueUseCase,
  });

  @override
  ConversionUnitValueModel _buildNewItem({
    required ConversionUnitValueModel item,
    required UnitModel newUnit,
    required ConvertouchListType? newListType,
    required ValueModel? newValue,
    required ValueModel? newDefaultValue,
  }) {
    return ConversionUnitValueModel(
      unit: newUnit,
      value: newValue ?? (newListType != null ? newDefaultValue : null),
      defaultValue: newListType != null ? null : newDefaultValue,
    );
  }

  @override
  InputDefaultValueCalculationModel<UnitModel> getDefaultValueInputModel(
    InputItemUnitReplaceModel<ConversionUnitValueModel> input,
  ) {
    return InputDefaultValueCalculationModel(
      item: input.item.unit,
      replacingUnit: input.newUnit,
    );
  }
}

class ReplaceUnitInParamUseCase extends ReplaceItemUnitUseCase<
    ConversionParamValueModel, ConversionParamModel> {
  const ReplaceUnitInParamUseCase({
    required super.listValueRepository,
    required super.calculateDefaultValueUseCase,
  });

  @override
  ConversionParamValueModel _buildNewItem({
    required ConversionParamValueModel item,
    required UnitModel newUnit,
    required ConvertouchListType? newListType,
    required ValueModel? newValue,
    required ValueModel? newDefaultValue,
  }) {
    return ConversionParamValueModel(
      param: item.param,
      unit: newUnit,
      value: newValue ?? (newListType != null ? newDefaultValue : null),
      defaultValue: newListType != null ? null : newDefaultValue,
      calculated: item.calculated,
    );
  }

  @override
  InputDefaultValueCalculationModel<ConversionParamModel>
      getDefaultValueInputModel(
    InputItemUnitReplaceModel<ConversionParamValueModel> input,
  ) {
    return InputDefaultValueCalculationModel(
      item: input.item.param,
      currentParamUnit: input.item.unit,
      replacingUnit: input.newUnit,
    );
  }
}
