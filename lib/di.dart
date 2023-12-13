import 'package:convertouch/data/dao/db/dbconfig/dbconfig.dart';
import 'package:convertouch/data/dao/db/dbconfig/dbhelper.dart';
import 'package:convertouch/data/repositories/unit_group_repository_impl.dart';
import 'package:convertouch/data/repositories/unit_repository_impl.dart';
import 'package:convertouch/data/translators/unit_group_translator.dart';
import 'package:convertouch/data/translators/unit_translator.dart';
import 'package:convertouch/domain/repositories/unit_group_repository.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:convertouch/domain/usecases/items_menu_view_mode/change_items_menu_view_use_case.dart';
import 'package:convertouch/domain/usecases/unit_groups/add_unit_group_use_case.dart';
import 'package:convertouch/domain/usecases/unit_groups/fetch_unit_groups_use_case.dart';
import 'package:convertouch/domain/usecases/unit_groups/get_unit_group_use_case.dart';
import 'package:convertouch/domain/usecases/unit_groups/remove_unit_groups_use_case.dart';
import 'package:convertouch/domain/usecases/unit_groups/search_unit_groups_use_case.dart';
import 'package:convertouch/domain/usecases/units/add_unit_use_case.dart';
import 'package:convertouch/domain/usecases/units/fetch_units_of_group_use_case.dart';
import 'package:convertouch/domain/usecases/units/prepare_unit_creation_use_case.dart';
import 'package:convertouch/domain/usecases/units/remove_units_use_case.dart';
import 'package:convertouch/domain/usecases/units_conversion/convert_unit_value_use_case.dart';
import 'package:convertouch/presentation/bloc/app_bloc.dart';
import 'package:convertouch/presentation/bloc/items_search_bloc.dart';
import 'package:convertouch/presentation/bloc/menu_items_view_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_creation_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups_bloc_for_conversion.dart';
import 'package:convertouch/presentation/bloc/unit_groups_bloc_for_unit_creation.dart';
import 'package:convertouch/presentation/bloc/units_bloc.dart';
import 'package:convertouch/presentation/bloc/units_bloc_for_conversion.dart';
import 'package:convertouch/presentation/bloc/units_bloc_for_unit_creation.dart';
import 'package:convertouch/presentation/bloc/units_conversion_bloc.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.I;

Future<void> init() async {
  // app

  locator.registerLazySingleton<ConvertouchDatabaseHelper>(
    () => ConvertouchDatabaseHelper(),
  );

  ConvertouchDatabase database =
      await ConvertouchDatabaseHelper.I.initDatabase();
  locator.registerLazySingleton(
    () => database,
  );

  locator.registerLazySingleton(
    () => ConvertouchAppBloc(),
  );

  locator.registerLazySingleton(
    () => UnitGroupsViewModeBloc(
      changeItemsMenuViewUseCase: locator(),
    ),
  );

  locator.registerLazySingleton(
    () => UnitsViewModeBloc(
      changeItemsMenuViewUseCase: locator(),
    ),
  );

  locator.registerLazySingleton<ChangeItemsMenuViewUseCase>(
    () => ChangeItemsMenuViewUseCase(),
  );

  // items search

  locator.registerLazySingleton(
    () => ItemsSearchBloc(
      searchUnitGroupsUseCase: locator(),
    ),
  );

  // unit groups

  locator.registerLazySingleton<SearchUnitGroupsUseCase>(
    () => SearchUnitGroupsUseCase(locator()),
  );

  locator.registerLazySingleton(
    () => UnitGroupsBloc(
      fetchUnitGroupsUseCase: locator(),
      addUnitGroupUseCase: locator(),
      removeUnitGroupsUseCase: locator(),
    ),
  );

  locator.registerLazySingleton(
    () => UnitGroupsBlocForConversion(
      fetchUnitGroupsUseCase: locator(),
    ),
  );

  locator.registerLazySingleton(
    () => UnitGroupsBlocForUnitCreation(
      fetchUnitGroupsUseCase: locator(),
    ),
  );

  locator.registerLazySingleton<FetchUnitGroupsUseCase>(
    () => FetchUnitGroupsUseCase(locator()),
  );
  locator.registerLazySingleton<GetUnitGroupUseCase>(
    () => GetUnitGroupUseCase(locator()),
  );
  locator.registerLazySingleton<AddUnitGroupUseCase>(
    () => AddUnitGroupUseCase(locator()),
  );
  locator.registerLazySingleton<RemoveUnitGroupsUseCase>(
    () => RemoveUnitGroupsUseCase(locator()),
  );
  locator.registerLazySingleton<UnitGroupRepository>(
    () => UnitGroupRepositoryImpl(database.unitGroupDao),
  );
  locator.registerLazySingleton<UnitGroupTranslator>(
    () => UnitGroupTranslator(),
  );

  // units

  locator.registerLazySingleton(
    () => UnitsBloc(
      getUnitGroupUseCase: locator(),
      addUnitUseCase: locator(),
      fetchUnitsOfGroupUseCase: locator(),
      removeUnitsUseCase: locator(),
    ),
  );

  locator.registerLazySingleton(
    () => UnitsBlocForConversion(
      fetchUnitsOfGroupUseCase: locator(),
    ),
  );

  locator.registerLazySingleton(
    () => UnitsBlocForUnitCreation(
      fetchUnitsOfGroupUseCase: locator(),
    ),
  );

  locator.registerLazySingleton<FetchUnitsOfGroupUseCase>(
    () => FetchUnitsOfGroupUseCase(locator()),
  );
  locator.registerLazySingleton<AddUnitUseCase>(
    () => AddUnitUseCase(locator()),
  );
  locator.registerLazySingleton<PrepareUnitCreationUseCase>(
    () => PrepareUnitCreationUseCase(locator()),
  );
  locator.registerLazySingleton<RemoveUnitsUseCase>(
    () => RemoveUnitsUseCase(locator()),
  );

  locator.registerLazySingleton<UnitRepository>(
    () => UnitRepositoryImpl(
      unitDao: database.unitDao,
      unitGroupDao: database.unitGroupDao,
    ),
  );
  locator.registerLazySingleton<UnitTranslator>(
    () => UnitTranslator(),
  );

  // unit creation

  locator.registerLazySingleton(
    () => UnitCreationBloc(
      addUnitUseCase: locator(),
      prepareUnitCreationUseCase: locator(),
    ),
  );

  // units conversion

  locator.registerLazySingleton(
    () => UnitsConversionBloc(
      convertUnitValueUseCase: locator(),
    ),
  );

  locator.registerLazySingleton<ConvertUnitValueUseCase>(
    () => ConvertUnitValueUseCase(),
  );
}
