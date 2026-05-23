import 'package:convertouch/data/repositories/local/list_value_repository_impl.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/list_value_model.dart';
import 'package:convertouch/domain/model/num_range.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_param_list_values_init_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_items_fetch_model.dart';
import 'package:convertouch/domain/use_cases/common/init_item_list_values_use_case.dart';
import 'package:convertouch/domain/use_cases/list_values/fetch_list_values_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:test/test.dart';

import '../../model/mock/mock_param.dart';
import '../../model/mock/mock_unit.dart';
import '../../repositories/mock/mock_network_repository.dart';

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
  }) async {
    final modifiedParamValue = ObjectUtils.tryGet(
      await useCase.execute(
        InputParamListValuesInitModel(
          paramSetValue: paramSetValue,
          paramValue: currentParamValue,
        ),
      ),
    );

    expect(modifiedParamValue.toJson(), expectedParamValue.toJson());
  }

  test(
      "Should init list values of param 'Bar Weight' kg, "
      "should preselect default value 10 since no value selected", () async {
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
      listValues: const OutputItemsFetchModel(items: [
        ListValueModel.str('10'),
        ListValueModel.str('20'),
      ], pageNum: 1, hasReachedMax: true),
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

  test(
      "Should init list values of param 'Bar Weight' kg, "
      "should leave value 20 as is since it exists in the list", () async {
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
      listValues: const OutputItemsFetchModel(items: [
        ListValueModel.str('10'),
        ListValueModel.str('20'),
      ], pageNum: 1, hasReachedMax: true),
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

  test(
      "Should init list values of param 'Bar Weight' kg, "
      "should replace unknown value 15 with default value 10", () async {
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
      listValues: const OutputItemsFetchModel(items: [
        ListValueModel.str('10'),
        ListValueModel.str('20'),
      ], pageNum: 1, hasReachedMax: true),
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

  test(
      "Should init list values of param 'Bar Weight' lb, "
      "should preselect default value 22 since no value selected", () async {
    final currentParamValue = ConversionParamValueModel.tuple(
      barWeightParam,
      null,
      null,
      unit: pound,
    );

    final expectedParamValue = ConversionParamValueModel.tuple(
      barWeightParam,
      22,
      null,
      unit: pound,
      listValues: const OutputItemsFetchModel(items: [
        ListValueModel.str('22'),
        ListValueModel.str('44'),
      ], pageNum: 1, hasReachedMax: true),
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

  test(
      "Should init list values of param 'Bar Weight' lb, "
      "should leave value 44 as is since it exists in the list", () async {
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
      listValues: const OutputItemsFetchModel(items: [
        ListValueModel.str('22'),
        ListValueModel.str('44'),
      ], pageNum: 1, hasReachedMax: true),
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

  test(
      "Should init list values of param 'Bar Weight' lb, "
      "should replace unknown value 15 with default value 22", () async {
    final currentParamValue = ConversionParamValueModel.tuple(
      barWeightParam,
      15,
      null,
      unit: pound,
    );

    final expectedParamValue = ConversionParamValueModel.tuple(
      barWeightParam,
      22,
      null,
      unit: pound,
      listValues: const OutputItemsFetchModel(items: [
        ListValueModel.str('22'),
        ListValueModel.str('44'),
      ], pageNum: 1, hasReachedMax: true),
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

  test("Should init list values of param 'Garment'", () async {
    final currentParamValue =
        ConversionParamValueModel.tuple(garmentParam, null, null);

    final expectedParamValue = ConversionParamValueModel.tuple(
      garmentParam,
      'Shirt',
      null,
      listValues: const OutputItemsFetchModel(items: [
        ListValueModel.str('Shirt'),
        ListValueModel.str('Trousers'),
      ], pageNum: 1, hasReachedMax: true),
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

  test("Should init list values of param 'Height' cm (clothes size)", () async {
    final currentParamValue = ConversionParamValueModel.tuple(
        heightParam, null, null,
        unit: centimeter);

    final expectedParamValue = ConversionParamValueModel.tuple(
      heightParam,
      const NumRange.withRight(0, 156),
      null,
      unit: centimeter,
      listValues: OutputItemsFetchModel(items: [
        ListValueModel.range(const NumRange.withRight(0, 156)),
        ListValueModel.range(const NumRange.withRight(156, 162)),
        ListValueModel.range(const NumRange.withRight(162, 168)),
        ListValueModel.range(const NumRange.withRight(168, 174)),
        ListValueModel.range(const NumRange.withRight(174, 180)),
        ListValueModel.range(const NumRange.withRight(180, 186)),
        ListValueModel.range(const NumRange.withoutBoth(186, double.infinity)),
      ], pageNum: 1, hasReachedMax: true),
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

  test("Should init list values of param 'Height' m (clothes size)", () async {
    final currentParamValue =
        ConversionParamValueModel.tuple(heightParam, null, null, unit: meter);

    final expectedParamValue = ConversionParamValueModel.tuple(
      heightParam,
      const NumRange.withRight(0, 1.56),
      null,
      unit: meter,
      listValues: OutputItemsFetchModel(items: [
        ListValueModel.range(const NumRange.withRight(0, 1.56)),
        ListValueModel.range(const NumRange.withRight(1.56, 1.62)),
        ListValueModel.range(const NumRange.withRight(1.62, 1.68)),
        ListValueModel.range(const NumRange.withRight(1.68, 1.74)),
        ListValueModel.range(const NumRange.withRight(1.74, 1.80)),
        ListValueModel.range(const NumRange.withRight(1.80, 1.86)),
        ListValueModel.range(const NumRange.withoutBoth(1.86, double.infinity)),
      ], pageNum: 1, hasReachedMax: true),
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
}
