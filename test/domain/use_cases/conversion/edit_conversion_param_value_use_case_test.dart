import 'package:convertouch/data/repositories/local/list_value_repository_impl.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/edit_conversion_param_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_source_item_by_params_use_case.dart';
import 'package:test/test.dart';

import '../../model/mock/mock_param.dart';
import '../../model/mock/mock_unit.dart';
import '../../model/mock/mock_unit_group.dart';
import '../../repositories/mock/mock_dynamic_value_repository.dart';
import 'helpers/helpers.dart';

void main() {
  late EditConversionParamValueUseCase useCase;

  setUp(() {
    const calculateDefaultValueUseCase = CalculateDefaultValueUseCase(
      dynamicValueRepository: MockDynamicValueRepository(),
      listValueRepository: ListValueRepositoryImpl(),
    );

    useCase = const EditConversionParamValueUseCase(
      calculateSourceItemByParamsUseCase: CalculateSourceItemByParamsUseCase(
        calculateDefaultValueUseCase: calculateDefaultValueUseCase,
      ),
      calculateDefaultValueUseCase: calculateDefaultValueUseCase,
    );
  });

  group('Conversion by coefficients', () {
    group('New list parameter value (barbell bar weight)', () {
      group('Src value exists | src default value exists', () {
        test('Source unit value only should be recalculated by params',
            () async {
          await testCase(
            unitGroup: massGroup,
            useCase: useCase,
            delta: EditConversionParamValueDelta(
              newValue: "20",
              newDefaultValue: null,
              paramId: barWeightParam.id,
              paramSetId: barbellWeightParamSet.id,
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
              paramSetsCanBeRemovedInBulk: true,
              paramSetsCanBeAdded: false,
              selectedIndex: 0,
              totalCount: 1,
            ),
            currentSrc: ConversionUnitValueModel.tuple(kilogram, 70, 1),
            currentUnitValues: [
              ConversionUnitValueModel.tuple(kilogram, 70, 1),
              ConversionUnitValueModel.tuple(pound, 70 / pound.coefficient!, 1),
            ],
            expectedSrc: ConversionUnitValueModel.tuple(kilogram, 80, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(kilogram, 80, null),
              ConversionUnitValueModel.tuple(
                  pound, 80 / pound.coefficient!, null),
            ],
            expectedParams: ConversionParamSetValueBulkModel(
              paramSetValues: [
                ConversionParamSetValueModel(
                  paramSet: barbellWeightParamSet,
                  paramValues: [
                    ConversionParamValueModel.tuple(barWeightParam, 20, null,
                        unit: kilogram),
                    ConversionParamValueModel.tuple(oneSideWeightParam, 30, 1,
                        unit: kilogram),
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

      group('Src value exists | src default value does not exist', () {
        test('Source unit value only should be recalculated by params',
            () async {
          await testCase(
            unitGroup: massGroup,
            useCase: useCase,
            delta: EditConversionParamValueDelta(
              newValue: "20",
              newDefaultValue: null,
              paramId: barWeightParam.id,
              paramSetId: barbellWeightParamSet.id,
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
              paramSetsCanBeRemovedInBulk: true,
              paramSetsCanBeAdded: false,
              selectedIndex: 0,
              totalCount: 1,
            ),
            currentSrc: ConversionUnitValueModel.tuple(kilogram, 1, null),
            currentUnitValues: [
              ConversionUnitValueModel.tuple(kilogram, 1, null),
              ConversionUnitValueModel.tuple(
                  pound, 1 / pound.coefficient!, null),
            ],
            expectedSrc: ConversionUnitValueModel.tuple(kilogram, 80, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(kilogram, 80, null),
              ConversionUnitValueModel.tuple(
                  pound, 80 / pound.coefficient!, null),
            ],
            expectedParams: ConversionParamSetValueBulkModel(
              paramSetValues: [
                ConversionParamSetValueModel(
                  paramSet: barbellWeightParamSet,
                  paramValues: [
                    ConversionParamValueModel.tuple(barWeightParam, 20, null,
                        unit: kilogram),
                    ConversionParamValueModel.tuple(oneSideWeightParam, 30, 1,
                        unit: kilogram),
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

      group('Src value does not exists | src default value exists', () {
        test('Source unit value only should be recalculated by params',
            () async {
          await testCase(
            unitGroup: massGroup,
            useCase: useCase,
            delta: EditConversionParamValueDelta(
              newValue: "20",
              newDefaultValue: null,
              paramId: barWeightParam.id,
              paramSetId: barbellWeightParamSet.id,
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
              paramSetsCanBeRemovedInBulk: true,
              paramSetsCanBeAdded: false,
              selectedIndex: 0,
              totalCount: 1,
            ),
            currentSrc: ConversionUnitValueModel.tuple(kilogram, null, 1),
            currentUnitValues: [
              ConversionUnitValueModel.tuple(kilogram, null, 1),
              ConversionUnitValueModel.tuple(
                  pound, null, 1 / pound.coefficient!),
            ],
            expectedSrc: ConversionUnitValueModel.tuple(kilogram, 80, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(kilogram, 80, null),
              ConversionUnitValueModel.tuple(
                  pound, 80 / pound.coefficient!, null),
            ],
            expectedParams: ConversionParamSetValueBulkModel(
              paramSetValues: [
                ConversionParamSetValueModel(
                  paramSet: barbellWeightParamSet,
                  paramValues: [
                    ConversionParamValueModel.tuple(barWeightParam, 20, null,
                        unit: kilogram),
                    ConversionParamValueModel.tuple(oneSideWeightParam, 30, 1,
                        unit: kilogram),
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

      group('Src value does not exists | src default value does not exist', () {
        test('Source unit value only should be recalculated by params',
            () async {
          await testCase(
            unitGroup: massGroup,
            useCase: useCase,
            delta: EditConversionParamValueDelta(
              newValue: "20",
              newDefaultValue: null,
              paramId: barWeightParam.id,
              paramSetId: barbellWeightParamSet.id,
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
              paramSetsCanBeRemovedInBulk: true,
              paramSetsCanBeAdded: false,
              selectedIndex: 0,
              totalCount: 1,
            ),
            currentSrc: ConversionUnitValueModel.tuple(kilogram, null, null),
            currentUnitValues: [
              ConversionUnitValueModel.tuple(kilogram, null, null),
              ConversionUnitValueModel.tuple(pound, null, null),
            ],
            expectedSrc: ConversionUnitValueModel.tuple(kilogram, 80, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(kilogram, 80, null),
              ConversionUnitValueModel.tuple(
                  pound, 80 / pound.coefficient!, null),
            ],
            expectedParams: ConversionParamSetValueBulkModel(
              paramSetValues: [
                ConversionParamSetValueModel(
                  paramSet: barbellWeightParamSet,
                  paramValues: [
                    ConversionParamValueModel.tuple(barWeightParam, 20, null,
                        unit: kilogram),
                    ConversionParamValueModel.tuple(oneSideWeightParam, 30, 1,
                        unit: kilogram),
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

    group('New non-list parameter value (barbell one side weight)', () {
      group('New param value exists | default value exists', () {
        group('Src value exists | src default value exists', () {
          test('Source unit value only should be recalculated by params',
              () async {
            await testCase(
              unitGroup: massGroup,
              useCase: useCase,
              delta: EditConversionParamValueDelta(
                newValue: "40",
                newDefaultValue: "1",
                paramId: oneSideWeightParam.id,
                paramSetId: barbellWeightParamSet.id,
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
                paramSetsCanBeRemovedInBulk: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
              currentSrc: ConversionUnitValueModel.tuple(kilogram, 70, 1),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, 70, 1),
                ConversionUnitValueModel.tuple(
                    pound, 70 / pound.coefficient!, 1),
              ],
              expectedSrc: ConversionUnitValueModel.tuple(kilogram, 90, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, 90, null),
                ConversionUnitValueModel.tuple(
                    pound, 90 / pound.coefficient!, null),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: barbellWeightParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(barWeightParam, 10, null,
                          unit: kilogram),
                      ConversionParamValueModel.tuple(oneSideWeightParam, 40, 1,
                          unit: kilogram),
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

        group('Src value exists | src default value does not exist', () {
          test('Source unit value only should be recalculated by params',
              () async {
            await testCase(
              unitGroup: massGroup,
              useCase: useCase,
              delta: EditConversionParamValueDelta(
                newValue: "40",
                newDefaultValue: "1",
                paramId: oneSideWeightParam.id,
                paramSetId: barbellWeightParamSet.id,
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
                paramSetsCanBeRemovedInBulk: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
              currentSrc: ConversionUnitValueModel.tuple(kilogram, 1, null),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, 1, null),
                ConversionUnitValueModel.tuple(
                    pound, 1 / pound.coefficient!, null),
              ],
              expectedSrc: ConversionUnitValueModel.tuple(kilogram, 90, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, 90, null),
                ConversionUnitValueModel.tuple(
                    pound, 90 / pound.coefficient!, null),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: barbellWeightParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(barWeightParam, 10, null,
                          unit: kilogram),
                      ConversionParamValueModel.tuple(oneSideWeightParam, 40, 1,
                          unit: kilogram),
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

        group('Src value does not exists | src default value exists', () {
          test('Source unit value only should be recalculated by params',
              () async {
            await testCase(
              unitGroup: massGroup,
              useCase: useCase,
              delta: EditConversionParamValueDelta(
                newValue: "40",
                newDefaultValue: "2",
                paramId: oneSideWeightParam.id,
                paramSetId: barbellWeightParamSet.id,
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
                paramSetsCanBeRemovedInBulk: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
              currentSrc: ConversionUnitValueModel.tuple(kilogram, null, 1),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, null, 1),
                ConversionUnitValueModel.tuple(
                    pound, null, 1 / pound.coefficient!),
              ],
              expectedSrc: ConversionUnitValueModel.tuple(kilogram, 90, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, 90, null),
                ConversionUnitValueModel.tuple(
                    pound, 90 / pound.coefficient!, null),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: barbellWeightParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(barWeightParam, 10, null,
                          unit: kilogram),
                      ConversionParamValueModel.tuple(oneSideWeightParam, 40, 2,
                          unit: kilogram),
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

        group('Src value does not exists | src default value does not exist',
            () {
          test('Source unit value only should be recalculated by params',
              () async {
            await testCase(
              unitGroup: massGroup,
              useCase: useCase,
              delta: EditConversionParamValueDelta(
                newValue: "40",
                newDefaultValue: "1",
                paramId: oneSideWeightParam.id,
                paramSetId: barbellWeightParamSet.id,
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
                paramSetsCanBeRemovedInBulk: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
              currentSrc: ConversionUnitValueModel.tuple(kilogram, null, null),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, null, null),
                ConversionUnitValueModel.tuple(pound, null, null),
              ],
              expectedSrc: ConversionUnitValueModel.tuple(kilogram, 90, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, 90, null),
                ConversionUnitValueModel.tuple(
                    pound, 90 / pound.coefficient!, null),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: barbellWeightParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(barWeightParam, 10, null,
                          unit: kilogram),
                      ConversionParamValueModel.tuple(oneSideWeightParam, 40, 1,
                          unit: kilogram),
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

      group('New param value exists | default value does not exist', () {
        group('Src value exists | src default value exists', () {
          test('Source unit value only should be recalculated by params',
              () async {
            await testCase(
              unitGroup: massGroup,
              useCase: useCase,
              delta: EditConversionParamValueDelta(
                newValue: "40",
                newDefaultValue: null,
                paramId: oneSideWeightParam.id,
                paramSetId: barbellWeightParamSet.id,
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
                paramSetsCanBeRemovedInBulk: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
              currentSrc: ConversionUnitValueModel.tuple(kilogram, 70, 1),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, 70, 1),
                ConversionUnitValueModel.tuple(
                    pound, 70 / pound.coefficient!, 1),
              ],
              expectedSrc: ConversionUnitValueModel.tuple(kilogram, 90, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, 90, null),
                ConversionUnitValueModel.tuple(
                    pound, 90 / pound.coefficient!, null),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: barbellWeightParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(barWeightParam, 10, null,
                          unit: kilogram),
                      ConversionParamValueModel.tuple(oneSideWeightParam, 40, 1,
                          unit: kilogram),
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

        group('Src value exists | src default value does not exist', () {
          test('Source unit value only should be recalculated by params',
              () async {
            await testCase(
              unitGroup: massGroup,
              useCase: useCase,
              delta: EditConversionParamValueDelta(
                newValue: "40",
                newDefaultValue: null,
                paramId: oneSideWeightParam.id,
                paramSetId: barbellWeightParamSet.id,
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
                paramSetsCanBeRemovedInBulk: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
              currentSrc: ConversionUnitValueModel.tuple(kilogram, 1, null),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, 1, null),
                ConversionUnitValueModel.tuple(
                    pound, 1 / pound.coefficient!, null),
              ],
              expectedSrc: ConversionUnitValueModel.tuple(kilogram, 90, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, 90, null),
                ConversionUnitValueModel.tuple(
                    pound, 90 / pound.coefficient!, null),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: barbellWeightParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(barWeightParam, 10, null,
                          unit: kilogram),
                      ConversionParamValueModel.tuple(oneSideWeightParam, 40, 1,
                          unit: kilogram),
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

        group('Src value does not exists | src default value exists', () {
          test('Source unit value only should be recalculated by params',
              () async {
            await testCase(
              unitGroup: massGroup,
              useCase: useCase,
              delta: EditConversionParamValueDelta(
                newValue: "40",
                newDefaultValue: null,
                paramId: oneSideWeightParam.id,
                paramSetId: barbellWeightParamSet.id,
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
                paramSetsCanBeRemovedInBulk: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
              currentSrc: ConversionUnitValueModel.tuple(kilogram, null, 1),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, null, 1),
                ConversionUnitValueModel.tuple(
                    pound, null, 1 / pound.coefficient!),
              ],
              expectedSrc: ConversionUnitValueModel.tuple(kilogram, 90, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, 90, null),
                ConversionUnitValueModel.tuple(
                    pound, 90 / pound.coefficient!, null),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: barbellWeightParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(barWeightParam, 10, null,
                          unit: kilogram),
                      ConversionParamValueModel.tuple(oneSideWeightParam, 40, 1,
                          unit: kilogram),
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

        group('Src value does not exists | src default value does not exist',
            () {
          test('Source unit value only should be recalculated by params',
              () async {
            await testCase(
              unitGroup: massGroup,
              useCase: useCase,
              delta: EditConversionParamValueDelta(
                newValue: "40",
                newDefaultValue: null,
                paramId: oneSideWeightParam.id,
                paramSetId: barbellWeightParamSet.id,
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
                paramSetsCanBeRemovedInBulk: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
              currentSrc: ConversionUnitValueModel.tuple(kilogram, null, null),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, null, null),
                ConversionUnitValueModel.tuple(pound, null, null),
              ],
              expectedSrc: ConversionUnitValueModel.tuple(kilogram, 90, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, 90, null),
                ConversionUnitValueModel.tuple(
                    pound, 90 / pound.coefficient!, null),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: barbellWeightParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(barWeightParam, 10, null,
                          unit: kilogram),
                      ConversionParamValueModel.tuple(oneSideWeightParam, 40, 1,
                          unit: kilogram),
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

      group('New param value does not exist | default value exists', () {
        group('Src value exists | src default value exists', () {
          test(
              'Source unit value only should be recalculated by param default value',
              () async {
            await testCase(
              unitGroup: massGroup,
              useCase: useCase,
              delta: EditConversionParamValueDelta(
                newValue: null,
                newDefaultValue: "40",
                paramId: oneSideWeightParam.id,
                paramSetId: barbellWeightParamSet.id,
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
                paramSetsCanBeRemovedInBulk: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
              currentSrc: ConversionUnitValueModel.tuple(kilogram, 70, 1),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, 70, 1),
                ConversionUnitValueModel.tuple(
                    pound, 70 / pound.coefficient!, 1),
              ],
              expectedSrc: ConversionUnitValueModel.tuple(kilogram, 90, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, 90, null),
                ConversionUnitValueModel.tuple(
                    pound, 90 / pound.coefficient!, null),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: barbellWeightParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(barWeightParam, 10, null,
                          unit: kilogram),
                      ConversionParamValueModel.tuple(
                          oneSideWeightParam, null, 40,
                          unit: kilogram),
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

        group('Src value exists | src default value does not exist', () {
          test(
              'Source unit value only should be recalculated by param default value',
              () async {
            await testCase(
              unitGroup: massGroup,
              useCase: useCase,
              delta: EditConversionParamValueDelta(
                newValue: null,
                newDefaultValue: "40",
                paramId: oneSideWeightParam.id,
                paramSetId: barbellWeightParamSet.id,
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
                paramSetsCanBeRemovedInBulk: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
              currentSrc: ConversionUnitValueModel.tuple(kilogram, 1, null),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, 1, null),
                ConversionUnitValueModel.tuple(
                    pound, 1 / pound.coefficient!, null),
              ],
              expectedSrc: ConversionUnitValueModel.tuple(kilogram, 90, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, 90, null),
                ConversionUnitValueModel.tuple(
                    pound, 90 / pound.coefficient!, null),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: barbellWeightParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(barWeightParam, 10, null,
                          unit: kilogram),
                      ConversionParamValueModel.tuple(
                          oneSideWeightParam, null, 40,
                          unit: kilogram),
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

        group('Src value does not exists | src default value exists', () {
          test(
              'Source unit value only should be recalculated by param default value',
              () async {
            await testCase(
              unitGroup: massGroup,
              useCase: useCase,
              delta: EditConversionParamValueDelta(
                newValue: null,
                newDefaultValue: "40",
                paramId: oneSideWeightParam.id,
                paramSetId: barbellWeightParamSet.id,
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
                paramSetsCanBeRemovedInBulk: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
              currentSrc: ConversionUnitValueModel.tuple(kilogram, null, 1),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, null, 1),
                ConversionUnitValueModel.tuple(
                    pound, null, 1 / pound.coefficient!),
              ],
              expectedSrc: ConversionUnitValueModel.tuple(kilogram, 90, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, 90, null),
                ConversionUnitValueModel.tuple(
                    pound, 90 / pound.coefficient!, null),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: barbellWeightParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(barWeightParam, 10, null,
                          unit: kilogram),
                      ConversionParamValueModel.tuple(
                          oneSideWeightParam, null, 40,
                          unit: kilogram),
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

        group('Src value does not exists | src default value does not exist',
            () {
          test('Source unit value only should be recalculated by params',
              () async {
            await testCase(
              unitGroup: massGroup,
              useCase: useCase,
              delta: EditConversionParamValueDelta(
                newValue: null,
                newDefaultValue: "40",
                paramId: oneSideWeightParam.id,
                paramSetId: barbellWeightParamSet.id,
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
                paramSetsCanBeRemovedInBulk: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
              currentSrc: ConversionUnitValueModel.tuple(kilogram, null, null),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, null, null),
                ConversionUnitValueModel.tuple(pound, null, null),
              ],
              expectedSrc: ConversionUnitValueModel.tuple(kilogram, 90, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, 90, null),
                ConversionUnitValueModel.tuple(
                    pound, 90 / pound.coefficient!, null),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: barbellWeightParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(barWeightParam, 10, null,
                          unit: kilogram),
                      ConversionParamValueModel.tuple(
                          oneSideWeightParam, null, 40,
                          unit: kilogram),
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

      group('New param value does not exist | default value does not exist',
          () {
        group('Src value exists | src default value exists', () {
          test(
              'Source unit value only should be recalculated '
              'by param default value of the unit type', () async {
            await testCase(
              unitGroup: massGroup,
              useCase: useCase,
              delta: EditConversionParamValueDelta(
                newValue: null,
                newDefaultValue: null,
                paramId: oneSideWeightParam.id,
                paramSetId: barbellWeightParamSet.id,
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
                paramSetsCanBeRemovedInBulk: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
              currentSrc: ConversionUnitValueModel.tuple(kilogram, 70, 1),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, 70, 1),
                ConversionUnitValueModel.tuple(
                    pound, 70 / pound.coefficient!, 1),
              ],
              expectedSrc: ConversionUnitValueModel.tuple(kilogram, 12, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, 12, null),
                ConversionUnitValueModel.tuple(
                    pound, 12 / pound.coefficient!, null),
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
                paramSetsCanBeRemovedInBulk: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
            );
          });
        });

        group('Src value exists | src default value does not exist', () {
          test(
              'Source unit value only should be recalculated '
              'by param default value of the unit type', () async {
            await testCase(
              unitGroup: massGroup,
              useCase: useCase,
              delta: EditConversionParamValueDelta(
                newValue: null,
                newDefaultValue: null,
                paramId: oneSideWeightParam.id,
                paramSetId: barbellWeightParamSet.id,
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
                paramSetsCanBeRemovedInBulk: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
              currentSrc: ConversionUnitValueModel.tuple(kilogram, 1, null),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, 1, null),
                ConversionUnitValueModel.tuple(
                    pound, 1 / pound.coefficient!, null),
              ],
              expectedSrc: ConversionUnitValueModel.tuple(kilogram, 12, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, 12, null),
                ConversionUnitValueModel.tuple(
                    pound, 12 / pound.coefficient!, null),
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
                paramSetsCanBeRemovedInBulk: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
            );
          });
        });

        group('Src value does not exists | src default value exists', () {
          test(
              'Source unit value only should be recalculated '
              'by param default value of the unit type', () async {
            await testCase(
              unitGroup: massGroup,
              useCase: useCase,
              delta: EditConversionParamValueDelta(
                newValue: null,
                newDefaultValue: null,
                paramId: oneSideWeightParam.id,
                paramSetId: barbellWeightParamSet.id,
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
                paramSetsCanBeRemovedInBulk: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
              currentSrc: ConversionUnitValueModel.tuple(kilogram, null, 1),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, null, 1),
                ConversionUnitValueModel.tuple(
                    pound, null, 1 / pound.coefficient!),
              ],
              expectedSrc: ConversionUnitValueModel.tuple(kilogram, 12, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, 12, null),
                ConversionUnitValueModel.tuple(
                    pound, 12 / pound.coefficient!, null),
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
                paramSetsCanBeRemovedInBulk: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
            );
          });
        });

        group('Src value does not exists | src default value does not exist',
            () {
          test(
              'Source unit value only should be recalculated '
              'by param default value of the unit type', () async {
            await testCase(
              unitGroup: massGroup,
              useCase: useCase,
              delta: EditConversionParamValueDelta(
                newValue: null,
                newDefaultValue: null,
                paramId: oneSideWeightParam.id,
                paramSetId: barbellWeightParamSet.id,
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
                paramSetsCanBeRemovedInBulk: true,
                paramSetsCanBeAdded: false,
                selectedIndex: 0,
                totalCount: 1,
              ),
              currentSrc: ConversionUnitValueModel.tuple(kilogram, null, null),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, null, null),
                ConversionUnitValueModel.tuple(pound, null, null),
              ],
              expectedSrc: ConversionUnitValueModel.tuple(kilogram, 12, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(kilogram, 12, null),
                ConversionUnitValueModel.tuple(
                    pound, 12 / pound.coefficient!, null),
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
                paramSetsCanBeRemovedInBulk: true,
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

    group('Change non-list parameter value (height)', () {
      group('New param value is not empty', () {
        test('New param value is acceptable (should recalculate conversion)',
            () async {
          await testCase(
            unitGroup: clothesSizeGroup,
            useCase: useCase,
            delta: EditConversionParamValueDelta(
              paramId: heightParam.id,
              paramSetId: heightParam.paramSetId,
              newValue: "150",
              newDefaultValue: null,
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
                    ConversionParamValueModel.tuple(heightParam, 160, 1,
                        unit: centimeter),
                  ],
                )
              ],
              selectedIndex: 0,
            ),
            currentUnitValues: currentUnitValues,
            expectedSrc:
                ConversionUnitValueModel.tuple(europeanClothSize, 42, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(europeanClothSize, 42, null),
              ConversionUnitValueModel.tuple(japanClothSize, 'S', null),
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
                        unit: centimeter),
                  ],
                )
              ],
              selectedIndex: 0,
            ),
          );
        });

        test(
            'Both new param values are not empty '
            '(the main value only should be applied)', () async {
          await testCase(
            unitGroup: clothesSizeGroup,
            useCase: useCase,
            delta: EditConversionParamValueDelta(
              paramId: heightParam.id,
              paramSetId: heightParam.paramSetId,
              newValue: "1800",
              newDefaultValue: "140",
            ),
            currentSrc:
                ConversionUnitValueModel.tuple(europeanClothSize, 30, null),
            currentParams: ConversionParamSetValueBulkModel(
              paramSetValues: [
                ConversionParamSetValueModel(
                  paramSet: clothesSizeParamSet,
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
            currentUnitValues: currentUnitValues,
            expectedSrc:
                ConversionUnitValueModel.tuple(europeanClothSize, 56, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(europeanClothSize, 56, null),
              ConversionUnitValueModel.tuple(japanClothSize, '6L', null),
            ],
            expectedParams: ConversionParamSetValueBulkModel(
              paramSetValues: [
                ConversionParamSetValueModel(
                  paramSet: clothesSizeParamSet,
                  paramValues: [
                    ConversionParamValueModel.tuple(personParam, "Man", null),
                    ConversionParamValueModel.tuple(
                        garmentParam, "Shirt", null),
                    ConversionParamValueModel.tuple(heightParam, 1800, 140,
                        unit: centimeter),
                  ],
                )
              ],
              selectedIndex: 0,
            ),
          );
        });
      });

      group('New param value is empty', () {
        test(
          'New param default value is not empty',
          () async {
            await testCase(
              unitGroup: clothesSizeGroup,
              useCase: useCase,
              delta: EditConversionParamValueDelta(
                paramId: heightParam.id,
                paramSetId: heightParam.paramSetId,
                newValue: null,
                newDefaultValue: "160",
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
                          unit: centimeter),
                    ],
                  )
                ],
                selectedIndex: 0,
              ),
              currentUnitValues: currentUnitValues,
              expectedSrc:
                  ConversionUnitValueModel.tuple(europeanClothSize, 42, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(europeanClothSize, 42, null),
                ConversionUnitValueModel.tuple(japanClothSize, 'S', null),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: clothesSizeParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(personParam, "Man", null),
                      ConversionParamValueModel.tuple(
                          garmentParam, "Shirt", null),
                      ConversionParamValueModel.tuple(heightParam, null, 160,
                          unit: centimeter),
                    ],
                  )
                ],
                selectedIndex: 0,
              ),
            );
          },
        );
      });
    });

    group('Change list parameter value (garment)', () {
      group('New param value is empty', () {
        test('New value and default value is empty', () async {
          await testCase(
            unitGroup: clothesSizeGroup,
            useCase: useCase,
            delta: EditConversionParamValueDelta(
              paramId: garmentParam.id,
              paramSetId: garmentParam.paramSetId,
              newValue: null,
              newDefaultValue: null,
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
                        unit: centimeter),
                  ],
                )
              ],
              selectedIndex: 0,
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
          'New value is empty and new default value is not empty '
          '(list value should be ignored)',
          () async {
            await testCase(
              unitGroup: clothesSizeGroup,
              useCase: useCase,
              delta: EditConversionParamValueDelta(
                paramId: garmentParam.id,
                paramSetId: garmentParam.paramSetId,
                newValue: null,
                newDefaultValue: "Any",
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
                          unit: centimeter),
                    ],
                  )
                ],
                selectedIndex: 0,
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
                      ConversionParamValueModel.tuple(garmentParam, null, null),
                      ConversionParamValueModel.tuple(heightParam, 150, 1,
                          unit: centimeter),
                    ],
                  )
                ],
                selectedIndex: 0,
              ),
            );
          },
        );
      });
    });
  });
}
