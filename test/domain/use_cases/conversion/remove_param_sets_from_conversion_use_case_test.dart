import 'dart:math';

import 'package:convertouch/data/repositories/local/list_value_repository_impl.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/num_range.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_unit_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/init_item_list_values_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/remove_param_sets_from_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/list_values/fetch_list_values_use_case.dart';
import 'package:test/test.dart';

import '../../model/mock/mock_list_values_batch.dart';
import '../../model/mock/mock_param.dart';
import '../../model/mock/mock_unit.dart';
import '../../model/mock/mock_unit_group.dart';
import '../../repositories/mock/mock_dynamic_value_repository.dart';
import '../../repositories/mock/mock_network_repository.dart';
import '../../repositories/mock/mock_unit_group_repository.dart';
import 'helpers/helpers.dart';

void main() {
  late RemoveParamSetsFromConversionUseCase useCase;

  setUpAll(() {
    const listValueRepository = ListValueRepositoryImpl(
      networkRepository: MockNetworkRepository(),
    );

    useCase = const RemoveParamSetsFromConversionUseCase(
        calculateUnitValueUseValue: CalculateUnitValueUseValue(
      calculateDefaultValueUseCase: CalculateDefaultValueUseCase(
        dynamicValueRepository: MockDynamicValueRepository(),
        listValueRepository: listValueRepository,
      ),
      initUnitListValuesUseCase: InitUnitListValuesUseCase(
        fetchListValuesUseCase: FetchListValuesUseCase(
          listValueRepository: listValueRepository,
        ),
      ),
      unitGroupRepository: MockUnitGroupRepository(),
    ));
  });

  group("Remove selected param set", () {
    group("Remove optional", () {
      group("Conversion has one param set", () {
        test(
            'Should remove the only current optional param set, '
            'should leave the same unit values', () async {
          await testCase(
            unitGroup: ringSizeGroup,
            useCase: useCase,
            delta: const RemoveParamSetsDelta.current(),
            currentParams: ConversionParamSetValueBulkModel(
              paramSetValues: [
                ConversionParamSetValueModel(
                  paramSet: ringSizeByDiameterParamSet,
                  paramValues: [
                    ConversionParamValueModel.tuple(diameterParam, 14, 1,
                        unit: millimeter)
                  ],
                ),
              ],
              selectedParamSetCanBeRemoved: true,
              optionalParamSetsExist: true,
              paramSetsCanBeAdded: true,
              selectedIndex: 0,
              totalCount: 2,
            ),
            currentSrc: ConversionUnitValueModel.tuple(
              usaRingSize,
              3,
              null,
              listValues: usaRingSizes,
            ),
            currentUnitValues: [
              ConversionUnitValueModel.tuple(
                usaRingSize,
                3,
                null,
                listValues: usaRingSizes,
              ),
              ConversionUnitValueModel.tuple(
                frRingSize,
                44,
                null,
                listValues: frRingSizes,
              ),
            ],
            expectedSrc: ConversionUnitValueModel.tuple(
              usaRingSize,
              3,
              null,
              listValues: usaRingSizes,
            ),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(
                usaRingSize,
                3,
                null,
                listValues: usaRingSizes,
              ),
              ConversionUnitValueModel.tuple(
                frRingSize,
                44,
                null,
                listValues: frRingSizes,
              ),
            ],
            expectedParams: const ConversionParamSetValueBulkModel(
              paramSetValues: [],
              selectedParamSetCanBeRemoved: false,
              optionalParamSetsExist: false,
              paramSetsCanBeAdded: true,
              selectedIndex: -1,
              totalCount: 2,
            ),
          );
        });

        test(
            'Should remove the only current optional param set, '
            'should leave conversion empty', () async {
          await testCase(
            unitGroup: ringSizeGroup,
            useCase: useCase,
            delta: const RemoveParamSetsDelta.current(),
            currentParams: ConversionParamSetValueBulkModel(
              paramSetValues: [
                ConversionParamSetValueModel(
                  paramSet: ringSizeByDiameterParamSet,
                  paramValues: [
                    ConversionParamValueModel.tuple(diameterParam, 14, 1,
                        unit: millimeter)
                  ],
                ),
              ],
              selectedParamSetCanBeRemoved: true,
              optionalParamSetsExist: true,
              paramSetsCanBeAdded: true,
              selectedIndex: 0,
              totalCount: 2,
            ),
            currentUnitValues: [],
            expectedUnitValues: [],
            expectedParams: const ConversionParamSetValueBulkModel(
              paramSetValues: [],
              selectedParamSetCanBeRemoved: false,
              optionalParamSetsExist: false,
              paramSetsCanBeAdded: true,
              selectedIndex: -1,
              totalCount: 2,
            ),
          );
        });

        test(
            'Should remove the only current optional param set, '
            'should preselect default src value, '
            'should recalculate conversion by new default src value', () async {
          await testCase(
            unitGroup: ringSizeGroup,
            useCase: useCase,
            delta: const RemoveParamSetsDelta.current(),
            currentParams: ConversionParamSetValueBulkModel(
              paramSetValues: [
                ConversionParamSetValueModel(
                  paramSet: ringSizeByDiameterParamSet,
                  paramValues: [
                    ConversionParamValueModel.tuple(diameterParam, 14, 1,
                        unit: millimeter)
                  ],
                ),
              ],
              selectedParamSetCanBeRemoved: true,
              optionalParamSetsExist: true,
              paramSetsCanBeAdded: true,
              selectedIndex: 0,
              totalCount: 2,
            ),
            currentSrc: ConversionUnitValueModel.tuple(
              usaRingSize,
              null,
              null,
              listValues: usaRingSizes,
            ),
            currentUnitValues: [
              ConversionUnitValueModel.tuple(
                usaRingSize,
                null,
                null,
                listValues: usaRingSizes,
              ),
              ConversionUnitValueModel.tuple(
                frRingSize,
                null,
                null,
                listValues: frRingSizes,
              ),
            ],
            expectedParams: const ConversionParamSetValueBulkModel(
              paramSetValues: [],
              selectedParamSetCanBeRemoved: false,
              optionalParamSetsExist: false,
              paramSetsCanBeAdded: true,
              selectedIndex: -1,
              totalCount: 2,
            ),
            expectedSrc: ConversionUnitValueModel.tuple(
              usaRingSize,
              3,
              null,
              listValues: usaRingSizes,
            ),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(
                usaRingSize,
                3,
                null,
                listValues: usaRingSizes,
              ),
              ConversionUnitValueModel.tuple(
                frRingSize,
                44,
                null,
                listValues: frRingSizes,
              ),
            ],
          );
        });
      });

      group("Conversion has several param sets", () {
        group("Remove the first param set - another set is applicable", () {
          test(
              "Should remove current param set 'By Diameter' "
              "and make 'By Circumference' the new current one", () async {
            await testCase(
              unitGroup: ringSizeGroup,
              useCase: useCase,
              delta: const RemoveParamSetsDelta.current(),
              currentParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: ringSizeByDiameterParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(
                        diameterParam,
                        ringDiameterRangesInMm.items[0].valueModel,
                        null,
                        unit: millimeter,
                        listValues: ringDiameterRangesInMm,
                      ),
                    ],
                  ),
                  ConversionParamSetValueModel(
                    paramSet: ringSizeByCircumferenceParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(
                        circumferenceParam,
                        ringCircumferenceRangesInMm.items[2].valueModel,
                        null,
                        unit: millimeter,
                        listValues: ringCircumferenceRangesInMm,
                      ),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                optionalParamSetsExist: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 2,
              ),
              currentSrc: ConversionUnitValueModel.tuple(
                usaRingSize,
                3,
                null,
                listValues: usaRingSizes,
              ),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(
                  usaRingSize,
                  3,
                  null,
                  listValues: usaRingSizes,
                ),
                ConversionUnitValueModel.tuple(
                  frRingSize,
                  44,
                  null,
                  listValues: frRingSizes,
                ),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: ringSizeByCircumferenceParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(
                        circumferenceParam,
                        ringCircumferenceRangesInMm.items[2].valueModel,
                        null,
                        unit: millimeter,
                        listValues: ringCircumferenceRangesInMm,
                      ),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                optionalParamSetsExist: true,
                paramSetsCanBeAdded: true,
                selectedIndex: 0,
                totalCount: 2,
              ),
              expectedSrc: ConversionUnitValueModel.tuple(
                usaRingSize,
                4,
                null,
                listValues: usaRingSizes,
              ),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(
                  usaRingSize,
                  4,
                  null,
                  listValues: usaRingSizes,
                ),
                ConversionUnitValueModel.tuple(
                  frRingSize,
                  46.5,
                  null,
                  listValues: frRingSizes,
                ),
              ],
            );
          });

          test('Conversion does not have unit values', () async {
            await testCase(
              unitGroup: ringSizeGroup,
              useCase: useCase,
              delta: const RemoveParamSetsDelta.current(),
              currentParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: ringSizeByDiameterParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(diameterParam, 14, 1,
                          unit: millimeter),
                    ],
                  ),
                  ConversionParamSetValueModel(
                    paramSet: ringSizeByCircumferenceParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(
                          circumferenceParam, 15.2 * pi, 1,
                          unit: millimeter),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                optionalParamSetsExist: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 2,
              ),
              currentUnitValues: [],
              expectedUnitValues: [],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: ringSizeByCircumferenceParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(
                          circumferenceParam, 15.2 * pi, 1,
                          unit: millimeter),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                optionalParamSetsExist: true,
                paramSetsCanBeAdded: true,
                selectedIndex: 0,
                totalCount: 2,
              ),
            );
          });
        });

        group("Remove the first param set - another set is not applicable", () {
          test(
              "Should remove current param set 'By Diameter' "
              "should make 'By Circumference' the new current one, "
              "should reset conversion item values to defaults "
              "(new current param set is NOT full)", () async {
            await testCase(
              unitGroup: ringSizeGroup,
              useCase: useCase,
              delta: const RemoveParamSetsDelta.current(),
              currentParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: ringSizeByDiameterParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(
                        diameterParam,
                        ringDiameterRangesInCm.items[0].valueModel,
                        null,
                        unit: centimeter,
                        listValues: ringDiameterRangesInCm,
                      ),
                    ],
                  ),
                  ConversionParamSetValueModel(
                    paramSet: ringSizeByCircumferenceParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(
                        circumferenceParam,
                        null,
                        null,
                        unit: millimeter,
                        listValues: ringCircumferenceRangesInMm,
                      ),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                optionalParamSetsExist: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 2,
              ),
              currentSrc: ConversionUnitValueModel.tuple(
                usaRingSize,
                3,
                null,
                listValues: usaRingSizes,
              ),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(
                  usaRingSize,
                  3,
                  null,
                  listValues: usaRingSizes,
                ),
                ConversionUnitValueModel.tuple(
                  frRingSize,
                  44,
                  null,
                  listValues: frRingSizes,
                ),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: ringSizeByCircumferenceParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(
                        circumferenceParam,
                        null,
                        null,
                        unit: millimeter,
                        listValues: ringCircumferenceRangesInMm,
                      ),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                optionalParamSetsExist: true,
                paramSetsCanBeAdded: true,
                selectedIndex: 0,
                totalCount: 2,
              ),
              expectedSrc: ConversionUnitValueModel.tuple(
                usaRingSize,
                3,
                null,
                listValues: usaRingSizes,
              ),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(
                  usaRingSize,
                  3,
                  null,
                  listValues: usaRingSizes,
                ),
                ConversionUnitValueModel.tuple(
                  frRingSize,
                  44,
                  null,
                  listValues: frRingSizes,
                ),
              ],
            );
          });

          test('Conversion does not have unit values', () async {
            await testCase(
              unitGroup: ringSizeGroup,
              useCase: useCase,
              delta: const RemoveParamSetsDelta.current(),
              currentParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: ringSizeByDiameterParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(diameterParam, 14, 1,
                          unit: millimeter),
                    ],
                  ),
                  ConversionParamSetValueModel(
                    paramSet: ringSizeByCircumferenceParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(
                          circumferenceParam, null, null,
                          unit: millimeter),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                optionalParamSetsExist: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 2,
              ),
              currentUnitValues: [],
              expectedUnitValues: [],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: ringSizeByCircumferenceParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(
                          circumferenceParam, null, null,
                          unit: millimeter),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                optionalParamSetsExist: true,
                paramSetsCanBeAdded: true,
                selectedIndex: 0,
                totalCount: 2,
              ),
            );
          });
        });

        group("Remove the last param set - another set is applicable", () {
          test("Should remove the last param set and select the previous one",
              () async {
            await testCase(
              unitGroup: ringSizeGroup,
              useCase: useCase,
              delta: const RemoveParamSetsDelta.current(),
              currentParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: ringSizeByDiameterParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(
                        diameterParam,
                        ringDiameterRangesInMm.items[0].valueModel,
                        null,
                        unit: millimeter,
                        listValues: ringDiameterRangesInMm,
                      ),
                    ],
                  ),
                  ConversionParamSetValueModel(
                    paramSet: ringSizeByCircumferenceParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(
                        circumferenceParam,
                        ringCircumferenceRangesInMm.items[1].valueModel,
                        null,
                        unit: millimeter,
                        listValues: ringCircumferenceRangesInMm,
                      ),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                optionalParamSetsExist: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 1,
                totalCount: 2,
              ),
              currentSrc: ConversionUnitValueModel.tuple(
                usaRingSize,
                4,
                null,
                listValues: usaRingSizes,
              ),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(
                  usaRingSize,
                  4,
                  null,
                  listValues: usaRingSizes,
                ),
                ConversionUnitValueModel.tuple(
                  frRingSize,
                  46.5,
                  null,
                  listValues: frRingSizes,
                ),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: ringSizeByDiameterParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(
                        diameterParam,
                        ringDiameterRangesInMm.items[0].valueModel,
                        null,
                        unit: millimeter,
                        listValues: ringDiameterRangesInMm,
                      ),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                optionalParamSetsExist: true,
                paramSetsCanBeAdded: true,
                selectedIndex: 0,
                totalCount: 2,
              ),
              expectedSrc: ConversionUnitValueModel.tuple(
                usaRingSize,
                3,
                null,
                listValues: usaRingSizes,
              ),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(
                  usaRingSize,
                  3,
                  null,
                  listValues: usaRingSizes,
                ),
                ConversionUnitValueModel.tuple(
                  frRingSize,
                  44,
                  null,
                  listValues: frRingSizes,
                ),
              ],
            );
          });

          test('Conversion does not have unit values', () async {
            await testCase(
              unitGroup: ringSizeGroup,
              useCase: useCase,
              delta: const RemoveParamSetsDelta.current(),
              currentParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: ringSizeByDiameterParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(diameterParam, 14, 1,
                          unit: millimeter),
                    ],
                  ),
                  ConversionParamSetValueModel(
                    paramSet: ringSizeByCircumferenceParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(
                          circumferenceParam, 15 * pi, 1,
                          unit: millimeter),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                optionalParamSetsExist: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 1,
                totalCount: 2,
              ),
              currentUnitValues: [],
              expectedUnitValues: [],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: ringSizeByDiameterParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(diameterParam, 14, 1,
                          unit: millimeter),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                optionalParamSetsExist: true,
                paramSetsCanBeAdded: true,
                selectedIndex: 0,
                totalCount: 2,
              ),
            );
          });
        });

        group("Remove the last param set - another set is not applicable", () {
          test(
              "Should remove the param set 'By Circumference', "
              "should select the param set 'By Diameter', "
              "should reset src value to default (new selected param set is NOT full)",
              () async {
            await testCase(
              unitGroup: ringSizeGroup,
              useCase: useCase,
              delta: const RemoveParamSetsDelta.current(),
              currentParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: ringSizeByDiameterParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(
                        diameterParam,
                        null,
                        null,
                        unit: millimeter,
                        listValues: ringDiameterRangesInMm,
                      ),
                    ],
                  ),
                  ConversionParamSetValueModel(
                    paramSet: ringSizeByCircumferenceParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(
                        circumferenceParam,
                        ringCircumferenceRangesInMm.items[2].valueModel,
                        null,
                        unit: millimeter,
                        listValues: ringCircumferenceRangesInMm,
                      ),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                optionalParamSetsExist: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 1,
                totalCount: 2,
              ),
              currentSrc: ConversionUnitValueModel.tuple(
                usaRingSize,
                4,
                null,
                listValues: usaRingSizes,
              ),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(
                  usaRingSize,
                  4,
                  null,
                  listValues: usaRingSizes,
                ),
                ConversionUnitValueModel.tuple(
                  frRingSize,
                  46.5,
                  null,
                  listValues: frRingSizes,
                ),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: ringSizeByDiameterParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(
                        diameterParam,
                        null,
                        null,
                        unit: millimeter,
                        listValues: ringDiameterRangesInMm,
                      ),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                optionalParamSetsExist: true,
                paramSetsCanBeAdded: true,
                selectedIndex: 0,
                totalCount: 2,
              ),
              expectedSrc: ConversionUnitValueModel.tuple(
                usaRingSize,
                3,
                null,
                listValues: usaRingSizes,
              ),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(
                  usaRingSize,
                  3,
                  null,
                  listValues: usaRingSizes,
                ),
                ConversionUnitValueModel.tuple(
                  frRingSize,
                  44,
                  null,
                  listValues: frRingSizes,
                ),
              ],
            );
          });

          test('Conversion does not have unit values', () async {
            await testCase(
              unitGroup: ringSizeGroup,
              useCase: useCase,
              delta: const RemoveParamSetsDelta.current(),
              currentParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: ringSizeByDiameterParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(diameterParam, null, null,
                          unit: millimeter),
                    ],
                  ),
                  ConversionParamSetValueModel(
                    paramSet: ringSizeByCircumferenceParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(
                          circumferenceParam, 15 * pi, 1,
                          unit: millimeter),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                optionalParamSetsExist: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 1,
                totalCount: 2,
              ),
              currentUnitValues: [],
              expectedUnitValues: [],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: ringSizeByDiameterParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(diameterParam, null, null,
                          unit: millimeter),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                optionalParamSetsExist: true,
                paramSetsCanBeAdded: true,
                selectedIndex: 0,
                totalCount: 2,
              ),
            );
          });
        });
      });
    });

    group("Remove mandatory param set (should not be removed)", () {
      test('Should NOT remove mandatory param set', () async {
        await testCase(
          unitGroup: clothesSizeGroup,
          useCase: useCase,
          delta: const RemoveParamSetsDelta.current(),
          currentParams: ConversionParamSetValueBulkModel(
            paramSetValues: [
              ConversionParamSetValueModel(
                paramSet: clothesSizeParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(personParam, "Man", null),
                  ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
                  ConversionParamValueModel.tuple(
                      heightParam, const NumRange.withRight(0, 164), null,
                      unit: centimeter),
                ],
              )
            ],
            selectedIndex: 0,
          ),
          currentSrc: ConversionUnitValueModel.tuple(
            japanClothSize,
            'S',
            null,
            listValues: japanClothesSizes,
          ),
          currentUnitValues: [
            ConversionUnitValueModel.tuple(
              japanClothSize,
              'S',
              null,
              listValues: japanClothesSizes,
            ),
            ConversionUnitValueModel.tuple(
              italianClothSize,
              42,
              null,
              listValues: italianClothesSizes,
            ),
          ],
          expectedSrc: ConversionUnitValueModel.tuple(
            japanClothSize,
            'S',
            null,
            listValues: japanClothesSizes,
          ),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(
              japanClothSize,
              'S',
              null,
              listValues: japanClothesSizes,
            ),
            ConversionUnitValueModel.tuple(
              italianClothSize,
              42,
              null,
              listValues: italianClothesSizes,
            ),
          ],
          expectedParams: ConversionParamSetValueBulkModel(
            paramSetValues: [
              ConversionParamSetValueModel(
                paramSet: clothesSizeParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(personParam, "Man", null),
                  ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
                  ConversionParamValueModel.tuple(
                      heightParam, const NumRange.withRight(0, 164), null,
                      unit: centimeter),
                ],
              )
            ],
            selectedIndex: 0,
          ),
        );
      });

      test('Conversion does not have unit values', () async {
        await testCase(
          unitGroup: clothesSizeGroup,
          useCase: useCase,
          delta: const RemoveParamSetsDelta.current(),
          currentParams: ConversionParamSetValueBulkModel(
            paramSetValues: [
              ConversionParamSetValueModel(
                paramSet: clothesSizeParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(personParam, "Man", null),
                  ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
                  ConversionParamValueModel.tuple(
                      heightParam, const NumRange.withRight(0, 164), null,
                      unit: centimeter),
                ],
              )
            ],
            selectedIndex: 0,
          ),
          currentUnitValues: [],
          expectedUnitValues: [],
          expectedParams: ConversionParamSetValueBulkModel(
            paramSetValues: [
              ConversionParamSetValueModel(
                paramSet: clothesSizeParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(personParam, "Man", null),
                  ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
                  ConversionParamValueModel.tuple(
                      heightParam, const NumRange.withRight(0, 164), null,
                      unit: centimeter),
                ],
              )
            ],
            selectedIndex: 0,
          ),
        );
      });
    });
  });

  group("Remove all param sets", () {
    group("Mandatory param set exists", () {
      test("Should NOT remove mandatory param set, "
          "should leave the same conversion", () async {
        await testCase(
          unitGroup: clothesSizeGroup,
          useCase: useCase,
          delta: const RemoveParamSetsDelta.all(),
          currentParams: ConversionParamSetValueBulkModel(
            paramSetValues: [
              ConversionParamSetValueModel(
                paramSet: clothesSizeParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(personParam, "Man", null),
                  ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
                  ConversionParamValueModel.tuple(
                      heightParam, const NumRange.withRight(0, 164), null,
                      unit: centimeter),
                ],
              )
            ],
            selectedIndex: 0,
          ),
          currentSrc: ConversionUnitValueModel.tuple(
            japanClothSize,
            'S',
            null,
            listValues: japanClothesSizes,
          ),
          currentUnitValues: [
            ConversionUnitValueModel.tuple(
              japanClothSize,
              'S',
              null,
              listValues: japanClothesSizes,
            ),
            ConversionUnitValueModel.tuple(
              italianClothSize,
              42,
              null,
              listValues: italianClothesSizes,
            ),
          ],
          expectedParams: ConversionParamSetValueBulkModel(
            paramSetValues: [
              ConversionParamSetValueModel(
                paramSet: clothesSizeParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(personParam, "Man", null),
                  ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
                  ConversionParamValueModel.tuple(
                      heightParam, const NumRange.withRight(0, 164), null,
                      unit: centimeter),
                ],
              )
            ],
            selectedIndex: 0,
          ),
          expectedSrc: ConversionUnitValueModel.tuple(
            japanClothSize,
            'S',
            null,
            listValues: japanClothesSizes,
          ),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(
              japanClothSize,
              'S',
              null,
              listValues: japanClothesSizes,
            ),
            ConversionUnitValueModel.tuple(
              italianClothSize,
              42,
              null,
              listValues: italianClothesSizes,
            ),
          ],
        );
      });

      test('Should NOT remove mandatory param set, '
          'should leave empty conversion', () async {
        await testCase(
          unitGroup: clothesSizeGroup,
          useCase: useCase,
          delta: const RemoveParamSetsDelta.all(),
          currentParams: ConversionParamSetValueBulkModel(
            paramSetValues: [
              ConversionParamSetValueModel(
                paramSet: clothesSizeParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(personParam, "Man", null),
                  ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
                  ConversionParamValueModel.tuple(
                      heightParam, const NumRange.withRight(0, 164), null,
                      unit: centimeter),
                ],
              )
            ],
            selectedIndex: 0,
          ),
          currentUnitValues: [],
          expectedParams: ConversionParamSetValueBulkModel(
            paramSetValues: [
              ConversionParamSetValueModel(
                paramSet: clothesSizeParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(personParam, "Man", null),
                  ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
                  ConversionParamValueModel.tuple(
                      heightParam, const NumRange.withRight(0, 164), null,
                      unit: centimeter),
                ],
              )
            ],
            selectedIndex: 0,
          ),
          expectedUnitValues: [],
        );
      });

      test('Should NOT remove mandatory param set, '
          'should remove optional param sets if any, '
          'should leave empty conversion', () async {
        await testCase(
          unitGroup: clothesSizeGroup,
          useCase: useCase,
          delta: const RemoveParamSetsDelta.all(),
          currentParams: ConversionParamSetValueBulkModel(
            paramSetValues: [
              ConversionParamSetValueModel(
                paramSet: clothesSizeParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(personParam, "Man", null),
                  ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
                  ConversionParamValueModel.tuple(
                      heightParam, const NumRange.withRight(0, 164), null,
                      unit: centimeter),
                ],
              ),
              ConversionParamSetValueModel(
                paramSet: testOptionalParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(testParam, "Test", null),
                ],
              ),
            ],
            selectedIndex: 0,
          ),
          currentUnitValues: [],
          expectedParams: ConversionParamSetValueBulkModel(
            paramSetValues: [
              ConversionParamSetValueModel(
                paramSet: clothesSizeParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(personParam, "Man", null),
                  ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
                  ConversionParamValueModel.tuple(
                      heightParam, const NumRange.withRight(0, 164), null,
                      unit: centimeter),
                ],
              )
            ],
            selectedIndex: 0,
          ),
          expectedUnitValues: [],
        );
      });
    });

    group("Mandatory param set does not exist", () {
      test("Should remove all param sets (they are all optional)", () async {
        await testCase(
          unitGroup: ringSizeGroup,
          useCase: useCase,
          delta: const RemoveParamSetsDelta.all(),
          currentParams: ConversionParamSetValueBulkModel(
            paramSetValues: [
              ConversionParamSetValueModel(
                paramSet: ringSizeByDiameterParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(diameterParam, 14, 1,
                      unit: millimeter),
                ],
              ),
              ConversionParamSetValueModel(
                paramSet: ringSizeByCircumferenceParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(circumferenceParam, null, 1,
                      unit: millimeter),
                ],
              ),
            ],
            selectedParamSetCanBeRemoved: true,
            optionalParamSetsExist: true,
            paramSetsCanBeAdded: true,
            selectedIndex: 0,
            totalCount: 2,
          ),
          currentSrc: ConversionUnitValueModel.tuple(
            usaRingSize,
            3,
            null,
            listValues: usaRingSizes,
          ),
          currentUnitValues: [
            ConversionUnitValueModel.tuple(
              usaRingSize,
              3,
              null,
              listValues: usaRingSizes,
            ),
            ConversionUnitValueModel.tuple(
              frRingSize,
              44,
              null,
              listValues: frRingSizes,
            ),
          ],
          expectedSrc: ConversionUnitValueModel.tuple(
            usaRingSize,
            3,
            null,
            listValues: usaRingSizes,
          ),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(
              usaRingSize,
              3,
              null,
              listValues: usaRingSizes,
            ),
            ConversionUnitValueModel.tuple(
              frRingSize,
              44,
              null,
              listValues: frRingSizes,
            ),
          ],
          expectedParams: const ConversionParamSetValueBulkModel(
            paramSetValues: [],
            selectedParamSetCanBeRemoved: false,
            optionalParamSetsExist: false,
            paramSetsCanBeAdded: true,
            selectedIndex: -1,
            totalCount: 2,
          ),
        );
      });

      test('Conversion does not have unit values', () async {
        await testCase(
          unitGroup: ringSizeGroup,
          useCase: useCase,
          delta: const RemoveParamSetsDelta.all(),
          currentParams: ConversionParamSetValueBulkModel(
            paramSetValues: [
              ConversionParamSetValueModel(
                paramSet: ringSizeByDiameterParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(diameterParam, 14, 1,
                      unit: millimeter),
                ],
              ),
              ConversionParamSetValueModel(
                paramSet: ringSizeByCircumferenceParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(circumferenceParam, null, 1,
                      unit: millimeter),
                ],
              ),
            ],
            selectedParamSetCanBeRemoved: true,
            optionalParamSetsExist: true,
            paramSetsCanBeAdded: true,
            selectedIndex: 0,
            totalCount: 2,
          ),
          currentUnitValues: [],
          expectedUnitValues: [],
          expectedParams: const ConversionParamSetValueBulkModel(
            paramSetValues: [],
            selectedParamSetCanBeRemoved: false,
            optionalParamSetsExist: false,
            paramSetsCanBeAdded: true,
            selectedIndex: -1,
            totalCount: 2,
          ),
        );
      });
    });
  });
}
