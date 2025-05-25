import 'package:convertouch/data/repositories/local/list_value_repository_impl.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/add_units_to_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_source_item_by_params_use_case.dart';
import 'package:test/test.dart';

import '../../model/mock/mock_param.dart';
import '../../model/mock/mock_unit.dart';
import '../../model/mock/mock_unit_group.dart';
import '../../repositories/mock/mock_dynamic_value_repository.dart';
import '../../repositories/mock/mock_unit_repository.dart';
import 'helpers/helpers.dart';

void main() {
  late AddUnitsToConversionUseCase useCase;

  setUp(() {
    useCase = const AddUnitsToConversionUseCase(
      calculateSourceItemByParamsUseCase: CalculateSourceItemByParamsUseCase(
        calculateDefaultValueUseCase: CalculateDefaultValueUseCase(
          dynamicValueRepository: MockDynamicValueRepository(),
          listValueRepository: ListValueRepositoryImpl(),
        ),
      ),
      unitRepository: MockUnitRepository(),
    );
  });

  group('By coefficients', () {
    group('Without params', () {
      test('Source item does not exist', () async {
        await testCase(
          useCase: useCase,
          delta: AddUnitsToConversionDelta(
            unitIds: [
              centimeter.id,
              kilometer.id,
              decimeter.id,
            ],
          ),
          unitGroup: lengthGroup,
          currentSrc: null,
          expectedSrc: ConversionUnitValueModel.tuple(centimeter, null, 1),
          currentUnitValues: [],
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(centimeter, null, 1),
            ConversionUnitValueModel.tuple(kilometer, null, 0.00001),
            ConversionUnitValueModel.tuple(decimeter, null, 0.1),
          ],
        );
      });

      test('Source item value and default value exist', () async {
        await testCase(
          useCase: useCase,
          delta: AddUnitsToConversionDelta(
            unitIds: [
              centimeter.id,
              kilometer.id,
            ],
          ),
          unitGroup: lengthGroup,
          currentSrc: ConversionUnitValueModel.tuple(decimeter, 10, 1),
          currentUnitValues: [
            ConversionUnitValueModel.tuple(decimeter, 10, 1),
          ],
          expectedSrc: ConversionUnitValueModel.tuple(decimeter, 10, 1),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(centimeter, 100, 10),
            ConversionUnitValueModel.tuple(kilometer, 0.001, 0.0001),
            ConversionUnitValueModel.tuple(decimeter, 10, 1),
          ],
        );
      });

      test('Source item default value exists only', () async {
        await testCase(
          useCase: useCase,
          delta: AddUnitsToConversionDelta(
            unitIds: [
              centimeter.id,
              kilometer.id,
            ],
          ),
          unitGroup: lengthGroup,
          currentSrc: ConversionUnitValueModel.tuple(decimeter, null, 1),
          currentUnitValues: [
            ConversionUnitValueModel.tuple(decimeter, null, 1),
          ],
          expectedSrc: ConversionUnitValueModel.tuple(decimeter, null, 1),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(centimeter, null, 10),
            ConversionUnitValueModel.tuple(kilometer, null, 0.0001),
            ConversionUnitValueModel.tuple(decimeter, null, 1),
          ],
        );
      });

      test('Source item value exists only', () async {
        await testCase(
          useCase: useCase,
          delta: AddUnitsToConversionDelta(
            unitIds: [
              centimeter.id,
              kilometer.id,
            ],
          ),
          unitGroup: lengthGroup,
          currentSrc: ConversionUnitValueModel.tuple(decimeter, 10, null),
          currentUnitValues: [
            ConversionUnitValueModel.tuple(decimeter, 10, null),
          ],
          expectedSrc: ConversionUnitValueModel.tuple(decimeter, 10, null),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(centimeter, 100, null),
            ConversionUnitValueModel.tuple(kilometer, 0.001, null),
            ConversionUnitValueModel.tuple(decimeter, 10, null),
          ],
        );
      });
    });
  });

  group('By formula', () {
    group('With params', () {
      group('All params are set', () {
        test('Source item does not exist', () async {
          await testCase(
            unitGroup: clothingSizeGroup,
            useCase: useCase,
            delta: AddUnitsToConversionDelta(
              unitIds: [
                japanClothSize.id,
                italianClothSize.id,
              ],
            ),
            currentParams: ConversionParamSetValueBulkModel(
              paramSetValues: [
                ConversionParamSetValueModel(
                  paramSet: clothingSizeParamSet,
                  paramValues: [
                    ConversionParamValueModel.tuple(personParam, "Man", null),
                    ConversionParamValueModel.tuple(
                        garmentParam, "Shirt", null),
                    ConversionParamValueModel.tuple(heightParam, 150, 1,
                        unit: centimeter),
                  ],
                )
              ],
              selectedIndex: 0,
            ),
            currentUnitValues: [],
            expectedSrc:
                ConversionUnitValueModel.tuple(japanClothSize, 'S', null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(japanClothSize, 'S', null),
              ConversionUnitValueModel.tuple(italianClothSize, 42, null),
            ],
            expectedParams: ConversionParamSetValueBulkModel(
              paramSetValues: [
                ConversionParamSetValueModel(
                  paramSet: clothingSizeParamSet,
                  paramValues: [
                    ConversionParamValueModel.tuple(personParam, "Man", null),
                    ConversionParamValueModel.tuple(
                        garmentParam, "Shirt", null),
                    ConversionParamValueModel.tuple(heightParam, 150, 1,
                        unit: centimeter),
                  ],
                )
              ],
              selectedIndex: 0,
            ),
          );
        });

        test(
            'Source item value and default value exist '
            '(default list value will be ignored)', () async {
          await testCase(
            unitGroup: clothingSizeGroup,
            useCase: useCase,
            delta: AddUnitsToConversionDelta(
              unitIds: [
                japanClothSize.id,
                italianClothSize.id,
              ],
            ),
            currentParams: ConversionParamSetValueBulkModel(
              paramSetValues: [
                ConversionParamSetValueModel(
                  paramSet: clothingSizeParamSet,
                  paramValues: [
                    ConversionParamValueModel.tuple(personParam, "Man", null),
                    ConversionParamValueModel.tuple(
                        garmentParam, "Shirt", null),
                    ConversionParamValueModel.tuple(heightParam, 150, 1,
                        unit: centimeter),
                  ],
                )
              ],
              selectedIndex: 0,
            ),
            currentSrc:
                ConversionUnitValueModel.tuple(europeanClothSize, 42, 42),
            currentUnitValues: [
              ConversionUnitValueModel.tuple(europeanClothSize, 42, 42),
            ],
            expectedSrc:
                ConversionUnitValueModel.tuple(europeanClothSize, 42, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(europeanClothSize, 42, null),
              ConversionUnitValueModel.tuple(japanClothSize, 'S', null),
              ConversionUnitValueModel.tuple(italianClothSize, 42, null),
            ],
            expectedParams: ConversionParamSetValueBulkModel(
              paramSetValues: [
                ConversionParamSetValueModel(
                  paramSet: clothingSizeParamSet,
                  paramValues: [
                    ConversionParamValueModel.tuple(personParam, "Man", null),
                    ConversionParamValueModel.tuple(
                        garmentParam, "Shirt", null),
                    ConversionParamValueModel.tuple(heightParam, 150, 1,
                        unit: centimeter),
                  ],
                )
              ],
              selectedIndex: 0,
            ),
          );
        });

        test(
            'Source item default value exists only '
            '(default list value will be ignored)', () async {
          await testCase(
            unitGroup: clothingSizeGroup,
            useCase: useCase,
            delta: AddUnitsToConversionDelta(
              unitIds: [
                japanClothSize.id,
                italianClothSize.id,
              ],
            ),
            currentParams: ConversionParamSetValueBulkModel(
              paramSetValues: [
                ConversionParamSetValueModel(
                  paramSet: clothingSizeParamSet,
                  paramValues: [
                    ConversionParamValueModel.tuple(personParam, "Man", null),
                    ConversionParamValueModel.tuple(
                        garmentParam, "Shirt", null),
                    ConversionParamValueModel.tuple(heightParam, 150, 1,
                        unit: centimeter),
                  ],
                )
              ],
              selectedIndex: 0,
            ),
            currentSrc:
                ConversionUnitValueModel.tuple(europeanClothSize, null, 32),
            currentUnitValues: [
              ConversionUnitValueModel.tuple(europeanClothSize, null, 32),
            ],
            expectedSrc:
                ConversionUnitValueModel.tuple(europeanClothSize, 42, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(europeanClothSize, 42, null),
              ConversionUnitValueModel.tuple(japanClothSize, 'S', null),
              ConversionUnitValueModel.tuple(italianClothSize, 42, null),
            ],
            expectedParams: ConversionParamSetValueBulkModel(
              paramSetValues: [
                ConversionParamSetValueModel(
                  paramSet: clothingSizeParamSet,
                  paramValues: [
                    ConversionParamValueModel.tuple(personParam, "Man", null),
                    ConversionParamValueModel.tuple(
                        garmentParam, "Shirt", null),
                    ConversionParamValueModel.tuple(heightParam, 150, 1,
                        unit: centimeter),
                  ],
                )
              ],
              selectedIndex: 0,
            ),
          );
        });

        test('Source item value exists only', () async {
          await testCase(
            unitGroup: clothingSizeGroup,
            useCase: useCase,
            delta: AddUnitsToConversionDelta(
              unitIds: [
                japanClothSize.id,
                italianClothSize.id,
              ],
            ),
            currentSrc:
                ConversionUnitValueModel.tuple(europeanClothSize, 42, null),
            currentParams: ConversionParamSetValueBulkModel(
              paramSetValues: [
                ConversionParamSetValueModel(
                  paramSet: clothingSizeParamSet,
                  paramValues: [
                    ConversionParamValueModel.tuple(personParam, "Man", null),
                    ConversionParamValueModel.tuple(
                        garmentParam, "Shirt", null),
                    ConversionParamValueModel.tuple(heightParam, 150, 1,
                        unit: centimeter),
                  ],
                )
              ],
              selectedIndex: 0,
            ),
            currentUnitValues: [
              ConversionUnitValueModel.tuple(europeanClothSize, 42, null)
            ],
            expectedSrc:
                ConversionUnitValueModel.tuple(europeanClothSize, 42, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(europeanClothSize, 42, null),
              ConversionUnitValueModel.tuple(japanClothSize, 'S', null),
              ConversionUnitValueModel.tuple(italianClothSize, 42, null),
            ],
            expectedParams: ConversionParamSetValueBulkModel(
              paramSetValues: [
                ConversionParamSetValueModel(
                  paramSet: clothingSizeParamSet,
                  paramValues: [
                    ConversionParamValueModel.tuple(personParam, "Man", null),
                    ConversionParamValueModel.tuple(
                        garmentParam, "Shirt", null),
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

      group('Some params are set by default', () {
        test('Source item does not exist', () async {
          await testCase(
            unitGroup: clothingSizeGroup,
            useCase: useCase,
            delta: AddUnitsToConversionDelta(
              unitIds: [
                japanClothSize.id,
                italianClothSize.id,
              ],
            ),
            currentParams: ConversionParamSetValueBulkModel(
              paramSetValues: [
                ConversionParamSetValueModel(
                  paramSet: clothingSizeParamSet,
                  paramValues: [
                    ConversionParamValueModel.tuple(personParam, "Man", null),
                    ConversionParamValueModel.tuple(
                        garmentParam, "Shirt", null),
                    ConversionParamValueModel.tuple(heightParam, null, 1,
                        unit: centimeter),
                  ],
                )
              ],
              selectedIndex: 0,
            ),
            currentUnitValues: [],
            expectedSrc:
                ConversionUnitValueModel.tuple(japanClothSize, 'S', null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(japanClothSize, 'S', null),
              ConversionUnitValueModel.tuple(italianClothSize, 42, null),
            ],
            expectedParams: ConversionParamSetValueBulkModel(
              paramSetValues: [
                ConversionParamSetValueModel(
                  paramSet: clothingSizeParamSet,
                  paramValues: [
                    ConversionParamValueModel.tuple(personParam, "Man", null),
                    ConversionParamValueModel.tuple(
                        garmentParam, "Shirt", null),
                    ConversionParamValueModel.tuple(heightParam, null, 1,
                        unit: centimeter),
                  ],
                )
              ],
              selectedIndex: 0,
            ),
          );
        });

        test(
            'Source item value and default value exist '
            '(default list value will be ignored)', () async {
          await testCase(
            unitGroup: clothingSizeGroup,
            useCase: useCase,
            delta: AddUnitsToConversionDelta(
              unitIds: [
                japanClothSize.id,
                italianClothSize.id,
              ],
            ),
            currentSrc:
                ConversionUnitValueModel.tuple(europeanClothSize, 42, 32),
            currentParams: ConversionParamSetValueBulkModel(
              paramSetValues: [
                ConversionParamSetValueModel(
                  paramSet: clothingSizeParamSet,
                  paramValues: [
                    ConversionParamValueModel.tuple(personParam, "Man", null),
                    ConversionParamValueModel.tuple(
                        garmentParam, "Shirt", null),
                    ConversionParamValueModel.tuple(heightParam, null, 1,
                        unit: centimeter),
                  ],
                )
              ],
              selectedIndex: 0,
            ),
            currentUnitValues: [
              ConversionUnitValueModel.tuple(europeanClothSize, 42, 32),
            ],
            expectedSrc:
                ConversionUnitValueModel.tuple(europeanClothSize, 42, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(europeanClothSize, 42, null),
              ConversionUnitValueModel.tuple(japanClothSize, 'S', null),
              ConversionUnitValueModel.tuple(italianClothSize, 42, null),
            ],
            expectedParams: ConversionParamSetValueBulkModel(
              paramSetValues: [
                ConversionParamSetValueModel(
                  paramSet: clothingSizeParamSet,
                  paramValues: [
                    ConversionParamValueModel.tuple(personParam, "Man", null),
                    ConversionParamValueModel.tuple(
                        garmentParam, "Shirt", null),
                    ConversionParamValueModel.tuple(heightParam, null, 1,
                        unit: centimeter),
                  ],
                )
              ],
              selectedIndex: 0,
            ),
          );
        });

        test(
            'Source item default value exists only '
            '(default list value will be ignored)', () async {
          await testCase(
            unitGroup: clothingSizeGroup,
            useCase: useCase,
            delta: AddUnitsToConversionDelta(
              unitIds: [
                japanClothSize.id,
                italianClothSize.id,
              ],
            ),
            currentParams: ConversionParamSetValueBulkModel(
              paramSetValues: [
                ConversionParamSetValueModel(
                  paramSet: clothingSizeParamSet,
                  paramValues: [
                    ConversionParamValueModel.tuple(personParam, "Man", null),
                    ConversionParamValueModel.tuple(
                        garmentParam, "Shirt", null),
                    ConversionParamValueModel.tuple(heightParam, null, 1,
                        unit: centimeter),
                  ],
                )
              ],
              selectedIndex: 0,
            ),
            currentSrc:
                ConversionUnitValueModel.tuple(europeanClothSize, null, 32),
            currentUnitValues: [
              ConversionUnitValueModel.tuple(europeanClothSize, null, 32),
            ],
            expectedSrc:
                ConversionUnitValueModel.tuple(europeanClothSize, 42, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(europeanClothSize, 42, null),
              ConversionUnitValueModel.tuple(japanClothSize, 'S', null),
              ConversionUnitValueModel.tuple(italianClothSize, 42, null),
            ],
            expectedParams: ConversionParamSetValueBulkModel(
              paramSetValues: [
                ConversionParamSetValueModel(
                  paramSet: clothingSizeParamSet,
                  paramValues: [
                    ConversionParamValueModel.tuple(personParam, "Man", null),
                    ConversionParamValueModel.tuple(
                        garmentParam, "Shirt", null),
                    ConversionParamValueModel.tuple(heightParam, null, 1,
                        unit: centimeter),
                  ],
                )
              ],
              selectedIndex: 0,
            ),
          );
        });

        test('Source item value exists only', () async {
          await testCase(
            unitGroup: clothingSizeGroup,
            useCase: useCase,
            delta: AddUnitsToConversionDelta(
              unitIds: [
                japanClothSize.id,
                italianClothSize.id,
              ],
            ),
            currentSrc:
                ConversionUnitValueModel.tuple(europeanClothSize, 42, null),
            currentParams: ConversionParamSetValueBulkModel(
              paramSetValues: [
                ConversionParamSetValueModel(
                  paramSet: clothingSizeParamSet,
                  paramValues: [
                    ConversionParamValueModel.tuple(personParam, "Man", null),
                    ConversionParamValueModel.tuple(
                        garmentParam, "Shirt", null),
                    ConversionParamValueModel.tuple(heightParam, null, 1,
                        unit: centimeter),
                  ],
                )
              ],
              selectedIndex: 0,
            ),
            currentUnitValues: [
              ConversionUnitValueModel.tuple(europeanClothSize, 42, null),
            ],
            expectedSrc:
                ConversionUnitValueModel.tuple(europeanClothSize, 42, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(europeanClothSize, 42, null),
              ConversionUnitValueModel.tuple(japanClothSize, 'S', null),
              ConversionUnitValueModel.tuple(italianClothSize, 42, null),
            ],
            expectedParams: ConversionParamSetValueBulkModel(
              paramSetValues: [
                ConversionParamSetValueModel(
                  paramSet: clothingSizeParamSet,
                  paramValues: [
                    ConversionParamValueModel.tuple(personParam, "Man", null),
                    ConversionParamValueModel.tuple(
                        garmentParam, "Shirt", null),
                    ConversionParamValueModel.tuple(heightParam, null, 1,
                        unit: centimeter),
                  ],
                )
              ],
              selectedIndex: 0,
            ),
          );
        });
      });

      group('Some params are not set', () {
        group('Optional params', () {
          test('Source item does not exist', () async {
            await testCase(
              unitGroup: ringSizeGroup,
              useCase: useCase,
              delta: AddUnitsToConversionDelta(
                unitIds: [
                  usaRingSize.id,
                  frRingSize.id,
                ],
              ),
              currentParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: ringSizeByDiameterParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(diameterParam, null, null,
                          unit: millimeter),
                    ],
                  )
                ],
                selectedIndex: 0,
              ),
              currentUnitValues: [],
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
                      ConversionParamValueModel.tuple(diameterParam, null, null,
                          unit: millimeter),
                    ],
                  )
                ],
                selectedIndex: 0,
              ),
            );
          });

          test(
              'Source item value and default value exist '
              '(default list value will be ignored)', () async {
            await testCase(
              unitGroup: ringSizeGroup,
              useCase: useCase,
              delta: AddUnitsToConversionDelta(
                unitIds: [
                  usaRingSize.id,
                  frRingSize.id,
                ],
              ),
              currentSrc: ConversionUnitValueModel.tuple(usaRingSize, 3.5, 3.5),
              currentParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: ringSizeByDiameterParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(diameterParam, null, null,
                          unit: millimeter),
                    ],
                  )
                ],
                selectedIndex: 0,
              ),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(usaRingSize, 3.5, 3.5),
              ],
              expectedSrc:
                  ConversionUnitValueModel.tuple(usaRingSize, 3.5, 3.5),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(usaRingSize, 3.5, 3.5),
                ConversionUnitValueModel.tuple(frRingSize, null, null),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: ringSizeByDiameterParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(diameterParam, null, null,
                          unit: millimeter),
                    ],
                  )
                ],
                selectedIndex: 0,
              ),
            );
          });

          test('Source item value exists only', () async {
            await testCase(
              unitGroup: ringSizeGroup,
              useCase: useCase,
              delta: AddUnitsToConversionDelta(
                unitIds: [
                  usaRingSize.id,
                  frRingSize.id,
                ],
              ),
              currentSrc:
                  ConversionUnitValueModel.tuple(usaRingSize, 3.5, null),
              currentParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: ringSizeByDiameterParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(diameterParam, null, null,
                          unit: millimeter),
                    ],
                  )
                ],
                selectedIndex: 0,
              ),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(usaRingSize, 3.5, null),
              ],
              expectedSrc:
                  ConversionUnitValueModel.tuple(usaRingSize, 3.5, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(usaRingSize, 3.5, null),
                ConversionUnitValueModel.tuple(frRingSize, null, null),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: ringSizeByDiameterParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(diameterParam, null, null,
                          unit: millimeter),
                    ],
                  )
                ],
                selectedIndex: 0,
              ),
            );
          });
        });

        group('Mandatory params', () {
          test('Source item does not exist', () async {
            await testCase(
              unitGroup: clothingSizeGroup,
              useCase: useCase,
              delta: AddUnitsToConversionDelta(
                unitIds: [
                  japanClothSize.id,
                  italianClothSize.id,
                ],
              ),
              currentParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: clothingSizeParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(personParam, "Man", null),
                      ConversionParamValueModel.tuple(garmentParam, null, null),
                      ConversionParamValueModel.tuple(heightParam, 150, 1,
                          unit: centimeter),
                    ],
                  )
                ],
                selectedIndex: 0,
              ),
              currentUnitValues: [],
              expectedSrc:
                  ConversionUnitValueModel.tuple(japanClothSize, null, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(japanClothSize, null, null),
                ConversionUnitValueModel.tuple(italianClothSize, null, null),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: clothingSizeParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(personParam, "Man", null),
                      ConversionParamValueModel.tuple(garmentParam, null, null),
                      ConversionParamValueModel.tuple(heightParam, 150, 1,
                          unit: centimeter),
                    ],
                  )
                ],
                selectedIndex: 0,
              ),
            );
          });

          test(
              'Source item value and default value exist '
              '(default list value will be ignored)', () async {
            await testCase(
              unitGroup: clothingSizeGroup,
              useCase: useCase,
              delta: AddUnitsToConversionDelta(
                unitIds: [
                  japanClothSize.id,
                  italianClothSize.id,
                ],
              ),
              currentSrc:
                  ConversionUnitValueModel.tuple(europeanClothSize, 32, 32),
              currentParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: clothingSizeParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(personParam, null, null),
                      ConversionParamValueModel.tuple(
                          garmentParam, "Shirt", null),
                      ConversionParamValueModel.tuple(heightParam, 150, 1,
                          unit: centimeter),
                    ],
                  )
                ],
                selectedIndex: 0,
              ),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(europeanClothSize, 32, 32),
              ],
              expectedSrc:
                  ConversionUnitValueModel.tuple(europeanClothSize, null, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(europeanClothSize, null, null),
                ConversionUnitValueModel.tuple(japanClothSize, null, null),
                ConversionUnitValueModel.tuple(italianClothSize, null, null),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: clothingSizeParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(personParam, null, null),
                      ConversionParamValueModel.tuple(
                          garmentParam, "Shirt", null),
                      ConversionParamValueModel.tuple(heightParam, 150, 1,
                          unit: centimeter),
                    ],
                  )
                ],
                selectedIndex: 0,
              ),
            );
          });

          test(
              'Source item default value exists only '
              '(default list value will be ignored)', () async {
            await testCase(
              unitGroup: clothingSizeGroup,
              useCase: useCase,
              delta: AddUnitsToConversionDelta(
                unitIds: [
                  japanClothSize.id,
                  italianClothSize.id,
                ],
              ),
              currentSrc:
                  ConversionUnitValueModel.tuple(europeanClothSize, null, 32),
              currentParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: clothingSizeParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(personParam, null, null),
                      ConversionParamValueModel.tuple(
                          garmentParam, "Shirt", null),
                      ConversionParamValueModel.tuple(heightParam, 150, 1,
                          unit: centimeter),
                    ],
                  )
                ],
                selectedIndex: 0,
              ),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(europeanClothSize, null, 32),
              ],
              expectedSrc:
                  ConversionUnitValueModel.tuple(europeanClothSize, null, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(europeanClothSize, null, null),
                ConversionUnitValueModel.tuple(japanClothSize, null, null),
                ConversionUnitValueModel.tuple(italianClothSize, null, null),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: clothingSizeParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(personParam, null, null),
                      ConversionParamValueModel.tuple(
                          garmentParam, "Shirt", null),
                      ConversionParamValueModel.tuple(heightParam, 150, 1,
                          unit: centimeter),
                    ],
                  )
                ],
                selectedIndex: 0,
              ),
            );
          });

          test('Source item value exists only', () async {
            await testCase(
              unitGroup: clothingSizeGroup,
              useCase: useCase,
              delta: AddUnitsToConversionDelta(
                unitIds: [
                  japanClothSize.id,
                  italianClothSize.id,
                ],
              ),
              currentSrc:
                  ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
              currentParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: clothingSizeParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(personParam, null, null),
                      ConversionParamValueModel.tuple(
                          garmentParam, "Shirt", null),
                      ConversionParamValueModel.tuple(heightParam, 150, 1,
                          unit: centimeter),
                    ],
                  )
                ],
                selectedIndex: 0,
              ),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
              ],
              expectedSrc:
                  ConversionUnitValueModel.tuple(europeanClothSize, null, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(europeanClothSize, null, null),
                ConversionUnitValueModel.tuple(japanClothSize, null, null),
                ConversionUnitValueModel.tuple(italianClothSize, null, null),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: clothingSizeParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(personParam, null, null),
                      ConversionParamValueModel.tuple(
                          garmentParam, "Shirt", null),
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

      group('No params are set', () {
        test('Source item does not exist', () async {
          await testCase(
            unitGroup: clothingSizeGroup,
            useCase: useCase,
            delta: AddUnitsToConversionDelta(
              unitIds: [
                japanClothSize.id,
                italianClothSize.id,
              ],
            ),
            currentParams: ConversionParamSetValueBulkModel(
              paramSetValues: [
                ConversionParamSetValueModel(
                  paramSet: clothingSizeParamSet,
                  paramValues: [
                    ConversionParamValueModel.tuple(personParam, null, null),
                    ConversionParamValueModel.tuple(garmentParam, null, null),
                    ConversionParamValueModel.tuple(heightParam, null, null,
                        unit: centimeter),
                  ],
                )
              ],
              selectedIndex: 0,
            ),
            currentUnitValues: [],
            expectedSrc:
                ConversionUnitValueModel.tuple(japanClothSize, null, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(japanClothSize, null, null),
              ConversionUnitValueModel.tuple(italianClothSize, null, null),
            ],
            expectedParams: ConversionParamSetValueBulkModel(
              paramSetValues: [
                ConversionParamSetValueModel(
                  paramSet: clothingSizeParamSet,
                  paramValues: [
                    ConversionParamValueModel.tuple(personParam, null, null),
                    ConversionParamValueModel.tuple(garmentParam, null, null),
                    ConversionParamValueModel.tuple(heightParam, null, null,
                        unit: centimeter),
                  ],
                )
              ],
              selectedIndex: 0,
            ),
          );
        });

        test(
            'Source item value and default value exist '
            '(default list value will be ignored)', () async {
          await testCase(
            unitGroup: clothingSizeGroup,
            useCase: useCase,
            delta: AddUnitsToConversionDelta(
              unitIds: [
                japanClothSize.id,
                italianClothSize.id,
              ],
            ),
            currentParams: ConversionParamSetValueBulkModel(
              paramSetValues: [
                ConversionParamSetValueModel(
                  paramSet: clothingSizeParamSet,
                  paramValues: [
                    ConversionParamValueModel.tuple(personParam, null, null),
                    ConversionParamValueModel.tuple(garmentParam, null, null),
                    ConversionParamValueModel.tuple(heightParam, null, null,
                        unit: centimeter),
                  ],
                )
              ],
              selectedIndex: 0,
            ),
            currentSrc:
                ConversionUnitValueModel.tuple(europeanClothSize, 32, 32),
            currentUnitValues: [
              ConversionUnitValueModel.tuple(europeanClothSize, 32, 32),
            ],
            expectedSrc:
                ConversionUnitValueModel.tuple(europeanClothSize, null, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(europeanClothSize, null, null),
              ConversionUnitValueModel.tuple(japanClothSize, null, null),
              ConversionUnitValueModel.tuple(italianClothSize, null, null),
            ],
            expectedParams: ConversionParamSetValueBulkModel(
              paramSetValues: [
                ConversionParamSetValueModel(
                  paramSet: clothingSizeParamSet,
                  paramValues: [
                    ConversionParamValueModel.tuple(personParam, null, null),
                    ConversionParamValueModel.tuple(garmentParam, null, null),
                    ConversionParamValueModel.tuple(heightParam, null, null,
                        unit: centimeter),
                  ],
                )
              ],
              selectedIndex: 0,
            ),
          );
        });

        test(
            'Source item default value exists only '
            '(default list value will be ignored)', () async {
          await testCase(
            unitGroup: clothingSizeGroup,
            useCase: useCase,
            delta: AddUnitsToConversionDelta(
              unitIds: [
                japanClothSize.id,
                italianClothSize.id,
              ],
            ),
            currentSrc:
                ConversionUnitValueModel.tuple(europeanClothSize, null, 32),
            currentParams: ConversionParamSetValueBulkModel(
              paramSetValues: [
                ConversionParamSetValueModel(
                  paramSet: clothingSizeParamSet,
                  paramValues: [
                    ConversionParamValueModel.tuple(personParam, null, null),
                    ConversionParamValueModel.tuple(garmentParam, null, null),
                    ConversionParamValueModel.tuple(heightParam, null, null,
                        unit: centimeter),
                  ],
                )
              ],
              selectedIndex: 0,
            ),
            currentUnitValues: [
              ConversionUnitValueModel.tuple(europeanClothSize, null, 32),
            ],
            expectedSrc:
                ConversionUnitValueModel.tuple(europeanClothSize, null, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(europeanClothSize, null, null),
              ConversionUnitValueModel.tuple(japanClothSize, null, null),
              ConversionUnitValueModel.tuple(italianClothSize, null, null),
            ],
            expectedParams: ConversionParamSetValueBulkModel(
              paramSetValues: [
                ConversionParamSetValueModel(
                  paramSet: clothingSizeParamSet,
                  paramValues: [
                    ConversionParamValueModel.tuple(personParam, null, null),
                    ConversionParamValueModel.tuple(garmentParam, null, null),
                    ConversionParamValueModel.tuple(heightParam, null, null,
                        unit: centimeter),
                  ],
                )
              ],
              selectedIndex: 0,
            ),
          );
        });

        test('Source item value exists only', () async {
          await testCase(
            unitGroup: clothingSizeGroup,
            useCase: useCase,
            delta: AddUnitsToConversionDelta(
              unitIds: [
                japanClothSize.id,
                italianClothSize.id,
              ],
            ),
            currentParams: ConversionParamSetValueBulkModel(
              paramSetValues: [
                ConversionParamSetValueModel(
                  paramSet: clothingSizeParamSet,
                  paramValues: [
                    ConversionParamValueModel.tuple(personParam, null, null),
                    ConversionParamValueModel.tuple(garmentParam, null, null),
                    ConversionParamValueModel.tuple(heightParam, null, null,
                        unit: centimeter),
                  ],
                )
              ],
              selectedIndex: 0,
            ),
            currentSrc:
                ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
            currentUnitValues: [
              ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
            ],
            expectedSrc:
                ConversionUnitValueModel.tuple(europeanClothSize, null, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(europeanClothSize, null, null),
              ConversionUnitValueModel.tuple(japanClothSize, null, null),
              ConversionUnitValueModel.tuple(italianClothSize, null, null),
            ],
            expectedParams: ConversionParamSetValueBulkModel(
              paramSetValues: [
                ConversionParamSetValueModel(
                  paramSet: clothingSizeParamSet,
                  paramValues: [
                    ConversionParamValueModel.tuple(personParam, null, null),
                    ConversionParamValueModel.tuple(garmentParam, null, null),
                    ConversionParamValueModel.tuple(heightParam, null, null,
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
  });
}
