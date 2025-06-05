import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:test/test.dart';

import 'mock/mock_param.dart';
import 'mock/mock_unit.dart';

final _clothesSizeParams = ConversionParamSetValueBulkModel(
  paramSetValues: [
    ConversionParamSetValueModel(
      paramSet: clothesSizeParamSet,
      paramValues: [
        ConversionParamValueModel.tuple(personParam, "Man", null),
        ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
        ConversionParamValueModel.tuple(heightParam, 160, 1, unit: centimeter),
      ],
    )
  ],
  selectedIndex: 0,
);

const _paramSetValueWithCalculableParams = ConversionParamSetValueBulkModel(
  paramSetValues: [
    ConversionParamSetValueModel(
      paramSet: barbellWeightParamSet,
      paramValues: [
        ConversionParamValueModel(
          param: barWeightParam,
        ),
        ConversionParamValueModel(
          param: oneSideWeightParam,
          calculated: true,
        ),
        ConversionParamValueModel(
          param: someCalculableParam,
        ),
      ],
    ),
  ],
  selectedIndex: 0,
);

void main() {
  test('Copy with changed list param value', () async {
    expect(
      await _clothesSizeParams.copyWithChangedParams(
        map: (paramValue, paramSetValue) async => paramValue.copyWith(
          value: ValueModel.str("Woman"),
        ),
        paramSetFilter: (paramSetValue) =>
            paramSetValue.paramSet.id == clothesSizeParamSet.id,
        paramFilter: (paramValue) => paramValue.param.id == personParam.id,
      ),
      ConversionParamSetValueBulkModel(
        paramSetValues: [
          ConversionParamSetValueModel(
            paramSet: clothesSizeParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(personParam, "Woman", null),
              ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
              ConversionParamValueModel.tuple(heightParam, 160, 1,
                  unit: centimeter),
            ],
          )
        ],
        selectedIndex: 0,
      ),
    );
  });

  test('Copy with changed list param value (in active param set)', () async {
    expect(
      await _clothesSizeParams.copyWithChangedParams(
        map: (paramValue, paramSetValue) async => paramValue.copyWith(
          value: ValueModel.str("Woman"),
        ),
        paramFilter: (paramValue) => paramValue.param.id == personParam.id,
      ),
      ConversionParamSetValueBulkModel(
        paramSetValues: [
          ConversionParamSetValueModel(
            paramSet: clothesSizeParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(personParam, "Woman", null),
              ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
              ConversionParamValueModel.tuple(heightParam, 160, 1,
                  unit: centimeter),
            ],
          )
        ],
        selectedIndex: 0,
      ),
    );
  });

  test('Copy with changed non-list param value', () async {
    expect(
      await _clothesSizeParams.copyWithChangedParamById(
        map: (paramValue, paramSetValue) async => paramValue.copyWith(
          value: ValueModel.numeric(150),
          defaultValue: ValueModel.numeric(2),
        ),
        paramSetId: clothesSizeParamSet.id,
        paramId: heightParam.id,
      ),
      ConversionParamSetValueBulkModel(
        paramSetValues: [
          ConversionParamSetValueModel(
            paramSet: clothesSizeParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(personParam, "Man", null),
              ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
              ConversionParamValueModel.tuple(heightParam, 150, 2,
                  unit: centimeter),
            ],
          )
        ],
        selectedIndex: 0,
      ),
    );
  });

  test('Copy with changed unknown param', () async {
    expect(
      await _clothesSizeParams.copyWithChangedParamById(
        map: (paramValue, paramSetValue) async => paramValue.copyWith(
          value: ValueModel.numeric(150),
          defaultValue: ValueModel.numeric(2),
        ),
        paramSetId: clothesSizeParamSet.id,
        paramId: -1,
      ),
      _clothesSizeParams,
    );
  });

  test('Copy with changed non-list param unit', () async {
    expect(
      await _clothesSizeParams.copyWithChangedParamById(
        map: (paramValue, paramSetValue) async => paramValue.copyWith(
          unit: meter,
        ),
        paramSetId: clothesSizeParamSet.id,
        paramId: heightParam.id,
      ),
      ConversionParamSetValueBulkModel(
        paramSetValues: [
          ConversionParamSetValueModel(
            paramSet: clothesSizeParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(personParam, "Man", null),
              ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
              ConversionParamValueModel.tuple(heightParam, 160, 1, unit: meter),
            ],
          )
        ],
        selectedIndex: 0,
      ),
    );
  });

  group('Copy with changed calculated param', () {
    test('Switch on another calculable param', () async {
      expect(
        await _paramSetValueWithCalculableParams.copyWithChangedParamSetByIds(
          map: (paramSetValue) async =>
              paramSetValue.copyWithNewCalculatedParam(
            newCalculatedParamId: someCalculableParam.id,
          ),
          paramSetId: barbellWeightParamSet.id,
        ),
        const ConversionParamSetValueBulkModel(
          paramSetValues: [
            ConversionParamSetValueModel(
              paramSet: barbellWeightParamSet,
              paramValues: [
                ConversionParamValueModel(
                  param: barWeightParam,
                ),
                ConversionParamValueModel(
                  param: oneSideWeightParam,
                ),
                ConversionParamValueModel(
                  param: someCalculableParam,
                  calculated: true,
                ),
              ],
            ),
          ],
          selectedIndex: 0,
        ),
      );
    });

    test('Switch off the calculable param', () async {
      expect(
        await _paramSetValueWithCalculableParams.copyWithChangedParamSetByIds(
          map: (paramSetValue) async =>
              paramSetValue.copyWithNewCalculatedParam(
            newCalculatedParamId: oneSideWeightParam.id,
          ),
          paramSetId: barbellWeightParamSet.id,
        ),
        const ConversionParamSetValueBulkModel(
          paramSetValues: [
            ConversionParamSetValueModel(
              paramSet: barbellWeightParamSet,
              paramValues: [
                ConversionParamValueModel(
                  param: barWeightParam,
                ),
                ConversionParamValueModel(
                  param: oneSideWeightParam,
                ),
                ConversionParamValueModel(
                  param: someCalculableParam,
                ),
              ],
            ),
          ],
          selectedIndex: 0,
        ),
      );
    });
  });
}
