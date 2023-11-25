import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:equatable/equatable.dart';

class ConvertouchPageState extends Equatable {
  final String pageId;
  final Type? prevState;
  final String pageTitle;
  final int startPageIndex;
  final UnitGroupModel? unitGroupInConversion;
  final bool floatingButtonVisible;
  final bool removalMode;
  final List<int> selectedItemIdsForRemoval;
  final ItemsViewMode? pageViewMode;
  final ItemsViewMode? iconViewMode;
  final ConvertouchUITheme theme;

  const ConvertouchPageState({
    required this.pageId,
    this.prevState,
    required this.pageTitle,
    required this.startPageIndex,
    this.unitGroupInConversion,
    required this.floatingButtonVisible,
    this.removalMode = false,
    this.selectedItemIdsForRemoval = const [],
    this.pageViewMode,
    this.iconViewMode,
    this.theme = ConvertouchUITheme.light,
  });

  @override
  List<Object?> get props => [
    pageId,
    prevState,
    pageTitle,
    startPageIndex,
    unitGroupInConversion,
    floatingButtonVisible,
    removalMode,
    selectedItemIdsForRemoval,
    pageViewMode,
    iconViewMode,
    theme,
  ];

  @override
  String toString() {
    return 'ConvertouchPageState{'
        'pageId: $pageId, '
        'prevState: $prevState, '
        'pageTitle: $pageTitle, '
        'startPageIndex: $startPageIndex, '
        'unitGroupInConversion: $unitGroupInConversion, '
        'floatingButtonVisible: $floatingButtonVisible, '
        'removalMode: $removalMode, '
        'selectedItemIdsForRemoval: $selectedItemIdsForRemoval, '
        'pageViewMode: $pageViewMode, '
        'iconViewMode: $iconViewMode, '
        'theme: $theme'
        '}';
  }
}
