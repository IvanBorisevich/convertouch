import 'package:convertouch/data/repositories/list_value_repository_impl.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/use_cases/list_values/fetch_list_values_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../model/mock/mock_list_values_batch.dart';
import '../../model/mock/mock_param.dart';
import '../../model/mock/mock_unit.dart';
import '../../repositories/mock/mockito_mock_repository.mocks.dart';

void main() {
  late final FetchListValuesUseCase useCase;
  late final MockitoNetworkRepository mockitoNetworkRepository =
      MockitoNetworkRepository();

  setUpAll(() {
    provideDummy<Either<ConvertouchException, List<ValueModel>>>(
      const Right([]),
    );

    useCase = FetchListValuesUseCase(
      listValueRepository: ListValueRepositoryImpl(
        networkRepository: mockitoNetworkRepository,
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
    bool leaveUnknownSelectedValue = false,
    bool leaveEmptySelectedValue = false,
  }) async {
    final currentListFetchResult = ObjectUtils.tryGet(
      await useCase.execute(
        InputItemsFetchModel(
          pageSize: listValuesPageSize,
          pageNum: pageNum,
          selectedItem: itemValue.value,
          fetchParams: ListValuesFetchParams(
            itemId: "",
            listType: itemValue.listType!,
            unit: itemValue.unitItem,
            conversionGroupName: conversionGroupName,
            conversionParams: paramSetValue,
            leaveUnknownSelectedValue: leaveUnknownSelectedValue,
            leaveEmptySelectedValue: leaveEmptySelectedValue,
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
    test("Should preselect if empty: empty -> default value 10", () async {
      final currentParamValue = ConversionParamValueModel.tuple(
        barWeightParam,
        null,
        null,
        unit: kilogram,
      );

      await testCase(
        itemValue: currentParamValue,
        expectedListFetchResult: barWeightParamKgListValues.copyWith(
          selectedItem: Patchable(
            ValueModel.num(10),
          ),
        ),
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

    test("Should NOT preselect if empty: empty -> empty", () async {
      final currentParamValue = ConversionParamValueModel.tuple(
        barWeightParam,
        null,
        null,
        unit: kilogram,
      );

      await testCase(
        leaveEmptySelectedValue: true,
        itemValue: currentParamValue,
        expectedListFetchResult: barWeightParamKgListValues,
        expectedSelectedValue: null,
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

    test("Should leave known value: 20 -> 20", () async {
      final currentParamValue = ConversionParamValueModel.tuple(
        barWeightParam,
        20,
        null,
        unit: kilogram,
      );

      await testCase(
        itemValue: currentParamValue,
        expectedListFetchResult: barWeightParamKgListValues.copyWith(
          selectedItem: Patchable(
            ValueModel.num(20),
          ),
        ),
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

    test("Should leave unknown value: 15 -> 15", () async {
      final currentParamValue = ConversionParamValueModel.tuple(
        barWeightParam,
        15,
        null,
        unit: kilogram,
      );

      await testCase(
        leaveUnknownSelectedValue: true,
        itemValue: currentParamValue,
        expectedListFetchResult: barWeightParamKgListValues.copyWith(
          selectedItem: Patchable(
            ValueModel.num(15),
          ),
        ),
        expectedSelectedValue: ValueModel.num(15),
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

    test("Should replace unknown value: 15 -> default value 10", () async {
      final currentParamValue = ConversionParamValueModel.tuple(
        barWeightParam,
        15,
        null,
        unit: kilogram,
      );

      await testCase(
        itemValue: currentParamValue,
        expectedListFetchResult: barWeightParamKgListValues.copyWith(
          selectedItem: Patchable(
            ValueModel.num(10),
          ),
        ),
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

    test("Should erase unknown value: 15 -> empty", () async {
      final currentParamValue = ConversionParamValueModel.tuple(
        barWeightParam,
        15,
        null,
        unit: kilogram,
      );

      await testCase(
        leaveEmptySelectedValue: true,
        itemValue: currentParamValue,
        expectedListFetchResult: barWeightParamKgListValues,
        expectedSelectedValue: null,
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

  group("Should init list values of param 'Bar Weight' pound", () {
    test("Should preselect if empty: empty -> default value 22", () async {
      final currentParamValue = ConversionParamValueModel.tuple(
        barWeightParam,
        null,
        null,
        unit: pound,
      );

      await testCase(
        itemValue: currentParamValue,
        expectedListFetchResult: barWeightParamPoundListValues.copyWith(
          selectedItem: const Patchable(
            ValueModel(raw: '10', alt: '22', numVal: 10),
          ),
        ),
        expectedSelectedValue:
            const ValueModel(raw: '10', alt: '22', numVal: 10),
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

    test("Should NOT preselect if empty: empty -> empty", () async {
      final currentParamValue = ConversionParamValueModel.tuple(
        barWeightParam,
        null,
        null,
        unit: pound,
      );

      await testCase(
        leaveEmptySelectedValue: true,
        itemValue: currentParamValue,
        expectedListFetchResult: barWeightParamPoundListValues,
        expectedSelectedValue: null,
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

    test("Should leave known value: 44 -> 44", () async {
      final currentParamValue = ConversionParamValueModel.tuple(
        barWeightParam,
        const ValueModel(raw: '20', alt: '44', numVal: 20),
        null,
        unit: pound,
      );

      await testCase(
        itemValue: currentParamValue,
        expectedListFetchResult: barWeightParamPoundListValues.copyWith(
          selectedItem: const Patchable(
            ValueModel(raw: '20', alt: '44', numVal: 20),
          ),
        ),
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

    test("Should leave unknown value: 15 -> 15", () async {
      final currentParamValue = ConversionParamValueModel.tuple(
        barWeightParam,
        15,
        null,
        unit: pound,
      );

      await testCase(
        leaveUnknownSelectedValue: true,
        itemValue: currentParamValue,
        expectedListFetchResult: barWeightParamPoundListValues.copyWith(
          selectedItem: Patchable(
            ValueModel.num(15),
          ),
        ),
        expectedSelectedValue: ValueModel.num(15),
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

    test("Should replace unknown value: 15 -> default value 22", () async {
      final currentParamValue = ConversionParamValueModel.tuple(
        barWeightParam,
        15,
        null,
        unit: pound,
      );

      await testCase(
        itemValue: currentParamValue,
        expectedListFetchResult: barWeightParamPoundListValues.copyWith(
          selectedItem: const Patchable(
            ValueModel(raw: '10', alt: '22', numVal: 10),
          ),
        ),
        expectedSelectedValue:
            const ValueModel(raw: '10', alt: '22', numVal: 10),
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

    test("Should erase unknown value: 15 -> empty", () async {
      final currentParamValue = ConversionParamValueModel.tuple(
        barWeightParam,
        15,
        null,
        unit: pound,
      );

      await testCase(
        leaveEmptySelectedValue: true,
        itemValue: currentParamValue,
        expectedListFetchResult: barWeightParamPoundListValues,
        expectedSelectedValue: null,
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
    test("Should preselect if empty: empty -> 'Shirt'", () async {
      final currentParamValue =
          ConversionParamValueModel.tuple(garmentParam, null, null);

      await testCase(
        itemValue: currentParamValue,
        expectedListFetchResult: garmentParamListValues.copyWith(
          selectedItem: Patchable(
            ValueModel.str('Shirt'),
          ),
        ),
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

    test("Should NOT preselect if empty: empty -> empty", () async {
      final currentParamValue =
          ConversionParamValueModel.tuple(garmentParam, null, null);

      await testCase(
        leaveEmptySelectedValue: true,
        itemValue: currentParamValue,
        expectedListFetchResult: garmentParamListValues,
        expectedSelectedValue: null,
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

    test("Should leave known value: 'Shirt' -> 'Shirt'", () async {
      final currentParamValue = ConversionParamValueModel.tuple(
        garmentParam,
        'Shirt',
        null,
      );

      await testCase(
        itemValue: currentParamValue,
        expectedListFetchResult: garmentParamListValues.copyWith(
          selectedItem: Patchable(
            ValueModel.str('Shirt'),
          ),
        ),
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

    test("Should leave unknown value: 'Pants' -> 'Pants'", () async {
      final currentParamValue = ConversionParamValueModel.tuple(
        garmentParam,
        'Pants',
        null,
      );

      await testCase(
        leaveUnknownSelectedValue: true,
        itemValue: currentParamValue,
        expectedListFetchResult: garmentParamListValues.copyWith(
          selectedItem: Patchable(
            ValueModel.str('Pants'),
          ),
        ),
        expectedSelectedValue: ValueModel.str('Pants'),
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

    test("Should replace unknown value: 'Pants' -> default value 'Shirt'",
        () async {
      final currentParamValue = ConversionParamValueModel.tuple(
        garmentParam,
        'Pants',
        null,
      );

      await testCase(
        itemValue: currentParamValue,
        expectedListFetchResult: garmentParamListValues.copyWith(
          selectedItem: Patchable(
            ValueModel.str('Shirt'),
          ),
        ),
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

    test("Should erase unknown value: 'Pants' -> empty", () async {
      final currentParamValue = ConversionParamValueModel.tuple(
        garmentParam,
        'Pants',
        null,
      );

      await testCase(
        leaveEmptySelectedValue: true,
        itemValue: currentParamValue,
        expectedListFetchResult: garmentParamListValues,
        expectedSelectedValue: null,
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

  group("Should init list values of param 'Source / Bank'", () {
    test("Should preselect if empty: empty -> 'FloatRates'", () async {
      final currentParamValue = ConversionParamValueModel.tuple(
          exchangeRateSourceBankParam, null, null);

      when(
        mockitoNetworkRepository.fetchListValues(
          listType: ConvertouchListType.exchangeRateSource,
          conversionGroupName: GroupNames.currency,
          params: anyNamed('params'),
          pageSize: listValuesPageSize,
          pageNum: 0,
        ),
      ).thenAnswer(
        (_) async => const Right([
          ValueModel.rawStr('FloatRates', iconUri: IconKeys.dataSource),
        ]),
      );

      await testCase(
        leaveUnknownSelectedValue: true,
        itemValue: currentParamValue,
        conversionGroupName: GroupNames.currency,
        expectedListFetchResult: exchangeRateSources.copyWith(
          selectedItem: const Patchable(
            ValueModel.rawStr(
              'FloatRates',
              iconUri: IconKeys.dataSource,
            ),
          ),
        ),
        expectedSelectedValue: const ValueModel.rawStr(
          'FloatRates',
          iconUri: IconKeys.dataSource,
        ),
        paramSetValue: ConversionParamSetValueModel(
          paramSet: exchangeRateParamSet,
          paramValues: [
            currentParamValue,
          ],
        ),
      );
    });
  });
}
