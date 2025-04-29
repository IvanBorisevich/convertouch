import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/conversion_param_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_states.dart';
import 'package:test/test.dart';

void main() {
  const ConversionBuilt state1 = ConversionBuilt(
    conversion: ConversionModel(
      id: -1,
      unitGroup: UnitGroupModel(
        id: 10,
        name: "Clothing Size",
        iconName: "clothing-size-group.png",
        conversionType: ConversionType.formula,
        refreshable: false,
        valueType: ConvertouchValueType.integerPositive,
        oob: true,
      ),
      params: ConversionParamSetValueBulkModel(
        paramSetValues: [
          ConversionParamSetValueModel(
            paramSet: ConversionParamSetModel(
              id: 1,
              name: "By Height",
              mandatory: true,
              groupId: 10,
            ),
            paramValues: [
              ConversionParamValueModel(
                param: ConversionParamModel(
                  id: 1,
                  name: "Gender",
                  calculable: false,
                  valueType: ConvertouchValueType.text,
                  listType: ConvertouchListType.gender,
                  paramSetId: 1,
                ),
                calculated: false,
              ),
              ConversionParamValueModel(
                param: ConversionParamModel(
                  id: 2,
                  name: "Garment",
                  calculable: false,
                  valueType: ConvertouchValueType.text,
                  listType: ConvertouchListType.garment,
                  paramSetId: 1,
                ),
                calculated: false,
              ),
              ConversionParamValueModel(
                param: ConversionParamModel(
                  id: 3,
                  name: "Height",
                  unitGroupId: 1,
                  calculable: false,
                  valueType: ConvertouchValueType.decimalPositive,
                  defaultUnit: UnitModel(
                    id: 1,
                    name: "Centimeter",
                    code: "cm",
                    coefficient: 0.01,
                    unitGroupId: 1,
                    valueType: ConvertouchValueType.decimalPositive,
                    minValue: ValueModel.zero,
                    invertible: true,
                    oob: true,
                  ),
                  paramSetId: 1,
                ),
                unit: UnitModel(
                  id: 1,
                  name: "Centimeter",
                  code: "cm",
                  coefficient: 0.01,
                  unitGroupId: 1,
                  valueType: ConvertouchValueType.decimalPositive,
                  minValue: ValueModel.zero,
                  invertible: true,
                  oob: true,
                ),
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
        name: "Clothing Size",
        iconName: "clothing-size-group.png",
        conversionType: ConversionType.formula,
        refreshable: false,
        valueType: ConvertouchValueType.integerPositive,
        oob: true,
      ),
      params: ConversionParamSetValueBulkModel(
        paramSetValues: [
          ConversionParamSetValueModel(
            paramSet: const ConversionParamSetModel(
              id: 1,
              name: "By Height",
              mandatory: true,
              groupId: 10,
            ),
            paramValues: [
              const ConversionParamValueModel(
                param: ConversionParamModel(
                  id: 1,
                  name: "Gender",
                  calculable: false,
                  valueType: ConvertouchValueType.text,
                  listType: ConvertouchListType.gender,
                  paramSetId: 1,
                ),
                calculated: false,
              ),
              const ConversionParamValueModel(
                param: ConversionParamModel(
                  id: 2,
                  name: "Garment",
                  calculable: false,
                  valueType: ConvertouchValueType.text,
                  listType: ConvertouchListType.garment,
                  paramSetId: 1,
                ),
                calculated: false,
              ),
              ConversionParamValueModel(
                param: const ConversionParamModel(
                  id: 3,
                  name: "Height",
                  unitGroupId: 1,
                  calculable: false,
                  valueType: ConvertouchValueType.decimalPositive,
                  defaultUnit: UnitModel(
                    id: 1,
                    name: "Centimeter",
                    code: "cm",
                    coefficient: 0.01,
                    unitGroupId: 1,
                    valueType: ConvertouchValueType.decimalPositive,
                    minValue: ValueModel.zero,
                    invertible: true,
                    oob: true,
                  ),
                  paramSetId: 1,
                ),
                unit: const UnitModel(
                  id: 1,
                  name: "Centimeter",
                  code: "cm",
                  coefficient: 0.01,
                  unitGroupId: 1,
                  valueType: ConvertouchValueType.decimalPositive,
                  minValue: ValueModel.zero,
                  invertible: true,
                  oob: true,
                ),
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
