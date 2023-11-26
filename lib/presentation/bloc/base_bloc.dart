import 'package:convertouch/presentation/bloc/base_event.dart';
import 'package:convertouch/presentation/bloc/base_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchCommonBloc
    extends Bloc<ConvertouchCommonEvent, ConvertouchCommonState> {
  ConvertouchCommonBloc()
      : super(
          const ConvertouchCommonStateBuilt(
            pageId: '',
            startPageIndex: 0,
          ),
        );

  @override
  Stream<ConvertouchCommonState> mapEventToState(
    ConvertouchCommonEvent event,
  ) async* {
    yield ConvertouchCommonStateBuilt(
      pageId: event.currentPageId,
      prevState: event.currentState,
      startPageIndex: event.startPageIndex,
      removalMode: event.selectedItemIdsForRemoval.isNotEmpty,
      selectedItemIdsForRemoval: event.selectedItemIdsForRemoval,
      theme: event.theme,
    );
  }
}
