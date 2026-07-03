import 'package:convertouch/data/repositories/list_value_repository_impl.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/dynamic_data_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_non_list_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_unit_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/update_conversion_coefficients_use_case.dart';
import 'package:convertouch/domain/use_cases/dynamic_data/fetch_dynamic_value_use_use.dart';
import 'package:convertouch/domain/use_cases/list_values/fetch_list_values_use_case.dart';
import 'package:test/test.dart';

import '../../model/mock/mock_param.dart';
import '../../model/mock/mock_unit.dart';
import '../../model/mock/mock_unit_group.dart';
import '../../repositories/mock/mock_dynamic_value_repository.dart';
import '../../repositories/mock/mock_network_repository.dart';
import '../../repositories/mock/mock_unit_group_repository.dart';
import 'helpers/helpers.dart';

void main() {
  late UpdateConversionCoefficientsUseCase useCase;
  late ConversionParamSetValueBulkModel exchangeRateParams;

  setUpAll(() {
    exchangeRateParams = ConversionParamSetValueBulkModel.singleCompact(
      paramSet: exchangeRateParamSet,
      paramValues: const [
        (
          exchangeRateSourceBankParam,
          'Test bank / url',
          null,
          unit: null,
          calculated: false,
          listValuesFetchResult: null,
        )
      ],
    );

    useCase = const UpdateConversionCoefficientsUseCase(
      calculateUnitValueUseValue: CalculateUnitValueUseValue(
        calculateDefaultValueUseCase: CalculateNonListDefaultValueUseCase(
          fetchDynamicValueUseCase: FetchDynamicValueUseCase(
            dynamicValueRepository: MockDynamicValueRepository(),
          ),
        ),
        unitGroupRepository: MockUnitGroupRepository(),
        fetchListValuesUseCase: FetchListValuesUseCase(
          listValueRepository: ListValueRepositoryImpl(
            networkRepository: MockNetworkRepository(),
          ),
        ),
      ),
    );
  });

  group("Should recalculate conversion for new coefficients (Exchange Rate)",
      () {
    test(
      "Should recalculate by current src unit id "
      "(it has coefficient in the fetch response)",
      () async {
        await testCaseCompact(
          unitGroup: currencyGroup,
          useCase: useCase,
          delta: UpdateConversionCoefficientsDelta(
            newCoefficients: DynamicCoefficientsModel({
              usd.id: 1.0,
              eur.id: 1.2,
              aud.id: 0.7,
            }),
          ),
          currentParams: exchangeRateParams,
          currentSrc: (eur, null, null, listValuesFetchResult: null),
          currentUnitValues: [
            (usd, null, null, listValuesFetchResult: null),
            (eur, null, null, listValuesFetchResult: null),
            (aud, null, null, listValuesFetchResult: null),
            (cny, null, null, listValuesFetchResult: null)
          ],
          expectedParams: exchangeRateParams,
          expectedSrc: (
            eur.copyWith(coefficient: 1.2),
            null,
            1,
            listValuesFetchResult: null
          ),
          expectedUnitValues: [
            (
              usd.copyWith(coefficient: 1),
              null,
              1.2,
              listValuesFetchResult: null
            ),
            (
              eur.copyWith(coefficient: 1.2),
              null,
              1,
              listValuesFetchResult: null
            ),
            (
              aud.copyWith(coefficient: 0.7),
              null,
              1.2 / 0.7,
              listValuesFetchResult: null
            ),
            (cny, null, null, listValuesFetchResult: null),
          ],
        );
      },
    );

    test(
      "Should recalculate by new src unit id "
      "(the current src unit value does not have coefficient neither "
      "in the fetch response and the conversion)",
      () async {
        await testCaseCompact(
          unitGroup: currencyGroup,
          useCase: useCase,
          delta: UpdateConversionCoefficientsDelta(
            newCoefficients: DynamicCoefficientsModel({
              usd.id: 1.0,
              eur.id: 1.2,
              aud.id: 0.7,
            }),
          ),
          currentParams: exchangeRateParams,
          currentSrc: (cny, null, null, listValuesFetchResult: null),
          currentUnitValues: [
            (usd, null, null, listValuesFetchResult: null),
            (eur, null, null, listValuesFetchResult: null),
            (aud, null, null, listValuesFetchResult: null),
            (cny, null, null, listValuesFetchResult: null)
          ],
          expectedParams: exchangeRateParams,
          expectedSrc: (
            usd.copyWith(coefficient: 1),
            null,
            1,
            listValuesFetchResult: null
          ),
          expectedUnitValues: [
            (
              usd.copyWith(coefficient: 1),
              null,
              1,
              listValuesFetchResult: null
            ),
            (
              eur.copyWith(coefficient: 1.2),
              null,
              1 / 1.2,
              listValuesFetchResult: null
            ),
            (
              aud.copyWith(coefficient: 0.7),
              null,
              1 / 0.7,
              listValuesFetchResult: null
            ),
            (cny, null, null, listValuesFetchResult: null),
          ],
        );
      },
    );

    test(
      "Should NOT recalculate by current src unit id "
      "(none of conversion unit values have coefficients in the fetch response)",
      () async {
        await testCaseCompact(
          unitGroup: currencyGroup,
          useCase: useCase,
          delta: UpdateConversionCoefficientsDelta(
            newCoefficients: DynamicCoefficientsModel({
              usd.id: 1.0,
              eur.id: 1.2,
              can.id: 0.75,
            }),
          ),
          currentParams: exchangeRateParams,
          currentSrc: (aud, null, null, listValuesFetchResult: null),
          currentUnitValues: [
            (aud, null, null, listValuesFetchResult: null),
            (cny, null, null, listValuesFetchResult: null)
          ],
          expectedParams: exchangeRateParams,
          expectedSrc: (aud, null, 1, listValuesFetchResult: null),
          expectedUnitValues: [
            (aud, null, 1, listValuesFetchResult: null),
            (cny, null, null, listValuesFetchResult: null),
          ],
        );
      },
    );
  });

  group(
    "Should recalculate conversion both for new "
    "and already saved local coefficients (Exchange Rate)",
    () {
      test(
        "Should recalculate by current src unit id "
        "(it has coefficient in the conversion)",
        () async {
          await testCaseCompact(
            unitGroup: currencyGroup,
            useCase: useCase,
            delta: UpdateConversionCoefficientsDelta(
              newCoefficients: DynamicCoefficientsModel({
                usd.id: 1.0,
                cny.id: 0.4,
                aud.id: 0.7,
              }),
            ),
            currentParams: exchangeRateParams,
            currentSrc: (
              eur.copyWith(coefficient: 1.2),
              null,
              null,
              listValuesFetchResult: null
            ),
            currentUnitValues: [
              (usd, null, null, listValuesFetchResult: null),
              (cny, null, null, listValuesFetchResult: null),
              (
                eur.copyWith(coefficient: 1.2),
                null,
                null,
                listValuesFetchResult: null
              ),
              (aud, null, null, listValuesFetchResult: null),
            ],
            expectedParams: exchangeRateParams,
            expectedSrc: (
              eur.copyWith(coefficient: 1.2),
              null,
              1,
              listValuesFetchResult: null
            ),
            expectedUnitValues: [
              (
                usd.copyWith(coefficient: 1),
                null,
                1.2,
                listValuesFetchResult: null
              ),
              (
                cny.copyWith(coefficient: 0.4),
                null,
                1.2 / 0.4,
                listValuesFetchResult: null,
              ),
              (
                eur.copyWith(coefficient: 1.2),
                null,
                1,
                listValuesFetchResult: null
              ),
              (
                aud.copyWith(coefficient: 0.7),
                null,
                1.2 / 0.7,
                listValuesFetchResult: null
              ),
            ],
          );
        },
      );

      test(
        "Should recalculate by new src unit id "
        "(the current src unit value does not have coefficient neither "
        "in the fetch response and the conversion)",
        () async {
          await testCaseCompact(
            unitGroup: currencyGroup,
            useCase: useCase,
            delta: UpdateConversionCoefficientsDelta(
              newCoefficients: DynamicCoefficientsModel({
                usd.id: 1.0,
                cny.id: 0.4,
                aud.id: 0.7,
              }),
            ),
            currentParams: exchangeRateParams,
            currentSrc: (
              can,
              null,
              null,
              listValuesFetchResult: null,
            ),
            currentUnitValues: [
              (
                can,
                null,
                null,
                listValuesFetchResult: null,
              ),
              (
                eur.copyWith(coefficient: 1.2),
                null,
                null,
                listValuesFetchResult: null,
              ),
              (
                aud,
                null,
                null,
                listValuesFetchResult: null,
              ),
              (
                usd,
                null,
                null,
                listValuesFetchResult: null,
              )
            ],
            expectedParams: exchangeRateParams,
            expectedSrc: (
              aud.copyWith(coefficient: 0.7),
              null,
              1,
              listValuesFetchResult: null
            ),
            expectedUnitValues: [
              (
                can,
                null,
                null,
                listValuesFetchResult: null,
              ),
              (
                eur.copyWith(coefficient: 1.2),
                null,
                0.7 / 1.2,
                listValuesFetchResult: null
              ),
              (
                aud.copyWith(coefficient: 0.7),
                null,
                1,
                listValuesFetchResult: null
              ),
              (
                usd.copyWith(coefficient: 1),
                null,
                0.7,
                listValuesFetchResult: null
              ),
            ],
          );
        },
      );
    },
  );
}
