import 'package:convertouch/model/constant.dart';
import 'package:convertouch/presenter/events/app_event.dart';
import 'package:convertouch/presenter/states/app_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppState(
    isSearchBarVisible: true,
    isFloatingButtonVisible: true,
    pageId: unitGroupItemsPageId
  ));

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    yield AppState(
      isSearchBarVisible: event.isSearchBarVisible,
      isFloatingButtonVisible: event.isFloatingButtonVisible,
      pageId: event.nextPageId
    );
  }
}
