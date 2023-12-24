import 'package:convertouch/domain/model/output/app_state.dart';
import 'package:convertouch/domain/model/output/conversion_states.dart';
import 'package:convertouch/domain/model/output/menu_items_view_states.dart';
import 'package:convertouch/domain/model/output/unit_creation_states.dart';
import 'package:convertouch/domain/model/output/unit_groups_states.dart';
import 'package:convertouch/domain/model/output/units_states.dart';
import 'package:convertouch/presentation/bloc/app_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/menu_items_view_bloc.dart';
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

// TODO: refactor view mode blocs in order to avoid duplicates

Widget appBloc(
  Widget Function(AppStateBuilt appState) builderFunc,
) {
  return BlocBuilder<AppBloc, AppState>(
    buildWhen: (prev, next) {
      return prev != next && next is AppStateBuilt;
    },
    builder: (_, appState) {
      if (appState is AppStateBuilt) {
        return builderFunc.call(appState);
      } else {
        return empty();
      }
    },
  );
}

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

Widget unitsBlocForUnitCreation(
  Widget Function(UnitsFetchedForUnitCreation pageState) builderFunc,
) {
  return BlocBuilder<UnitsBlocForUnitCreation, UnitsState>(
    buildWhen: (prev, next) {
      return prev != next && next is UnitsFetchedForUnitCreation;
    },
    builder: (_, unitsFetched) {
      if (unitsFetched is UnitsFetchedForUnitCreation) {
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

Widget unitGroupsBlocForUnitCreation(
  Widget Function(UnitGroupsFetchedForUnitCreation pageState) builderFunc,
) {
  return BlocBuilder<UnitGroupsBlocForUnitCreation, UnitGroupsState>(
    buildWhen: (prev, next) {
      return prev != next && next is UnitGroupsFetchedForUnitCreation;
    },
    builder: (_, unitGroupsState) {
      if (unitGroupsState is UnitGroupsFetchedForUnitCreation) {
        return builderFunc.call(unitGroupsState);
      } else {
        return empty();
      }
    },
  );
}

Widget unitCreationBloc(
  Widget Function(UnitCreationPrepared pageState) builderFunc,
) {
  return BlocBuilder<UnitCreationBloc, UnitCreationState>(
    buildWhen: (prev, next) {
      return prev != next && next is UnitCreationPrepared;
    },
    builder: (_, unitCreationState) {
      if (unitCreationState is UnitCreationPrepared) {
        return builderFunc.call(unitCreationState);
      } else {
        return empty();
      }
    },
  );
}

Widget conversionsBloc(
  Widget Function(ConversionBuilt conversionInitialized) builderFunc,
) {
  return BlocBuilder<ConversionBloc, ConversionState>(
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

Widget unitGroupCreationListener(
  BuildContext context, {
  required Widget child,
}) {
  return BlocListener<UnitGroupsBloc, UnitGroupsState>(
    listener: (_, unitGroupsState) {
      if (unitGroupsState is UnitGroupExists) {
        showAlertDialog(context,
            "Unit group '${unitGroupsState.unitGroupName}' already exist");
      } else if (unitGroupsState is UnitGroupsFetched) {
        Navigator.of(context).pop();
      }
    },
    child: child,
  );
}

Widget unitCreationListener(
  BuildContext context, {
  required Widget child,
}) {
  return BlocListener<UnitsBloc, UnitsState>(
    listener: (_, unitsState) {
      if (unitsState is UnitExists) {
        showAlertDialog(context, "Unit '${unitsState.unitName}' already exist");
      } else if (unitsState is UnitsFetched) {
        Navigator.of(context).pop();
      }
    },
    child: child,
  );
}
