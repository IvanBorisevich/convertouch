import 'package:convertouch/domain/model/input/abstract_event.dart';
import 'package:convertouch/domain/model/output/abstract_state.dart';
import 'package:convertouch/domain/model/output/app_state.dart';
import 'package:convertouch/domain/model/output/conversion_states.dart';
import 'package:convertouch/domain/model/output/menu_items_view_states.dart';
import 'package:convertouch/domain/model/output/refreshing_jobs_states.dart';
import 'package:convertouch/domain/model/output/unit_creation_states.dart';
import 'package:convertouch/domain/model/output/unit_groups_states.dart';
import 'package:convertouch/domain/model/output/units_states.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/app_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/menu_items_view_bloc.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_bloc.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_progress_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_creation_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups_bloc_for_conversion.dart';
import 'package:convertouch/presentation/bloc/unit_groups_bloc_for_unit_creation.dart';
import 'package:convertouch/presentation/bloc/units_bloc.dart';
import 'package:convertouch/presentation/bloc/units_bloc_for_conversion.dart';
import 'package:convertouch/presentation/bloc/units_bloc_for_unit_creation.dart';
import 'package:convertouch/presentation/ui/pages/templates/basic_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget blocBuilderWrap<B extends ConvertouchBloc<ConvertouchEvent, S>,
    S extends ConvertouchState, PS extends S>(
  Widget Function(PS pageState) builderFunc,
) {
  return BlocBuilder<B, S>(
    buildWhen: (prev, next) {
      return prev != next && next is PS;
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
    UnitsState, UnitsFetchedToMarkForConversion>;
var unitsBlocBuilderForUnitCreation = blocBuilderWrap<UnitsBlocForUnitCreation,
    UnitsState, UnitsFetchedForUnitCreation>;
var unitCreationBlocBuilder =
    blocBuilderWrap<UnitCreationBloc, UnitCreationState, UnitCreationPrepared>;

var conversionsBlocBuilder =
    blocBuilderWrap<ConversionBloc, ConversionState, ConversionBuilt>;

var refreshingJobsBlocBuilder = blocBuilderWrap<RefreshingJobsBloc,
    RefreshingJobsState, RefreshingJobsFetched>;
var refreshingJobsProgressBlocBuilder = blocBuilderWrap<
    RefreshingJobsProgressBloc,
    RefreshingJobsState,
    RefreshingJobsProgressUpdated>;

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
