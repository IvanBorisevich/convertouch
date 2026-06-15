import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';

class RootScreenState extends ConvertouchState {
  final BottomNavbarItem selectedNavbarItem;
  final int index;
  final List<BottomNavbarItem> openedNavbarItems;
  final bool isBottomNavbarOpenedFirstTime;

  const RootScreenState({
    required this.selectedNavbarItem,
    required this.index,
    this.openedNavbarItems = const [],
    this.isBottomNavbarOpenedFirstTime = false,
  });

  @override
  List<Object?> get props => [
        selectedNavbarItem,
        index,
        openedNavbarItems,
        isBottomNavbarOpenedFirstTime,
      ];

  @override
  String toString() {
    return 'RootScreenState{'
        'selectedNavbarItem: $selectedNavbarItem, '
        'index: $index, '
        'openedNavbarItems: $openedNavbarItems, '
        'isBottomNavbarOpenedFirstTime: $isBottomNavbarOpenedFirstTime}';
  }
}
