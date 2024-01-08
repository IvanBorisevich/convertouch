import 'package:convertouch/data/dao/db/dbconfig/dbconfig.dart';
import 'package:convertouch/data/dao/db/dbconfig/dbhelper.dart';
import 'package:convertouch/data/repositories/conversion_repository_impl.dart';
import 'package:convertouch/data/repositories/job_data_source_repository_impl.dart';
import 'package:convertouch/data/repositories/refreshable_value_repository_impl.dart';
import 'package:convertouch/data/repositories/refreshing_job_repository_impl.dart';
import 'package:convertouch/data/repositories/unit_group_repository_impl.dart';
import 'package:convertouch/data/repositories/unit_repository_impl.dart';
import 'package:convertouch/data/translators/job_data_source_translator.dart';
import 'package:convertouch/data/translators/refreshable_value_translator.dart';
import 'package:convertouch/data/translators/refreshing_job_translator.dart';
import 'package:convertouch/data/translators/unit_group_translator.dart';
import 'package:convertouch/data/translators/unit_translator.dart';
import 'package:convertouch/domain/repositories/conversion_repository.dart';
import 'package:convertouch/domain/repositories/job_data_source_repository.dart';
import 'package:convertouch/domain/repositories/refreshable_value_repository.dart';
import 'package:convertouch/domain/repositories/refreshing_job_repository.dart';
import 'package:convertouch/domain/repositories/unit_group_repository.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:convertouch/domain/usecases/conversion/build_conversion_use_case.dart';
import 'package:convertouch/domain/usecases/conversion/restore_last_conversion_use_case.dart';
import 'package:convertouch/domain/usecases/conversion/save_conversion_use_case.dart';
import 'package:convertouch/domain/usecases/items_menu_view_mode/change_items_menu_view_use_case.dart';
import 'package:convertouch/domain/usecases/refreshing_jobs/fetch_refreshing_jobs_use_case.dart';
import 'package:convertouch/domain/usecases/refreshing_jobs/get_job_details_use_case.dart';
import 'package:convertouch/domain/usecases/refreshing_jobs/refresh_data_use_case.dart';
import 'package:convertouch/domain/usecases/refreshing_jobs/select_auto_refresh_cron_use_case.dart';
import 'package:convertouch/domain/usecases/refreshing_jobs/select_job_data_source_use_case.dart';
import 'package:convertouch/domain/usecases/refreshing_jobs/toggle_auto_refresh_mode_use_case.dart';
import 'package:convertouch/domain/usecases/refreshing_jobs/update_data_refreshing_time_use_case.dart';
import 'package:convertouch/domain/usecases/unit_groups/add_unit_group_use_case.dart';
import 'package:convertouch/domain/usecases/unit_groups/fetch_unit_groups_use_case.dart';
import 'package:convertouch/domain/usecases/unit_groups/get_unit_group_use_case.dart';
import 'package:convertouch/domain/usecases/unit_groups/remove_unit_groups_use_case.dart';
import 'package:convertouch/domain/usecases/units/add_unit_use_case.dart';
import 'package:convertouch/domain/usecases/units/fetch_units_use_case.dart';
import 'package:convertouch/domain/usecases/units/prepare_unit_creation_use_case.dart';
import 'package:convertouch/domain/usecases/units/remove_units_use_case.dart';
import 'package:convertouch/presentation/bloc/app_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/menu_items_view_bloc.dart';
import 'package:convertouch/presentation/bloc/refreshing_job_details_bloc.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_bloc.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_progress_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_creation_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups_bloc_for_conversion.dart';
import 'package:convertouch/presentation/bloc/unit_groups_bloc_for_unit_creation.dart';
import 'package:convertouch/presentation/bloc/units_bloc.dart';
import 'package:convertouch/presentation/bloc/units_bloc_for_conversion.dart';
import 'package:convertouch/presentation/bloc/units_bloc_for_unit_creation.dart';
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
    () => AppBloc(),
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

  // unit groups

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
      addUnitUseCase: locator(),
      fetchUnitsUseCase: locator(),
      removeUnitsUseCase: locator(),
    ),
  );

  locator.registerLazySingleton(
    () => UnitsBlocForConversion(
      fetchUnitsUseCase: locator(),
    ),
  );

  locator.registerLazySingleton(
    () => UnitsBlocForUnitCreation(
      fetchUnitsUseCase: locator(),
    ),
  );

  locator.registerLazySingleton<FetchUnitsUseCase>(
    () => FetchUnitsUseCase(locator()),
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
    () => ConversionBloc(
      buildConversionUseCase: locator(),
      saveConversionUseCase: locator(),
      restoreLastConversionUseCase: locator(),
    ),
  );

  locator.registerLazySingleton<BuildConversionUseCase>(
    () => BuildConversionUseCase(
      refreshableValueRepository: locator(),
    ),
  );

  locator.registerLazySingleton<SaveConversionUseCase>(
    () => SaveConversionUseCase(
      conversionRepository: locator(),
    ),
  );

  locator.registerLazySingleton<RestoreLastConversionUseCase>(
    () => RestoreLastConversionUseCase(
      conversionRepository: locator(),
      unitGroupRepository: locator(),
      unitRepository: locator(),
      buildConversionUseCase: locator(),
    ),
  );

  locator.registerLazySingleton<ConversionRepository>(
    () => const ConversionRepositoryImpl(),
  );

  // refreshing jobs

  locator.registerLazySingleton(
    () => RefreshingJobsBloc(
      fetchRefreshingJobsUseCase: locator(),
    ),
  );

  locator.registerLazySingleton(
    () => RefreshingJobDetailsBloc(
      getJobDetailsUseCase: locator(),
      toggleAutoRefreshModeUseCase: locator(),
      selectAutoRefreshCronUseCase: locator(),
    ),
  );

  locator.registerLazySingleton(
    () => RefreshingJobsProgressBloc(
      refreshDataUseCase: locator(),
      updateDataRefreshingTimeUseCase: locator(),
    ),
  );

  locator.registerLazySingleton<GetJobDetailsUseCase>(
    () => GetJobDetailsUseCase(
      selectJobDataSourceUseCase: locator(),
      jobDataSourceRepository: locator(),
    ),
  );

  locator.registerLazySingleton<SelectJobDataSourceUseCase>(
    () => SelectJobDataSourceUseCase(
      refreshingJobRepository: locator(),
    ),
  );

  locator.registerLazySingleton<ToggleAutoRefreshModeUseCase>(
    () => ToggleAutoRefreshModeUseCase(
      refreshingJobRepository: locator(),
    ),
  );

  locator.registerLazySingleton<SelectAutoRefreshCronUseCase>(
    () => SelectAutoRefreshCronUseCase(
      refreshingJobRepository: locator(),
    ),
  );

  locator.registerLazySingleton<FetchRefreshingJobsUseCase>(
    () => FetchRefreshingJobsUseCase(
      refreshingJobRepository: locator(),
    ),
  );

  locator.registerLazySingleton<RefreshDataUseCase>(
    () => const RefreshDataUseCase(),
  );

  locator.registerLazySingleton<UpdateDataRefreshingTimeUseCase>(
    () => UpdateDataRefreshingTimeUseCase(
      refreshingJobRepository: locator(),
    ),
  );

  locator.registerLazySingleton<RefreshingJobRepository>(
    () => RefreshingJobRepositoryImpl(
      unitGroupDao: database.unitGroupDao,
      refreshingJobDao: database.refreshingJobDao,
      jobDataSourceDao: database.jobDataSourceDao,
    ),
  );

  locator.registerLazySingleton<JobDataSourceRepository>(
    () => JobDataSourceRepositoryImpl(database.jobDataSourceDao),
  );

  locator.registerLazySingleton<RefreshingJobTranslator>(
    () => RefreshingJobTranslator(),
  );

  locator.registerLazySingleton<JobDataSourceTranslator>(
    () => JobDataSourceTranslator(),
  );

  // refreshable values

  locator.registerLazySingleton<RefreshableValueRepository>(
    () => RefreshableValueRepositoryImpl(database.refreshableValueDao),
  );

  locator.registerLazySingleton<RefreshableValueTranslator>(
    () => RefreshableValueTranslator(),
  );
}
