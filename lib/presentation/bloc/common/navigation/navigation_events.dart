import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';

abstract class NavigationEvent extends ConvertouchEvent {
  const NavigationEvent();
}

class SelectBottomNavbarItem extends NavigationEvent {
  final BottomNavbarItem bottomNavbarItem;

  const SelectBottomNavbarItem({
    required this.bottomNavbarItem,
  });

  @override
  List<Object?> get props => [
    bottomNavbarItem,
  ];

  @override
  String toString() {
    return 'SelectBottomNavbarItem{'
        'bottomNavbarItem: $bottomNavbarItem}';
  }
}