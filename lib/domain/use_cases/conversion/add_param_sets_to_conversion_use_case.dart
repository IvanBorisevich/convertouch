import 'package:collection/collection.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/repositories/conversion_param_repository.dart';
import 'package:convertouch/domain/repositories/conversion_param_set_repository.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/inner/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/utils/conversion_rule_utils.dart' as rules;
import 'package:convertouch/domain/utils/object_utils.dart';

class AddParamSetsToConversionUseCase
    extends AbstractModifyConversionUseCase<AddParamSetsDelta> {
  final ConversionParamSetRepository conversionParamSetRepository;
  final ConversionParamRepository conversionParamRepository;
  final CalculateDefaultValueUseCase calculateDefaultValueUseCase;

  const AddParamSetsToConversionUseCase({
    required this.conversionParamSetRepository,
    required this.conversionParamRepository,
    required this.calculateDefaultValueUseCase,
  });

  @override
  Future<ConversionParamSetValueBulkModel?> newConversionParams({
    required ConversionParamSetValueBulkModel? oldConversionParams,
    required UnitGroupModel unitGroup,
    required ConversionUnitValueModel? srcUnitValue,
    required AddParamSetsDelta delta,
  }) async {
    List<ConversionParamSetModel> newParamSets = [];
    int paramSetsTotalCount;
    bool mandatoryParamSetExists;

    if (oldConversionParams == null) {
      paramSetsTotalCount = ObjectUtils.tryGet(
        await conversionParamSetRepository.getCount(unitGroup.id),
      );

      if (paramSetsTotalCount == 0) {
        return null;
      }

      var mandatoryParamSet = ObjectUtils.tryGet(
        await conversionParamSetRepository.getMandatory(unitGroup.id),
      );

      mandatoryParamSetExists = mandatoryParamSet != null;
      newParamSets = mandatoryParamSetExists ? [mandatoryParamSet] : [];
    } else {
      paramSetsTotalCount = oldConversionParams.totalCount;
      mandatoryParamSetExists = oldConversionParams.mandatoryParamSetExists;
    }

    if (delta.paramSetIds.isNotEmpty) {
      List<int> currentParamSetIds = oldConversionParams?.paramSetValues
              .map((p) => p.paramSet.id)
              .toList() ??
          [];

      List<int> newParamSetIds = delta.paramSetIds
          .whereNot((id) => currentParamSetIds.contains(id))
          .toList();

      newParamSets = ObjectUtils.tryGet(
        await conversionParamSetRepository.getByIds(ids: newParamSetIds),
      );
    }

    if (newParamSets.isEmpty) {
      return oldConversionParams;
    }

    List<ConversionParamSetValueModel> newParamSetValues = [];

    for (ConversionParamSetModel paramSet in newParamSets) {
      List<ConversionParamModel> params = ObjectUtils.tryGet(
        await conversionParamRepository.get(paramSet.id),
      );

      List<ConversionParamValueModel> paramValues = [];
      for (ConversionParamModel param in params) {
        ValueModel? defaultValue = ObjectUtils.tryGet(
          await calculateDefaultValueUseCase.execute(param),
        );

        ConversionParamValueModel paramValue = ConversionParamValueModel(
          param: param,
          unit: param.defaultUnit,
          value: param.listType != null ? defaultValue : null,
          defaultValue: param.listType != null ? null : defaultValue,
        );

        paramValues.add(paramValue);
      }

      newParamSetValues.add(
        ConversionParamSetValueModel(
          paramSet: paramSet,
          paramValues: paramValues,
        ),
      );
    }

    List<ConversionParamSetValueModel> resultParamSetValues;
    if (oldConversionParams != null) {
      resultParamSetValues = [
        ...oldConversionParams.paramSetValues,
        ...newParamSetValues,
      ];
    } else {
      resultParamSetValues = newParamSetValues;
    }

    int resultSelectedIndex = resultParamSetValues.length - 1;

    resultParamSetValues[resultSelectedIndex] =
        await resultParamSetValues[resultSelectedIndex].copyWithChangedParam(
      map: (paramValue, paramSetValue) async {
        var newParamValue = srcUnitValue != null
            ? rules.calculateParamValueBySrcValue(
                srcUnitValue: srcUnitValue,
                unitGroupName: unitGroup.name,
                params: paramSetValue,
                param: paramValue.param,
              )
            : paramValue;

        return newParamValue.copyWith(
          calculated: true,
        );
      },
      paramFilter: (p) => p.param.calculable,
    );

    return ConversionParamSetValueBulkModel(
      paramSetValues: resultParamSetValues,
      paramSetsCanBeAdded: mandatoryParamSetExists &&
              resultParamSetValues.length < paramSetsTotalCount - 1 ||
          resultParamSetValues.length < paramSetsTotalCount,
      selectedIndex: resultSelectedIndex,
      selectedParamSetCanBeRemoved:
          !resultParamSetValues[resultSelectedIndex].paramSet.mandatory,
      paramSetsCanBeRemovedInBulk: !(resultParamSetValues.length == 1 &&
          resultParamSetValues.first.paramSet.mandatory),
      mandatoryParamSetExists: mandatoryParamSetExists,
      totalCount: paramSetsTotalCount,
    );
  }
}
