import 'package:convertouch/domain/constants/constants.dart';
import 'package:equatable/equatable.dart';

abstract class ConvertouchCommonState extends Equatable {
  const ConvertouchCommonState();

  @override
  List<Object?> get props => [];
}

class ConvertouchCommonStateInBuilding extends ConvertouchCommonState {
  const ConvertouchCommonStateInBuilding();

  @override
  String toString() {
    return 'ConvertouchCommonStateInBuilding{}';
  }
}

class ConvertouchCommonStateBuilt extends ConvertouchCommonState {
  final String pageId;
  final Type? prevState;
  final String pageTitle;
  final int startPageIndex;
  final bool removalMode;
  final List<int> selectedItemIdsForRemoval;
  final ConvertouchUITheme theme;

  const ConvertouchCommonStateBuilt({
    required this.pageId,
    this.prevState,
    this.pageTitle = '',
    required this.startPageIndex,
    this.removalMode = false,
    this.selectedItemIdsForRemoval = const [],
    this.theme = ConvertouchUITheme.light,
  });

  @override
  List<Object?> get props => [
    pageId,
    prevState,
    pageTitle,
    startPageIndex,
    removalMode,
    selectedItemIdsForRemoval,
    theme,
  ];

  @override
  String toString() {
    return 'ConvertouchCommonStateBuilt{'
        'pageId: $pageId, '
        'prevState: $prevState, '
        'pageTitle: $pageTitle, '
        'startPageIndex: $startPageIndex, '
        'removalMode: $removalMode, '
        'selectedItemIdsForRemoval: $selectedItemIdsForRemoval, '
        'theme: $theme'
        '}';
  }
}
