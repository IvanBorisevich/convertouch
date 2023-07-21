import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/unit_value_model.dart';
import 'package:convertouch/presenter/bloc/items_menu_view_bloc.dart';
import 'package:convertouch/presenter/bloc/unit_creation_bloc.dart';
import 'package:convertouch/presenter/bloc/unit_groups_bloc.dart';
import 'package:convertouch/presenter/bloc/units_conversion_bloc.dart';
import 'package:convertouch/presenter/bloc/units_bloc.dart';
import 'package:convertouch/presenter/states/items_view_mode_state.dart';
import 'package:convertouch/presenter/states/unit_creation_states.dart';
import 'package:convertouch/presenter/states/unit_groups_states.dart';
import 'package:convertouch/presenter/states/units_conversion_states.dart';
import 'package:convertouch/presenter/states/units_states.dart';
import 'package:convertouch/view/scaffold/navigation.dart';
import 'package:convertouch/view/scaffold/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget wrapIntoUnitsBloc(
    Widget Function(UnitsFetched unitsFetched) builderFunc) {
  return BlocBuilder<UnitsBloc, UnitsState>(
      buildWhen: (prev, next) {
        return prev != next && next is UnitsFetched;
      }, builder: (_, unitsFetched) {
        if (unitsFetched is UnitsFetched) {
          return builderFunc.call(unitsFetched);
        } else {
          return const SizedBox(width: 0, height: 0);
        }
      });
}

Widget wrapIntoUnitsBlocForItem(
    Widget Function(UnitsState unitSelected) builderFunc) {
  return BlocBuilder<UnitsBloc, UnitsState>(
      buildWhen: (prev, next) {
        return prev != next && next is UnitSelected;
      }, builder: (_, unitSelected) {
        return builderFunc.call(unitSelected);
      });
}

Widget wrapIntoUnitGroupsBloc(
    Widget Function(UnitGroupsFetched unitGroupsFetched) builderFunc) {
  return BlocBuilder<UnitGroupsBloc, UnitGroupsState>(
      buildWhen: (prev, next) {
        return prev != next && next is UnitGroupsFetched;
      }, builder: (_, unitGroupsFetched) {
        if (unitGroupsFetched is UnitGroupsFetched) {
          return builderFunc.call(unitGroupsFetched);
        } else {
          return const SizedBox(width: 0, height: 0);
        }
      });
}

Widget wrapIntoUnitGroupsBlocForItem(
    Widget Function(UnitGroupSelected unitGroupSelected) builderFunc) {
  return BlocBuilder<UnitGroupsBloc, UnitGroupsState>(
      buildWhen: (prev, next) {
        return prev != next && next is UnitGroupSelected;
      }, builder: (_, unitGroupSelected) {
        if (unitGroupSelected is UnitGroupSelected) {
          return builderFunc.call(unitGroupSelected);
        } else {
          return const SizedBox(width: 0, height: 0);
        }
  });
}

Widget wrapIntoUnitCreationBloc(
    Widget Function(UnitCreationPrepared unitCreationStarted) builderFunc) {
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

Widget wrapIntoItemsViewModeBloc(
    Widget Function(ItemsViewModeState itemsMenuViewState) builderFunc) {
  return BlocBuilder<ItemsMenuViewBloc, ItemsViewModeState>(
      builder: (_, itemsMenuViewState) {
        return builderFunc.call(itemsMenuViewState);
      });
}

Widget wrapIntoUnitsConversionBloc(
    Widget Function(UnitsConversionState conversionInitialized) builderFunc) {
  return BlocBuilder<UnitsConversionBloc, UnitsConversionState>(
      buildWhen: (prev, next) {
        return prev != next && next is ConversionInitialized;
      }, builder: (_, conversionInitialized) {
        return builderFunc.call(conversionInitialized);
      });
}

Widget wrapIntoUnitsConversionBlocForItem(UnitValueModel item,
    Widget Function(UnitValueModel item) builderFunc) {
  return BlocBuilder<UnitsConversionBloc, UnitsConversionState>(
    buildWhen: (prev, next) {
      return prev != next &&
        next is UnitConverted &&
        next.unitValue.unit.id == item.unit.id;
    }, builder: (_, unitConverted) {
      if (unitConverted is UnitConverted) {
        return builderFunc.call(unitConverted.unitValue);
      } else {
        return builderFunc.call(item);
      }
    });
}

Widget wrapIntoNavigationListeners(Widget widget) {
  return MultiBlocListener(
      listeners: [
        BlocListener<UnitGroupsBloc, UnitGroupsState>(
          listener: (_, unitGroupsState) {
            switch (unitGroupsState.runtimeType) {
              case UnitGroupsFetched:
                UnitGroupsFetched unitGroupsFetched =
                  unitGroupsState as UnitGroupsFetched;
                if (unitGroupsFetched.addedUnitGroup != null) {
                  NavigationService.I.navigateBack();
                } else {
                  ActionTypeOnItemClick actionOnItemSelect;
                  if (unitGroupsFetched.forPage == unitCreationPageId) {
                    actionOnItemSelect = ActionTypeOnItemClick.select;
                  } else {
                    actionOnItemSelect = ActionTypeOnItemClick.fetch;
                  }
                  NavigationService.I.navigateTo(unitGroupsPageId,
                      arguments: actionOnItemSelect);
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
                if (unitsFetched.addedUnit != null) {
                  NavigationService.I.navigateBack();
                } else {
                  ActionTypeOnItemClick actionOnItemSelect;
                  if (unitsFetched.forPage == unitCreationPageId) {
                    actionOnItemSelect = ActionTypeOnItemClick.select;
                  } else {
                    actionOnItemSelect = ActionTypeOnItemClick.markForSelection;
                  }
                  NavigationService.I.navigateTo(unitsPageId,
                      arguments: actionOnItemSelect);
                }
                break;
            }
          },
        ),
        BlocListener<UnitCreationBloc, UnitCreationState>(
          listener: (_, unitCreationState) {
            if (unitCreationState is UnitCreationPrepared) {
              if (unitCreationState.initial) {
                NavigationService.I.navigateTo(unitCreationPageId);
              } else {
                NavigationService.I.navigateBack();
              }
            }
          }
        ),
        BlocListener<UnitsConversionBloc, UnitsConversionState>(
          listener: (_, convertedUnitsState) {
            if (convertedUnitsState is ConversionInitialized) {
              NavigationService.I.navigateBack();
            }
          }),
      ],
      child: widget
  );
}


Widget wrapIntoUnitGroupCreationPageListener(BuildContext context, Widget widget) {
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

Widget wrapIntoUnitCreationPageListener(BuildContext context, Widget widget) {
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