import 'package:convertouch/data/dao/db/dbhelper/dbconfig/dbconfig.dart';
import 'package:convertouch/data/dao/db/dbhelper/dbhelper.dart';
import 'package:convertouch/data/dao/net/network_dao_impl.dart';
import 'package:convertouch/data/dao/network_dao.dart';
import 'package:convertouch/data/repositories/db/dynamic_value_repository_impl.dart';
import 'package:convertouch/data/repositories/db/unit_group_repository_impl.dart';
import 'package:convertouch/data/repositories/db/unit_repository_impl.dart';
import 'package:convertouch/data/repositories/local/data_source_repository_impl.dart';
import 'package:convertouch/data/repositories/local/job_repository_impl.dart';
import 'package:convertouch/data/repositories/net/network_repository_impl.dart';
import 'package:convertouch/data/translators/data_source_translator.dart';
import 'package:convertouch/data/translators/dynamic_value_translator.dart';
import 'package:convertouch/data/translators/unit_group_translator.dart';
import 'package:convertouch/data/translators/unit_translator.dart';
import 'package:convertouch/domain/repositories/data_source_repository.dart';
import 'package:convertouch/domain/repositories/dynamic_value_repository.dart';
import 'package:convertouch/domain/repositories/job_repository.dart';
import 'package:convertouch/domain/repositories/network_repository.dart';
import 'package:convertouch/domain/repositories/unit_group_repository.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:convertouch/domain/use_cases/common/mark_items_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/add_units_to_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/build_new_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/edit_conversion_item_unit_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/edit_conversion_item_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/get_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/remove_conversion_items_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/replace_conversion_item_unit_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/update_conversion_coefficients_use_case.dart';
import 'package:convertouch/domain/use_cases/dynamic_data/get_dynamic_data_for_conversion.dart';
import 'package:convertouch/domain/use_cases/jobs/start_job_use_case.dart';
import 'package:convertouch/domain/use_cases/jobs/stop_job_use_case.dart';
import 'package:convertouch/domain/use_cases/unit_details/build_unit_details_use_case.dart';
import 'package:convertouch/domain/use_cases/unit_details/modify_unit_details_use_case.dart';
import 'package:convertouch/domain/use_cases/unit_groups/fetch_unit_groups_use_case.dart';
import 'package:convertouch/domain/use_cases/unit_groups/get_unit_group_use_case.dart';
import 'package:convertouch/domain/use_cases/unit_groups/remove_unit_groups_use_case.dart';
import 'package:convertouch/domain/use_cases/unit_groups/save_unit_group_use_case.dart';
import 'package:convertouch/domain/use_cases/units/fetch_units_use_case.dart';
import 'package:convertouch/domain/use_cases/units/remove_units_use_case.dart';
import 'package:convertouch/domain/use_cases/units/save_unit_use_case.dart';
import 'package:convertouch/presentation/bloc/common/app/app_bloc.dart';
import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'presentation/bloc/unit_group_details_page/unit_group_details_bloc.dart';

final locator = GetIt.I;

Future<void> init() async {
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  locator.registerLazySingleton<ConvertouchDatabaseHelper>(
    () => ConvertouchDatabaseHelper(),
  );

  ConvertouchDatabase database =
      await ConvertouchDatabaseHelper.I.initDatabase();

  locator.registerLazySingleton<ConvertouchDatabase>(
    () => database,
  );

  await _initDao();
  await _initRepositories(database);
  await _initTranslators();
  await _initUseCases();
  await _initBloc();
}

Future<void> _initDao() async {
  locator.registerLazySingleton<NetworkDao>(
    () => const NetworkDaoImpl(),
  );
}

Future<void> _initRepositories(ConvertouchDatabase database) async {
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

  locator.registerLazySingleton<NetworkRepository>(
    () => NetworkRepositoryImpl(
      networkDao: locator(),
      unitDao: database.unitDao,
      dynamicValueDao: database.dynamicValueDao,
      database: database.database.database,
    ),
  );

  locator.registerLazySingleton<DataSourceRepository>(
    () => const DataSourceRepositoryImpl(),
  );

  locator.registerLazySingleton<JobRepository>(
    () => const JobRepositoryImpl(),
  );

  locator.registerLazySingleton<DynamicValueRepository>(
    () => DynamicValueRepositoryImpl(
      dynamicValueDao: database.dynamicValueDao,
      unitDao: database.unitDao,
      database: database.database.database,
    ),
  );
}

Future<void> _initTranslators() async {
  locator.registerLazySingleton<UnitGroupTranslator>(
    () => UnitGroupTranslator(),
  );

  locator.registerLazySingleton<UnitTranslator>(
    () => UnitTranslator(),
  );

  locator.registerLazySingleton<DynamicValueTranslator>(
    () => DynamicValueTranslator(),
  );

  locator.registerLazySingleton<DataSourceTranslator>(
    () => DataSourceTranslator(),
  );
}

Future<void> _initUseCases() async {
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

  locator.registerLazySingleton<BuildUnitDetailsUseCase>(
    () => BuildUnitDetailsUseCase(
      unitRepository: locator(),
    ),
  );

  locator.registerLazySingleton<ModifyUnitDetailsUseCase>(
    () => ModifyUnitDetailsUseCase(
      unitRepository: locator(),
    ),
  );

  locator.registerLazySingleton<RemoveUnitsUseCase>(
    () => RemoveUnitsUseCase(locator()),
  );

  locator.registerLazySingleton<BuildNewConversionUseCase>(
    () => BuildNewConversionUseCase(
      dynamicValueRepository: locator(),
    ),
  );

  locator.registerLazySingleton<GetConversionUseCase>(
    () => const GetConversionUseCase(),
  );

  locator.registerLazySingleton<AddUnitsToConversionUseCase>(
    () => AddUnitsToConversionUseCase(
      buildNewConversionUseCase: locator(),
      unitRepository: locator(),
    ),
  );

  locator.registerLazySingleton<EditConversionItemUnitUseCase>(
    () => EditConversionItemUnitUseCase(
      buildNewConversionUseCase: locator(),
    ),
  );

  locator.registerLazySingleton<EditConversionItemValueUseCase>(
    () => EditConversionItemValueUseCase(
      buildNewConversionUseCase: locator(),
    ),
  );

  locator.registerLazySingleton<RemoveConversionItemsUseCase>(
    () => RemoveConversionItemsUseCase(
      buildNewConversionUseCase: locator(),
    ),
  );

  locator.registerLazySingleton<ReplaceConversionItemUnitUseCase>(
    () => ReplaceConversionItemUnitUseCase(
      buildNewConversionUseCase: locator(),
    ),
  );

  locator.registerLazySingleton<UpdateConversionCoefficientsUseCase>(
    () => UpdateConversionCoefficientsUseCase(
      buildNewConversionUseCase: locator(),
    ),
  );

  locator.registerLazySingleton<GetDynamicDataForConversionUseCase>(
    () => GetDynamicDataForConversionUseCase(
      networkRepository: locator(),
    ),
  );

  locator.registerLazySingleton<StartJobUseCase>(
    () => const StartJobUseCase(),
  );

  locator.registerLazySingleton<StopJobUseCase>(
    () => const StopJobUseCase(),
  );

  locator.registerLazySingleton<MarkItemsUseCase>(
    () => MarkItemsUseCase(),
  );
}

Future<void> _initBloc() async {
  locator.registerLazySingleton<AppBloc>(
    () => AppBloc(),
  );

  locator.registerLazySingleton<NavigationBloc>(
    () => NavigationBloc(),
  );

  locator.registerLazySingleton<ItemsSelectionBloc>(
    () => ItemsSelectionBloc(
      markItemsUseCase: locator(),
    ),
  );

  locator.registerLazySingleton<ItemsSelectionBlocForUnitDetails>(
    () => ItemsSelectionBlocForUnitDetails(
      markItemsUseCase: locator(),
    ),
  );

  locator.registerLazySingleton<UnitGroupsBloc>(
    () => UnitGroupsBloc(
      fetchUnitGroupsUseCase: locator(),
      saveUnitGroupUseCase: locator(),
      removeUnitGroupsUseCase: locator(),
      navigationBloc: locator(),
    ),
  );

  locator.registerLazySingleton<UnitGroupsBlocForUnitDetails>(
    () => UnitGroupsBlocForUnitDetails(
      fetchUnitGroupsUseCase: locator(),
      saveUnitGroupUseCase: locator(),
      removeUnitGroupsUseCase: locator(),
      navigationBloc: locator(),
    ),
  );

  locator.registerLazySingleton<UnitsBloc>(
    () => UnitsBloc(
      saveUnitUseCase: locator(),
      fetchUnitsUseCase: locator(),
      removeUnitsUseCase: locator(),
      navigationBloc: locator(),
    ),
  );

  locator.registerLazySingleton<UnitsBlocForUnitDetails>(
    () => UnitsBlocForUnitDetails(
      saveUnitUseCase: locator(),
      fetchUnitsUseCase: locator(),
      removeUnitsUseCase: locator(),
      navigationBloc: locator(),
    ),
  );

  locator.registerLazySingleton<UnitDetailsBloc>(
    () => UnitDetailsBloc(
      buildUnitDetailsUseCase: locator(),
      modifyUnitDetailsUseCase: locator(),
      navigationBloc: locator(),
    ),
  );

  locator.registerLazySingleton<UnitGroupDetailsBloc>(
    () => UnitGroupDetailsBloc(
      navigationBloc: locator(),
    ),
  );

  locator.registerLazySingleton<ConversionBloc>(
    () => ConversionBloc(
      buildNewConversionUseCase: locator(),
      getConversionUseCase: locator(),
      addUnitsToConversionUseCase: locator(),
      editConversionItemUnitUseCase: locator(),
      editConversionItemValueUseCase: locator(),
      updateConversionCoefficientsUseCase: locator(),
      removeConversionItemsUseCase: locator(),
      replaceConversionItemUnitUseCase: locator(),
      navigationBloc: locator(),
    ),
  );

  locator.registerLazySingleton<RefreshingJobsBloc>(
    () => RefreshingJobsBloc(
      startJobUseCase: locator(),
      stopJobUseCase: locator(),
      getDynamicDataForConversionUseCase: locator(),
      dataSourceRepository: locator(),
      jobRepository: locator(),
      conversionBloc: locator(),
      navigationBloc: locator(),
    ),
  );
}
