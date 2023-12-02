import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/app/app_event.dart';
import 'package:convertouch/presentation/bloc/app/app_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchAppBloc
    extends Bloc<ConvertouchAppEvent, ConvertouchAppState> {
  ConvertouchAppBloc() : super(const ConvertouchAppStateBuilt(
    activeNavbarItem: BottomNavbarItem.home,
  ));

  @override
  Stream<ConvertouchAppState> mapEventToState(
    ConvertouchAppEvent event,
  ) async* {
    yield ConvertouchAppStateBuilt(
      activeNavbarItem: event.activeNavbarItem,
      removalMode: event.selectedItemIdsForRemoval.isNotEmpty,
      selectedItemIdsForRemoval: event.selectedItemIdsForRemoval,
      theme: event.theme,
    );
  }
}
