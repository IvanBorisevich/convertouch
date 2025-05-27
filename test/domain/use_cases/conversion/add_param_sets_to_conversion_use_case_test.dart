import 'dart:math';

import 'package:convertouch/data/repositories/local/list_value_repository_impl.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/add_param_sets_to_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_default_value_use_case.dart';
import 'package:test/test.dart';

import '../../model/mock/mock_param.dart';
import '../../model/mock/mock_unit.dart';
import '../../model/mock/mock_unit_group.dart';
import '../../repositories/mock/mock_conversion_param_repository.dart';
import '../../repositories/mock/mock_conversion_param_set_repository.dart';
import '../../repositories/mock/mock_dynamic_value_repository.dart';
import 'helpers/helpers.dart';

void main() {
  late AddParamSetsToConversionUseCase useCase;

  setUp(() {
    useCase = const AddParamSetsToConversionUseCase(
      conversionParamRepository: MockConversionParamRepository(),
      conversionParamSetRepository: MockConversionParamSetRepository(),
      calculateDefaultValueUseCase: CalculateDefaultValueUseCase(
        dynamicValueRepository: MockDynamicValueRepository(),
        listValueRepository: ListValueRepositoryImpl(),
      ),
    );
  });

  group('Conversion has no params', () {
    group('Conversion has items', () {
      group('New optional param set', () {
        group('With explicit param set id', () {
          group('With mapping table (circumference)', () {
            test('Circumference param should be auto-calculated', () async {
              await testCase(
                unitGroup: ringSizeGroup,
                useCase: useCase,
                delta: AddParamSetsDelta(
                  paramSetIds: [
                    ringSizeByCircumferenceParamSet.id,
                  ],
                ),
                currentParams: null,
                currentSrc:
                    ConversionUnitValueModel.tuple(usaRingSize, 3, null),
                currentUnitValues: [
                  ConversionUnitValueModel.tuple(usaRingSize, 3, null),
                  ConversionUnitValueModel.tuple(frRingSize, 44, null),
                ],
                expectedSrc:
                    ConversionUnitValueModel.tuple(usaRingSize, 3, null),
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
                          circumferenceParam,
                          14.5 * pi,
                          1,
                          unit: millimeter,
                          calculated: true,
                        ),
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

          group('With formula (barbell weight)', () {
            test(
                'Bar weight param should be set by default,'
                'one side weight param should be auto-calculated', () async {
              await testCase(
                unitGroup: massGroup,
                useCase: useCase,
                delta: AddParamSetsDelta(
                  paramSetIds: [
                    barbellWeightParamSet.id,
                  ],
                ),
                currentParams: null,
                currentSrc: ConversionUnitValueModel.tuple(kilogram, 40, 1),
                currentUnitValues: [
                  ConversionUnitValueModel.tuple(kilogram, 40, 1),
                  ConversionUnitValueModel.tuple(
                      pound, 40 / pound.coefficient!, 1),
                ],
                expectedSrc: ConversionUnitValueModel.tuple(kilogram, 40, 1),
                expectedUnitValues: [
                  ConversionUnitValueModel.tuple(kilogram, 40, 1),
                  ConversionUnitValueModel.tuple(
                      pound, 40 / pound.coefficient!, 1 / pound.coefficient!),
                ],
                expectedParams: ConversionParamSetValueBulkModel(
                  paramSetValues: [
                    ConversionParamSetValueModel(
                      paramSet: barbellWeightParamSet,
                      paramValues: [
                        ConversionParamValueModel.tuple(
                            barWeightParam, 10, null,
                            unit: kilogram),
                        ConversionParamValueModel.tuple(
                          oneSideWeightParam,
                          15,
                          1,
                          unit: kilogram,
                          calculated: true,
                        ),
                      ],
                    ),
                  ],
                  selectedParamSetCanBeRemoved: true,
                  paramSetsCanBeRemovedInBulk: true,
                  paramSetsCanBeAdded: false,
                  selectedIndex: 0,
                  totalCount: 1,
                ),
              );
            });
          });
        });

        group('Without explicit param set id', () {
          test('Empty param sets list should be added initially', () async {
            await testCase(
              unitGroup: ringSizeGroup,
              useCase: useCase,
              delta: const AddParamSetsDelta(),
              currentParams: null,
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
                paramSetsCanBeRemovedInBulk: true,
                paramSetsCanBeAdded: true,
                selectedIndex: -1,
                totalCount: 2,
              ),
            );
          });
        });
      });

      group('New mandatory param set', () {
        group('With mapping table (clothes size)', () {
          test(
              'Height param should be set by default, '
              'other params should not be auto-calculated', () async {
            await testCase(
              unitGroup: clothesSizeGroup,
              useCase: useCase,
              delta: const AddParamSetsDelta(),
              currentSrc:
                  ConversionUnitValueModel.tuple(japanClothSize, 3, null),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(japanClothSize, 3, null),
              ],
              expectedSrc:
                  ConversionUnitValueModel.tuple(japanClothSize, 3, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(japanClothSize, 3, null),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: clothesSizeParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(personParam, null, null),
                      ConversionParamValueModel.tuple(garmentParam, null, null),
                      ConversionParamValueModel.tuple(heightParam, null, 1,
                          unit: centimeter, calculated: true),
                    ],
                  ),
                ],
                selectedIndex: 0,
                mandatoryParamSetExists: true,
                totalCount: 1,
              ),
            );
          });
        });

        group('With formula', () {});
      });
    });

    group('Conversion has no items', () {
      group('New optional param set', () {
        group('With explicit param set id', () {
          group('With mapping table (diameter and circumference)', () {
            test(
                'When both params added, the last one should not be '
                'auto-calculated', () async {
              await testCase(
                unitGroup: ringSizeGroup,
                useCase: useCase,
                delta: AddParamSetsDelta(
                  paramSetIds: [
                    ringSizeByDiameterParamSet.id,
                    ringSizeByCircumferenceParamSet.id,
                  ],
                ),
                currentParams: null,
                currentUnitValues: [],
                expectedUnitValues: [],
                expectedParams: ConversionParamSetValueBulkModel(
                  paramSetValues: [
                    ConversionParamSetValueModel(
                      paramSet: ringSizeByDiameterParamSet,
                      paramValues: [
                        ConversionParamValueModel.tuple(diameterParam, null, 1,
                            unit: millimeter),
                      ],
                    ),
                    ConversionParamSetValueModel(
                      paramSet: ringSizeByCircumferenceParamSet,
                      paramValues: [
                        ConversionParamValueModel.tuple(
                          circumferenceParam,
                          null,
                          1,
                          unit: millimeter,
                          calculated: true,
                        ),
                      ],
                    ),
                  ],
                  selectedParamSetCanBeRemoved: true,
                  paramSetsCanBeRemovedInBulk: true,
                  paramSetsCanBeAdded: false,
                  selectedIndex: 1,
                  totalCount: 2,
                ),
              );
            });
          });

          group('With formula (barbell weight)', () {
            test(
                'Bar weight list param should be set by default,'
                'one side weight params should not be auto-calculated',
                () async {
              await testCase(
                unitGroup: massGroup,
                useCase: useCase,
                delta: AddParamSetsDelta(
                  paramSetIds: [
                    barbellWeightParamSet.id,
                  ],
                ),
                currentParams: null,
                currentUnitValues: [],
                expectedUnitValues: [],
                expectedParams: ConversionParamSetValueBulkModel(
                  paramSetValues: [
                    ConversionParamSetValueModel(
                      paramSet: barbellWeightParamSet,
                      paramValues: [
                        ConversionParamValueModel.tuple(
                            barWeightParam, 10, null,
                            unit: kilogram),
                        ConversionParamValueModel.tuple(
                          oneSideWeightParam,
                          null,
                          1,
                          unit: kilogram,
                          calculated: true,
                        ),
                      ],
                    ),
                  ],
                  selectedParamSetCanBeRemoved: true,
                  paramSetsCanBeRemovedInBulk: true,
                  paramSetsCanBeAdded: false,
                  selectedIndex: 0,
                  totalCount: 1,
                ),
              );
            });
          });
        });

        group('Without explicit param set id', () {
          test('Empty param sets list should be added initially', () async {
            await testCase(
              unitGroup: ringSizeGroup,
              useCase: useCase,
              delta: const AddParamSetsDelta(),
              currentParams: null,
              currentUnitValues: [],
              expectedUnitValues: [],
              expectedParams: const ConversionParamSetValueBulkModel(
                paramSetValues: [],
                selectedParamSetCanBeRemoved: false,
                paramSetsCanBeRemovedInBulk: true,
                paramSetsCanBeAdded: true,
                selectedIndex: -1,
                totalCount: 2,
              ),
            );
          });
        });
      });

      group('New mandatory param set', () {
        group('With mapping table (clothes size)', () {
          test(
              'Height param should be set by default, '
              'other params should not be auto-calculated', () async {
            await testCase(
              unitGroup: clothesSizeGroup,
              useCase: useCase,
              delta: const AddParamSetsDelta(),
              currentUnitValues: [],
              expectedUnitValues: [],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: clothesSizeParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(personParam, null, null),
                      ConversionParamValueModel.tuple(garmentParam, null, null),
                      ConversionParamValueModel.tuple(heightParam, null, 1,
                          unit: centimeter, calculated: true),
                    ],
                  ),
                ],
                mandatoryParamSetExists: true,
                selectedIndex: 0,
                totalCount: 1,
              ),
            );
          });
        });

        group('With formula', () {});
      });
    });
  });

  group('Conversion has params', () {
    group('Conversion has items', () {
      group('New optional param set', () {
        group('With mapping table (circumference)', () {
          test(
              'Circumference param should be auto-calculated, '
              'duplicated param set ids should be omitted', () async {
            await testCase(
              unitGroup: ringSizeGroup,
              useCase: useCase,
              delta: AddParamSetsDelta(
                paramSetIds: [
                  ringSizeByCircumferenceParamSet.id,
                  ringSizeByDiameterParamSet.id,
                ],
              ),
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
              expectedParams: ConversionParamSetValueBulkModel(
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
                        circumferenceParam,
                        14.5 * pi,
                        1,
                        unit: millimeter,
                        calculated: true,
                      ),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                paramSetsCanBeRemovedInBulk: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 1,
                totalCount: 2,
              ),
            );
          });
        });

        group('With formula', () {});
      });
    });

    group('Conversion has no items', () {
      group('New optional param set', () {
        group('With mapping table (circumference)', () {
          test('Circumference param should not be auto-calculated', () async {
            await testCase(
              unitGroup: ringSizeGroup,
              useCase: useCase,
              delta: AddParamSetsDelta(
                paramSetIds: [
                  ringSizeByCircumferenceParamSet.id,
                ],
              ),
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
              expectedParams: ConversionParamSetValueBulkModel(
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
                        circumferenceParam,
                        null,
                        1,
                        unit: millimeter,
                        calculated: true,
                      ),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                paramSetsCanBeRemovedInBulk: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 1,
                totalCount: 2,
              ),
            );
          });
        });

        group('With formula', () {});
      });
    });
  });
}
