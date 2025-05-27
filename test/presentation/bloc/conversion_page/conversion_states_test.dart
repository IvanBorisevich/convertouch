import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_states.dart';
import 'package:test/test.dart';

import '../../../domain/model/mock/mock_param.dart';
import '../../../domain/model/mock/mock_unit.dart';

void main() {
  const ConversionBuilt state1 = ConversionBuilt(
    conversion: ConversionModel(
      id: -1,
      unitGroup: UnitGroupModel(
        id: 10,
        name: "Clothes Size",
        iconName: "clothes-size-group.png",
        conversionType: ConversionType.formula,
        refreshable: false,
        valueType: ConvertouchValueType.integerPositive,
        oob: true,
      ),
      params: ConversionParamSetValueBulkModel(
        paramSetValues: [
          ConversionParamSetValueModel(
            paramSet: clothesSizeParamSet,
            paramValues: [
              ConversionParamValueModel(
                param: personParam,
                calculated: false,
              ),
              ConversionParamValueModel(
                param: garmentParam,
                calculated: false,
              ),
              ConversionParamValueModel(
                param: heightParam,
                unit: centimeter,
                calculated: false,
              ),
            ],
          ),
        ],
        selectedIndex: 0,
        paramSetsCanBeAdded: true,
        selectedParamSetCanBeRemoved: false,
        paramSetsCanBeRemovedInBulk: false,
        mandatoryParamSetExists: true,
        totalCount: 2,
      ),
      convertedUnitValues: [],
    ),
    showRefreshButton: false,
  );

  ConversionBuilt state2 = ConversionBuilt(
    conversion: ConversionModel(
      id: -1,
      unitGroup: const UnitGroupModel(
        id: 10,
        name: "Clothes Size",
        iconName: "clothes-size-group.png",
        conversionType: ConversionType.formula,
        refreshable: false,
        valueType: ConvertouchValueType.integerPositive,
        oob: true,
      ),
      params: ConversionParamSetValueBulkModel(
        paramSetValues: [
          ConversionParamSetValueModel(
            paramSet: clothesSizeParamSet,
            paramValues: [
              const ConversionParamValueModel(
                param: personParam,
                calculated: false,
              ),
              const ConversionParamValueModel(
                param: garmentParam,
                calculated: false,
              ),
              ConversionParamValueModel(
                param: heightParam,
                unit: centimeter,
                calculated: false,
                value: ValueModel.str("1"),
                defaultValue: ValueModel.str("1"),
              ),
            ],
          ),
        ],
        selectedIndex: 0,
        paramSetsCanBeAdded: true,
        selectedParamSetCanBeRemoved: false,
        paramSetsCanBeRemovedInBulk: false,
        mandatoryParamSetExists: true,
        totalCount: 2,
      ),
      convertedUnitValues: const [],
    ),
    showRefreshButton: false,
  );

  test('Conversion states are different', () {
    expect(state1 == state2, false);
  });
}
