import 'package:convertouch/domain/model/input/items_search_events.dart';
import 'package:convertouch/domain/model/output/items_search_states.dart';
import 'package:convertouch/domain/usecases/unit_groups/search_unit_groups_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemsSearchBloc extends Bloc<ItemsSearchEvent, ItemsSearchState> {
  final SearchUnitGroupsUseCase searchUnitGroupsUseCase;

  ItemsSearchBloc({
    required this.searchUnitGroupsUseCase,
  }) : super(const ItemsSearchInitState());

  @override
  Stream<ItemsSearchState> mapEventToState(ItemsSearchEvent event) async* {
    if (event is SearchUnitGroups) {
      final result = await searchUnitGroupsUseCase.execute(event);

      yield result.fold(
        (error) => ItemsSearchErrorState(message: error.message),
        (foundUnitGroups) => UnitGroupsFound(foundItems: foundUnitGroups),
      );
    } else if (event is ResetSearch) {
      yield const ItemsSearchInitState();
    }
  }
}
