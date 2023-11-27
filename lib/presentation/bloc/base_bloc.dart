import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/base_event.dart';
import 'package:convertouch/presentation/bloc/base_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchCommonBloc
    extends Bloc<ConvertouchCommonEvent, ConvertouchCommonState> {
  ConvertouchCommonBloc()
      : super(
          const ConvertouchCommonStateBuilt(
            pageId: unitsConversionPageId,
          ),
        );

  @override
  Stream<ConvertouchCommonState> mapEventToState(
    ConvertouchCommonEvent event,
  ) async* {
    yield ConvertouchCommonStateBuilt(
      pageId: event.targetPageId,
      prevState: event.currentState,
      removalMode: event.selectedItemIdsForRemoval.isNotEmpty,
      selectedItemIdsForRemoval: event.selectedItemIdsForRemoval,
      theme: event.theme,
    );
  }
}
