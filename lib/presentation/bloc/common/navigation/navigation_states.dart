import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';

class NavigationState extends ConvertouchState {
  final BottomNavbarItem bottomNavbarItem;
  final int index;
  final PageName? nextPageName;
  final bool navigateBack;
  final ConvertouchException? exception;

  const NavigationState({
    required this.bottomNavbarItem,
    required this.index,
    this.nextPageName,
    this.navigateBack = false,
    this.exception,
  });

  @override
  List<Object?> get props => [
    bottomNavbarItem,
    index,
    nextPageName,
    navigateBack,
    exception,
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