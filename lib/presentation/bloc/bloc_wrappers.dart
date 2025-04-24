import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';
import 'package:convertouch/presentation/bloc/common/app/app_bloc.dart';
import 'package:convertouch/presentation/bloc/common/app/app_state.dart';
import 'package:convertouch/presentation/bloc/common/items_list/dropdown_bloc.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_bloc.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_states.dart';
import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_bloc.dart';
import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_states.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_states.dart';
import 'package:convertouch/presentation/bloc/conversion_param_sets_page/single_param_bloc.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_bloc.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_states.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_states.dart';
import 'package:convertouch/presentation/bloc/unit_group_details_page/unit_group_details_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_group_details_page/unit_group_details_states.dart';
import 'package:convertouch/presentation/bloc/units_page/single_group_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget blocBuilderWrap<
    BlocType extends Bloc<ConvertouchEvent, AbstractStateType>,
    AbstractStateType extends ConvertouchState,
    PageStateType extends AbstractStateType>({
  BlocType? bloc,
  required Widget Function(PageStateType pageState) builderFunc,
}) {
  return BlocBuilder<BlocType, AbstractStateType>(
    bloc: bloc,
    buildWhen: (prev, next) {
      return prev != next && next is PageStateType;
    },
    builder: (_, state) {
      if (state is PageStateType) {
        return builderFunc.call(state);
      }
      return const SizedBox(
        height: 0,
        width: 0,
      );
    },
  );
}

const appBlocBuilder = blocBuilderWrap<AppBloc, AppState, AppStateReady>;
const itemsSelectionBlocBuilder = blocBuilderWrap<ItemsSelectionBloc,
    ItemsSelectionState, ItemsSelectionDone>;
const itemsListBlocBuilder =
    blocBuilderWrap<ItemsListBloc, ItemsFetched, ItemsFetched>;
const dropdownBlocBuilder = blocBuilderWrap<DropdownBloc,
    ItemsFetched<ListValueModel>, ItemsFetched<ListValueModel>>;
const singleGroupBlocBuilder =
    blocBuilderWrap<SingleGroupBloc, SingleGroupState, SingleGroupState>;
const unitDetailsBlocBuilder =
    blocBuilderWrap<UnitDetailsBloc, UnitDetailsState, UnitDetailsReady>;
const unitGroupDetailsBlocBuilder = blocBuilderWrap<UnitGroupDetailsBloc,
    UnitGroupDetailsState, UnitGroupDetailsReady>;
const conversionBlocBuilder =
    blocBuilderWrap<ConversionBloc, ConversionState, ConversionBuilt>;
const refreshingJobsBlocBuilder = blocBuilderWrap<RefreshingJobsBloc,
    RefreshingJobsState, RefreshingJobsFetched>;
const singleParamBlocBuilder =
    blocBuilderWrap<SingleParamBloc, SingleParamState, SingleParamState>;
