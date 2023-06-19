import 'package:convertouch/presenter/events/base_event.dart';

class AppEvent extends BlocEvent {
  const AppEvent({
    required this.isSearchBarVisible,
    required this.isFloatingButtonVisible,
    required this.nextPageId,
  });

  final bool isSearchBarVisible;
  final bool isFloatingButtonVisible;
  final String nextPageId;

  @override
  List<Object> get props => [
    isSearchBarVisible,
    isFloatingButtonVisible,
    nextPageId,
  ];

  @override
  String toString() {
    return 'AppEvent{'
        'isSearchBarVisible: $isSearchBarVisible, '
        'isFloatingButtonVisible: $isFloatingButtonVisible, '
        'nextPageId: $nextPageId}';
  }
}
