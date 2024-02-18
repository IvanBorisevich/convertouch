import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';

class NavigationState extends ConvertouchState {
  final BottomNavbarItem bottomNavbarItem;
  final int index;

  const NavigationState({
    required this.bottomNavbarItem,
    required this.index,
  });

  @override
  List<Object?> get props => [
    bottomNavbarItem,
    index,
  ];

  @override
  String toString() {
    return 'NavigationState{'
        'bottomNavbarItem: $bottomNavbarItem, '
        'index: $index}';
  }
}