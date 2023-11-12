import 'package:convertouch/presentation/bloc/app/app_events.dart';
import 'package:convertouch/presentation/bloc/app/app_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppState());

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is SelectItemForRemoval) {
      yield const AppStateProcessing();

      List<int> result;
      if (event.currentSelectedItemIdsForRemoval == null ||
          event.currentSelectedItemIdsForRemoval!.isEmpty) {
        result = [];
      } else {
        result = event.currentSelectedItemIdsForRemoval!;
      }

      if (!result.contains(event.itemId)) {
        result.add(event.itemId);
      } else {
        result.remove(event.itemId);
      }

      yield AppState(
        removalMode: true,
        selectedItemIdsForRemoval: result,
      );
    } else if (event is DisableRemovalMode) {
      yield const AppState(
        removalMode: false,
      );
    }
  }
}
