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
    required super.createConversionUseCase,
    required this.conversionParamSetRepository,
    required this.conversionParamRepository,
  });

  @override
  Future<ConversionParamSetValueBulkModel?> modifyConversionParamValues({
    required ConversionParamSetValueBulkModel? currentParams,
    required UnitGroupModel unitGroup,
    required ConversionUnitValueModel? currentSourceItem,
    required AddParamSetsDelta delta,
  }) async {
    List<ConversionParamSetModel> paramSets = [];

    if (delta.initial) {
      var mandatoryParamSet = ObjectUtils.tryGet(
        await conversionParamSetRepository.getMandatory(unitGroup.id),
      );

      paramSets = mandatoryParamSet != null ? [mandatoryParamSet] : [];
    } else {
      paramSets = ObjectUtils.tryGet(
        await conversionParamSetRepository.getByIds(ids: delta.paramSetIds),
      );
    }

    bool optionalParamSetsExist = ObjectUtils.tryGet(
      await conversionParamSetRepository.hasOptionalParamSets(unitGroup.id),
    );

    if (paramSets.isEmpty && !optionalParamSetsExist) {
      return null;
    }

    List<ConversionParamSetValueModel> paramSetValues = [];

    for (ConversionParamSetModel paramSet in paramSets) {
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

    ConversionParamSetValueBulkModel result =
        currentParams ?? const ConversionParamSetValueBulkModel();

    var resultParamSetValues = [
      ...result.paramSetValues,
      ...paramSetValues,
    ];

    return result.copyWith(
      paramSetValues: resultParamSetValues,
      paramSetsCanBeAdded: optionalParamSetsExist,
      selectedParamSetCanBeRemoved:
          !resultParamSetValues[result.selectedIndex].paramSet.mandatory,
      paramSetsCanBeRemovedInBulk: !(resultParamSetValues.length == 1 &&
          resultParamSetValues.first.paramSet.mandatory),
    );
  }
}
