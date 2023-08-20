import 'package:convertouch/data/dao/db/unit_group_db_dao_impl.dart';
import 'package:convertouch/data/dao/unit_group_dao.dart';
import 'package:convertouch/data/repositories/unit_group_repository_impl.dart';
import 'package:convertouch/domain/repositories/unit_group_repository.dart';
import 'package:convertouch/domain/usecases/unit_groups/fetch_unit_groups_use_case.dart';
import 'package:convertouch/presentation/bloc/unit_groups/unit_groups_bloc.dart';
import 'package:convertouch/presentation/pages/scaffold/navigation_service.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.I;

void init() {
  // navigation service

  locator.registerLazySingleton<NavigationService>(
    () => NavigationService(),
  );

  // unit groups

  locator.registerFactory(
    () => UnitGroupsBloc(locator()),
  );
  locator.registerLazySingleton<FetchUnitGroupsUseCase>(
    () => FetchUnitGroupsUseCase(locator()),
  );
  locator.registerLazySingleton<UnitGroupRepository>(
    () => UnitGroupRepositoryImpl(locator()),
  );
  locator.registerLazySingleton<UnitGroupDao>(
    () => UnitGroupDbDaoImpl(),
  );
}
