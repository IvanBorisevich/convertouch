import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/convert_unit_values_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/remove_param_sets_from_conversion_use_case.dart';
import 'package:test/test.dart';

import '../../model/mock/mock_param.dart';
import '../../model/mock/mock_unit.dart';
import '../../model/mock/mock_unit_group.dart';
import 'helpers/helpers.dart';

void main() {
  late RemoveParamSetsFromConversionUseCase useCase;

  setUp(() {
    useCase = const RemoveParamSetsFromConversionUseCase(
      convertUnitValuesUseCase: ConvertUnitValuesUseCase(),
    );
  });

  group("Remove selected param set", () {
    group("It is optional", () {
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
        group("Remove the first param set", () {
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
                          circumferenceParam, null, 1,
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
                ConversionUnitValueModel.tuple(frRingSize, null, null),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: ringSizeByCircumferenceParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(
                          circumferenceParam, null, 1,
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
                          circumferenceParam, null, 1,
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
                          circumferenceParam, null, 1,
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

        group("Remove the last param set", () {
          test('Conversion has unit values (should be recalculated)', () async {
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
                          circumferenceParam, null, 1,
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
              currentSrc: ConversionUnitValueModel.tuple(usaRingSize, 3, null),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(usaRingSize, 3, null),
                ConversionUnitValueModel.tuple(frRingSize, null, null),
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
                          circumferenceParam, null, 1,
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
      });
    });

    group("It is mandatory (should not be removed)", () {
      test('Conversion has unit values (should not be changed)', () async {
        await testCase(
          unitGroup: clothingSizeGroup,
          useCase: useCase,
          delta: const RemoveParamSetsDelta.current(),
          currentParams: ConversionParamSetValueBulkModel(
            paramSetValues: [
              ConversionParamSetValueModel(
                paramSet: clothingSizeParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(genderParam, "Male", null),
                  ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
                  ConversionParamValueModel.tuple(heightParam, 150, 1,
                      unit: centimeter),
                ],
              )
            ],
          ),
          currentSrc: ConversionUnitValueModel.tuple(japanClothSize, 3, null),
          currentUnitValues: [
            ConversionUnitValueModel.tuple(japanClothSize, 3, null),
            ConversionUnitValueModel.tuple(italianClothSize, 36, null),
          ],
          expectedSrc: ConversionUnitValueModel.tuple(japanClothSize, 3, null),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(japanClothSize, 3, null),
            ConversionUnitValueModel.tuple(italianClothSize, 36, null),
          ],
          expectedParams: ConversionParamSetValueBulkModel(
            paramSetValues: [
              ConversionParamSetValueModel(
                paramSet: clothingSizeParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(genderParam, "Male", null),
                  ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
                  ConversionParamValueModel.tuple(heightParam, 150, 1,
                      unit: centimeter),
                ],
              )
            ],
          ),
        );
      });

      test('Conversion does not have unit values', () async {
        await testCase(
          unitGroup: clothingSizeGroup,
          useCase: useCase,
          delta: const RemoveParamSetsDelta.current(),
          currentParams: ConversionParamSetValueBulkModel(
            paramSetValues: [
              ConversionParamSetValueModel(
                paramSet: clothingSizeParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(genderParam, "Male", null),
                  ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
                  ConversionParamValueModel.tuple(heightParam, 150, 1,
                      unit: centimeter),
                ],
              )
            ],
          ),
          currentUnitValues: [],
          expectedUnitValues: [],
          expectedParams: ConversionParamSetValueBulkModel(
            paramSetValues: [
              ConversionParamSetValueModel(
                paramSet: clothingSizeParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(genderParam, "Male", null),
                  ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
                  ConversionParamValueModel.tuple(heightParam, 150, 1,
                      unit: centimeter),
                ],
              )
            ],
          ),
        );
      });
    });
  });

  group("Remove all param sets", () {
    group("Mandatory param set exists (should not be removed)", () {
      test('Conversion has unit values (should not be changed)', () async {
        await testCase(
          unitGroup: clothingSizeGroup,
          useCase: useCase,
          delta: const RemoveParamSetsDelta.all(),
          currentParams: ConversionParamSetValueBulkModel(
            paramSetValues: [
              ConversionParamSetValueModel(
                paramSet: clothingSizeParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(genderParam, "Male", null),
                  ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
                  ConversionParamValueModel.tuple(heightParam, 150, 1,
                      unit: centimeter),
                ],
              )
            ],
          ),
          currentSrc: ConversionUnitValueModel.tuple(japanClothSize, 3, null),
          currentUnitValues: [
            ConversionUnitValueModel.tuple(japanClothSize, 3, null),
            ConversionUnitValueModel.tuple(italianClothSize, 36, null),
          ],
          expectedSrc: ConversionUnitValueModel.tuple(japanClothSize, 3, null),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(japanClothSize, 3, null),
            ConversionUnitValueModel.tuple(italianClothSize, 36, null),
          ],
          expectedParams: ConversionParamSetValueBulkModel(
            paramSetValues: [
              ConversionParamSetValueModel(
                paramSet: clothingSizeParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(genderParam, "Male", null),
                  ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
                  ConversionParamValueModel.tuple(heightParam, 150, 1,
                      unit: centimeter),
                ],
              )
            ],
          ),
        );
      });

      test('Conversion does not have unit values', () async {
        await testCase(
          unitGroup: clothingSizeGroup,
          useCase: useCase,
          delta: const RemoveParamSetsDelta.all(),
          currentParams: ConversionParamSetValueBulkModel(
            paramSetValues: [
              ConversionParamSetValueModel(
                paramSet: clothingSizeParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(genderParam, "Male", null),
                  ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
                  ConversionParamValueModel.tuple(heightParam, 150, 1,
                      unit: centimeter),
                ],
              )
            ],
          ),
          currentUnitValues: [],
          expectedUnitValues: [],
          expectedParams: ConversionParamSetValueBulkModel(
            paramSetValues: [
              ConversionParamSetValueModel(
                paramSet: clothingSizeParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(genderParam, "Male", null),
                  ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
                  ConversionParamValueModel.tuple(heightParam, 150, 1,
                      unit: centimeter),
                ],
              )
            ],
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
