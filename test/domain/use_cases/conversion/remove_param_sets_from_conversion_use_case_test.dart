import 'dart:math';

import 'package:convertouch/data/repositories/local/list_value_repository_impl.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_source_item_by_params_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/remove_param_sets_from_conversion_use_case.dart';
import 'package:test/test.dart';

import '../../model/mock/mock_param.dart';
import '../../model/mock/mock_unit.dart';
import '../../model/mock/mock_unit_group.dart';
import '../../repositories/mock/mock_dynamic_value_repository.dart';
import 'helpers/helpers.dart';

void main() {
  late RemoveParamSetsFromConversionUseCase useCase;

  setUp(() {
    useCase = const RemoveParamSetsFromConversionUseCase(
      calculateSourceItemByParamsUseCase: CalculateSourceItemByParamsUseCase(
        calculateDefaultValueUseCase: CalculateDefaultValueUseCase(
          dynamicValueRepository: MockDynamicValueRepository(),
          listValueRepository: ListValueRepositoryImpl(),
        ),
      ),
    );
  });

  group("Remove selected param set", () {
    group("Remove optional", () {
      group("Conversion has one param set", () {
        test('Conversion has unit values (should not be changed)', () async {
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
              paramSetsCanBeRemovedInBulk: true,
              paramSetsCanBeAdded: true,
              selectedIndex: 0,
              totalCount: 2,
            ),
            currentSrc: ConversionUnitValueModel.tuple(usaRingSize, 3, null),
            currentUnitValues: [
              ConversionUnitValueModel.tuple(usaRingSize, 3, null),
              ConversionUnitValueModel.tuple(frRingSize, 44, null),
            ],
            expectedSrc: ConversionUnitValueModel.tuple(usaRingSize, 3, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(usaRingSize, 3, null),
              ConversionUnitValueModel.tuple(frRingSize, 44, null),
            ],
            expectedParams: const ConversionParamSetValueBulkModel(
              paramSetValues: [],
              selectedParamSetCanBeRemoved: false,
              paramSetsCanBeRemovedInBulk: false,
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
              paramSetsCanBeRemovedInBulk: true,
              paramSetsCanBeAdded: true,
              selectedIndex: 0,
              totalCount: 2,
            ),
            currentUnitValues: [],
            expectedUnitValues: [],
            expectedParams: const ConversionParamSetValueBulkModel(
              paramSetValues: [],
              selectedParamSetCanBeRemoved: false,
              paramSetsCanBeRemovedInBulk: false,
              paramSetsCanBeAdded: true,
              selectedIndex: -1,
              totalCount: 2,
            ),
          );
        });
      });

      group("Conversion has several param sets", () {
        group("Remove the first param set - another set is applicable", () {
          test('Conversion has unit values (should be changed)', () async {
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
                paramSetsCanBeRemovedInBulk: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 2,
              ),
              currentSrc: ConversionUnitValueModel.tuple(usaRingSize, 3, null),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(usaRingSize, 3, null),
                ConversionUnitValueModel.tuple(frRingSize, 44, null),
              ],
              expectedSrc: ConversionUnitValueModel.tuple(usaRingSize, 4, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(usaRingSize, 4, null),
                ConversionUnitValueModel.tuple(frRingSize, 46.5, null),
              ],
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
                paramSetsCanBeRemovedInBulk: true,
                paramSetsCanBeAdded: true,
                selectedIndex: 0,
                totalCount: 2,
              ),
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
                paramSetsCanBeRemovedInBulk: true,
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
                paramSetsCanBeRemovedInBulk: true,
                paramSetsCanBeAdded: true,
                selectedIndex: 0,
                totalCount: 2,
              ),
            );
          });
        });

        group("Remove the first param set - another set is not applicable", () {
          test('Conversion has unit values (should be changed to defaults)',
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
                paramSetsCanBeRemovedInBulk: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 2,
              ),
              currentSrc: ConversionUnitValueModel.tuple(usaRingSize, 3, null),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(usaRingSize, 3, null),
                ConversionUnitValueModel.tuple(frRingSize, 44, null),
              ],
              expectedSrc: ConversionUnitValueModel.tuple(usaRingSize, 3, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(usaRingSize, 3, null),
                ConversionUnitValueModel.tuple(frRingSize, 44, null),
              ],
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
                paramSetsCanBeRemovedInBulk: true,
                paramSetsCanBeAdded: true,
                selectedIndex: 0,
                totalCount: 2,
              ),
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
                paramSetsCanBeRemovedInBulk: true,
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
                paramSetsCanBeRemovedInBulk: true,
                paramSetsCanBeAdded: true,
                selectedIndex: 0,
                totalCount: 2,
              ),
            );
          });
        });

        group("Remove the last param set - another set is applicable", () {
          test('Conversion has unit values (should be changed)', () async {
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
                paramSetsCanBeRemovedInBulk: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 1,
                totalCount: 2,
              ),
              currentSrc: ConversionUnitValueModel.tuple(usaRingSize, 4, null),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(usaRingSize, 4, null),
                ConversionUnitValueModel.tuple(frRingSize, 46.5, null),
              ],
              expectedSrc: ConversionUnitValueModel.tuple(usaRingSize, 3, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(usaRingSize, 3, null),
                ConversionUnitValueModel.tuple(frRingSize, 44, null),
              ],
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
                paramSetsCanBeRemovedInBulk: true,
                paramSetsCanBeAdded: true,
                selectedIndex: 0,
                totalCount: 2,
              ),
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
                paramSetsCanBeRemovedInBulk: true,
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
                paramSetsCanBeRemovedInBulk: true,
                paramSetsCanBeAdded: true,
                selectedIndex: 0,
                totalCount: 2,
              ),
            );
          });
        });

        group("Remove the last param set - another set is not applicable", () {
          test('Conversion has unit values (should not be changed)', () async {
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
                paramSetsCanBeRemovedInBulk: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 1,
                totalCount: 2,
              ),
              currentSrc: ConversionUnitValueModel.tuple(usaRingSize, 4, null),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(usaRingSize, 4, null),
                ConversionUnitValueModel.tuple(frRingSize, 46.5, null),
              ],
              expectedSrc: ConversionUnitValueModel.tuple(usaRingSize, 4, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(usaRingSize, 4, null),
                ConversionUnitValueModel.tuple(frRingSize, 46.5, null),
              ],
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
                paramSetsCanBeRemovedInBulk: true,
                paramSetsCanBeAdded: true,
                selectedIndex: 0,
                totalCount: 2,
              ),
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
                paramSetsCanBeRemovedInBulk: true,
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
                paramSetsCanBeRemovedInBulk: true,
                paramSetsCanBeAdded: true,
                selectedIndex: 0,
                totalCount: 2,
              ),
            );
          });
        });
      });
    });

    group("Remove mandatory (should not be removed)", () {
      test('Conversion has unit values (should not be changed)', () async {
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
                  ConversionParamValueModel.tuple(heightParam, 150, 1,
                      unit: centimeter),
                ],
              )
            ],
            selectedIndex: 0,
          ),
          currentSrc: ConversionUnitValueModel.tuple(japanClothSize, 'S', null),
          currentUnitValues: [
            ConversionUnitValueModel.tuple(japanClothSize, 'S', null),
            ConversionUnitValueModel.tuple(italianClothSize, 42, null),
          ],
          expectedSrc:
              ConversionUnitValueModel.tuple(japanClothSize, 'S', null),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(japanClothSize, 'S', null),
            ConversionUnitValueModel.tuple(italianClothSize, 42, null),
          ],
          expectedParams: ConversionParamSetValueBulkModel(
            paramSetValues: [
              ConversionParamSetValueModel(
                paramSet: clothesSizeParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(personParam, "Man", null),
                  ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
                  ConversionParamValueModel.tuple(heightParam, 150, 1,
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
                  ConversionParamValueModel.tuple(heightParam, 150, 1,
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
                  ConversionParamValueModel.tuple(heightParam, 150, 1,
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
    group("Mandatory param set exists (should not be removed)", () {
      test('Conversion has unit values (should not be changed)', () async {
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
                  ConversionParamValueModel.tuple(heightParam, 150, 1,
                      unit: centimeter),
                ],
              )
            ],
            selectedIndex: 0,
          ),
          currentSrc: ConversionUnitValueModel.tuple(japanClothSize, 'S', null),
          currentUnitValues: [
            ConversionUnitValueModel.tuple(japanClothSize, 'S', null),
            ConversionUnitValueModel.tuple(italianClothSize, 42, null),
          ],
          expectedSrc:
              ConversionUnitValueModel.tuple(japanClothSize, 'S', null),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(japanClothSize, 'S', null),
            ConversionUnitValueModel.tuple(italianClothSize, 42, null),
          ],
          expectedParams: ConversionParamSetValueBulkModel(
            paramSetValues: [
              ConversionParamSetValueModel(
                paramSet: clothesSizeParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(personParam, "Man", null),
                  ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
                  ConversionParamValueModel.tuple(heightParam, 150, 1,
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
          delta: const RemoveParamSetsDelta.all(),
          currentParams: ConversionParamSetValueBulkModel(
            paramSetValues: [
              ConversionParamSetValueModel(
                paramSet: clothesSizeParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(personParam, "Man", null),
                  ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
                  ConversionParamValueModel.tuple(heightParam, 150, 1,
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
                  ConversionParamValueModel.tuple(heightParam, 150, 1,
                      unit: centimeter),
                ],
              )
            ],
            selectedIndex: 0,
          ),
        );
      });
    });

    group("Mandatory param set does not exist", () {
      test('Conversion has unit values (should not be changed)', () async {
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
            paramSetsCanBeRemovedInBulk: true,
            paramSetsCanBeAdded: true,
            selectedIndex: 0,
            totalCount: 2,
          ),
          currentSrc: ConversionUnitValueModel.tuple(usaRingSize, 3, null),
          currentUnitValues: [
            ConversionUnitValueModel.tuple(usaRingSize, 3, null),
            ConversionUnitValueModel.tuple(frRingSize, 44, null),
          ],
          expectedSrc: ConversionUnitValueModel.tuple(usaRingSize, 3, null),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(usaRingSize, 3, null),
            ConversionUnitValueModel.tuple(frRingSize, 44, null),
          ],
          expectedParams: const ConversionParamSetValueBulkModel(
            paramSetValues: [],
            selectedParamSetCanBeRemoved: false,
            paramSetsCanBeRemovedInBulk: false,
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
            paramSetsCanBeRemovedInBulk: true,
            paramSetsCanBeAdded: true,
            selectedIndex: 0,
            totalCount: 2,
          ),
          currentUnitValues: [],
          expectedUnitValues: [],
          expectedParams: const ConversionParamSetValueBulkModel(
            paramSetValues: [],
            selectedParamSetCanBeRemoved: false,
            paramSetsCanBeRemovedInBulk: false,
            paramSetsCanBeAdded: true,
            selectedIndex: -1,
            totalCount: 2,
          ),
        );
      });
    });
  });
}
