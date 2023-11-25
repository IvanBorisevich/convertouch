import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/base_state.dart';

abstract class AppState extends ConvertouchBlocState {
  const AppState();
}

class AppStateChanged extends AppState {
  final String pageId;
  final String? prevPageId;
  final String pageTitle;
  final bool floatingButtonVisible;
  final bool removalMode;
  final List<int> selectedItemIdsForRemoval;
  final ConvertouchUITheme theme;

  const AppStateChanged({
    required this.pageId,
    this.prevPageId,
    required this.pageTitle,
    required this.floatingButtonVisible,
    required this.removalMode,
    this.selectedItemIdsForRemoval = const [],
    required this.theme,
  });

  @override
  List<Object?> get props => [
    pageId,
    prevPageId,
    pageTitle,
    floatingButtonVisible,
    removalMode,
    selectedItemIdsForRemoval,
    theme,
  ];

  @override
  String toString() {
    return 'AppStateChanged{'
        'removalMode: $removalMode, '
        'selectedItemIdsForRemoval: $selectedItemIdsForRemoval, '
        'theme: $theme'
        '}';
  }
}

class AppStateChanging extends AppState {
  const AppStateChanging();

  @override
  String toString() {
    return 'AppStateChanging{}';
  }
}

