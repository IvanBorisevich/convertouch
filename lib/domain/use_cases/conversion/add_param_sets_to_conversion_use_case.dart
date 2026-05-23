import 'package:collection/collection.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_default_value_calculation_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_param_list_values_init_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/repositories/conversion_param_repository.dart';
import 'package:convertouch/domain/repositories/conversion_param_set_repository.dart';
import 'package:convertouch/domain/use_cases/common/init_item_list_values_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/utils/conversion_rule_utils.dart' as rules;
import 'package:convertouch/domain/utils/object_utils.dart';

class AddParamSetsToConversionUseCase
    extends AbstractModifyConversionUseCase<AddParamSetsDelta> {
  final ConversionParamSetRepository conversionParamSetRepository;
  final ConversionParamRepository conversionParamRepository;
  final CalculateDefaultValueUseCase calculateDefaultValueUseCase;
  final InitParamListValuesUseCase initParamListValuesUseCase;

  const AddParamSetsToConversionUseCase({
    required this.conversionParamSetRepository,
    required this.conversionParamRepository,
    required this.calculateDefaultValueUseCase,
    required this.initParamListValuesUseCase,
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
      if (oldConversionParams != null) {
        return await _alignParams(oldConversionParams);
      } else if (paramSetsTotalCount == 0) {
        return null;
      } else {
        return ConversionParamSetValueBulkModel.basic(
          totalCount: paramSetsTotalCount,
        );
      }
    }

    List<ConversionParamSetValueModel> newParamSetValues = [];

    for (ConversionParamSetModel paramSet in newParamSets) {
      var paramSetValue = await _initParamSetValue(paramSet);
      newParamSetValues.add(paramSetValue);
    }

    List<ConversionParamSetValueModel> mergedParamSetValues = [
      ...(oldConversionParams?.paramSetValues ?? []),
      ...newParamSetValues,
    ];

    List<ConversionParamSetValueModel> resultParamSetValues = [];

    for (int i = 0; i < mergedParamSetValues.length; i++) {
      var resultParamSetValue =
          await mergedParamSetValues[i].copyWithChangedParams(
        map: (paramValue, paramSetValue) async {
          var newParamValue = srcUnitValue != null
              ? rules.calculateParamValueBySrcValue(
                  srcUnitValue: srcUnitValue,
                  unitGroup: unitGroup,
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

      resultParamSetValues.add(resultParamSetValue);
    }

    return ConversionParamSetValueBulkModel.basic(
      paramSetValues: resultParamSetValues,
      selectedIndex: resultParamSetValues.length - 1,
      totalCount: paramSetsTotalCount,
    );
  }

  Future<ConversionParamSetValueModel> _initParamSetValue(
    ConversionParamSetModel paramSet,
  ) async {
    List<ConversionParamModel> params = ObjectUtils.tryGet(
      await conversionParamRepository.getBySetId(paramSet.id),
    );

    List<ConversionParamValueModel> paramValues = [];

    ConversionParamSetValueModel paramSetValue = ConversionParamSetValueModel(
      paramSet: paramSet,
      paramValues: paramValues,
    );

    for (ConversionParamModel param in params) {
      var paramValue = await _initParamValue(
        param,
        paramSetValue: paramSetValue,
      );

      paramValues.add(paramValue);
    }

    return paramSetValue;
  }

  Future<ConversionParamValueModel> _initParamValue(
    ConversionParamModel param, {
    ConversionParamSetValueModel? paramSetValue,
  }) async {
    ConversionParamValueModel paramValue;

    if (param.listType != null || param.defaultUnit?.listType != null) {
      paramValue = ObjectUtils.tryGet(
        await initParamListValuesUseCase.execute(
          InputParamListValuesInitModel(
            paramValue: ConversionParamValueModel(
              param: param,
              unit: param.defaultUnit,
            ),
            paramSetValue: paramSetValue,
          ),
        ),
      );
    } else {
      ValueModel? defaultValue = ObjectUtils.tryGet(
        await calculateDefaultValueUseCase.execute(
          InputDefaultValueCalculationModel(item: param),
        ),
      );

      paramValue = ConversionParamValueModel(
        param: param,
        unit: param.defaultUnit,
        defaultValue: defaultValue,
      );
    }

    return paramValue;
  }

  Future<ConversionParamSetValueBulkModel> _alignParams(
    ConversionParamSetValueBulkModel oldConversionParams,
  ) async {
    return await oldConversionParams.copyWithChangedParams(
      paramFilter: (p) => true,
      changeFirstMatchedParamOnly: false,
      map: (paramValue, paramSetValue) async {
        final param = ObjectUtils.tryGet(
          await conversionParamRepository.get(paramValue.param.id),
        );

        if (param == null) {
          return paramValue;
        }

        return paramValue.copyWith(
          param: param,
          calculated: param.calculable && paramValue.calculated,
        );
      },
    );
  }
}
