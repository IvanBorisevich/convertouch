import 'package:convertouch/data/dao/db/unit_dao_db_impl.dart';
import 'package:convertouch/data/dao/db/unit_group_dao_db_impl.dart';
import 'package:convertouch/data/dao/unit_dao.dart';
import 'package:convertouch/data/dao/unit_group_dao.dart';
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
import 'package:convertouch/domain/usecases/units/add_unit_use_case.dart';
import 'package:convertouch/domain/usecases/units/fetch_units_of_group_use_case.dart';
import 'package:convertouch/domain/usecases/units/get_base_unit_use_case.dart';
import 'package:convertouch/domain/usecases/units_conversion/convert_unit_value_use_case.dart';
import 'package:convertouch/presentation/bloc/items_menu_view_mode/items_menu_view_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups/unit_groups_bloc.dart';
import 'package:convertouch/presentation/bloc/units/units_bloc.dart';
import 'package:convertouch/presentation/bloc/units_conversion/units_conversion_bloc.dart';
import 'package:convertouch/presentation/pages/scaffold/navigation_service.dart';
import 'package:get_it/get_it.dart';

import 'presentation/bloc/unit_creation/unit_creation_bloc.dart';

final locator = GetIt.I;

void init() {
  // navigation service

  locator.registerLazySingleton<NavigationService>(
    () => NavigationService(),
  );

  // unit groups

  locator.registerFactory(
    () => UnitGroupsBloc(
      fetchUnitGroupsUseCase: locator(),
      addUnitGroupUseCase: locator(),
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
  locator.registerLazySingleton<UnitGroupRepository>(
    () => UnitGroupRepositoryImpl(locator()),
  );
  locator.registerLazySingleton<UnitGroupDao>(
    () => UnitGroupDaoDbImpl(),
  );
  locator.registerLazySingleton<UnitGroupTranslator>(
    () => UnitGroupTranslator(),
  );

  // units

  locator.registerFactory(
    () => UnitsBloc(
      getUnitGroupUseCase: locator(),
      fetchUnitsOfGroupUseCase: locator(),
      addUnitUseCase: locator(),
    ),
  );

  locator.registerLazySingleton<FetchUnitsOfGroupUseCase>(
    () => FetchUnitsOfGroupUseCase(locator()),
  );
  locator.registerLazySingleton<AddUnitUseCase>(
    () => AddUnitUseCase(locator()),
  );
  locator.registerLazySingleton<GetBaseUnitUseCase>(
    () => GetBaseUnitUseCase(locator()),
  );

  locator.registerLazySingleton<UnitRepository>(
    () => UnitRepositoryImpl(locator()),
  );
  locator.registerLazySingleton<UnitDao>(
    () => UnitDaoDbImpl(),
  );
  locator.registerLazySingleton<UnitTranslator>(
    () => UnitTranslator(),
  );

  // unit creation

  locator.registerFactory(
    () => UnitCreationBloc(
      getBaseUnitUseCase: locator(),
    ),
  );

  // units conversion

  locator.registerFactory(
    () => UnitsConversionBloc(
      convertUnitValueUseCase: locator(),
    ),
  );

  locator.registerLazySingleton<ConvertUnitValueUseCase>(
    () => ConvertUnitValueUseCase(),
  );

  // items menu view mode

  locator.registerFactory(
    () => ItemsMenuViewBloc(
      changeItemsMenuViewUseCase: locator(),
    ),
  );

  locator.registerLazySingleton<ChangeItemsMenuViewUseCase>(
    () => ChangeItemsMenuViewUseCase(),
  );
}
