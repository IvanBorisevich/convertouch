import 'package:convertouch/presenter/states/base_state.dart';

class AppState extends BlocState {
  const AppState({
    required this.isSearchBarVisible,
    required this.isFloatingButtonVisible,
    required this.pageId,
  });

  final bool isSearchBarVisible;
  final bool isFloatingButtonVisible;
  final String pageId;

  @override
  List<Object> get props => [
    isSearchBarVisible,
    isFloatingButtonVisible,
    pageId,
  ];

  @override
  String toString() {
    return 'AppState {'
        'isSearchBarVisible: $isSearchBarVisible, '
        'isFloatingButtonVisible: $isFloatingButtonVisible, '
        'pageId: $pageId}';
  }
}
