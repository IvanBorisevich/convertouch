import 'package:convertouch/data/repositories/local/list_value_repository_impl.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/edit_conversion_item_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_default_value_use_case.dart';
import 'package:test/test.dart';

import '../../model/mock/mock_param.dart';
import '../../model/mock/mock_unit.dart';
import '../../model/mock/mock_unit_group.dart';
import '../../repositories/mock/mock_dynamic_value_repository.dart';
import 'helpers/helpers.dart';

void main() {
  late EditConversionItemValueUseCase useCase;

  setUp(() {
    useCase = const EditConversionItemValueUseCase(
      calculateDefaultValueUseCase: CalculateDefaultValueUseCase(
        dynamicValueRepository: MockDynamicValueRepository(),
        listValueRepository: ListValueRepositoryImpl(),
      ),
    );
  });

  group('Conversion by coefficients', () {
    var currentUnitValues = [
      ConversionUnitValueModel.tuple(decimeter, 10, 1),
      ConversionUnitValueModel.tuple(centimeter, 100, 10),
    ];

    group('Conversion has no params', () {
      group('New src value exists | new src default value exists', () {
        test('New value and new default value should be applied', () async {
          await testCase(
            useCase: useCase,
            delta: EditConversionItemValueDelta(
              newValue: '2',
              newDefaultValue: '2',
              unitId: decimeter.id,
            ),
            unitGroup: lengthGroup,
            currentSrc: ConversionUnitValueModel.tuple(decimeter, 10, 1),
            currentParams: null,
            currentUnitValues: currentUnitValues,
            expectedSrc: ConversionUnitValueModel.tuple(decimeter, 2, 2),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(decimeter, 2, 2),
              ConversionUnitValueModel.tuple(centimeter, 20, 20),
            ],
          );
        });
      });

      group('New src value exists | new src default value does not exist', () {
        test(
            'New value should be applied, default value should be a default value of the unit type',
            () async {
          await testCase(
            useCase: useCase,
            delta: EditConversionItemValueDelta(
              newValue: '2',
              newDefaultValue: null,
              unitId: decimeter.id,
            ),
            unitGroup: lengthGroup,
            currentSrc: ConversionUnitValueModel.tuple(decimeter, 10, 2),
            currentParams: null,
            currentUnitValues: currentUnitValues,
            expectedSrc: ConversionUnitValueModel.tuple(decimeter, 2, 1),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(decimeter, 2, 1),
              ConversionUnitValueModel.tuple(centimeter, 20, 10),
            ],
          );
        });
      });

      group('New src value does not exist | new src default value exists', () {
        test('For null src value new default value should be applied',
            () async {
          await testCase(
            useCase: useCase,
            delta: EditConversionItemValueDelta(
              newValue: null,
              newDefaultValue: '2',
              unitId: decimeter.id,
            ),
            unitGroup: lengthGroup,
            currentSrc: ConversionUnitValueModel.tuple(decimeter, 10, 1),
            currentParams: null,
            currentUnitValues: currentUnitValues,
            expectedSrc: ConversionUnitValueModel.tuple(decimeter, null, 2),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(decimeter, null, 2),
              ConversionUnitValueModel.tuple(centimeter, null, 20),
            ],
          );
        });

        test('For empty src value new default value should be applied',
            () async {
          await testCase(
            useCase: useCase,
            delta: EditConversionItemValueDelta(
              newValue: '',
              newDefaultValue: '2',
              unitId: decimeter.id,
            ),
            unitGroup: lengthGroup,
            currentSrc: ConversionUnitValueModel.tuple(decimeter, 10, 1),
            currentParams: null,
            currentUnitValues: currentUnitValues,
            expectedSrc: ConversionUnitValueModel.tuple(decimeter, null, 2),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(decimeter, null, 2),
              ConversionUnitValueModel.tuple(centimeter, null, 20),
            ],
          );
        });
      });

      group(
          'New src value does not exist | new src default value does not exist',
          () {
        test(
            'For null src value default value should be a default value of the unit type',
            () async {
          await testCase(
            useCase: useCase,
            delta: EditConversionItemValueDelta(
              newValue: null,
              newDefaultValue: null,
              unitId: decimeter.id,
            ),
            unitGroup: lengthGroup,
            currentSrc: ConversionUnitValueModel.tuple(decimeter, 10, 1),
            currentParams: null,
            currentUnitValues: currentUnitValues,
            expectedSrc: ConversionUnitValueModel.tuple(decimeter, null, 1),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(decimeter, null, 1),
              ConversionUnitValueModel.tuple(centimeter, null, 10),
            ],
          );
        });

        test(
            'For empty src value default value should be '
            'a default value of the unit type', () async {
          await testCase(
            useCase: useCase,
            delta: EditConversionItemValueDelta(
              newValue: '',
              newDefaultValue: null,
              unitId: decimeter.id,
            ),
            unitGroup: lengthGroup,
            currentSrc: ConversionUnitValueModel.tuple(decimeter, 10, 1),
            currentParams: null,
            currentUnitValues: currentUnitValues,
            expectedSrc: ConversionUnitValueModel.tuple(decimeter, null, 1),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(decimeter, null, 1),
              ConversionUnitValueModel.tuple(centimeter, null, 10),
            ],
          );
        });
      });
    });

    group('Conversion has params', () {
      group('Calculable param is switched on', () {
        group('New src value exists | new src default value exists', () {
          test('The param is not empty (should be calculated by new value)',
              () async {
            await testCase(
              unitGroup: massGroup,
              useCase: useCase,
              delta: EditConversionItemValueDelta(
                newValue: "100",
                newDefaultValue: "1",
                unitId: kilogram.id,
              ),
              currentParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: barbellWeightParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(barWeightParam, 20, null,
                          unit: kilogram),
                      ConversionParamValueModel.tuple(oneSideWeightParam, 20, 1,
                          unit: kilogram, calculated: true),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                optionalParamSetsExist: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
              currentSrc: ConversionUnitValueModel.tuple(kilogram, 50, 1),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, 50, 1),
                ConversionUnitValueModel.tuple(
                    pound, 50 / pound.coefficient!, 1),
              ],
              expectedSrc: ConversionUnitValueModel.tuple(kilogram, 100, 1),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, 100, 1),
                ConversionUnitValueModel.tuple(
                    pound, 100 / pound.coefficient!, 1 / pound.coefficient!),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: barbellWeightParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(barWeightParam, 20, null,
                          unit: kilogram),
                      ConversionParamValueModel.tuple(oneSideWeightParam, 40, 1,
                          unit: kilogram, calculated: true),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                optionalParamSetsExist: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
            );
          });

          test('The param is empty (should be calculated by new value)',
              () async {
            await testCase(
              unitGroup: massGroup,
              useCase: useCase,
              delta: EditConversionItemValueDelta(
                newValue: "100",
                newDefaultValue: "1",
                unitId: kilogram.id,
              ),
              currentParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: barbellWeightParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(barWeightParam, 20, null,
                          unit: kilogram),
                      ConversionParamValueModel.tuple(
                          oneSideWeightParam, null, 1,
                          unit: kilogram, calculated: true),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                optionalParamSetsExist: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
              currentSrc: ConversionUnitValueModel.tuple(kilogram, 50, 1),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, 50, 1),
                ConversionUnitValueModel.tuple(
                    pound, 50 / pound.coefficient!, 1),
              ],
              expectedSrc: ConversionUnitValueModel.tuple(kilogram, 100, 1),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, 100, 1),
                ConversionUnitValueModel.tuple(
                    pound, 100 / pound.coefficient!, 1 / pound.coefficient!),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: barbellWeightParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(barWeightParam, 20, null,
                          unit: kilogram),
                      ConversionParamValueModel.tuple(oneSideWeightParam, 40, 1,
                          unit: kilogram, calculated: true),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                optionalParamSetsExist: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
            );
          });
        });

        group('New src value exists | new src default value does not exist',
            () {
          test('The param is not empty (should be calculated by new value)',
              () async {
            await testCase(
              unitGroup: massGroup,
              useCase: useCase,
              delta: EditConversionItemValueDelta(
                newValue: "80",
                newDefaultValue: null,
                unitId: kilogram.id,
              ),
              currentParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: barbellWeightParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(barWeightParam, 20, null,
                          unit: kilogram),
                      ConversionParamValueModel.tuple(oneSideWeightParam, 20, 1,
                          unit: kilogram, calculated: true),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                optionalParamSetsExist: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
              currentSrc: ConversionUnitValueModel.tuple(kilogram, 50, 1),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, 50, 1),
                ConversionUnitValueModel.tuple(
                    pound, 50 / pound.coefficient!, 1),
              ],
              expectedSrc: ConversionUnitValueModel.tuple(kilogram, 80, 1),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, 80, 1),
                ConversionUnitValueModel.tuple(
                    pound, 80 / pound.coefficient!, 1 / pound.coefficient!),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: barbellWeightParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(barWeightParam, 20, null,
                          unit: kilogram),
                      ConversionParamValueModel.tuple(oneSideWeightParam, 30, 1,
                          unit: kilogram, calculated: true),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                optionalParamSetsExist: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
            );
          });

          test('The param is empty (should be calculated by new value)',
              () async {
            await testCase(
              unitGroup: massGroup,
              useCase: useCase,
              delta: EditConversionItemValueDelta(
                newValue: "80",
                newDefaultValue: null,
                unitId: kilogram.id,
              ),
              currentParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: barbellWeightParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(barWeightParam, 20, null,
                          unit: kilogram),
                      ConversionParamValueModel.tuple(
                          oneSideWeightParam, null, 1,
                          unit: kilogram, calculated: true),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                optionalParamSetsExist: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
              currentSrc: ConversionUnitValueModel.tuple(kilogram, 50, 1),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, 50, 1),
                ConversionUnitValueModel.tuple(
                    pound, 50 / pound.coefficient!, 1),
              ],
              expectedSrc: ConversionUnitValueModel.tuple(kilogram, 80, 1),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, 80, 1),
                ConversionUnitValueModel.tuple(
                    pound, 80 / pound.coefficient!, 1 / pound.coefficient!),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: barbellWeightParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(barWeightParam, 20, null,
                          unit: kilogram),
                      ConversionParamValueModel.tuple(oneSideWeightParam, 30, 1,
                          unit: kilogram, calculated: true),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                optionalParamSetsExist: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
            );
          });
        });

        group('New src value does not exist | new src default value exists',
            () {
          test(
              'The param is not empty '
              '(should be calculated by new default value)', () async {
            await testCase(
              unitGroup: massGroup,
              useCase: useCase,
              delta: EditConversionItemValueDelta(
                newValue: null,
                newDefaultValue: "100",
                unitId: kilogram.id,
              ),
              currentParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: barbellWeightParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(barWeightParam, 20, null,
                          unit: kilogram),
                      ConversionParamValueModel.tuple(oneSideWeightParam, 20, 1,
                          unit: kilogram, calculated: true),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                optionalParamSetsExist: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
              currentSrc: ConversionUnitValueModel.tuple(kilogram, 50, 1),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, 50, 1),
                ConversionUnitValueModel.tuple(
                    pound, 50 / pound.coefficient!, 1),
              ],
              expectedSrc: ConversionUnitValueModel.tuple(kilogram, null, 100),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, null, 100),
                ConversionUnitValueModel.tuple(
                    pound, null, 100 / pound.coefficient!),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: barbellWeightParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(barWeightParam, 20, null,
                          unit: kilogram),
                      ConversionParamValueModel.tuple(oneSideWeightParam, 40, 1,
                          unit: kilogram, calculated: true),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                optionalParamSetsExist: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
            );
          });

          test(
              'The param is empty '
              '(should be calculated by new default value)', () async {
            await testCase(
              unitGroup: massGroup,
              useCase: useCase,
              delta: EditConversionItemValueDelta(
                newValue: null,
                newDefaultValue: "100",
                unitId: kilogram.id,
              ),
              currentParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: barbellWeightParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(barWeightParam, 20, null,
                          unit: kilogram),
                      ConversionParamValueModel.tuple(
                          oneSideWeightParam, null, 1,
                          unit: kilogram, calculated: true),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                optionalParamSetsExist: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
              currentSrc: ConversionUnitValueModel.tuple(kilogram, 50, 1),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, 50, 1),
                ConversionUnitValueModel.tuple(
                    pound, 50 / pound.coefficient!, 1),
              ],
              expectedSrc: ConversionUnitValueModel.tuple(kilogram, null, 100),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, null, 100),
                ConversionUnitValueModel.tuple(
                    pound, null, 100 / pound.coefficient!),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: barbellWeightParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(barWeightParam, 20, null,
                          unit: kilogram),
                      ConversionParamValueModel.tuple(oneSideWeightParam, 40, 1,
                          unit: kilogram, calculated: true),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                optionalParamSetsExist: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
            );
          });
        });

        group(
            'New src value does not exist | new src default value does not exist',
            () {
          test(
              'The param is not empty '
              '(should be calculated by default value of the unit type)',
              () async {
            await testCase(
              unitGroup: massGroup,
              useCase: useCase,
              delta: EditConversionItemValueDelta(
                newValue: null,
                newDefaultValue: null,
                unitId: kilogram.id,
              ),
              currentParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: barbellWeightParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(barWeightParam, 10, null,
                          unit: kilogram),
                      ConversionParamValueModel.tuple(oneSideWeightParam, 30, 1,
                          unit: kilogram, calculated: true),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                optionalParamSetsExist: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
              currentSrc: ConversionUnitValueModel.tuple(kilogram, 40, 1),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, 40, 1),
                ConversionUnitValueModel.tuple(
                    pound, 40 / pound.coefficient!, 1),
              ],
              expectedSrc: ConversionUnitValueModel.tuple(kilogram, null, 1),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, null, 1),
                ConversionUnitValueModel.tuple(
                    pound, null, 1 / pound.coefficient!),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: barbellWeightParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(barWeightParam, 10, null,
                          unit: kilogram),
                      ConversionParamValueModel.tuple(
                          oneSideWeightParam, null, null,
                          unit: kilogram, calculated: true),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                optionalParamSetsExist: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
            );
          });

          test(
              'The param is empty '
              '(should be calculated by default value of the unit type)',
              () async {
            await testCase(
              unitGroup: massGroup,
              useCase: useCase,
              delta: EditConversionItemValueDelta(
                newValue: null,
                newDefaultValue: null,
                unitId: kilogram.id,
              ),
              currentParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: barbellWeightParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(barWeightParam, 10, null,
                          unit: kilogram),
                      ConversionParamValueModel.tuple(
                          oneSideWeightParam, null, 1,
                          unit: kilogram, calculated: true),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                optionalParamSetsExist: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
              currentSrc: ConversionUnitValueModel.tuple(kilogram, 40, 1),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, 40, 1),
                ConversionUnitValueModel.tuple(
                    pound, 40 / pound.coefficient!, 1),
              ],
              expectedSrc: ConversionUnitValueModel.tuple(kilogram, null, 1),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, null, 1),
                ConversionUnitValueModel.tuple(
                    pound, null, 1 / pound.coefficient!),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: barbellWeightParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(barWeightParam, 10, null,
                          unit: kilogram),
                      ConversionParamValueModel.tuple(
                          oneSideWeightParam, null, null,
                          unit: kilogram, calculated: true),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                optionalParamSetsExist: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
            );
          });
        });
      });

      group('Calculable params are switched off or do not exist', () {
        group('New src value exists | new src default value exists', () {
          test('Calculable param is not empty (should not be recalculated)',
              () async {
            await testCase(
              unitGroup: massGroup,
              useCase: useCase,
              delta: EditConversionItemValueDelta(
                newValue: "100",
                newDefaultValue: "1",
                unitId: kilogram.id,
              ),
              currentParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: barbellWeightParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(barWeightParam, 20, null,
                          unit: kilogram),
                      ConversionParamValueModel.tuple(oneSideWeightParam, 20, 1,
                          unit: kilogram),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                optionalParamSetsExist: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
              currentSrc: ConversionUnitValueModel.tuple(kilogram, 50, 1),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, 50, 1),
                ConversionUnitValueModel.tuple(
                    pound, 50 / pound.coefficient!, 1),
              ],
              expectedSrc: ConversionUnitValueModel.tuple(kilogram, 100, 1),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, 100, 1),
                ConversionUnitValueModel.tuple(
                    pound, 100 / pound.coefficient!, 1 / pound.coefficient!),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: barbellWeightParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(barWeightParam, 20, null,
                          unit: kilogram),
                      ConversionParamValueModel.tuple(oneSideWeightParam, 20, 1,
                          unit: kilogram),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                optionalParamSetsExist: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
            );
          });

          test('Calculable param is empty (should not be recalculated)',
              () async {
            await testCase(
              unitGroup: massGroup,
              useCase: useCase,
              delta: EditConversionItemValueDelta(
                newValue: "100",
                newDefaultValue: "1",
                unitId: kilogram.id,
              ),
              currentParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: barbellWeightParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(barWeightParam, 20, null,
                          unit: kilogram),
                      ConversionParamValueModel.tuple(
                          oneSideWeightParam, null, 1,
                          unit: kilogram),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                optionalParamSetsExist: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
              currentSrc: ConversionUnitValueModel.tuple(kilogram, 50, 1),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, 50, 1),
                ConversionUnitValueModel.tuple(
                    pound, 50 / pound.coefficient!, 1),
              ],
              expectedSrc: ConversionUnitValueModel.tuple(kilogram, 100, 1),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, 100, 1),
                ConversionUnitValueModel.tuple(
                    pound, 100 / pound.coefficient!, 1 / pound.coefficient!),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: barbellWeightParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(barWeightParam, 20, null,
                          unit: kilogram),
                      ConversionParamValueModel.tuple(
                          oneSideWeightParam, null, 1,
                          unit: kilogram),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                optionalParamSetsExist: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
            );
          });
        });

        group('New src value exists | new src default value does not exist',
            () {
          test('Calculable param is not empty (should not be recalculated)',
              () async {
            await testCase(
              unitGroup: massGroup,
              useCase: useCase,
              delta: EditConversionItemValueDelta(
                newValue: "80",
                newDefaultValue: null,
                unitId: kilogram.id,
              ),
              currentParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: barbellWeightParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(barWeightParam, 20, null,
                          unit: kilogram),
                      ConversionParamValueModel.tuple(oneSideWeightParam, 20, 1,
                          unit: kilogram),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                optionalParamSetsExist: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
              currentSrc: ConversionUnitValueModel.tuple(kilogram, 50, 1),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, 50, 1),
                ConversionUnitValueModel.tuple(
                    pound, 50 / pound.coefficient!, 1),
              ],
              expectedSrc: ConversionUnitValueModel.tuple(kilogram, 80, 1),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, 80, 1),
                ConversionUnitValueModel.tuple(
                    pound, 80 / pound.coefficient!, 1 / pound.coefficient!),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: barbellWeightParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(barWeightParam, 20, null,
                          unit: kilogram),
                      ConversionParamValueModel.tuple(oneSideWeightParam, 20, 1,
                          unit: kilogram),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                optionalParamSetsExist: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
            );
          });

          test('Calculable param is empty (should not be recalculated)',
              () async {
            await testCase(
              unitGroup: massGroup,
              useCase: useCase,
              delta: EditConversionItemValueDelta(
                newValue: "80",
                newDefaultValue: null,
                unitId: kilogram.id,
              ),
              currentParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: barbellWeightParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(barWeightParam, 20, null,
                          unit: kilogram),
                      ConversionParamValueModel.tuple(
                          oneSideWeightParam, null, 1,
                          unit: kilogram),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                optionalParamSetsExist: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
              currentSrc: ConversionUnitValueModel.tuple(kilogram, 50, 1),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, 50, 1),
                ConversionUnitValueModel.tuple(
                    pound, 50 / pound.coefficient!, 1),
              ],
              expectedSrc: ConversionUnitValueModel.tuple(kilogram, 80, 1),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, 80, 1),
                ConversionUnitValueModel.tuple(
                    pound, 80 / pound.coefficient!, 1 / pound.coefficient!),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: barbellWeightParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(barWeightParam, 20, null,
                          unit: kilogram),
                      ConversionParamValueModel.tuple(
                          oneSideWeightParam, null, 1,
                          unit: kilogram),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                optionalParamSetsExist: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
            );
          });
        });

        group('New src value does not exist | new src default value exists',
            () {
          test('Calculable param is not empty (should not be recalculated)',
              () async {
            await testCase(
              unitGroup: massGroup,
              useCase: useCase,
              delta: EditConversionItemValueDelta(
                newValue: null,
                newDefaultValue: "100",
                unitId: kilogram.id,
              ),
              currentParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: barbellWeightParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(barWeightParam, 20, null,
                          unit: kilogram),
                      ConversionParamValueModel.tuple(oneSideWeightParam, 20, 1,
                          unit: kilogram),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                optionalParamSetsExist: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
              currentSrc: ConversionUnitValueModel.tuple(kilogram, 50, 1),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, 50, 1),
                ConversionUnitValueModel.tuple(
                    pound, 50 / pound.coefficient!, 1),
              ],
              expectedSrc: ConversionUnitValueModel.tuple(kilogram, null, 100),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, null, 100),
                ConversionUnitValueModel.tuple(
                    pound, null, 100 / pound.coefficient!),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: barbellWeightParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(barWeightParam, 20, null,
                          unit: kilogram),
                      ConversionParamValueModel.tuple(oneSideWeightParam, 20, 1,
                          unit: kilogram),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                optionalParamSetsExist: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
            );
          });

          test('Calculable param is empty (should not be recalculated)',
              () async {
            await testCase(
              unitGroup: massGroup,
              useCase: useCase,
              delta: EditConversionItemValueDelta(
                newValue: null,
                newDefaultValue: "100",
                unitId: kilogram.id,
              ),
              currentParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: barbellWeightParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(barWeightParam, 20, null,
                          unit: kilogram),
                      ConversionParamValueModel.tuple(
                          oneSideWeightParam, null, 1,
                          unit: kilogram),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                optionalParamSetsExist: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
              currentSrc: ConversionUnitValueModel.tuple(kilogram, 50, 1),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, 50, 1),
                ConversionUnitValueModel.tuple(
                    pound, 50 / pound.coefficient!, 1),
              ],
              expectedSrc: ConversionUnitValueModel.tuple(kilogram, null, 100),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, null, 100),
                ConversionUnitValueModel.tuple(
                    pound, null, 100 / pound.coefficient!),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: barbellWeightParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(barWeightParam, 20, null,
                          unit: kilogram),
                      ConversionParamValueModel.tuple(
                          oneSideWeightParam, null, 1,
                          unit: kilogram),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                optionalParamSetsExist: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
            );
          });
        });

        group(
            'New src value does not exist | new src default value does not exist',
            () {
          test('Calculable param is not empty (should not be recalculated)',
              () async {
            await testCase(
              unitGroup: massGroup,
              useCase: useCase,
              delta: EditConversionItemValueDelta(
                newValue: null,
                newDefaultValue: null,
                unitId: kilogram.id,
              ),
              currentParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: barbellWeightParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(barWeightParam, 10, null,
                          unit: kilogram),
                      ConversionParamValueModel.tuple(oneSideWeightParam, 30, 1,
                          unit: kilogram),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                optionalParamSetsExist: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
              currentSrc: ConversionUnitValueModel.tuple(kilogram, 40, 1),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, 40, 1),
                ConversionUnitValueModel.tuple(
                    pound, 40 / pound.coefficient!, 1),
              ],
              expectedSrc: ConversionUnitValueModel.tuple(kilogram, null, 1),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, null, 1),
                ConversionUnitValueModel.tuple(
                    pound, null, 1 / pound.coefficient!),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: barbellWeightParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(barWeightParam, 10, null,
                          unit: kilogram),
                      ConversionParamValueModel.tuple(oneSideWeightParam, 30, 1,
                          unit: kilogram),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                optionalParamSetsExist: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
            );
          });

          test('Calculable param is empty (should not be recalculated)',
              () async {
            await testCase(
              unitGroup: massGroup,
              useCase: useCase,
              delta: EditConversionItemValueDelta(
                newValue: null,
                newDefaultValue: null,
                unitId: kilogram.id,
              ),
              currentParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: barbellWeightParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(barWeightParam, 10, null,
                          unit: kilogram),
                      ConversionParamValueModel.tuple(
                          oneSideWeightParam, null, 1,
                          unit: kilogram),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                optionalParamSetsExist: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
              currentSrc: ConversionUnitValueModel.tuple(kilogram, 40, 1),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, 40, 1),
                ConversionUnitValueModel.tuple(
                    pound, 40 / pound.coefficient!, 1),
              ],
              expectedSrc: ConversionUnitValueModel.tuple(kilogram, null, 1),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, null, 1),
                ConversionUnitValueModel.tuple(
                    pound, null, 1 / pound.coefficient!),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: barbellWeightParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(barWeightParam, 10, null,
                          unit: kilogram),
                      ConversionParamValueModel.tuple(
                          oneSideWeightParam, null, 1,
                          unit: kilogram),
                    ],
                  ),
                ],
                selectedParamSetCanBeRemoved: true,
                optionalParamSetsExist: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
            );
          });
        });
      });
    });
  });

  group('Conversion by formula', () {
    var currentUnitValues = [
      ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
      ConversionUnitValueModel.tuple(japanClothSize, 3, null),
    ];

    group('Conversion has no params', () {});

    group('Conversion has params', () {
      group('Calculable param is switched on', () {
        group('New src value exists | new src default value exists', () {
          test('New list value only should be applied', () async {
            await testCase(
              unitGroup: clothesSizeGroup,
              useCase: useCase,
              delta: EditConversionItemValueDelta(
                newValue: '44',
                newDefaultValue: '32',
                unitId: europeanClothSize.id,
              ),
              currentSrc:
                  ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
              currentParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: clothesSizeParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(personParam, "Man", null),
                      ConversionParamValueModel.tuple(
                          garmentParam, "Shirt", null),
                      ConversionParamValueModel.tuple(heightParam, 167, 1,
                          unit: centimeter, calculated: true),
                    ],
                  )
                ],
                selectedIndex: 0,
              ),
              currentUnitValues: currentUnitValues,
              expectedSrc:
                  ConversionUnitValueModel.tuple(europeanClothSize, 44, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(europeanClothSize, 44, null),
                ConversionUnitValueModel.tuple(japanClothSize, 'M', null),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: clothesSizeParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(personParam, "Man", null),
                      ConversionParamValueModel.tuple(
                          garmentParam, "Shirt", null),
                      ConversionParamValueModel.tuple(heightParam, 167, 1,
                          unit: centimeter, calculated: true),
                    ],
                  )
                ],
                selectedIndex: 0,
              ),
            );
          });
        });

        group('New src value exists | new src default value do not exist', () {
          test('New list value only should be applied', () async {
            await testCase(
              unitGroup: clothesSizeGroup,
              useCase: useCase,
              delta: EditConversionItemValueDelta(
                newValue: '50',
                newDefaultValue: null,
                unitId: europeanClothSize.id,
              ),
              currentSrc:
                  ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
              currentParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: clothesSizeParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(personParam, "Man", null),
                      ConversionParamValueModel.tuple(
                          garmentParam, "Shirt", null),
                      ConversionParamValueModel.tuple(heightParam, null, 1,
                          unit: centimeter, calculated: true),
                    ],
                  )
                ],
                selectedIndex: 0,
              ),
              currentUnitValues: currentUnitValues,
              expectedSrc:
                  ConversionUnitValueModel.tuple(europeanClothSize, 50, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(europeanClothSize, 50, null),
                ConversionUnitValueModel.tuple(japanClothSize, '3L', null),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: clothesSizeParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(personParam, "Man", null),
                      ConversionParamValueModel.tuple(
                          garmentParam, "Shirt", null),
                      ConversionParamValueModel.tuple(heightParam, 184, 1,
                          unit: centimeter, calculated: true),
                    ],
                  )
                ],
                selectedIndex: 0,
              ),
            );
          });
        });

        group('New src value do not exist | new src default value exists', () {
          test('New empty list value should be applied', () async {
            await testCase(
              unitGroup: clothesSizeGroup,
              useCase: useCase,
              delta: EditConversionItemValueDelta(
                newValue: null,
                newDefaultValue: '34',
                unitId: europeanClothSize.id,
              ),
              currentSrc:
                  ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
              currentParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: clothesSizeParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(personParam, "Man", null),
                      ConversionParamValueModel.tuple(
                          garmentParam, "Shirt", null),
                      ConversionParamValueModel.tuple(heightParam, 165, 1,
                          unit: centimeter, calculated: true),
                    ],
                  )
                ],
              ),
              currentUnitValues: currentUnitValues,
              expectedSrc:
                  ConversionUnitValueModel.tuple(europeanClothSize, null, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(europeanClothSize, null, null),
                ConversionUnitValueModel.tuple(japanClothSize, null, null),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: clothesSizeParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(personParam, "Man", null),
                      ConversionParamValueModel.tuple(
                          garmentParam, "Shirt", null),
                      ConversionParamValueModel.tuple(heightParam, 165, 1,
                          unit: centimeter, calculated: true),
                    ],
                  )
                ],
              ),
            );
          });
        });

        group('New src value do not exist | new src default value do not exist',
            () {
          test('New empty list value should be applied', () async {
            await testCase(
              unitGroup: clothesSizeGroup,
              useCase: useCase,
              delta: EditConversionItemValueDelta(
                newValue: null,
                newDefaultValue: null,
                unitId: europeanClothSize.id,
              ),
              currentSrc:
                  ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
              currentParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: clothesSizeParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(personParam, "Man", null),
                      ConversionParamValueModel.tuple(
                          garmentParam, "Shirt", null),
                      ConversionParamValueModel.tuple(heightParam, 150, 1,
                          unit: centimeter, calculated: true),
                    ],
                  )
                ],
              ),
              currentUnitValues: currentUnitValues,
              expectedSrc:
                  ConversionUnitValueModel.tuple(europeanClothSize, null, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(europeanClothSize, null, null),
                ConversionUnitValueModel.tuple(japanClothSize, null, null),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: clothesSizeParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(personParam, "Man", null),
                      ConversionParamValueModel.tuple(
                          garmentParam, "Shirt", null),
                      ConversionParamValueModel.tuple(heightParam, 150, 1,
                          unit: centimeter, calculated: true),
                    ],
                  )
                ],
              ),
            );
          });
        });
      });

      group('Calculable params are switched off or do not exist', () {});
    });
  });
}
