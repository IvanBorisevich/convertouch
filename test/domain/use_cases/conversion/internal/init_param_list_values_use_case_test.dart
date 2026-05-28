import 'package:convertouch/data/repositories/local/list_value_repository_impl.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/num_range.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_item_list_values_init_model.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/init_item_list_values_use_case.dart';
import 'package:convertouch/domain/use_cases/list_values/fetch_list_values_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:test/test.dart';

import '../../../model/mock/mock_list_values_batch.dart';
import '../../../model/mock/mock_param.dart';
import '../../../model/mock/mock_unit.dart';
import '../../../repositories/mock/mock_network_repository.dart';

void main() {
  late InitParamListValuesUseCase useCase;

  setUpAll(() {
    useCase = const InitParamListValuesUseCase(
      fetchListValuesUseCase: FetchListValuesUseCase(
        listValueRepository: ListValueRepositoryImpl(
          networkRepository: MockNetworkRepository(),
        ),
      ),
    );
  });

  Future<void> testCase({
    required ConversionParamSetValueModel paramSetValue,
    required ConversionParamValueModel currentParamValue,
    required ConversionParamValueModel expectedParamValue,
    bool alignSelectedValue = true,
  }) async {
    final modifiedParamValue = ObjectUtils.tryGet(
      await useCase.execute(
        InputParamListValuesInitModel(
          itemValue: currentParamValue,
          paramSetValue: paramSetValue,
          alignSelectedValue: alignSelectedValue,
        ),
      ),
    );

    expect(modifiedParamValue.toJson(), expectedParamValue.toJson());
  }

  group("Should init list values of param 'Bar Weight' kg", () {
    group("Should align selected value", () {
      test("Should preselect default value 10 when no value selected",
          () async {
        final currentParamValue = ConversionParamValueModel.tuple(
          barWeightParam,
          null,
          null,
          unit: kilogram,
        );

        final expectedParamValue = ConversionParamValueModel.tuple(
          barWeightParam,
          10,
          null,
          unit: kilogram,
          listValues: barWeightParamKgListValues,
        );

        await testCase(
          paramSetValue: ConversionParamSetValueModel(
            paramSet: barbellWeightParamSet,
            paramValues: [
              currentParamValue,
              ConversionParamValueModel.tuple(oneSideWeightParam, 30, 1,
                  unit: kilogram),
            ],
          ),
          currentParamValue: currentParamValue,
          expectedParamValue: expectedParamValue,
        );
      });

      test("Should leave value 20 when it exists in the list", () async {
        final currentParamValue = ConversionParamValueModel.tuple(
          barWeightParam,
          20,
          null,
          unit: kilogram,
        );

        final expectedParamValue = ConversionParamValueModel.tuple(
          barWeightParam,
          20,
          null,
          unit: kilogram,
          listValues: barWeightParamKgListValues,
        );

        await testCase(
          paramSetValue: ConversionParamSetValueModel(
            paramSet: barbellWeightParamSet,
            paramValues: [
              currentParamValue,
              ConversionParamValueModel.tuple(oneSideWeightParam, 30, 1,
                  unit: kilogram),
            ],
          ),
          currentParamValue: currentParamValue,
          expectedParamValue: expectedParamValue,
        );
      });

      test("Should replace unknown value 15 with default value 10", () async {
        final currentParamValue = ConversionParamValueModel.tuple(
          barWeightParam,
          15,
          null,
          unit: kilogram,
        );

        final expectedParamValue = ConversionParamValueModel.tuple(
          barWeightParam,
          10,
          null,
          unit: kilogram,
          listValues: barWeightParamKgListValues,
        );

        await testCase(
          paramSetValue: ConversionParamSetValueModel(
            paramSet: barbellWeightParamSet,
            paramValues: [
              currentParamValue,
              ConversionParamValueModel.tuple(oneSideWeightParam, 30, 1,
                  unit: kilogram),
            ],
          ),
          currentParamValue: currentParamValue,
          expectedParamValue: expectedParamValue,
        );
      });
    });

    group("Should NOT align selected value", () {
      test("Should NOT preselect default value 10 when no value selected",
          () async {
        final currentParamValue = ConversionParamValueModel.tuple(
          barWeightParam,
          null,
          null,
          unit: kilogram,
        );

        final expectedParamValue = ConversionParamValueModel.tuple(
          barWeightParam,
          null,
          null,
          unit: kilogram,
          listValues: barWeightParamKgListValues,
        );

        await testCase(
          alignSelectedValue: false,
          paramSetValue: ConversionParamSetValueModel(
            paramSet: barbellWeightParamSet,
            paramValues: [
              currentParamValue,
              ConversionParamValueModel.tuple(oneSideWeightParam, 30, 1,
                  unit: kilogram),
            ],
          ),
          currentParamValue: currentParamValue,
          expectedParamValue: expectedParamValue,
        );
      });

      test("Should leave value 20 when it exists in the list", () async {
        final currentParamValue = ConversionParamValueModel.tuple(
          barWeightParam,
          20,
          null,
          unit: kilogram,
        );

        final expectedParamValue = ConversionParamValueModel.tuple(
          barWeightParam,
          20,
          null,
          unit: kilogram,
          listValues: barWeightParamKgListValues,
        );

        await testCase(
          alignSelectedValue: false,
          paramSetValue: ConversionParamSetValueModel(
            paramSet: barbellWeightParamSet,
            paramValues: [
              currentParamValue,
              ConversionParamValueModel.tuple(oneSideWeightParam, 30, 1,
                  unit: kilogram),
            ],
          ),
          currentParamValue: currentParamValue,
          expectedParamValue: expectedParamValue,
        );
      });

      test("Should NOT replace unknown value 15", () async {
        final currentParamValue = ConversionParamValueModel.tuple(
          barWeightParam,
          15,
          null,
          unit: kilogram,
        );

        final expectedParamValue = ConversionParamValueModel.tuple(
          barWeightParam,
          15,
          null,
          unit: kilogram,
          listValues: barWeightParamKgListValues,
        );

        await testCase(
          alignSelectedValue: false,
          paramSetValue: ConversionParamSetValueModel(
            paramSet: barbellWeightParamSet,
            paramValues: [
              currentParamValue,
              ConversionParamValueModel.tuple(oneSideWeightParam, 30, 1,
                  unit: kilogram),
            ],
          ),
          currentParamValue: currentParamValue,
          expectedParamValue: expectedParamValue,
        );
      });
    });
  });

  group("Should init list values of param 'Bar Weight' lb", () {
    group("Should align selected value", () {
      test("Should preselect default value 22 when no value selected",
          () async {
        final currentParamValue = ConversionParamValueModel.tuple(
          barWeightParam,
          null,
          null,
          unit: pound,
        );

        final expectedParamValue = ConversionParamValueModel.tuple(
          barWeightParam,
          barWeightParamPoundListValues.items[0].valueModel,
          null,
          unit: pound,
          listValues: barWeightParamPoundListValues,
        );

        await testCase(
          paramSetValue: ConversionParamSetValueModel(
            paramSet: barbellWeightParamSet,
            paramValues: [
              currentParamValue,
              ConversionParamValueModel.tuple(oneSideWeightParam, 30, 1,
                  unit: kilogram),
            ],
          ),
          currentParamValue: currentParamValue,
          expectedParamValue: expectedParamValue,
        );
      });

      test("Should leave value 44 when it exists in the list", () async {
        final currentParamValue = ConversionParamValueModel.tuple(
          barWeightParam,
          barWeightParamPoundListValues.items[1].valueModel,
          null,
          unit: pound,
        );

        final expectedParamValue = ConversionParamValueModel.tuple(
          barWeightParam,
          barWeightParamPoundListValues.items[1].valueModel,
          null,
          unit: pound,
          listValues: barWeightParamPoundListValues,
        );

        await testCase(
          paramSetValue: ConversionParamSetValueModel(
            paramSet: barbellWeightParamSet,
            paramValues: [
              currentParamValue,
              ConversionParamValueModel.tuple(oneSideWeightParam, 30, 1,
                  unit: kilogram),
            ],
          ),
          currentParamValue: currentParamValue,
          expectedParamValue: expectedParamValue,
        );
      });

      test("Should replace unknown value 15 with default value 22", () async {
        final currentParamValue = ConversionParamValueModel.tuple(
          barWeightParam,
          15,
          null,
          unit: pound,
        );

        final expectedParamValue = ConversionParamValueModel.tuple(
          barWeightParam,
          barWeightParamPoundListValues.items[0].valueModel,
          null,
          unit: pound,
          listValues: barWeightParamPoundListValues,
        );

        await testCase(
          paramSetValue: ConversionParamSetValueModel(
            paramSet: barbellWeightParamSet,
            paramValues: [
              currentParamValue,
              ConversionParamValueModel.tuple(oneSideWeightParam, 30, 1,
                  unit: kilogram),
            ],
          ),
          currentParamValue: currentParamValue,
          expectedParamValue: expectedParamValue,
        );
      });
    });

    group("Should NOT align selected value", () {
      test("Should NOT preselect default value 22 when no value selected",
          () async {
        final currentParamValue = ConversionParamValueModel.tuple(
          barWeightParam,
          null,
          null,
          unit: pound,
        );

        final expectedParamValue = ConversionParamValueModel.tuple(
          barWeightParam,
          null,
          null,
          unit: pound,
          listValues: barWeightParamPoundListValues,
        );

        await testCase(
          alignSelectedValue: false,
          paramSetValue: ConversionParamSetValueModel(
            paramSet: barbellWeightParamSet,
            paramValues: [
              currentParamValue,
              ConversionParamValueModel.tuple(oneSideWeightParam, 30, 1,
                  unit: kilogram),
            ],
          ),
          currentParamValue: currentParamValue,
          expectedParamValue: expectedParamValue,
        );
      });

      test("Should leave value 44 when it exists in the list", () async {
        final currentParamValue = ConversionParamValueModel.tuple(
          barWeightParam,
          44,
          null,
          unit: pound,
        );

        final expectedParamValue = ConversionParamValueModel.tuple(
          barWeightParam,
          44,
          null,
          unit: pound,
          listValues: barWeightParamPoundListValues,
        );

        await testCase(
          alignSelectedValue: false,
          paramSetValue: ConversionParamSetValueModel(
            paramSet: barbellWeightParamSet,
            paramValues: [
              currentParamValue,
              ConversionParamValueModel.tuple(oneSideWeightParam, 30, 1,
                  unit: kilogram),
            ],
          ),
          currentParamValue: currentParamValue,
          expectedParamValue: expectedParamValue,
        );
      });

      test("Should NOT replace unknown value 15", () async {
        final currentParamValue = ConversionParamValueModel.tuple(
          barWeightParam,
          15,
          null,
          unit: pound,
        );

        final expectedParamValue = ConversionParamValueModel.tuple(
          barWeightParam,
          15,
          null,
          unit: pound,
          listValues: barWeightParamPoundListValues,
        );

        await testCase(
          alignSelectedValue: false,
          paramSetValue: ConversionParamSetValueModel(
            paramSet: barbellWeightParamSet,
            paramValues: [
              currentParamValue,
              ConversionParamValueModel.tuple(oneSideWeightParam, 30, 1,
                  unit: kilogram),
            ],
          ),
          currentParamValue: currentParamValue,
          expectedParamValue: expectedParamValue,
        );
      });
    });
  });

  group("Should init list values of param 'Garment'", () {
    group("Should align selected value", () {
      test("Should preselect default value 'Shirt' when no value selected",
          () async {
        final currentParamValue =
            ConversionParamValueModel.tuple(garmentParam, null, null);

        final expectedParamValue = ConversionParamValueModel.tuple(
          garmentParam,
          'Shirt',
          null,
          listValues: garmentParamListValues,
        );

        await testCase(
          paramSetValue: ConversionParamSetValueModel(
            paramSet: clothesSizeParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(personParam, "Woman", null),
              currentParamValue,
              ConversionParamValueModel.tuple(heightParam, null, null,
                  unit: centimeter),
            ],
          ),
          currentParamValue: currentParamValue,
          expectedParamValue: expectedParamValue,
        );
      });

      test("Should leave 'Shirt' when it exists in the list", () async {
        final currentParamValue = ConversionParamValueModel.tuple(
          garmentParam,
          'Shirt',
          null,
        );

        final expectedParamValue = ConversionParamValueModel.tuple(
          garmentParam,
          'Shirt',
          null,
          listValues: garmentParamListValues,
        );

        await testCase(
          paramSetValue: ConversionParamSetValueModel(
            paramSet: clothesSizeParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(personParam, "Woman", null),
              currentParamValue,
              ConversionParamValueModel.tuple(heightParam, null, null,
                  unit: centimeter),
            ],
          ),
          currentParamValue: currentParamValue,
          expectedParamValue: expectedParamValue,
        );
      });

      test("Should replace unknown value 'Pants' with default value 'Shirt'",
          () async {
        final currentParamValue = ConversionParamValueModel.tuple(
          garmentParam,
          'Pants',
          null,
        );

        final expectedParamValue = ConversionParamValueModel.tuple(
          garmentParam,
          'Shirt',
          null,
          listValues: garmentParamListValues,
        );

        await testCase(
          paramSetValue: ConversionParamSetValueModel(
            paramSet: clothesSizeParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(personParam, "Woman", null),
              currentParamValue,
              ConversionParamValueModel.tuple(heightParam, null, null,
                  unit: centimeter),
            ],
          ),
          currentParamValue: currentParamValue,
          expectedParamValue: expectedParamValue,
        );
      });
    });

    group("Should NOT align selected value", () {
      test("Should NOT preselect default value 'Shirt' when no value selected",
          () async {
        final currentParamValue =
            ConversionParamValueModel.tuple(garmentParam, null, null);

        final expectedParamValue = ConversionParamValueModel.tuple(
          garmentParam,
          null,
          null,
          listValues: garmentParamListValues,
        );

        await testCase(
          alignSelectedValue: false,
          paramSetValue: ConversionParamSetValueModel(
            paramSet: clothesSizeParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(personParam, "Woman", null),
              currentParamValue,
              ConversionParamValueModel.tuple(heightParam, null, null,
                  unit: centimeter),
            ],
          ),
          currentParamValue: currentParamValue,
          expectedParamValue: expectedParamValue,
        );
      });

      test("Should leave 'Shirt' when it exists in the list", () async {
        final currentParamValue = ConversionParamValueModel.tuple(
          garmentParam,
          'Shirt',
          null,
        );

        final expectedParamValue = ConversionParamValueModel.tuple(
          garmentParam,
          'Shirt',
          null,
          listValues: garmentParamListValues,
        );

        await testCase(
          alignSelectedValue: false,
          paramSetValue: ConversionParamSetValueModel(
            paramSet: clothesSizeParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(personParam, "Woman", null),
              currentParamValue,
              ConversionParamValueModel.tuple(heightParam, null, null,
                  unit: centimeter),
            ],
          ),
          currentParamValue: currentParamValue,
          expectedParamValue: expectedParamValue,
        );
      });

      test("Should NOT replace unknown value 'Pants'", () async {
        final currentParamValue = ConversionParamValueModel.tuple(
          garmentParam,
          'Pants',
          null,
        );

        final expectedParamValue = ConversionParamValueModel.tuple(
          garmentParam,
          'Pants',
          null,
          listValues: garmentParamListValues,
        );

        await testCase(
          alignSelectedValue: false,
          paramSetValue: ConversionParamSetValueModel(
            paramSet: clothesSizeParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(personParam, "Woman", null),
              currentParamValue,
              ConversionParamValueModel.tuple(heightParam, null, null,
                  unit: centimeter),
            ],
          ),
          currentParamValue: currentParamValue,
          expectedParamValue: expectedParamValue,
        );
      });
    });
  });

  group("Should init list values of param 'Height' cm", () {
    group("Should align selected value", () {
      test("Should preselect default value '..-156' when no value selected",
          () async {
        final currentParamValue = ConversionParamValueModel.tuple(
            heightParam, null, null,
            unit: centimeter);

        final expectedParamValue = ConversionParamValueModel.tuple(
          heightParam,
          heightRangesFrom0_156To186InCm.items[0].valueModel,
          null,
          unit: centimeter,
          listValues: heightRangesFrom0_156To186InCm,
        );

        await testCase(
          paramSetValue: ConversionParamSetValueModel(
            paramSet: clothesSizeParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(personParam, "Woman", null),
              ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
              currentParamValue,
            ],
          ),
          currentParamValue: currentParamValue,
          expectedParamValue: expectedParamValue,
        );
      });

      test("Should leave '168-174' when it exists in the list", () async {
        final currentParamValue = ConversionParamValueModel.tuple(
          heightParam,
          heightRangesFrom0_156To186InCm.items[3].valueModel,
          null,
          unit: centimeter,
        );

        final expectedParamValue = ConversionParamValueModel.tuple(
          heightParam,
          heightRangesFrom0_156To186InCm.items[3].valueModel,
          null,
          unit: centimeter,
          listValues: heightRangesFrom0_156To186InCm,
        );

        await testCase(
          paramSetValue: ConversionParamSetValueModel(
            paramSet: clothesSizeParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(personParam, "Woman", null),
              ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
              currentParamValue,
            ],
          ),
          currentParamValue: currentParamValue,
          expectedParamValue: expectedParamValue,
        );
      });

      test("Should replace unknown value '10-20' with default value '..-156'",
          () async {
        final currentParamValue = ConversionParamValueModel.tuple(
          heightParam,
          const NumRange.withRight(10, 20),
          null,
          unit: centimeter,
        );

        final expectedParamValue = ConversionParamValueModel.tuple(
          heightParam,
          heightRangesFrom0_156To186InCm.items[0].valueModel,
          null,
          unit: centimeter,
          listValues: heightRangesFrom0_156To186InCm,
        );

        await testCase(
          paramSetValue: ConversionParamSetValueModel(
            paramSet: clothesSizeParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(personParam, "Woman", null),
              ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
              currentParamValue,
            ],
          ),
          currentParamValue: currentParamValue,
          expectedParamValue: expectedParamValue,
        );
      });
    });

    group("Should NOT align selected value", () {
      test("Should NOT preselect default value '..-156' when no value selected",
          () async {
        final currentParamValue = ConversionParamValueModel.tuple(
          heightParam,
          null,
          null,
          unit: centimeter,
        );

        final expectedParamValue = ConversionParamValueModel.tuple(
          heightParam,
          null,
          null,
          unit: centimeter,
          listValues: heightRangesFrom0_156To186InCm,
        );

        await testCase(
          alignSelectedValue: false,
          paramSetValue: ConversionParamSetValueModel(
            paramSet: clothesSizeParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(personParam, "Woman", null),
              ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
              currentParamValue,
            ],
          ),
          currentParamValue: currentParamValue,
          expectedParamValue: expectedParamValue,
        );
      });

      test("Should leave '168-174' when it exists in the list", () async {
        final currentParamValue = ConversionParamValueModel.tuple(
          heightParam,
          const NumRange.withRight(168, 174),
          null,
          unit: centimeter,
        );

        final expectedParamValue = ConversionParamValueModel.tuple(
          heightParam,
          const NumRange.withRight(168, 174),
          null,
          unit: centimeter,
          listValues: heightRangesFrom0_156To186InCm,
        );

        await testCase(
          alignSelectedValue: false,
          paramSetValue: ConversionParamSetValueModel(
            paramSet: clothesSizeParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(personParam, "Woman", null),
              ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
              currentParamValue,
            ],
          ),
          currentParamValue: currentParamValue,
          expectedParamValue: expectedParamValue,
        );
      });

      test("Should NOT replace unknown value '10-20'", () async {
        final currentParamValue = ConversionParamValueModel.tuple(
          heightParam,
          const NumRange.withRight(10, 20),
          null,
          unit: centimeter,
        );

        final expectedParamValue = ConversionParamValueModel.tuple(
          heightParam,
          const NumRange.withRight(10, 20),
          null,
          unit: centimeter,
          listValues: heightRangesFrom0_156To186InCm,
        );

        await testCase(
          alignSelectedValue: false,
          paramSetValue: ConversionParamSetValueModel(
            paramSet: clothesSizeParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(personParam, "Woman", null),
              ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
              currentParamValue,
            ],
          ),
          currentParamValue: currentParamValue,
          expectedParamValue: expectedParamValue,
        );
      });
    });
  });

  group("Should init list values of param 'Height' m", () {
    group("Should align selected value", () {
      test("Should preselect default value '..-1.56' when no value selected",
          () async {
        final currentParamValue = ConversionParamValueModel.tuple(
            heightParam, null, null,
            unit: meter);

        final expectedParamValue = ConversionParamValueModel.tuple(
          heightParam,
          heightRangesFrom0_156To186InMeter.items[0].valueModel,
          null,
          unit: meter,
          listValues: heightRangesFrom0_156To186InMeter,
        );

        await testCase(
          paramSetValue: ConversionParamSetValueModel(
            paramSet: clothesSizeParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(personParam, "Woman", null),
              ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
              currentParamValue,
            ],
          ),
          currentParamValue: currentParamValue,
          expectedParamValue: expectedParamValue,
        );
      });

      test("Should leave '1.56-1.62' when it exists in the list", () async {
        final currentParamValue = ConversionParamValueModel.tuple(
          heightParam,
          heightRangesFrom0_156To186InMeter.items[1].valueModel,
          null,
          unit: meter,
        );

        final expectedParamValue = ConversionParamValueModel.tuple(
          heightParam,
          heightRangesFrom0_156To186InMeter.items[1].valueModel,
          null,
          unit: meter,
          listValues: heightRangesFrom0_156To186InMeter,
        );

        await testCase(
          paramSetValue: ConversionParamSetValueModel(
            paramSet: clothesSizeParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(personParam, "Woman", null),
              ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
              currentParamValue,
            ],
          ),
          currentParamValue: currentParamValue,
          expectedParamValue: expectedParamValue,
        );
      });

      test("Should replace unknown value '1.5-3' with default value '..-1.56'",
          () async {
        final currentParamValue = ConversionParamValueModel.tuple(
          heightParam,
          const NumRange.withRight(1.5, 3),
          null,
          unit: meter,
        );

        final expectedParamValue = ConversionParamValueModel.tuple(
          heightParam,
          heightRangesFrom0_156To186InMeter.items[0].valueModel,
          null,
          unit: meter,
          listValues: heightRangesFrom0_156To186InMeter,
        );

        await testCase(
          paramSetValue: ConversionParamSetValueModel(
            paramSet: clothesSizeParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(personParam, "Woman", null),
              ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
              currentParamValue,
            ],
          ),
          currentParamValue: currentParamValue,
          expectedParamValue: expectedParamValue,
        );
      });
    });

    group("Should NOT align selected value", () {
      test(
          "Should NOT preselect default value '..-1.56' when no value selected",
          () async {
        final currentParamValue = ConversionParamValueModel.tuple(
          heightParam,
          null,
          null,
          unit: meter,
        );

        final expectedParamValue = ConversionParamValueModel.tuple(
          heightParam,
          null,
          null,
          unit: meter,
          listValues: heightRangesFrom0_156To186InMeter,
        );

        await testCase(
          alignSelectedValue: false,
          paramSetValue: ConversionParamSetValueModel(
            paramSet: clothesSizeParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(personParam, "Woman", null),
              ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
              currentParamValue,
            ],
          ),
          currentParamValue: currentParamValue,
          expectedParamValue: expectedParamValue,
        );
      });

      test("Should leave '1.56-1.62' when it exists in the list", () async {
        final currentParamValue = ConversionParamValueModel.tuple(
          heightParam,
          heightRangesFrom0_156To186InMeter.items[1].valueModel,
          null,
          unit: meter,
        );

        final expectedParamValue = ConversionParamValueModel.tuple(
          heightParam,
          heightRangesFrom0_156To186InMeter.items[1].valueModel,
          null,
          unit: meter,
          listValues: heightRangesFrom0_156To186InMeter,
        );

        await testCase(
          alignSelectedValue: false,
          paramSetValue: ConversionParamSetValueModel(
            paramSet: clothesSizeParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(personParam, "Woman", null),
              ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
              currentParamValue,
            ],
          ),
          currentParamValue: currentParamValue,
          expectedParamValue: expectedParamValue,
        );
      });

      test("Should NOT replace unknown value '1.5-3'", () async {
        final currentParamValue = ConversionParamValueModel.tuple(
          heightParam,
          const NumRange.withRight(1.5, 3),
          null,
          unit: meter,
        );

        final expectedParamValue = ConversionParamValueModel.tuple(
          heightParam,
          const NumRange.withRight(1.5, 3),
          null,
          unit: meter,
          listValues: heightRangesFrom0_156To186InMeter,
        );

        await testCase(
          alignSelectedValue: false,
          paramSetValue: ConversionParamSetValueModel(
            paramSet: clothesSizeParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(personParam, "Woman", null),
              ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
              currentParamValue,
            ],
          ),
          currentParamValue: currentParamValue,
          expectedParamValue: expectedParamValue,
        );
      });
    });
  });
}
