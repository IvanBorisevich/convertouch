import 'package:collection/collection.dart';
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
import 'package:convertouch/presentation/ui/pages/error_page.dart';
import 'package:convertouch/presentation/ui/pages/templates/basic_page.dart';
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

class StateHandler<T> {
  final Type stateType;
  final void Function(dynamic) handlerFunc;

  StateHandler(void Function(T) func)
      : stateType = T,
        handlerFunc = _castFunc(func);

  static void Function(dynamic) _castFunc<T>(void Function(T) func) {
    return (value) {
      func.call(value as T);
    };
  }
}

BlocListener<BlocType, AbstractStateType> blocListenerWrap<
    BlocType extends Bloc<ConvertouchEvent, AbstractStateType>,
    AbstractStateType extends ConvertouchState>(List<StateHandler> handlers) {
  return BlocListener<BlocType, AbstractStateType>(
    listener: (_, state) {
      StateHandler? handler = handlers.firstWhereOrNull(
        (handler) => handler.stateType == state.runtimeType,
      );
      handler?.handlerFunc.call(state);
    },
  );
}

const unitGroupsBlocListener =
    blocListenerWrap<UnitGroupsBloc, UnitGroupsState>;
const unitGroupsBlocListenerForConversion =
    blocListenerWrap<UnitGroupsBlocForConversion, UnitGroupsState>;
const unitsBlocListener = blocListenerWrap<UnitsBloc, UnitsState>;
const unitsBlocListenerForConversion =
    blocListenerWrap<UnitsBlocForConversion, UnitsState>;
const unitDetailsBlocListener =
    blocListenerWrap<UnitDetailsBloc, UnitDetailsState>;
const conversionBlocListener =
    blocListenerWrap<ConversionBloc, ConversionState>;
const refreshingJobsBlocListener =
    blocListenerWrap<RefreshingJobsBloc, RefreshingJobsState>;

BlocListener<BlocType, AbstractStateType> errorHandlingBlocListenerWrap<
    BlocType extends Bloc<ConvertouchEvent, AbstractStateType>,
    AbstractStateType extends ConvertouchState,
    ErrorStateType extends ConvertouchErrorState>(BuildContext context) {
  return blocListenerWrap<BlocType, AbstractStateType>([
    StateHandler<ErrorStateType>((state) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ConvertouchErrorPage<BlocType, AbstractStateType>(
            errorState: state,
            lastSuccessfulState: state.lastSuccessfulState as AbstractStateType,
          ),
        ),
      );
    })
  ]);
}

const conversionErrorListener = errorHandlingBlocListenerWrap<ConversionBloc,
    ConversionState, ConversionErrorState>;
const unitGroupsErrorListener = errorHandlingBlocListenerWrap<UnitGroupsBloc,
    UnitGroupsState, UnitGroupsErrorState>;
const unitGroupsErrorListenerForConversion = errorHandlingBlocListenerWrap<
    UnitGroupsBlocForConversion, UnitGroupsState, UnitGroupsErrorState>;
const unitGroupDetailsErrorListener = errorHandlingBlocListenerWrap<
    UnitGroupDetailsBloc, UnitGroupDetailsState, UnitGroupDetailsErrorState>;
const unitsErrorListener =
    errorHandlingBlocListenerWrap<UnitsBloc, UnitsState, UnitsErrorState>;
const unitsErrorListenerForConversion = errorHandlingBlocListenerWrap<
    UnitsBlocForConversion, UnitsState, UnitsErrorState>;
const unitDetailsErrorListener = errorHandlingBlocListenerWrap<UnitDetailsBloc,
    UnitDetailsState, UnitDetailsErrorState>;
const refreshingJobsErrorListener = errorHandlingBlocListenerWrap<
    RefreshingJobsBloc, RefreshingJobsState, RefreshingJobsErrorState>;
