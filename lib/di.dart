import 'package:convertouch/data/dao/db/dbconfig/dbconfig.dart';
import 'package:convertouch/data/dao/db/dbhelper/dbhelper.dart';
import 'package:convertouch/data/dao/net/network_dao_impl.dart';
import 'package:convertouch/data/dao/network_dao.dart';
import 'package:convertouch/data/repositories/db/refreshable_value_repository_impl.dart';
import 'package:convertouch/data/repositories/db/unit_group_repository_impl.dart';
import 'package:convertouch/data/repositories/db/unit_repository_impl.dart';
import 'package:convertouch/data/repositories/net/network_data_repository_impl.dart';
import 'package:convertouch/data/translators/refreshable_value_translator.dart';
import 'package:convertouch/data/translators/unit_group_translator.dart';
import 'package:convertouch/data/translators/unit_translator.dart';
import 'package:convertouch/domain/repositories/network_data_repository.dart';
import 'package:convertouch/domain/repositories/refreshable_value_repository.dart';
import 'package:convertouch/domain/repositories/unit_group_repository.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:convertouch/domain/use_cases/conversion/build_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/rebuild_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/refreshing_jobs/execute_job_use_case.dart';
import 'package:convertouch/domain/use_cases/unit_details/prepare_draft_unit_details_use_case.dart';
import 'package:convertouch/domain/use_cases/unit_details/prepare_saved_unit_details_use_case.dart';
import 'package:convertouch/domain/use_cases/unit_groups/fetch_unit_groups_use_case.dart';
import 'package:convertouch/domain/use_cases/unit_groups/get_unit_group_use_case.dart';
import 'package:convertouch/domain/use_cases/unit_groups/mark_groups_for_removal_use_case.dart';
import 'package:convertouch/domain/use_cases/unit_groups/remove_unit_groups_use_case.dart';
import 'package:convertouch/domain/use_cases/unit_groups/save_unit_group_use_case.dart';
import 'package:convertouch/domain/use_cases/units/fetch_units_use_case.dart';
import 'package:convertouch/domain/use_cases/units/remove_units_use_case.dart';
import 'package:convertouch/domain/use_cases/units/save_unit_use_case.dart';
import 'package:convertouch/presentation/bloc/common/app/app_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc_for_conversion.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc_for_unit_details.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc_for_conversion.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc_for_unit_details.dart';
import 'package:get_it/get_it.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'presentation/bloc/unit_group_details_page/unit_group_details_bloc.dart';

final locator = GetIt.I;

Future<void> init() async {
  // app

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  locator.registerLazySingleton<ConvertouchDatabaseHelper>(
    () => ConvertouchDatabaseHelper(),
  );

  ConvertouchDatabase database =
      await ConvertouchDatabaseHelper.I.initDatabase();
  locator.registerLazySingleton(
    () => database,
  );

  // bloc

  locator.registerLazySingleton(
    () => AppBloc(),
  );

  locator.registerLazySingleton(
    () => NavigationBloc(),
  );

  locator.registerLazySingleton(
    () => UnitGroupsBloc(
      fetchUnitGroupsUseCase: locator(),
      saveUnitGroupUseCase: locator(),
      removeUnitGroupsUseCase: locator(),
      markGroupsForRemovalUseCase: locator(),
      navigationBloc: locator(),
    ),
  );

  locator.registerLazySingleton(
    () => UnitGroupsBlocForConversion(
      fetchUnitGroupsUseCase: locator(),
      navigationBloc: locator(),
    ),
  );

  locator.registerLazySingleton(
    () => UnitGroupsBlocForUnitDetails(
      fetchUnitGroupsUseCase: locator(),
      navigationBloc: locator(),
    ),
  );

  locator.registerLazySingleton(
    () => UnitsBloc(
      saveUnitUseCase: locator(),
      fetchUnitsUseCase: locator(),
      removeUnitsUseCase: locator(),
      navigationBloc: locator(),
    ),
  );

  locator.registerLazySingleton(
    () => UnitsBlocForConversion(
      fetchUnitsUseCase: locator(),
      navigationBloc: locator(),
    ),
  );

  locator.registerLazySingleton(
    () => UnitsBlocForUnitDetails(
      fetchUnitsUseCase: locator(),
      navigationBloc: locator(),
    ),
  );

  locator.registerLazySingleton(
    () => UnitDetailsBloc(
      prepareSavedUnitDetailsUseCase: locator(),
      prepareDraftUnitDetailsUseCase: locator(),
      navigationBloc: locator(),
    ),
  );

  locator.registerLazySingleton(
    () => UnitGroupDetailsBloc(
      navigationBloc: locator(),
    ),
  );

  locator.registerLazySingleton(
    () => ConversionBloc(
      buildConversionUseCase: locator(),
      navigationBloc: locator(),
    ),
  );

  locator.registerLazySingleton(
    () => RefreshingJobsBloc(
      executeJobUseCase: locator(),
      navigationBloc: locator(),
    ),
  );

  // use cases

  locator.registerLazySingleton<FetchUnitGroupsUseCase>(
    () => FetchUnitGroupsUseCase(locator()),
  );
  locator.registerLazySingleton<GetUnitGroupUseCase>(
    () => GetUnitGroupUseCase(locator()),
  );
  locator.registerLazySingleton<SaveUnitGroupUseCase>(
    () => SaveUnitGroupUseCase(locator()),
  );
  locator.registerLazySingleton<RemoveUnitGroupsUseCase>(
    () => RemoveUnitGroupsUseCase(locator()),
  );

  locator.registerLazySingleton<FetchUnitsUseCase>(
    () => FetchUnitsUseCase(locator()),
  );
  locator.registerLazySingleton<SaveUnitUseCase>(
    () => SaveUnitUseCase(locator()),
  );
  locator.registerLazySingleton<PrepareDraftUnitDetailsUseCase>(
    () => PrepareDraftUnitDetailsUseCase(
      unitRepository: locator(),
    ),
  );
  locator.registerLazySingleton<PrepareSavedUnitDetailsUseCase>(
    () => PrepareSavedUnitDetailsUseCase(
      unitRepository: locator(),
    ),
  );
  locator.registerLazySingleton<RemoveUnitsUseCase>(
    () => RemoveUnitsUseCase(locator()),
  );

  locator.registerLazySingleton<RebuildConversionUseCase>(
    () => RebuildConversionUseCase(
      buildConversionUseCase: locator(),
    ),
  );

  locator.registerLazySingleton<BuildConversionUseCase>(
    () => BuildConversionUseCase(
      unitGroupRepository: locator(),
      refreshableValueRepository: locator(),
    ),
  );

  locator.registerLazySingleton<ExecuteJobUseCase>(
    () => ExecuteJobUseCase(
      networkDataRepository: locator(),
      rebuildConversionUseCase: locator(),
    ),
  );

  locator.registerLazySingleton<MarkGroupsForRemovalUseCase>(
    () => MarkGroupsForRemovalUseCase(),
  );

  // repositories

  locator.registerLazySingleton<UnitGroupRepository>(
    () => UnitGroupRepositoryImpl(database.unitGroupDao),
  );

  locator.registerLazySingleton<UnitRepository>(
    () => UnitRepositoryImpl(
      unitDao: database.unitDao,
      unitGroupDao: database.unitGroupDao,
      database: database.database.database,
    ),
  );

  locator.registerLazySingleton<NetworkDataRepository>(
    () => NetworkDataRepositoryImpl(
      networkDao: locator(),
      unitDao: database.unitDao,
      refreshableValueDao: database.refreshableValueDao,
      database: database.database.database,
    ),
  );

  locator.registerLazySingleton<RefreshableValueRepository>(
    () => RefreshableValueRepositoryImpl(
      refreshableValueDao: database.refreshableValueDao,
      unitDao: database.unitDao,
      database: database.database.database,
    ),
  );

  // dao

  locator.registerLazySingleton<NetworkDao>(
    () => const NetworkDaoImpl(),
  );

  // model translators

  locator.registerLazySingleton<UnitGroupTranslator>(
    () => UnitGroupTranslator(),
  );

  locator.registerLazySingleton<UnitTranslator>(
    () => UnitTranslator(),
  );

  locator.registerLazySingleton<RefreshableValueTranslator>(
    () => RefreshableValueTranslator(),
  );
}
