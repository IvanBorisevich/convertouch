import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/app/app_events.dart';
import 'package:convertouch/presentation/bloc/app/app_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc()
      : super(const AppStateChanged(
          pageId: unitsConversionPageId,
          pageTitle: appName,
          floatingButtonVisible: false,
          removalMode: false,
          theme: ConvertouchUITheme.light,
        ));

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is SelectItemForRemoval) {
      yield const AppStateChanging();

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

      yield AppStateChanged(
        pageId: event.currentPageId,
        prevPageId: event.currentPageId,
        pageTitle: event.pageTitle,
        floatingButtonVisible: event.floatingButtonVisible,
        removalMode: true,
        selectedItemIdsForRemoval: result,
        theme: event.uiTheme,
      );
    } else if (event is DisableRemovalMode) {
      yield AppStateChanged(
        pageId: event.currentPageId,
        prevPageId: event.currentPageId,
        pageTitle: event.pageTitle,
        floatingButtonVisible: event.floatingButtonVisible,
        removalMode: false,
        theme: event.uiTheme,
      );
    } else if (event is ChangeUiTheme) {
      yield const AppStateChanging();
      yield AppStateChanged(
        pageId: event.currentPageId,
        prevPageId: event.currentPageId,
        pageTitle: event.pageTitle,
        floatingButtonVisible: event.floatingButtonVisible,
        removalMode: event.removalMode,
        selectedItemIdsForRemoval: event.currentSelectedItemIdsForRemoval ?? [],
        theme: event.uiTheme,
      );
    }
  }
}
