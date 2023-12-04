import 'package:convertouch/presentation/bloc/app/app_bloc.dart';
import 'package:convertouch/presentation/bloc/app/app_state.dart';
import 'package:convertouch/presentation/bloc/menu_items_view/menu_items_view_bloc.dart';
import 'package:convertouch/presentation/bloc/menu_items_view/menu_items_view_states.dart';
import 'package:convertouch/presentation/bloc/unit_conversions_page/units_conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_conversions_page/units_conversion_states.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc_for_conversion.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_states.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc_for_conversion.dart';
import 'package:convertouch/presentation/bloc/units_page/units_states.dart';
import 'package:convertouch/presentation/ui/pages/templates/basic_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget appBloc(
  Widget Function(ConvertouchAppStateBuilt appState) builderFunc,
) {
  return BlocBuilder<ConvertouchAppBloc, ConvertouchAppState>(
    buildWhen: (prev, next) {
      return prev != next && next is ConvertouchAppStateBuilt;
    },
    builder: (_, appState) {
      if (appState is ConvertouchAppStateBuilt) {
        return builderFunc.call(appState);
      } else {
        return empty();
      }
    },
  );
}

// TODO: refactor view mode blocs in order to avoid duplicates

Widget unitsViewModeBloc(
  Widget Function(MenuItemsViewStateSet viewModeState) builderFunc,
) {
  return BlocBuilder<UnitsViewModeBloc, MenuItemsViewState>(
    buildWhen: (prev, next) {
      return prev != next && next is MenuItemsViewStateSet;
    },
    builder: (_, viewModeState) {
      if (viewModeState is MenuItemsViewStateSet) {
        return builderFunc.call(viewModeState);
      } else {
        return empty();
      }
    },
  );
}

Widget unitGroupsViewModeBloc(
  Widget Function(MenuItemsViewStateSet viewModeState) builderFunc,
) {
  return BlocBuilder<UnitGroupsViewModeBloc, MenuItemsViewState>(
    buildWhen: (prev, next) {
      return prev != next && next is MenuItemsViewStateSet;
    },
    builder: (_, viewModeState) {
      if (viewModeState is MenuItemsViewStateSet) {
        return builderFunc.call(viewModeState);
      } else {
        return empty();
      }
    },
  );
}

Widget unitsBloc(
  Widget Function(UnitsFetched unitsFetched) builderFunc,
) {
  return BlocBuilder<UnitsBloc, UnitsState>(
    buildWhen: (prev, next) {
      return prev != next && next is UnitsFetched;
    },
    builder: (_, unitsFetched) {
      if (unitsFetched is UnitsFetched) {
        return builderFunc.call(unitsFetched);
      } else {
        return empty();
      }
    },
  );
}

Widget unitsBlocForConversion(
  Widget Function(UnitsFetchedToMarkForConversion pageState) builderFunc,
) {
  return BlocBuilder<UnitsBlocForConversion, UnitsState>(
    buildWhen: (prev, next) {
      return prev != next && next is UnitsFetchedToMarkForConversion;
    },
    builder: (_, unitsFetched) {
      if (unitsFetched is UnitsFetchedToMarkForConversion) {
        return builderFunc.call(unitsFetched);
      } else {
        return empty();
      }
    },
  );
}

Widget unitGroupsBloc(
  Widget Function(UnitGroupsFetched unitGroupsFetched) builderFunc,
) {
  return BlocBuilder<UnitGroupsBloc, UnitGroupsState>(
    buildWhen: (prev, next) {
      return prev != next && next is UnitGroupsFetched;
    },
    builder: (_, unitGroupsFetched) {
      if (unitGroupsFetched is UnitGroupsFetched) {
        return builderFunc.call(unitGroupsFetched);
      } else {
        return empty();
      }
    },
  );
}

Widget unitGroupsBlocForConversion(
  Widget Function(UnitGroupsFetchedForConversion pageState) builderFunc,
) {
  return BlocBuilder<UnitGroupsBlocForConversion, UnitGroupsState>(
    buildWhen: (prev, next) {
      return prev != next && next is UnitGroupsFetchedForConversion;
    },
    builder: (_, unitGroupsState) {
      if (unitGroupsState is UnitGroupsFetchedForConversion) {
        return builderFunc.call(unitGroupsState);
      } else {
        return empty();
      }
    },
  );
}

//
// Widget unitCreationBloc(
//   Widget Function(UnitCreationPrepared unitCreationPrepared) builderFunc,
// ) {
//   return BlocBuilder<UnitCreationBloc, UnitCreationState>(
//     buildWhen: (prev, next) {
//       return prev != next && next is UnitCreationPrepared;
//     },
//     builder: (_, unitCreationState) {
//       if (unitCreationState is UnitCreationPrepared) {
//         return builderFunc.call(unitCreationState);
//       } else {
//         return empty();
//       }
//     },
//   );
// }
//
// Widget unitGroupCreationBloc(
//   Widget Function(UnitGroupCreationPrepared unitGroupCreationPrepared)
//       builderFunc,
// ) {
//   return BlocBuilder<UnitGroupCreationBloc, UnitGroupCreationState>(
//     buildWhen: (prev, next) {
//       return prev != next && next is UnitGroupCreationPrepared;
//     },
//     builder: (_, unitGroupCreationState) {
//       if (unitGroupCreationState is UnitGroupCreationPrepared) {
//         return builderFunc.call(unitGroupCreationState);
//       } else {
//         return empty();
//       }
//     },
//   );
// }

Widget unitsConversionBloc(
  Widget Function(ConversionBuilt conversionInitialized) builderFunc,
) {
  return BlocBuilder<UnitsConversionBloc, UnitsConversionState>(
    buildWhen: (prev, next) {
      return prev != next && next is ConversionBuilt;
    },
    builder: (_, conversionInitialized) {
      if (conversionInitialized is ConversionBuilt) {
        return builderFunc.call(conversionInitialized);
      } else {
        return empty();
      }
    },
  );
}

// Widget unitGroupCreationListener(
//   BuildContext context,
//   Widget widget,
// ) {
//   return BlocListener<UnitGroupCreationBloc, UnitGroupCreationState>(
//     listener: (_, unitGroupCreationState) {
//       if (unitGroupCreationState is UnitGroupExists) {
//         showAlertDialog(context,
//             "Unit group '${unitGroupCreationState.unitGroupName}' already exist");
//       }
//     },
//     child: widget,
//   );
// }
//
// Widget unitCreationListener(
//   BuildContext context,
//   Widget widget,
// ) {
//   return BlocListener<UnitCreationBloc, UnitCreationState>(
//     listener: (_, unitCreationState) {
//       if (unitCreationState is UnitExists) {
//         showAlertDialog(
//             context, "Unit '${unitCreationState.unitName}' already exist");
//       }
//     },
//     child: widget,
//   );
// }
