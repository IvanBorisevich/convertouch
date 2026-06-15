import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_events.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationBloc extends ConvertouchBloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationDone()) {
    on<NavigateToPage>(_onNavigateToPage);
    on<NavigateBack>(_onNavigateBack);
    on<NavigateBackToRootPage>(_onNavigateBackToRootPage);
    on<ShowException>(_onShowException);
  }

  _onNavigateToPage(
    NavigateToPage event,
    Emitter<NavigationState> emit,
  ) async {
    emit(const NavigationInProgress());

    emit(
      NavigationDone(
        nextPageName: event.targetPageName,
        isReplaced: event.replace,
      ),
    );
  }

  _onNavigateBack(
    NavigateBack event,
    Emitter<NavigationState> emit,
  ) async {
    emit(const NavigationInProgress());

    emit(
      const NavigationDone(navigateBack: true),
    );
  }

  _onNavigateBackToRootPage(
    NavigateBackToRootPage event,
    Emitter<NavigationState> emit,
  ) async {
    emit(
      const NavigationDone(
        navigateBack: true,
        navigateBackToRoot: true,
      ),
    );
  }

  _onShowException(
    ShowException event,
    Emitter<NavigationState> emit,
  ) async {
    emit(
      NavigationDone(
        navigateBack: false,
        exception: event.exception,
      ),
    );
  }
}
