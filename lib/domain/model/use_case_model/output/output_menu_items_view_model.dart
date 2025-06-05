import 'package:convertouch/domain/constants/settings.dart';

class OutputMenuItemsViewModel {
  final ItemsViewMode currentMode;
  final ItemsViewMode nextMode;

  const OutputMenuItemsViewModel({
    required this.currentMode,
    required this.nextMode,
  });

  @override
  String toString() {
    return 'OutputMenuItemsViewModel{'
        'currentMode: $currentMode, '
        'nextMode: $nextMode}';
  }
}
