import 'package:convertouch/presentation/bloc/abstract_event.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';
import 'package:convertouch/presentation/bloc/common/app/app_bloc.dart';
import 'package:convertouch/presentation/bloc/common/app/app_state.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_states.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_bloc.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_states.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_states.dart';
import 'package:convertouch/presentation/bloc/unit_group_details_page/unit_group_details_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_group_details_page/unit_group_details_states.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc_for_conversion.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc_for_unit_details.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_states.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc_for_conversion.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc_for_unit_details.dart';
import 'package:convertouch/presentation/bloc/units_page/units_states.dart';
import 'package:convertouch/presentation/ui/pages/templates/basic_page.dart';
import 'package:convertouch/presentation/ui/pages/templates/error_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget blocBuilderWrap<
    BlocType extends Bloc<ConvertouchEvent, AbstractStateType>,
    AbstractStateType extends ConvertouchState,
    PageStateType extends AbstractStateType>(
  Widget Function(PageStateType pageState) builderFunc,
) {
  return BlocBuilder<BlocType, AbstractStateType>(
    buildWhen: (prev, next) {
      return prev != next &&
          (next is PageStateType || next is ConvertouchErrorState);
    },
    builder: (_, state) {
      if (state is ConvertouchErrorState) {
        return ConvertouchErrorPage<BlocType, PageStateType>(
          errorState: state,
          lastSuccessfulState: state.lastSuccessfulState as PageStateType,
        );
      }
      if (state is PageStateType) {
        return builderFunc.call(state);
      }
      return empty();
    },
  );
}

const appBlocBuilder = blocBuilderWrap<AppBloc, AppState, AppStateReady>;

const unitGroupsBlocBuilder =
    blocBuilderWrap<UnitGroupsBloc, UnitGroupsState, UnitGroupsFetched>;
const unitGroupsBlocBuilderForConversion = blocBuilderWrap<
    UnitGroupsBlocForConversion,
    UnitGroupsState,
    UnitGroupsFetchedForConversion>;
const unitGroupsBlocBuilderForUnitDetails = blocBuilderWrap<
    UnitGroupsBlocForUnitDetails,
    UnitGroupsState,
    UnitGroupsFetchedForUnitDetails>;

const unitsBlocBuilder = blocBuilderWrap<UnitsBloc, UnitsState, UnitsFetched>;
const unitsBlocBuilderForConversion = blocBuilderWrap<UnitsBlocForConversion,
    UnitsState, UnitsFetchedForConversion>;
const unitsBlocBuilderForUnitDetails = blocBuilderWrap<UnitsBlocForUnitDetails,
    UnitsState, UnitsFetchedForUnitDetails>;
const unitDetailsBlocBuilder =
    blocBuilderWrap<UnitDetailsBloc, UnitDetailsState, UnitDetailsReady>;
const unitGroupDetailsBlocBuilder = blocBuilderWrap<UnitGroupDetailsBloc,
    UnitGroupDetailsState, UnitGroupDetailsReady>;

const conversionBlocBuilder =
    blocBuilderWrap<ConversionBloc, ConversionState, ConversionBuilt>;

const refreshingJobsBlocBuilder = blocBuilderWrap<RefreshingJobsBloc,
    RefreshingJobsState, RefreshingJobsFetched>;

BlocListener<BlocType, AbstractStateType> pageListenerWrap<
    BlocType extends Bloc<ConvertouchEvent, AbstractStateType>,
    AbstractStateType extends ConvertouchState,
    PageStateType extends AbstractStateType>({
  required BuildContext context,
  required Map<dynamic, void Function(AbstractStateType)> handlers,
  Widget? child,
}) {
  return BlocListener<BlocType, AbstractStateType>(
    listener: (_, state) {
      // if (state is ConvertouchErrorState) {
      //   log("Trigger error page");
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => ConvertouchErrorPage<BlocType, PageStateType>(
      //         errorState: state,
      //         lastSuccessfulState: state.lastSuccessfulState as PageStateType,
      //       ),
      //     ),
      //   );
      // } else {
      handlers[state.runtimeType]?.call(state);
      // }
    },
    child: child,
  );
}

const unitDetailsListener =
    pageListenerWrap<UnitDetailsBloc, UnitDetailsState, UnitDetailsReady>;

Widget unitsChangeBlocListenerWrap({
  required Function(UnitsFetched)? handler,
  required Widget? child,
}) {
  return BlocListener<UnitsBloc, UnitsState>(
    listener: (_, unitsState) {
      if (unitsState is UnitsFetched &&
          (unitsState.removedIds.isNotEmpty ||
              unitsState.modifiedUnit != null)) {
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
              unitGroupsState.modifiedUnitGroup != null)) {
        handler?.call(unitGroupsState);
      }
    },
    child: child,
  );
}
