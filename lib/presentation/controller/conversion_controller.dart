import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/conversion_param_model.dart';
import 'package:convertouch/domain/model/dynamic_data_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_events.dart';
import 'package:convertouch/presentation/controller/navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final conversionController = di.locator.get<ConversionController>();

class ConversionController {
  const ConversionController();

  void getConversion(
    BuildContext context, {
    required UnitGroupModel unitGroup,
    void Function(ConversionModel?)? processCurrentConversion,
  }) {
    BlocProvider.of<ConversionBloc>(context).add(
      GetConversion(
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

  void editConversionItemUnit(
    BuildContext context, {
    required UnitModel modifiedUnit,
  }) {
    BlocProvider.of<ConversionBloc>(context).add(
      EditConversionItemUnit(
        editedUnit: modifiedUnit,
        onError: (error) {
          navigationController.showException(context, exception: error);
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
        onSuccess: ({info}) {
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
    required String? newValue,
  }) {
    BlocProvider.of<ConversionBloc>(context).add(
      EditConversionItemValue(
        newValue: newValue,
        unitId: unitId,
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
    BlocProvider.of<ConversionBloc>(context).add(
      RemoveConversionItems(
        unitIds: unitIds,
        onError: (error) {
          navigationController.showException(context, exception: error);
        },
      ),
    );
  }

  void changeParamUnit(
    BuildContext context, {
    required ConversionParamModel param,
    required UnitModel newUnit,
  }) {
    BlocProvider.of<ConversionBloc>(context).add(
      ReplaceConversionParamUnit(
        newUnit: newUnit,
        paramId: param.id,
        paramSetId: param.paramSetId,
        onSuccess: ({info}) {
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
    required String? newValue,
  }) {
    BlocProvider.of<ConversionBloc>(context).add(
      EditConversionParamValue(
        newValue: newValue,
        paramId: paramValue.param.id,
        paramSetId: paramValue.param.paramSetId,
        onError: (error) {
          navigationController.showException(context, exception: error);
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
      ),
    );
  }

  void showParamSet(BuildContext context, {required int index}) {
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
    BlocProvider.of<ConversionBloc>(context).add(
      RemoveSelectedParamSetFromConversion(
        onError: (error) {
          navigationController.showException(context, exception: error);
        },
      ),
    );
  }

  void removeOptionalParams(BuildContext context) {
    BlocProvider.of<ConversionBloc>(context).add(
      RemoveAllParamSetsFromConversion(
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

  void addParamsToConversion(
    BuildContext context, {
    List<int> paramSetIds = const [],
  }) {
    BlocProvider.of<ConversionBloc>(context).add(
      AddParamSetsToConversion(
        paramSetIds: paramSetIds,
        onSuccess: ({info}) {
          navigationController.navigateBack(context);
        },
        onError: (error) {
          navigationController.showException(context, exception: error);
        },
      ),
    );
  }

  void clearConversion(BuildContext context, {bool preserveParams = true}) {
    BlocProvider.of<ConversionBloc>(context).add(
      CleanupConversion(
        keepParams: preserveParams,
        onError: (error) {
          navigationController.showException(context, exception: error);
        },
      ),
    );
  }

  void updateCoefficients(
    BuildContext context, {
    required DynamicCoefficientsModel coefficients,
  }) {
    BlocProvider.of<ConversionBloc>(context).add(
      UpdateConversionCoefficients(newCoefficients: coefficients),
    );
  }

  void updateDynamicSrcValue(
    BuildContext context, {
    required DynamicValueModel dynamicSrcValue,
  }) {
    BlocProvider.of<ConversionBloc>(context).add(
      EditConversionItemValue(
        newValue: null,
        newDefaultValue: dynamicSrcValue.value,
        unitId: dynamicSrcValue.unitId,
      ),
    );
  }

  void updateFromNetwork(
    BuildContext context, {
    required DynamicDataModel data,
  }) {
    if (data is DynamicCoefficientsModel) {
      conversionController.updateCoefficients(
        context,
        coefficients: data,
      );
    }

    if (data is DynamicValueModel) {
      conversionController.updateDynamicSrcValue(
        context,
        dynamicSrcValue: data,
      );
    }
  }
}
