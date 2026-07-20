import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/conversion_param_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/dynamic_data_model.dart';
import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_events.dart';
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
    required bool conversionHasUnitValuesOrParams,
  }) {
    BlocProvider.of<ConversionBloc>(context).add(
      AddUnitsToConversion(
        unitIds: unitIds,
        onError: (error) {
          navigationController.showException(context, exception: error);
        },
      ),
    );

    if (conversionHasUnitValuesOrParams) {
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
        doAfter: (updatedConversion, {info}) {
          navigationController.navigateBack(context);
        },
        onError: (error) {
          navigationController.showException(context, exception: error);
        },
      ),
    );
  }

  void editConversionUnitValue(
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
        doAfter: (updatedConversion, {info}) {
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
    void Function(ConversionModel)? ifParamSetFilled,
    void Function(ConversionModel)? ifParamSetFilledPartiallyOrEmpty,
  }) {
    BlocProvider.of<ConversionBloc>(context).add(
      EditConversionParamValue(
        newValue: newValue,
        listValues: listValues,
        paramId: paramValue.param.id,
        paramSetId: paramValue.param.paramSetId,
        doAfter: (updatedConversion, {info}) {
          if (areParamsFilled(updatedConversion.params?.active)) {
            ifParamSetFilled?.call(updatedConversion);
          } else if (areParamsPartiallyFilled(
              updatedConversion.params?.active)) {
            ifParamSetFilledPartiallyOrEmpty?.call(updatedConversion);
          }
        },
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

  void selectParamSet(BuildContext context, {required int index}) {
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

  void removeOptionalParamSets(BuildContext context) {
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
    BlocProvider.of<ConversionBloc>(context).add(
      AddParamSetsToConversion(
        paramSetIds: paramSetIds,
        fetchListValues: fetchListValues,
        doAfter: (updatedConversion, {info}) {
          navigationController.navigateBack(context);
        },
        onError: (error) {
          navigationController.showException(context, exception: error);
        },
      ),
    );
  }

  void cleanupConversion(BuildContext context, {bool preserveParams = true}) {
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
