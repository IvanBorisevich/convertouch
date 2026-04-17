import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/presentation/bloc/unit_group_details_page/unit_group_details_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_group_details_page/unit_group_details_events.dart';
import 'package:convertouch/presentation/controller/navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final unitGroupDetailsController = di.locator.get<UnitGroupDetailsController>();

class UnitGroupDetailsController {
  const UnitGroupDetailsController();

  void startGroupCreation(BuildContext context) {
    BlocProvider.of<UnitGroupDetailsBloc>(context).add(
      GetNewUnitGroupDetails(
        onSuccess: ({info}) {
          navigationController.navigateTo(
            context,
            pageName: PageName.unitGroupDetailsPage,
          );
        },
      ),
    );
  }

  void showGroupDetails(
    BuildContext context, {
    required UnitGroupModel unitGroup,
  }) {
    BlocProvider.of<UnitGroupDetailsBloc>(context).add(
      GetExistingUnitGroupDetails(
        unitGroup: unitGroup,
        onSuccess: ({info}) {
          navigationController.navigateTo(
            context,
            pageName: PageName.unitGroupDetailsPage,
          );
        },
      ),
    );
  }

  void updateGroupName(BuildContext context, {required String newValue}) {
    BlocProvider.of<UnitGroupDetailsBloc>(context).add(
      UpdateUnitGroupName(newValue: newValue),
    );
  }
}
