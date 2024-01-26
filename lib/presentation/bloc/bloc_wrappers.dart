import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';
import 'package:convertouch/presentation/bloc/app/app_bloc.dart';
import 'package:convertouch/presentation/bloc/app/app_state.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_states.dart';
import 'package:convertouch/presentation/bloc/menu_items/menu_items_view_bloc.dart';
import 'package:convertouch/presentation/bloc/menu_items/menu_items_view_states.dart';
import 'package:convertouch/presentation/bloc/refreshing_job_details_page/refreshing_job_details_bloc.dart';
import 'package:convertouch/presentation/bloc/refreshing_job_details_page/refreshing_job_details_states.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_control/refreshing_jobs_control_bloc.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_control/refreshing_jobs_control_states.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_bloc.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_states.dart';
import 'package:convertouch/presentation/bloc/unit_creation_page/unit_creation_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_creation_page/unit_creation_states.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc_for_conversion.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc_for_unit_creation.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_states.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc_for_conversion.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc_for_unit_creation.dart';
import 'package:convertouch/presentation/bloc/units_page/units_states.dart';
import 'package:convertouch/presentation/ui/pages/templates/basic_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget blocBuilderWrap<B extends ConvertouchBloc<ConvertouchEvent, S>,
    S extends ConvertouchState, PS extends S>(
  Widget Function(PS pageState) builderFunc,
) {
  return BlocBuilder<B, S>(
    buildWhen: (prev, next) {
      return prev != next && (next is PS || next is ConvertouchErrorState);
    },
    builder: (_, state) {
      if (state is PS) {
        return builderFunc.call(state);
      } else {
        return empty();
      }
    },
  );
}

var appBlocBuilder = blocBuilderWrap<AppBloc, AppState, AppStateBuilt>;

var unitGroupsViewModeBlocBuilder = blocBuilderWrap<UnitGroupsViewModeBloc,
    MenuItemsViewState, MenuItemsViewStateSet>;
var unitGroupsBlocBuilder =
    blocBuilderWrap<UnitGroupsBloc, UnitGroupsState, UnitGroupsFetched>;
var unitGroupsBlocBuilderForConversion = blocBuilderWrap<
    UnitGroupsBlocForConversion,
    UnitGroupsState,
    UnitGroupsFetchedForConversion>;
var unitGroupsBlocBuilderForUnitCreation = blocBuilderWrap<
    UnitGroupsBlocForUnitCreation,
    UnitGroupsState,
    UnitGroupsFetchedForUnitCreation>;

var unitsViewModeBlocBuilder = blocBuilderWrap<UnitsViewModeBloc,
    MenuItemsViewState, MenuItemsViewStateSet>;
var unitsBlocBuilder = blocBuilderWrap<UnitsBloc, UnitsState, UnitsFetched>;
var unitsBlocBuilderForConversion = blocBuilderWrap<UnitsBlocForConversion,
    UnitsState, UnitsFetchedForConversion>;
var unitsBlocBuilderForUnitCreation = blocBuilderWrap<UnitsBlocForUnitCreation,
    UnitsState, UnitsFetchedForUnitCreation>;
var unitCreationBlocBuilder =
    blocBuilderWrap<UnitCreationBloc, UnitCreationState, UnitCreationPrepared>;

var conversionsBlocBuilder =
    blocBuilderWrap<ConversionBloc, ConversionState, ConversionBuilt>;

var refreshingJobsBlocBuilder = blocBuilderWrap<RefreshingJobsBloc,
    RefreshingJobsState, RefreshingJobsFetched>;

var refreshingJobsControlBlocBuilder = blocBuilderWrap<
    RefreshingJobsControlBloc,
    RefreshingJobsControlState,
    RefreshingJobsProgressUpdated>;

var refreshingJobDetailsBlocBuilder = blocBuilderWrap<RefreshingJobDetailsBloc,
    RefreshingJobDetailsState, RefreshingJobDetailsReady>;

Widget unitsChangeBlocListenerWrap({
  required Function(UnitsFetched)? handler,
  required Widget? child,
}) {
  return BlocListener<UnitsBloc, UnitsState>(
    listener: (_, unitsState) {
      if (unitsState is UnitsFetched &&
          (unitsState.removedIds.isNotEmpty || unitsState.addedId != null)) {
        handler?.call(unitsState);
      }
    },
    child: child,
  );
}

Widget unitGroupsChangeBlocListenerWrap({
  required Function(UnitGroupsFetched)? handler,
  required Widget? child,
}) {
  return BlocListener<UnitGroupsBloc, UnitGroupsState>(
    listener: (_, unitGroupsState) {
      if (unitGroupsState is UnitGroupsFetched &&
          (unitGroupsState.removedIds.isNotEmpty ||
              unitGroupsState.addedId != null)) {
        handler?.call(unitGroupsState);
      }
    },
    child: child,
  );
}
