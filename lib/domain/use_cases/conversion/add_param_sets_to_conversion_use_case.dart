import 'package:collection/collection.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_param_set_value_calculation_model.dart';
import 'package:convertouch/domain/repositories/conversion_param_repository.dart';
import 'package:convertouch/domain/repositories/conversion_param_set_repository.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_param_set_value_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';

class AddParamSetsToConversionUseCase
    extends AbstractModifyConversionUseCase<AddParamSetsDelta> {
  final ConversionParamSetRepository conversionParamSetRepository;
  final ConversionParamRepository conversionParamRepository;
  final CalculateParamSetValueUseCase calculateParamSetValueUseCase;

  const AddParamSetsToConversionUseCase({
    required this.conversionParamSetRepository,
    required this.conversionParamRepository,
    required this.calculateParamSetValueUseCase,
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
        return oldConversionParams;
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
      var paramSetValue = await _initParamSetValue(
        paramSet: paramSet,
        srcUnitValue: srcUnitValue,
        unitGroupName: unitGroup.name,
      );

      newParamSetValues.add(paramSetValue);
    }

    List<ConversionParamSetValueModel> mergedParamSetValues = [
      ...(newParamSetValues.where((p) => p.paramSet.mandatory).toList()),
      ...(oldConversionParams?.paramSetValues ?? []),
      ...(newParamSetValues.whereNot((p) => p.paramSet.mandatory).toList()),
    ];

    return ConversionParamSetValueBulkModel.basic(
      paramSetValues: mergedParamSetValues,
      selectedIndex:
          mandatoryParamSetExists ? 0 : mergedParamSetValues.length - 1,
      totalCount: paramSetsTotalCount,
    );
  }

  Future<ConversionParamSetValueModel> _initParamSetValue({
    required ConversionParamSetModel paramSet,
    ConversionUnitValueModel? srcUnitValue,
    required String unitGroupName,
  }) async {
    List<ConversionParamModel> params = ObjectUtils.tryGet(
      await conversionParamRepository.getBySetId(paramSet.id),
    );

    List<ConversionParamValueModel> paramValues = params
        .map(
          (param) => ConversionParamValueModel(
            param: param,
            unit: param.defaultUnit,
          ),
        )
        .toList();

    return ObjectUtils.tryGet(
      await calculateParamSetValueUseCase.execute(
        InputParamSetValueCalculationModel(
          paramSetValue: ConversionParamSetValueModel(
            paramSet: paramSet,
            paramValues: paramValues,
          ),
          srcUnitValue: srcUnitValue,
          unitGroupName: unitGroupName,
          alignCurrentValues: true,
          enableFirstCalculableParamIfNoCalculatedEnabled: true,
        ),
      ),
    );
  }
}
