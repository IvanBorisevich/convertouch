import 'package:collection/collection.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/repositories/conversion_param_repository.dart';
import 'package:convertouch/domain/repositories/conversion_param_set_repository.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';

class AddParamSetsToConversionUseCase
    extends AbstractModifyConversionUseCase<AddParamSetsDelta> {
  final ConversionParamSetRepository conversionParamSetRepository;
  final ConversionParamRepository conversionParamRepository;

  const AddParamSetsToConversionUseCase({
    required super.convertUnitValuesUseCase,
    required this.conversionParamSetRepository,
    required this.conversionParamRepository,
  });

  @override
  Future<ConversionParamSetValueBulkModel?> newConversionParams({
    required ConversionParamSetValueBulkModel? oldConversionParams,
    required UnitGroupModel unitGroup,
    required ConversionUnitValueModel? srcUnitValue,
    required AddParamSetsDelta delta,
  }) async {
    List<ConversionParamSetModel> paramSetsInConversion = [];

    int paramSetsTotalCount = oldConversionParams?.totalCount ?? 0;
    bool mandatoryParamSetExists =
        oldConversionParams?.mandatoryParamSetExists ?? false;

    if (delta.initial) {
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

      paramSetsInConversion =
          mandatoryParamSetExists ? [mandatoryParamSet] : [];
    } else {
      List<int> currentParamSetIds =
          oldConversionParams?.paramSetValues.map((p) => p.paramSet.id).toList() ??
              [];

      List<int> newParamSetIds = delta.paramSetIds
          .whereNot((id) => currentParamSetIds.contains(id))
          .toList();

      paramSetsInConversion = ObjectUtils.tryGet(
        await conversionParamSetRepository.getByIds(ids: newParamSetIds),
      );
    }

    List<ConversionParamSetValueModel> paramSetValues = [];

    for (ConversionParamSetModel paramSet in paramSetsInConversion) {
      List<ConversionParamModel> params = ObjectUtils.tryGet(
        await conversionParamRepository.get(paramSet.id),
      );

      List<ConversionParamValueModel> paramValues = params
          .map(
            (p) => ConversionParamValueModel(
              param: p,
              unit: p.defaultUnit,
            ),
          )
          .toList();

      paramSetValues.add(
        ConversionParamSetValueModel(
          paramSet: paramSet,
          paramValues: paramValues,
        ),
      );
    }

    List<ConversionParamSetValueModel> resultParamSetValues;
    int resultSelectedIndex;

    if (oldConversionParams != null) {
      resultParamSetValues = [
        ...oldConversionParams.paramSetValues,
        ...paramSetValues,
      ];
      resultSelectedIndex = oldConversionParams.selectedIndex;
    } else {
      resultParamSetValues = paramSetValues;
      resultSelectedIndex = 0;
    }

    return ConversionParamSetValueBulkModel(
      paramSetValues: resultParamSetValues,
      paramSetsCanBeAdded: mandatoryParamSetExists &&
          resultParamSetValues.length < paramSetsTotalCount - 1 ||
          resultParamSetValues.length < paramSetsTotalCount,
      selectedParamSetCanBeRemoved:
      !resultParamSetValues[resultSelectedIndex].paramSet.mandatory,
      paramSetsCanBeRemovedInBulk: !(resultParamSetValues.length == 1 &&
          resultParamSetValues.first.paramSet.mandatory),
      mandatoryParamSetExists: mandatoryParamSetExists,
      totalCount: paramSetsTotalCount,
    );
  }
}
