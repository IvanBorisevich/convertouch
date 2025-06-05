import 'package:convertouch/data/dao/db/dbhelper/dbconfig/dbconfig.dart';
import 'package:convertouch/data/dao/db/dbhelper/dbhelper.dart';
import 'package:convertouch/data/dao/net/network_dao_impl.dart';
import 'package:convertouch/data/dao/network_dao.dart';
import 'package:convertouch/data/repositories/db/conversion_param_repository_impl.dart';
import 'package:convertouch/data/repositories/db/conversion_param_set_repository_impl.dart';
import 'package:convertouch/data/repositories/db/conversion_repository_impl.dart';
import 'package:convertouch/data/repositories/db/dynamic_value_repository_impl.dart';
import 'package:convertouch/data/repositories/db/unit_group_repository_impl.dart';
import 'package:convertouch/data/repositories/db/unit_repository_impl.dart';
import 'package:convertouch/data/repositories/local/data_source_repository_impl.dart';
import 'package:convertouch/data/repositories/local/list_value_repository_impl.dart';
import 'package:convertouch/data/repositories/net/network_repository_impl.dart';
import 'package:convertouch/data/translators/conversion_item_value_translator.dart';
import 'package:convertouch/data/translators/conversion_param_set_translator.dart';
import 'package:convertouch/data/translators/conversion_param_translator.dart';
import 'package:convertouch/data/translators/conversion_translator.dart';
import 'package:convertouch/data/translators/dynamic_value_translator.dart';
import 'package:convertouch/data/translators/unit_group_translator.dart';
import 'package:convertouch/data/translators/unit_translator.dart';
import 'package:convertouch/domain/repositories/conversion_param_repository.dart';
import 'package:convertouch/domain/repositories/conversion_param_set_repository.dart';
import 'package:convertouch/domain/repositories/conversion_repository.dart';
import 'package:convertouch/domain/repositories/data_source_repository.dart';
import 'package:convertouch/domain/repositories/dynamic_value_repository.dart';
import 'package:convertouch/domain/repositories/list_value_repository.dart';
import 'package:convertouch/domain/repositories/network_repository.dart';
import 'package:convertouch/domain/repositories/unit_group_repository.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:convertouch/domain/use_cases/common/mark_items_use_case.dart';
import 'package:convertouch/domain/use_cases/common/select_list_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/add_param_sets_to_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/add_units_to_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/edit_conversion_group_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/edit_conversion_item_unit_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/edit_conversion_item_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/edit_conversion_param_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/fetch_more_list_values_of_conv_item_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/fetch_more_list_values_of_param_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/get_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_source_item_by_params_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/enrich_items_with_list_values_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/replace_item_unit_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/remove_conversion_items_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/remove_param_sets_from_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/replace_conversion_item_unit_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/replace_conversion_param_unit_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/save_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/select_param_set_in_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/toggle_calculable_param_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/update_conversion_coefficients_use_case.dart';
import 'package:convertouch/domain/use_cases/data_sources/get_data_source_use_case.dart';
import 'package:convertouch/domain/use_cases/jobs/start_refreshing_job_use_case.dart';
import 'package:convertouch/domain/use_cases/jobs/stop_job_use_case.dart';
import 'package:convertouch/domain/use_cases/list_values/fetch_list_values_use_case.dart';
import 'package:convertouch/domain/use_cases/param_set/fetch_param_sets_use_case.dart';
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
import 'package:convertouch/presentation/bloc/conversion_param_sets_page/conversion_param_sets_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_param_sets_page/single_param_bloc.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/single_group_bloc.dart';
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
      conversionParamUnitDao: database.conversionParamUnitDao,
    ),
  );

  locator.registerLazySingleton<ConversionRepository>(
    () => ConversionRepositoryImpl(
      conversionDao: database.conversionDao,
      conversionUnitValueDao: database.conversionUnitValueDao,
      conversionParamValueDao: database.conversionParamValueDao,
      unitGroupRepository: locator(),
      unitRepository: locator(),
      conversionParamRepository: locator(),
      conversionParamSetRepository: locator(),
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

  locator.registerLazySingleton<DynamicValueRepository>(
    () => DynamicValueRepositoryImpl(
      dynamicValueDao: database.dynamicValueDao,
      unitDao: database.unitDao,
      database: database.database.database,
    ),
  );

  locator.registerLazySingleton<ConversionParamSetRepository>(
    () => ConversionParamSetRepositoryImpl(
      conversionParamSetDao: database.conversionParamSetDao,
    ),
  );

  locator.registerLazySingleton<ConversionParamRepository>(
    () => ConversionParamRepositoryImpl(
      conversionParamDao: database.conversionParamDao,
      unitDao: database.unitDao,
    ),
  );

  locator.registerLazySingleton<ListValueRepository>(
    () => const ListValueRepositoryImpl(),
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

  locator.registerLazySingleton<ConversionTranslator>(
    () => ConversionTranslator(),
  );

  locator.registerLazySingleton<ConversionUnitValueTranslator>(
    () => ConversionUnitValueTranslator(),
  );

  locator.registerLazySingleton<ConversionParamValueTranslator>(
    () => ConversionParamValueTranslator(),
  );

  locator.registerLazySingleton<ConversionParamSetTranslator>(
    () => ConversionParamSetTranslator(),
  );

  locator.registerLazySingleton<ConversionParamTranslator>(
    () => ConversionParamTranslator(),
  );
}

Future<void> _initUseCases() async {
  locator.registerLazySingleton<CalculateDefaultValueUseCase>(
    () => CalculateDefaultValueUseCase(
      dynamicValueRepository: locator(),
      listValueRepository: locator(),
    ),
  );

  locator.registerLazySingleton<CalculateSourceItemByParamsUseCase>(
    () => CalculateSourceItemByParamsUseCase(
      calculateDefaultValueUseCase: locator(),
    ),
  );

  locator.registerLazySingleton<ReplaceUnitInConversionItemUseCase>(
    () => ReplaceUnitInConversionItemUseCase(
      listValueRepository: locator(),
      calculateDefaultValueUseCase: locator(),
    ),
  );

  locator.registerLazySingleton<ReplaceUnitInParamUseCase>(
    () => ReplaceUnitInParamUseCase(
      listValueRepository: locator(),
      calculateDefaultValueUseCase: locator(),
    ),
  );

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

  locator.registerLazySingleton<GetConversionUseCase>(
    () => GetConversionUseCase(
      conversionRepository: locator(),
    ),
  );

  locator.registerLazySingleton<SaveConversionUseCase>(
    () => SaveConversionUseCase(
      conversionRepository: locator(),
    ),
  );

  locator.registerLazySingleton<AddUnitsToConversionUseCase>(
    () => AddUnitsToConversionUseCase(
      calculateSourceItemByParamsUseCase: locator(),
      unitRepository: locator(),
    ),
  );

  locator.registerLazySingleton<EditConversionGroupUseCase>(
    () => const EditConversionGroupUseCase(),
  );

  locator.registerLazySingleton<EditConversionItemUnitUseCase>(
    () => const EditConversionItemUnitUseCase(),
  );

  locator.registerLazySingleton<EditConversionItemValueUseCase>(
    () => EditConversionItemValueUseCase(
      calculateDefaultValueUseCase: locator(),
    ),
  );

  locator.registerLazySingleton<RemoveConversionItemsUseCase>(
    () => const RemoveConversionItemsUseCase(),
  );

  locator.registerLazySingleton<ReplaceConversionItemUnitUseCase>(
    () => ReplaceConversionItemUnitUseCase(
      replaceUnitInConversionItemUseCase: locator(),
    ),
  );

  locator.registerLazySingleton<UpdateConversionCoefficientsUseCase>(
    () => const UpdateConversionCoefficientsUseCase(),
  );

  locator.registerLazySingleton<AddParamSetsToConversionUseCase>(
    () => AddParamSetsToConversionUseCase(
      conversionParamSetRepository: locator(),
      conversionParamRepository: locator(),
      calculateDefaultValueUseCase: locator(),
    ),
  );

  locator.registerLazySingleton<RemoveParamSetsFromConversionUseCase>(
    () => RemoveParamSetsFromConversionUseCase(
      calculateSourceItemByParamsUseCase: locator(),
    ),
  );

  locator.registerLazySingleton<SelectParamSetInConversionUseCase>(
    () => SelectParamSetInConversionUseCase(
      calculateSourceItemByParamsUseCase: locator(),
    ),
  );

  locator.registerLazySingleton<EditConversionParamValueUseCase>(
    () => EditConversionParamValueUseCase(
      calculateDefaultValueUseCase: locator(),
      calculateSourceItemByParamsUseCase: locator(),
    ),
  );

  locator.registerLazySingleton<ReplaceConversionParamUnitUseCase>(
    () => ReplaceConversionParamUnitUseCase(
      replaceUnitInParamUseCase: locator(),
      calculateSourceItemByParamsUseCase: locator(),
    ),
  );

  locator.registerLazySingleton<ToggleCalculableParamUseCase>(
    () => const ToggleCalculableParamUseCase(),
  );

  locator.registerLazySingleton<EnrichItemsWithListValuesUseCase>(
    () => EnrichItemsWithListValuesUseCase(
      fetchListValuesUseCase: locator(),
    ),
  );

  locator.registerLazySingleton<FetchMoreListValuesOfParamUseCase>(
    () => FetchMoreListValuesOfParamUseCase(
      fetchListValuesUseCase: locator(),
    ),
  );

  locator.registerLazySingleton<FetchMoreListValuesOfConvItemUseCase>(
    () => FetchMoreListValuesOfConvItemUseCase(
      fetchListValuesUseCase: locator(),
    ),
  );

  locator.registerLazySingleton<StartRefreshingJobUseCase>(
    () => StartRefreshingJobUseCase(
      networkRepository: locator(),
      dataSourceRepository: locator(),
    ),
  );

  locator.registerLazySingleton<StopJobUseCase>(
    () => const StopJobUseCase(),
  );

  locator.registerLazySingleton<GetDataSourceUseCase>(
    () => GetDataSourceUseCase(
      dataSourceRepository: locator(),
    ),
  );

  locator.registerLazySingleton<MarkItemsUseCase>(
    () => MarkItemsUseCase(),
  );

  locator.registerLazySingleton<FetchParamSetsUseCase>(
    () => FetchParamSetsUseCase(
      conversionParamSetRepository: locator(),
    ),
  );

  locator.registerLazySingleton<FetchListValuesUseCase>(
    () => FetchListValuesUseCase(
      listValueRepository: locator(),
    ),
  );

  locator.registerLazySingleton<SelectListValueUseCase>(
    () => SelectListValueUseCase(
      listValueRepository: locator(),
    ),
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

  locator.registerLazySingleton<SingleGroupBloc>(
    () => SingleGroupBloc(),
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
      getConversionUseCase: locator(),
      saveConversionUseCase: locator(),
      addUnitsToConversionUseCase: locator(),
      editConversionGroupUseCase: locator(),
      editConversionItemUnitUseCase: locator(),
      editConversionItemValueUseCase: locator(),
      updateConversionCoefficientsUseCase: locator(),
      removeConversionItemsUseCase: locator(),
      replaceConversionItemUnitUseCase: locator(),
      addParamSetsToConversionUseCase: locator(),
      removeParamSetsFromConversionUseCase: locator(),
      selectParamSetInConversionUseCase: locator(),
      editConversionParamValueUseCase: locator(),
      replaceConversionParamUnitUseCase: locator(),
      toggleCalculableParamUseCase: locator(),
      enrichItemsWithListValuesUseCase: locator(),
      fetchMoreListValuesOfParamUseCase: locator(),
      fetchMoreListValuesOfConvItemUseCase: locator(),
      navigationBloc: locator(),
    ),
  );

  locator.registerLazySingleton<ConversionParamSetsBloc>(
    () => ConversionParamSetsBloc(
      fetchParamSetsUseCase: locator(),
    ),
  );

  locator.registerLazySingleton<SingleParamBloc>(
    () => SingleParamBloc(),
  );

  locator.registerLazySingleton<RefreshingJobsBloc>(
    () => RefreshingJobsBloc(
      startRefreshingJobUseCase: locator(),
      stopJobUseCase: locator(),
      getDataSourceUseCase: locator(),
      conversionBloc: locator(),
      navigationBloc: locator(),
    ),
  );
}
