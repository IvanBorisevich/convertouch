import 'package:convertouch/data/dao/db/dbconfig/dbconfig.dart';
import 'package:convertouch/data/dao/db/dbconfig/dbhelper.dart';
import 'package:convertouch/data/dao/net/network_dao_impl.dart';
import 'package:convertouch/data/dao/network_dao.dart';
import 'package:convertouch/data/dao/preferences_dao.dart';
import 'package:convertouch/data/dao/shared_prefs/preferences_dao_impl.dart';
import 'package:convertouch/data/repositories/conversion_repository_impl.dart';
import 'package:convertouch/data/repositories/job_data_source_repository_impl.dart';
import 'package:convertouch/data/repositories/network_data_repository_impl.dart';
import 'package:convertouch/data/repositories/preferences_repository_impl.dart';
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
import 'package:convertouch/domain/repositories/network_data_repository.dart';
import 'package:convertouch/domain/repositories/preferences_repository.dart';
import 'package:convertouch/domain/repositories/refreshable_value_repository.dart';
import 'package:convertouch/domain/repositories/refreshing_job_repository.dart';
import 'package:convertouch/domain/repositories/unit_group_repository.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:convertouch/domain/use_cases/conversion/build_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/prepare_source_conversion_item_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/restore_last_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/save_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/items_menu_view_mode/change_items_menu_view_use_case.dart';
import 'package:convertouch/domain/use_cases/refresh_data/refresh_data_use_case.dart';
import 'package:convertouch/domain/use_cases/refresh_data/refresh_unit_coefficients_use_case.dart';
import 'package:convertouch/domain/use_cases/refresh_data/refresh_unit_values_use_case.dart';
import 'package:convertouch/domain/use_cases/refreshing_jobs/change_job_cron_use_case.dart';
import 'package:convertouch/domain/use_cases/refreshing_jobs/change_job_data_source_use_case.dart';
import 'package:convertouch/domain/use_cases/refreshing_jobs/get_job_details_by_group_use_case.dart';
import 'package:convertouch/domain/use_cases/refreshing_jobs/get_job_details_use_case.dart';
import 'package:convertouch/domain/use_cases/refreshing_jobs/get_jobs_list_use_case.dart';
import 'package:convertouch/domain/use_cases/refreshing_jobs/update_job_finish_time_use_case.dart';
import 'package:convertouch/domain/use_cases/refreshing_jobs_control/start_job_use_case.dart';
import 'package:convertouch/domain/use_cases/unit_groups/add_unit_group_use_case.dart';
import 'package:convertouch/domain/use_cases/unit_groups/fetch_unit_groups_use_case.dart';
import 'package:convertouch/domain/use_cases/unit_groups/get_unit_group_use_case.dart';
import 'package:convertouch/domain/use_cases/unit_groups/remove_unit_groups_use_case.dart';
import 'package:convertouch/domain/use_cases/units/add_unit_use_case.dart';
import 'package:convertouch/domain/use_cases/units/fetch_units_use_case.dart';
import 'package:convertouch/domain/use_cases/units/prepare_unit_creation_use_case.dart';
import 'package:convertouch/domain/use_cases/units/remove_units_use_case.dart';
import 'package:convertouch/presentation/bloc/app/app_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/menu_items/menu_items_view_bloc.dart';
import 'package:convertouch/presentation/bloc/refreshing_job_details_page/refreshing_job_details_bloc.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_control/refreshing_jobs_control_bloc.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_creation_page/unit_creation_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc_for_conversion.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc_for_unit_creation.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc_for_conversion.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc_for_unit_creation.dart';
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

  // bloc

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

  locator.registerLazySingleton(
    () => UnitCreationBloc(
      addUnitUseCase: locator(),
      prepareUnitCreationUseCase: locator(),
    ),
  );

  locator.registerLazySingleton(
    () => ConversionBloc(
      buildConversionUseCase: locator(),
      saveConversionUseCase: locator(),
      restoreLastConversionUseCase: locator(),
      getJobDetailsByGroupUseCase: locator(),
    ),
  );

  locator.registerLazySingleton(
    () => RefreshingJobsBloc(
      getJobsListUseCase: locator(),
    ),
  );

  locator.registerLazySingleton(
    () => RefreshingJobDetailsBloc(
      getJobDetailsUseCase: locator(),
      changeJobCronUseCase: locator(),
    ),
  );

  locator.registerLazySingleton(
    () => RefreshingJobsControlBloc(
      startJobUseCase: locator(),
      updateJobFinishTimeUseCase: locator(),
    ),
  );

  // use cases

  locator.registerLazySingleton<ChangeItemsMenuViewUseCase>(
    () => ChangeItemsMenuViewUseCase(),
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

  locator.registerLazySingleton<PrepareSourceConversionItemUseCase>(
    () => PrepareSourceConversionItemUseCase(
      unitGroupRepository: locator(),
      refreshingJobRepository: locator(),
      refreshableValueRepository: locator(),
    ),
  );

  locator.registerLazySingleton<BuildConversionUseCase>(
    () => BuildConversionUseCase(
      prepareSourceConversionItemUseCase: locator(),
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
      buildConversionUseCase: locator(),
    ),
  );

  locator.registerLazySingleton<GetJobDetailsUseCase>(
    () => GetJobDetailsUseCase(
      changeJobDataSourceUseCase: locator(),
      jobDataSourceRepository: locator(),
    ),
  );

  locator.registerLazySingleton<GetJobDetailsByGroupUseCase>(
    () => GetJobDetailsByGroupUseCase(
      refreshingJobRepository: locator(),
    ),
  );

  locator.registerLazySingleton<ChangeJobDataSourceUseCase>(
    () => ChangeJobDataSourceUseCase(
      refreshingJobRepository: locator(),
    ),
  );

  locator.registerLazySingleton<ChangeJobCronUseCase>(
    () => ChangeJobCronUseCase(
      refreshingJobRepository: locator(),
    ),
  );

  locator.registerLazySingleton<GetJobsListUseCase>(
    () => GetJobsListUseCase(
      refreshingJobRepository: locator(),
    ),
  );

  locator.registerLazySingleton<RefreshDataUseCase>(
    () => RefreshDataUseCase(
      refreshUnitCoefficientsUseCase: locator(),
      refreshUnitValuesUseCase: locator(),
    ),
  );

  locator.registerLazySingleton<RefreshUnitValuesUseCase>(
    () => const RefreshUnitValuesUseCase(),
  );

  locator.registerLazySingleton<RefreshUnitCoefficientsUseCase>(
    () => RefreshUnitCoefficientsUseCase(
      networkDataRepository: locator(),
    ),
  );

  locator.registerLazySingleton<UpdateJobFinishTimeUseCase>(
    () => UpdateJobFinishTimeUseCase(
      refreshingJobRepository: locator(),
    ),
  );

  locator.registerLazySingleton<StartJobUseCase>(
    () => const StartJobUseCase(),
  );

  // repositories

  locator.registerLazySingleton<UnitGroupRepository>(
    () => UnitGroupRepositoryImpl(database.unitGroupDao),
  );

  locator.registerLazySingleton<UnitRepository>(
    () => UnitRepositoryImpl(
      unitDao: database.unitDao,
      unitGroupDao: database.unitGroupDao,
    ),
  );

  locator.registerLazySingleton<ConversionRepository>(
    () => ConversionRepositoryImpl(
      preferencesRepository: locator(),
      unitGroupRepository: locator(),
      unitRepository: locator(),
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

  locator.registerLazySingleton<NetworkDataRepository>(
    () => NetworkDataRepositoryImpl(locator()),
  );

  locator.registerLazySingleton<RefreshableValueRepository>(
    () => RefreshableValueRepositoryImpl(database.refreshableValueDao),
  );

  locator.registerLazySingleton<PreferencesRepository>(
    () => PreferencesRepositoryImpl(locator()),
  );

  // dao

  locator.registerLazySingleton<NetworkDao>(
    () => const NetworkDaoImpl(),
  );

  locator.registerLazySingleton<PreferencesDao>(
    () => const PreferencesDaoImpl(),
  );

  // model translators

  locator.registerLazySingleton<UnitGroupTranslator>(
    () => UnitGroupTranslator(),
  );

  locator.registerLazySingleton<UnitTranslator>(
    () => UnitTranslator(),
  );

  locator.registerLazySingleton<RefreshingJobTranslator>(
    () => RefreshingJobTranslator(),
  );

  locator.registerLazySingleton<JobDataSourceTranslator>(
    () => JobDataSourceTranslator(),
  );

  locator.registerLazySingleton<RefreshableValueTranslator>(
    () => RefreshableValueTranslator(),
  );
}
