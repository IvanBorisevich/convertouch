import 'package:convertouch/domain/constants.dart';
import 'package:convertouch/domain/model/unit_value_model.dart';
import 'package:convertouch/presentation/bloc/items_menu_view_mode/items_menu_view_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_creation/unit_creation_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups/unit_groups_bloc.dart';
import 'package:convertouch/presentation/bloc/units_conversion/units_conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/units/units_bloc.dart';
import 'package:convertouch/presentation/bloc/items_menu_view_mode/items_view_mode_state.dart';
import 'package:convertouch/presentation/bloc/unit_creation/unit_creation_states.dart';
import 'package:convertouch/presentation/bloc/unit_groups/unit_groups_states.dart';
import 'package:convertouch/presentation/bloc/units_conversion/units_conversion_states.dart';
import 'package:convertouch/presentation/bloc/units/units_states.dart';
import 'package:convertouch/presentation/pages/scaffold/navigation_service.dart';
import 'package:convertouch/presentation/pages/scaffold/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        return const SizedBox(width: 0, height: 0);
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
        return const SizedBox(width: 0, height: 0);
      }
    },
  );
}

Widget unitGroupsBlocForItem(
  Widget Function(UnitGroupSelected unitGroupSelected) builderFunc,
) {
  return BlocBuilder<UnitGroupsBloc, UnitGroupsState>(
    buildWhen: (prev, next) {
      return prev != next && next is UnitGroupSelected;
    },
    builder: (_, unitGroupSelected) {
      if (unitGroupSelected is UnitGroupSelected) {
        return builderFunc.call(unitGroupSelected);
      } else {
        return const SizedBox(width: 0, height: 0);
      }
    },
  );
}

Widget unitCreationBloc(
  Widget Function(UnitCreationPrepared unitCreationPrepared) builderFunc,
) {
  return BlocBuilder<UnitCreationBloc, UnitCreationState>(
    buildWhen: (prev, next) {
      return prev != next && next is UnitCreationPrepared;
    },
    builder: (_, unitCreationState) {
      if (unitCreationState is UnitCreationPrepared) {
        return builderFunc.call(unitCreationState);
      } else {
        return const SizedBox(width: 0, height: 0);
      }
    },
  );
}

Widget itemsViewModeBloc(
  Widget Function(ItemsViewModeState itemsMenuViewState) builderFunc,
) {
  return BlocBuilder<ItemsMenuViewBloc, ItemsViewModeState>(
    builder: (_, itemsMenuViewState) {
      return builderFunc.call(itemsMenuViewState);
    },
  );
}

Widget unitsConversionBloc(
  Widget Function(UnitsConversionState conversionInitialized) builderFunc,
) {
  return BlocBuilder<UnitsConversionBloc, UnitsConversionState>(
    buildWhen: (prev, next) {
      return prev != next && next is ConversionInitialized;
    },
    builder: (_, conversionInitialized) {
      return builderFunc.call(conversionInitialized);
    },
  );
}

Widget unitsConversionBlocForItem(
  UnitValueModel item,
  Widget Function(UnitValueModel item) builderFunc,
) {
  return BlocBuilder<UnitsConversionBloc, UnitsConversionState>(
    buildWhen: (prev, next) {
      return prev != next &&
          next is UnitConverted &&
          next.unitValue.unit.id == item.unit.id;
    },
    builder: (_, unitConverted) {
      if (unitConverted is UnitConverted &&
          unitConverted.unitValue.unit.id == item.unit.id) {
        return builderFunc.call(unitConverted.unitValue);
      } else {
        return builderFunc.call(item);
      }
    },
  );
}

Widget navigationListeners(Widget widget) {
  return MultiBlocListener(
    listeners: [
      BlocListener<UnitGroupsBloc, UnitGroupsState>(
        listener: (_, unitGroupsState) {
          switch (unitGroupsState.runtimeType) {
            case UnitGroupsFetched:
              UnitGroupsFetched unitGroupsFetched =
                  unitGroupsState as UnitGroupsFetched;
              if (unitGroupsFetched.addedUnitGroupId > -1) {
                NavigationService.I.navigateBack();
              } else if (unitGroupsFetched.action !=
                  ConvertouchAction.fetchUnitGroupsInitially) {
                NavigationService.I.navigateTo(unitGroupsPageId,
                    arguments: unitGroupsFetched.action);
              }
              break;
            case UnitGroupSelected:
              NavigationService.I.navigateBack();
              break;
          }
        },
      ),
      BlocListener<UnitsBloc, UnitsState>(
        listener: (_, unitsState) {
          switch (unitsState.runtimeType) {
            case UnitsFetched:
              UnitsFetched unitsFetched = unitsState as UnitsFetched;
              if (unitsFetched.addedUnitId > -1) {
                NavigationService.I.navigateBack();
              } else if (unitsFetched.action !=
                  ConvertouchAction.fetchUnitsToContinueMark) {
                NavigationService.I
                    .navigateTo(unitsPageId, arguments: unitsFetched.action);
              }
              break;
          }
        },
      ),
      BlocListener<UnitCreationBloc, UnitCreationState>(
        listener: (_, unitCreationState) {
          if (unitCreationState is UnitCreationPrepared) {
            if (unitCreationState.action ==
                ConvertouchAction.initUnitCreationParams) {
              NavigationService.I.navigateTo(unitCreationPageId);
            } else {
              NavigationService.I.navigateBack();
            }
          }
        },
      ),
      BlocListener<UnitsConversionBloc, UnitsConversionState>(
        listener: (_, unitsConversionState) {
          if (unitsConversionState is ConversionInitialized) {
            NavigationService.I.navigateToHome();
          }
        },
      ),
    ],
    child: widget,
  );
}

Widget unitGroupCreationListener(
  BuildContext context,
  Widget widget,
) {
  return BlocListener<UnitGroupsBloc, UnitGroupsState>(
    listener: (_, unitGroupsMenuState) {
      if (unitGroupsMenuState is UnitGroupExists) {
        showAlertDialog(context,
            "Unit group '${unitGroupsMenuState.unitGroupName}' already exist");
      }
    },
    child: widget,
  );
}

Widget unitCreationListener(
  BuildContext context,
  Widget widget,
) {
  return BlocListener<UnitsBloc, UnitsState>(
    listener: (_, unitsMenuState) {
      if (unitsMenuState is UnitExists) {
        showAlertDialog(
            context, "Unit '${unitsMenuState.unitName}' already exist");
      }
    },
    child: widget,
  );
}
