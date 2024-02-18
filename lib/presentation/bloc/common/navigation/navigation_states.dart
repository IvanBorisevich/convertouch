import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';

class NavigationState extends ConvertouchState {
  final BottomNavbarItem bottomNavbarItem;
  final int index;
  final PageName? nextPageName;
  final bool navigateBack;

  const NavigationState({
    required this.bottomNavbarItem,
    required this.index,
    this.nextPageName,
    this.navigateBack = false,
  });

  @override
  List<Object?> get props => [
    bottomNavbarItem,
    index,
    nextPageName,
    navigateBack,
  ];

  @override
  String toString() {
    return 'NavigationState{'
        'bottomNavbarItem: $bottomNavbarItem, '
        'index: $index, '
        'nextPageName: $nextPageName, '
        'navigateBack: $navigateBack}';
  }
}