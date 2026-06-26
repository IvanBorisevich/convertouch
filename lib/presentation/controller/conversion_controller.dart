import 'package:collection/collection.dart';
import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/conversion_param_model.dart';
import 'package:convertouch/domain/model/dynamic_data_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
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

  void alignConversion(
    BuildContext context, {
    required ConversionModel conversion,
    bool alignParams = true,
    bool alignUnits = true,
  }) {
    BlocProvider.of<ConversionBloc>(context).add(
      AlignConversion(
        conversion: conversion,
        alignParams: alignParams,
        alignUnits: alignUnits,
        onParamValueUpdated: (newParamValue) {
          conversionItemController.updateParamValue(
            context,
            id: newParamValue.id,
            newParamValue: newParamValue,
          );
        },
        onUnitValueUpdated: (newUnitValue, isSource) {
          conversionItemController.updateUnitValue(
            context,
            id: newUnitValue.id,
            newUnitValue: newUnitValue,
            isSource: isSource,
          );
        },
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
        onParamValueUpdated: (newParamValue) {
          conversionItemController.updateParamValue(
            context,
            id: newParamValue.id,
            newParamValue: newParamValue,
          );
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

  void changeConversionItemUnit(
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

  void changeConversionItemValue(
    BuildContext context, {
    required int unitId,
    required ValueModel? newValue,
  }) {
    BlocProvider.of<ConversionBloc>(context).add(
      EditConversionUnitValue(
        newValue: newValue,
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

  void changeParamValue(
    BuildContext context, {
    required ConversionParamValueModel paramValue,
    required ValueModel? newValue,
    void Function(ConversionModel, {ConvertouchException? info})? onChanged,
  }) {
    BlocProvider.of<ConversionBloc>(context).add(
      EditConversionParamValue(
        newValue: newValue,
        paramId: paramValue.param.id,
        paramSetId: paramValue.param.paramSetId,
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

          onChanged?.call(updatedConversion, info: info);
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

  void refreshParamListValues(
    BuildContext context, {
    required int paramId,
  }) {
    BlocProvider.of<ConversionBloc>(context).add(
      AlignConversion(
        alignUnits: false,
        paramIdToRefreshListValues: paramId,
        onParamValueUpdated: (newParamValue) {
          conversionItemController.updateParamValue(
            context,
            id: newParamValue.id,
            newParamValue: newParamValue,
          );
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
      ),
    );
  }

  void removeSelectedParamSet(BuildContext context) {
    conversionItemController.resetParamValues(context);

    BlocProvider.of<ConversionBloc>(context).add(
      RemoveSelectedParamSetFromConversion(
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
        UpdateConversionCoefficients(newCoefficients: data),
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
