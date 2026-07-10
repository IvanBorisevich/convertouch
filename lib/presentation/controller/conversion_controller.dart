import 'package:collection/collection.dart';
import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/conversion_param_model.dart';
import 'package:convertouch/domain/model/dynamic_data_model.dart';
import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_events.dart';
import 'package:convertouch/presentation/controller/conversion_item_controller.dart';
import 'package:convertouch/presentation/controller/navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final conversionController = di.locator.get<ConversionController>();

class ConversionController {
  const ConversionController();

  void getOrBuildConversion(
    BuildContext context, {
    required UnitGroupModel unitGroup,
    void Function(ConversionModel)? processCurrentConversion,
  }) {
    conversionItemController.resetUnitValues(context);
    conversionItemController.resetParamValues(context);

    BlocProvider.of<ConversionBloc>(context).add(
      GetOrBuildConversion(
        unitGroup: unitGroup,
        processPrevConversion: (prevConversion) {
          BlocProvider.of<ConversionBloc>(context).add(
            SaveConversion(
              conversion: prevConversion,
              onError: (error) {
                navigationController.showException(context, exception: error);
              },
            ),
          );
        },
        processCurrentConversion: processCurrentConversion,
      ),
    );
  }

  void editConversionGroup(
    BuildContext context, {
    required UnitGroupModel modifiedGroup,
  }) {
    BlocProvider.of<ConversionBloc>(context).add(
      EditConversionGroup(
        editedGroup: modifiedGroup,
        onError: (error) {
          navigationController.showException(context, exception: error);
        },
      ),
    );
  }

  void addUnitsToConversion(
    BuildContext context, {
    List<int> unitIds = const [],
    required bool conversionHasItems,
  }) {
    conversionItemController.resetUnitValues(context);

    BlocProvider.of<ConversionBloc>(context).add(
      AddUnitsToConversion(
        unitIds: unitIds,
        onError: (error) {
          navigationController.showException(context, exception: error);
        },
      ),
    );

    if (conversionHasItems) {
      navigationController.navigateBack(context);
    } else {
      navigationController.navigateTo(
        context,
        pageName: PageName.conversionPage,
        replace: true,
      );
    }
  }

  void editConversionItemUnit(
    BuildContext context, {
    required UnitModel modifiedUnit,
  }) {
    BlocProvider.of<ConversionBloc>(context).add(
      EditConversionUnit(
        editedUnit: modifiedUnit,
        onError: (error) {
          navigationController.showException(context, exception: error);
        },
        onConversionUpdated: (updatedConversion, {info}) {
          final updatedUnitValue = updatedConversion.convertedUnitValues
              .firstWhereOrNull(
                  (unitValue) => unitValue.unit.id == modifiedUnit.id);

          if (updatedUnitValue != null) {
            conversionItemController.updateUnitValue(
              context,
              id: updatedUnitValue.id,
              newUnitValue: updatedUnitValue,
              isSource: updatedUnitValue.unit.id ==
                  updatedConversion.srcUnitValue?.unit.id,
            );
          }
        },
      ),
    );
  }

  void replaceConversionItemUnit(
    BuildContext context, {
    required int currentUnitId,
    required UnitModel newUnit,
    required RecalculationOnUnitChange recalculationMode,
  }) {
    BlocProvider.of<ConversionBloc>(context).add(
      ReplaceConversionItemUnit(
        newUnit: newUnit,
        oldUnitId: currentUnitId,
        recalculationMode: recalculationMode,
        onConversionUpdated: (updatedConversion, {info}) {
          for (final unitValue in updatedConversion.convertedUnitValues) {
            conversionItemController.updateUnitValue(
              context,
              id: unitValue.unit.id == newUnit.id
                  ? unitValueKey(currentUnitId)
                  : unitValue.id,
              newUnitValue: unitValue,
              isSource: unitValue.unit.id == newUnit.id,
            );
          }

          navigationController.navigateBack(context);
        },
        onError: (error) {
          navigationController.showException(context, exception: error);
        },
      ),
    );
  }

  void editConversionItemValue(
    BuildContext context, {
    required int unitId,
    required ValueModel? newValue,
    ListValuesFetchResult? listValues,
  }) {
    BlocProvider.of<ConversionBloc>(context).add(
      EditConversionUnitValue(
        newValue: newValue,
        listValues: listValues,
        unitId: unitId,
        onConversionUpdated: (updatedConversion, {info}) {
          for (final unitValue in updatedConversion.convertedUnitValues) {
            conversionItemController.updateUnitValue(
              context,
              id: unitValue.id,
              newUnitValue: unitValue,
              isSource: unitValue.unit.id == unitId,
            );
          }
        },
        onError: (error) {
          navigationController.showException(context, exception: error);
        },
      ),
    );
  }

  void removeConversionItem(BuildContext context, {required int unitId}) {
    removeConversionItems(context, unitIds: [unitId]);
  }

  void removeConversionItems(
    BuildContext context, {
    List<int> unitIds = const [],
  }) {
    conversionItemController.resetUnitValues(context);

    BlocProvider.of<ConversionBloc>(context).add(
      RemoveConversionItems(
        unitIds: unitIds,
        onError: (error) {
          navigationController.showException(context, exception: error);
        },
      ),
    );
  }

  void replaceParamUnit(
    BuildContext context, {
    required ConversionParamModel param,
    required UnitModel newUnit,
  }) {
    BlocProvider.of<ConversionBloc>(context).add(
      ReplaceConversionParamUnit(
        newUnit: newUnit,
        paramId: param.id,
        paramSetId: param.paramSetId,
        onConversionUpdated: (updatedConversion, {info}) {
          final updatedParamValue = updatedConversion.params
              ?.getParamSetValueById(param.paramSetId)
              ?.getParamValueById(param.id);

          if (updatedParamValue != null) {
            conversionItemController.updateParamValue(
              context,
              id: updatedParamValue.id,
              newParamValue: updatedParamValue,
            );
          }

          navigationController.navigateBack(context);
        },
        onError: (error) {
          navigationController.showException(context, exception: error);
        },
      ),
    );
  }

  void editConversionParamValue(
    BuildContext context, {
    required ConversionParamValueModel paramValue,
    required ValueModel? newValue,
    ListValuesFetchResult? listValues,
    ParamSetValueChangedCallback? ifParamSetFilled,
    ParamSetValueChangedCallback? ifParamSetFilledPartiallyOrEmpty,
  }) {
    BlocProvider.of<ConversionBloc>(context).add(
      EditConversionParamValue(
        newValue: newValue,
        listValues: listValues,
        paramId: paramValue.param.id,
        paramSetId: paramValue.param.paramSetId,
        ifParamSetFilled: ifParamSetFilled,
        ifParamSetFilledPartiallyOrEmpty: ifParamSetFilledPartiallyOrEmpty,
        onError: (error) {
          navigationController.showException(context, exception: error);
        },
        onConversionUpdated: (updatedConversion, {info}) {
          for (final paramValue
              in updatedConversion.params!.active!.paramValues) {
            conversionItemController.updateParamValue(
              context,
              id: paramValue.id,
              newParamValue: paramValue,
            );
          }

          for (final unitValue in updatedConversion.convertedUnitValues) {
            conversionItemController.updateUnitValue(
              context,
              id: unitValue.id,
              newUnitValue: unitValue,
              isSource:
                  unitValue.unit.id == updatedConversion.srcUnitValue?.unit.id,
            );
          }
        },
      ),
    );
  }

  void toggleParamCalculable(
    BuildContext context, {
    required int paramId,
    required int paramSetId,
  }) {
    BlocProvider.of<ConversionBloc>(context).add(
      ToggleCalculableParam(
        paramId: paramId,
        paramSetId: paramSetId,
        onConversionUpdated: (updatedConversion, {info}) {
          final updatedParamValue = updatedConversion.params
              ?.getParamSetValueById(paramSetId)
              ?.getParamValueById(paramId);

          if (updatedParamValue != null) {
            conversionItemController.updateParamValue(
              context,
              id: updatedParamValue.id,
              newParamValue: updatedParamValue,
            );
          }
        },
      ),
    );
  }

  void selectParamSet(BuildContext context, {required int index}) {
    conversionItemController.resetParamValues(context);

    BlocProvider.of<ConversionBloc>(context).add(
      SelectParamSetInConversion(
        newSelectedParamSetIndex: index,
        onError: (error) {
          navigationController.showException(context, exception: error);
        },
        onConversionUpdated: (updatedConversion, {info}) {
          for (final unitValue in updatedConversion.convertedUnitValues) {
            conversionItemController.updateUnitValue(
              context,
              id: unitValue.id,
              newUnitValue: unitValue,
              isSource:
                  unitValue.unit.id == updatedConversion.srcUnitValue?.unit.id,
            );
          }
        },
      ),
    );
  }

  void removeSelectedParamSet(BuildContext context) {
    conversionItemController.resetParamValues(context);

    BlocProvider.of<ConversionBloc>(context).add(
      RemoveSelectedParamSetFromConversion(
        onConversionUpdated: (updatedConversion, {info}) {
          for (final unitValue in updatedConversion.convertedUnitValues) {
            conversionItemController.updateUnitValue(
              context,
              id: unitValue.id,
              newUnitValue: unitValue,
              isSource:
                  unitValue.unit.id == updatedConversion.srcUnitValue?.unit.id,
            );
          }
        },
        onError: (error) {
          navigationController.showException(context, exception: error);
        },
      ),
    );
  }

  void removeOptionalParamSets(BuildContext context) {
    conversionItemController.resetParamValues(context);

    BlocProvider.of<ConversionBloc>(context).add(
      RemoveAllParamSetsFromConversion(
        onConversionUpdated: (updatedConversion, {info}) {
          for (final unitValue in updatedConversion.convertedUnitValues) {
            conversionItemController.updateUnitValue(
              context,
              id: unitValue.id,
              newUnitValue: unitValue,
              isSource:
                  unitValue.unit.id == updatedConversion.srcUnitValue?.unit.id,
            );
          }
        },
        onError: (error) {
          navigationController.showException(context, exception: error);
        },
      ),
    );
  }

  void addParamsToConversion(
    BuildContext context, {
    List<int> paramSetIds = const [],
    bool fetchListValues = true,
  }) {
    conversionItemController.resetParamValues(context);

    BlocProvider.of<ConversionBloc>(context).add(
      AddParamSetsToConversion(
        paramSetIds: paramSetIds,
        fetchListValues: fetchListValues,
        onConversionUpdated: (updatedConversion, {info}) {
          navigationController.navigateBack(context);
        },
        onError: (error) {
          navigationController.showException(context, exception: error);
        },
      ),
    );
  }

  void cleanupConversion(BuildContext context, {bool preserveParams = true}) {
    conversionItemController.resetUnitValues(context);

    if (!preserveParams) {
      conversionItemController.resetParamValues(context);
    }

    BlocProvider.of<ConversionBloc>(context).add(
      CleanupConversion(
        keepParams: preserveParams,
        onError: (error) {
          navigationController.showException(context, exception: error);
        },
      ),
    );
  }

  void moveConversionUnitValue(
    BuildContext context, {
    required int oldIndex,
    required int newIndex,
  }) {
    conversionItemController.resetUnitValues(context);

    BlocProvider.of<ConversionBloc>(context).add(
      MoveConversionUnitValue(
        oldIndex: oldIndex,
        newIndex: newIndex,
      ),
    );
  }

  void updateWithDynamicData(
    BuildContext context, {
    required DynamicDataModel data,
  }) {
    if (data is DynamicCoefficientsModel) {
      BlocProvider.of<ConversionBloc>(context).add(
        UpdateConversionCoefficients(
          newCoefficients: data,
          onConversionUpdated: (updatedConversion, {info}) {
            for (final unitValue in updatedConversion.convertedUnitValues) {
              conversionItemController.updateUnitValue(
                context,
                id: unitValue.id,
                newUnitValue: unitValue,
                isSource: unitValue.unit.id ==
                    updatedConversion.srcUnitValue?.unit.id,
              );
            }
          },
        ),
      );
    }

    if (data is DynamicValueModel) {
      BlocProvider.of<ConversionBloc>(context).add(
        EditConversionUnitValue(
          newValue: null,
          newDefaultValue: ValueModel.any(data.value),
          unitId: data.unitId,
        ),
      );
    }
  }
}
