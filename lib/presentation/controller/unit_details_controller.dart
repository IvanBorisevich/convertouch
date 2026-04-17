import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_events.dart';
import 'package:convertouch/presentation/controller/navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final unitDetailsController = di.locator.get<UnitDetailsController>();

class UnitDetailsController {
  const UnitDetailsController();

  void startUnitCreation(
    BuildContext context, {
    required UnitGroupModel unitGroup,
  }) {
    BlocProvider.of<UnitDetailsBloc>(context).add(
      GetNewUnitDetails(
        unitGroup: unitGroup,
        onSuccess: ({info}) {
          navigationController.navigateTo(
            context,
            pageName: PageName.unitDetailsPage,
          );
        },
        onError: (error) {
          navigationController.showException(context, exception: error);
        },
      ),
    );
  }

  void showUnitDetails(
    BuildContext context, {
    required UnitModel unit,
    required UnitGroupModel unitGroup,
  }) {
    BlocProvider.of<UnitDetailsBloc>(context).add(
      GetExistingUnitDetails(
        unit: unit,
        unitGroup: unitGroup,
        onSuccess: ({info}) {
          navigationController.navigateTo(
            context,
            pageName: PageName.unitDetailsPage,
          );
        },
        onError: (error) {
          navigationController.showException(context, exception: error);
        },
      ),
    );
  }

  void changeGroup(
    BuildContext context, {
    required UnitGroupModel unitGroup,
  }) {
    BlocProvider.of<UnitDetailsBloc>(context).add(
      ChangeGroupInUnitDetails(
        unitGroup: unitGroup,
        onSuccess: ({info}) {
          navigationController.navigateBack(context);
        },
        onError: (error) {
          navigationController.showException(context, exception: error);
        },
      ),
    );
  }

  void updateUnitName(BuildContext context, {required String newValue}) {
    BlocProvider.of<UnitDetailsBloc>(context).add(
      UpdateUnitNameInUnitDetails(
        newValue: newValue,
        onError: (error) {
          navigationController.showException(context, exception: error);
        },
      ),
    );
  }

  void updateUnitCode(BuildContext context, {required String newValue}) {
    BlocProvider.of<UnitDetailsBloc>(context).add(
      UpdateUnitCodeInUnitDetails(
        newValue: newValue,
        onError: (error) {
          navigationController.showException(context, exception: error);
        },
      ),
    );
  }

  void updateUnitValue(BuildContext context, {required String newValue}) {
    BlocProvider.of<UnitDetailsBloc>(context).add(
      UpdateUnitValueInUnitDetails(
        newValue: newValue,
        onError: (error) {
          navigationController.showException(context, exception: error);
        },
      ),
    );
  }

  void updateArgUnitValue(BuildContext context, {required String newValue}) {
    BlocProvider.of<UnitDetailsBloc>(context).add(
      UpdateArgumentUnitValueInUnitDetails(
        newValue: newValue,
        onError: (error) {
          navigationController.showException(context, exception: error);
        },
      ),
    );
  }

  void changeArgUnit(BuildContext context, {required UnitModel newUnit}) {
    BlocProvider.of<UnitDetailsBloc>(context).add(
      ChangeArgumentUnitInUnitDetails(
        argumentUnit: newUnit,
        onSuccess: ({info}) {
          navigationController.navigateBack(context);
        },
        onError: (error) {
          navigationController.showException(context, exception: error);
        },
      ),
    );
  }
}
