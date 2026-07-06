import 'package:convertouch/data/repositories/list_value_repository_impl.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/domain/model/num_range.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/use_cases/list_values/fetch_list_values_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:test/test.dart';

import '../../model/mock/mock_list_values_batch.dart';
import '../../model/mock/mock_param.dart';
import '../../model/mock/mock_unit.dart';
import '../../repositories/mock/mock_network_repository.dart';

void main() {
  late FetchListValuesUseCase useCase;

  setUpAll(() {
    useCase = const FetchListValuesUseCase(
      listValueRepository: ListValueRepositoryImpl(
        networkRepository: MockNetworkRepository(),
      ),
    );
  });

  Future<void> testCase<T extends ItemValueModel>({
    required T itemValue,
    required ConversionParamSetValueModel? paramSetValue,
    required ListValuesFetchResult expectedListFetchResult,
    required ValueModel? expectedSelectedValue,
    String? conversionGroupName,
    int pageNum = 0,
    bool keepSelectedValueIfNotInList = false,
  }) async {
    final currentListFetchResult = ObjectUtils.tryGet(
      await useCase.execute(
        InputItemsFetchModel(
          pageSize: listValuesPageSize,
          pageNum: pageNum,
          fetchParams: ListValuesFetchParams(
            itemId: "",
            selectedValue: itemValue.value,
            listType: itemValue.listType!,
            unit: itemValue.unitItem,
            conversionGroupName: conversionGroupName,
            conversionParams: paramSetValue,
            keepSelectedValueIfNotInList: keepSelectedValueIfNotInList,
          ),
        ),
      ),
    );

    expect(
      currentListFetchResult.toJson(),
      expectedListFetchResult.toJson(),
    );

    expect(currentListFetchResult.selectedItem, expectedSelectedValue);
  }

  group("Should init list values of param 'Bar Weight' kg", () {
    test("Should preselect default value 10 when no value selected", () async {
      final currentParamValue = ConversionParamValueModel.tuple(
        barWeightParam,
        null,
        null,
        unit: kilogram,
      );

      await testCase(
        itemValue: currentParamValue,
        expectedListFetchResult: barWeightParamKgListValues,
        expectedSelectedValue: ValueModel.num(10),
        paramSetValue: ConversionParamSetValueModel(
          paramSet: barbellWeightParamSet,
          paramValues: [
            currentParamValue,
            ConversionParamValueModel.tuple(
              oneSideWeightParam,
              30,
              1,
              unit: kilogram,
            ),
          ],
        ),
      );
    });

    test("Should leave value 20 when it exists in the list", () async {
      final currentParamValue = ConversionParamValueModel.tuple(
        barWeightParam,
        20,
        null,
        unit: kilogram,
      );

      await testCase(
        itemValue: currentParamValue,
        expectedListFetchResult: barWeightParamKgListValues,
        expectedSelectedValue: ValueModel.num(20),
        paramSetValue: ConversionParamSetValueModel(
          paramSet: barbellWeightParamSet,
          paramValues: [
            currentParamValue,
            ConversionParamValueModel.tuple(
              oneSideWeightParam,
              30,
              1,
              unit: kilogram,
            ),
          ],
        ),
      );
    });

    test("Should replace unknown value 15 with default value 10", () async {
      final currentParamValue = ConversionParamValueModel.tuple(
        barWeightParam,
        15,
        null,
        unit: kilogram,
      );

      await testCase(
        itemValue: currentParamValue,
        expectedListFetchResult: barWeightParamKgListValues,
        expectedSelectedValue: ValueModel.num(10),
        paramSetValue: ConversionParamSetValueModel(
          paramSet: barbellWeightParamSet,
          paramValues: [
            currentParamValue,
            ConversionParamValueModel.tuple(
              oneSideWeightParam,
              30,
              1,
              unit: kilogram,
            ),
          ],
        ),
      );
    });
  });

  group("Should init list values of param 'Bar Weight' lb", () {
    test("Should preselect default value 22 when no value selected", () async {
      final currentParamValue = ConversionParamValueModel.tuple(
        barWeightParam,
        null,
        null,
        unit: pound,
      );

      await testCase(
        itemValue: currentParamValue,
        expectedListFetchResult: barWeightParamPoundListValues,
        expectedSelectedValue: const ValueModel(raw: '10', alt: '22'),
        paramSetValue: ConversionParamSetValueModel(
          paramSet: barbellWeightParamSet,
          paramValues: [
            currentParamValue,
            ConversionParamValueModel.tuple(
              oneSideWeightParam,
              30,
              1,
              unit: kilogram,
            ),
          ],
        ),
      );
    });

    test("Should leave value 44 when it exists in the list", () async {
      final currentParamValue = ConversionParamValueModel.tuple(
        barWeightParam,
        const ValueModel(raw: '20', alt: '44'),
        null,
        unit: pound,
      );

      await testCase(
        itemValue: currentParamValue,
        expectedListFetchResult: barWeightParamPoundListValues,
        expectedSelectedValue: const ValueModel(raw: '20', alt: '44'),
        paramSetValue: ConversionParamSetValueModel(
          paramSet: barbellWeightParamSet,
          paramValues: [
            currentParamValue,
            ConversionParamValueModel.tuple(
              oneSideWeightParam,
              30,
              1,
              unit: kilogram,
            ),
          ],
        ),
      );
    });

    test("Should replace unknown value 15 with default value 22", () async {
      final currentParamValue = ConversionParamValueModel.tuple(
        barWeightParam,
        15,
        null,
        unit: pound,
      );

      await testCase(
        itemValue: currentParamValue,
        expectedListFetchResult: barWeightParamPoundListValues,
        expectedSelectedValue: const ValueModel(raw: '10', alt: '22'),
        paramSetValue: ConversionParamSetValueModel(
          paramSet: barbellWeightParamSet,
          paramValues: [
            currentParamValue,
            ConversionParamValueModel.tuple(
              oneSideWeightParam,
              30,
              1,
              unit: kilogram,
            ),
          ],
        ),
      );
    });
  });

  group("Should init list values of param 'Garment'", () {
    test("Should preselect default value 'Shirt' when no value selected",
        () async {
      final currentParamValue =
          ConversionParamValueModel.tuple(garmentParam, null, null);

      await testCase(
        itemValue: currentParamValue,
        expectedListFetchResult: garmentParamListValues,
        expectedSelectedValue: ValueModel.str('Shirt'),
        paramSetValue: ConversionParamSetValueModel(
          paramSet: clothesSizeParamSet,
          paramValues: [
            ConversionParamValueModel.tuple(personParam, "Woman", null),
            currentParamValue,
            ConversionParamValueModel.tuple(heightParam, null, null,
                unit: centimeter),
          ],
        ),
      );
    });

    test("Should leave 'Shirt' when it exists in the list", () async {
      final currentParamValue = ConversionParamValueModel.tuple(
        garmentParam,
        'Shirt',
        null,
      );

      await testCase(
        itemValue: currentParamValue,
        expectedListFetchResult: garmentParamListValues,
        expectedSelectedValue: ValueModel.str('Shirt'),
        paramSetValue: ConversionParamSetValueModel(
          paramSet: clothesSizeParamSet,
          paramValues: [
            ConversionParamValueModel.tuple(personParam, "Woman", null),
            currentParamValue,
            ConversionParamValueModel.tuple(heightParam, null, null,
                unit: centimeter),
          ],
        ),
      );
    });

    test("Should replace unknown value 'Pants' with default value 'Shirt'",
        () async {
      final currentParamValue = ConversionParamValueModel.tuple(
        garmentParam,
        'Pants',
        null,
      );

      await testCase(
        itemValue: currentParamValue,
        expectedListFetchResult: garmentParamListValues,
        expectedSelectedValue: ValueModel.str('Shirt'),
        paramSetValue: ConversionParamSetValueModel(
          paramSet: clothesSizeParamSet,
          paramValues: [
            ConversionParamValueModel.tuple(personParam, "Woman", null),
            currentParamValue,
            ConversionParamValueModel.tuple(heightParam, null, null,
                unit: centimeter),
          ],
        ),
      );
    });
  });

  group("Should init list values of param 'Height' cm", () {
    test("Should preselect default value '..-156' when no value selected",
        () async {
      final currentParamValue = ConversionParamValueModel.tuple(
        heightParam,
        null,
        null,
        unit: centimeter,
      );

      await testCase(
        itemValue: currentParamValue,
        expectedListFetchResult: womanTrousersHeightRangesFrom0_156To186InCm,
        expectedSelectedValue:
            womanTrousersHeightRangesFrom0_156To186InCm.items[0],
        paramSetValue: ConversionParamSetValueModel(
          paramSet: clothesSizeParamSet,
          paramValues: [
            ConversionParamValueModel.tuple(personParam, "Woman", null),
            ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
            currentParamValue,
          ],
        ),
      );
    });

    test("Should leave '168-174' when it exists in the list", () async {
      final currentParamValue = ConversionParamValueModel.tuple(
        heightParam,
        womanTrousersHeightRangesFrom0_156To186InCm.items[3],
        null,
        unit: centimeter,
      );

      await testCase(
        itemValue: currentParamValue,
        expectedListFetchResult: womanTrousersHeightRangesFrom0_156To186InCm,
        expectedSelectedValue:
            womanTrousersHeightRangesFrom0_156To186InCm.items[3],
        paramSetValue: ConversionParamSetValueModel(
          paramSet: clothesSizeParamSet,
          paramValues: [
            ConversionParamValueModel.tuple(personParam, "Woman", null),
            ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
            currentParamValue,
          ],
        ),
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

      await testCase(
        itemValue: currentParamValue,
        expectedListFetchResult: womanTrousersHeightRangesFrom0_156To186InCm,
        expectedSelectedValue:
            womanTrousersHeightRangesFrom0_156To186InCm.items[0],
        paramSetValue: ConversionParamSetValueModel(
          paramSet: clothesSizeParamSet,
          paramValues: [
            ConversionParamValueModel.tuple(personParam, "Woman", null),
            ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
            currentParamValue,
          ],
        ),
      );
    });
  });

  group("Should init list values of param 'Height' m", () {
    test("Should preselect default value '..-1.56' when no value selected",
        () async {
      final currentParamValue = ConversionParamValueModel.tuple(
        heightParam,
        null,
        null,
        unit: meter,
      );

      await testCase(
        itemValue: currentParamValue,
        expectedListFetchResult: womanTrousersHeightRangesFrom0_156To186InMeter,
        expectedSelectedValue:
            womanTrousersHeightRangesFrom0_156To186InMeter.items[0],
        paramSetValue: ConversionParamSetValueModel(
          paramSet: clothesSizeParamSet,
          paramValues: [
            ConversionParamValueModel.tuple(personParam, "Woman", null),
            ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
            currentParamValue,
          ],
        ),
      );
    });

    test("Should leave '1.56-1.62' when it exists in the list", () async {
      final currentParamValue = ConversionParamValueModel.tuple(
        heightParam,
        womanTrousersHeightRangesFrom0_156To186InMeter.items[1],
        null,
        unit: meter,
      );

      await testCase(
        itemValue: currentParamValue,
        expectedListFetchResult: womanTrousersHeightRangesFrom0_156To186InMeter,
        expectedSelectedValue:
            womanTrousersHeightRangesFrom0_156To186InMeter.items[1],
        paramSetValue: ConversionParamSetValueModel(
          paramSet: clothesSizeParamSet,
          paramValues: [
            ConversionParamValueModel.tuple(personParam, "Woman", null),
            ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
            currentParamValue,
          ],
        ),
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

      await testCase(
        itemValue: currentParamValue,
        expectedListFetchResult: womanTrousersHeightRangesFrom0_156To186InMeter,
        expectedSelectedValue:
            womanTrousersHeightRangesFrom0_156To186InMeter.items[0],
        paramSetValue: ConversionParamSetValueModel(
          paramSet: clothesSizeParamSet,
          paramValues: [
            ConversionParamValueModel.tuple(personParam, "Woman", null),
            ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
            currentParamValue,
          ],
        ),
      );
    });
  });
}
