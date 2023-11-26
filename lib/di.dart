import 'package:convertouch/data/dao/db/dbconfig/dbconfig.dart';
import 'package:convertouch/data/dao/db/dbconfig/dbhelper.dart';
import 'package:convertouch/data/repositories/unit_group_repository_impl.dart';
import 'package:convertouch/data/repositories/unit_repository_impl.dart';
import 'package:convertouch/data/translators/unit_group_translator.dart';
import 'package:convertouch/data/translators/unit_translator.dart';
import 'package:convertouch/domain/repositories/unit_group_repository.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:convertouch/domain/usecases/unit_groups/add_unit_group_use_case.dart';
import 'package:convertouch/domain/usecases/unit_groups/fetch_unit_groups_use_case.dart';
import 'package:convertouch/domain/usecases/unit_groups/get_unit_group_use_case.dart';
import 'package:convertouch/domain/usecases/unit_groups/remove_unit_groups_use_case.dart';
import 'package:convertouch/domain/usecases/units/add_unit_use_case.dart';
import 'package:convertouch/domain/usecases/units/fetch_units_of_group_use_case.dart';
import 'package:convertouch/domain/usecases/units/get_base_unit_use_case.dart';
import 'package:convertouch/domain/usecases/units/remove_units_use_case.dart';
import 'package:convertouch/domain/usecases/units_conversion/convert_unit_value_use_case.dart';
import 'package:convertouch/presentation/bloc/base_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_conversions_page/units_conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_creation_page/unit_creation_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_group_creation_page/unit_group_creation_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc.dart';
import 'package:convertouch/presentation/pages/scaffold/navigation_service.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.I;

Future<void> init() async {
  // database

  locator.registerLazySingleton<ConvertouchDatabaseHelper>(
    () => ConvertouchDatabaseHelper(),
  );

  ConvertouchDatabase database =
      await ConvertouchDatabaseHelper.I.initDatabase();
  locator.registerLazySingleton(
    () => database,
  );

  // app, global

  locator.registerLazySingleton(
    () => ConvertouchCommonBloc(),
  );

  locator.registerLazySingleton<NavigationService>(
    () => NavigationService(),
  );

  // unit groups

  locator.registerLazySingleton(
    () => UnitGroupsBloc(
      fetchUnitGroupsUseCase: locator(),
      addUnitGroupUseCase: locator(),
      removeUnitGroupsUseCase: locator(),
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

  // locator.registerLazySingleton(
  //   () => UnitsBloc(
  //     getUnitGroupUseCase: locator(),
  //     fetchUnitsOfGroupUseCase: locator(),
  //     removeUnitsUseCase: locator(),
  //   ),
  // );

  locator.registerLazySingleton<FetchUnitsOfGroupUseCase>(
    () => FetchUnitsOfGroupUseCase(locator()),
  );
  locator.registerLazySingleton<AddUnitUseCase>(
    () => AddUnitUseCase(locator()),
  );
  locator.registerLazySingleton<GetBaseUnitUseCase>(
    () => GetBaseUnitUseCase(locator()),
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

  // locator.registerLazySingleton(
  //   () => UnitCreationBloc(
  //     addUnitUseCase: locator(),
  //     getBaseUnitUseCase: locator(),
  //   ),
  // );

  // unit group creation

  // locator.registerLazySingleton(
  //   () => UnitGroupCreationBloc(
  //     addUnitGroupUseCase: locator(),
  //   ),
  // );

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
