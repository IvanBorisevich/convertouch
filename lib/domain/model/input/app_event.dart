import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/input/abstract_event.dart';

abstract class AppEvent extends ConvertouchEvent {
  const AppEvent();
}

class ChangeUITheme extends AppEvent {
  final ConvertouchUITheme newTheme;

  const ChangeUITheme({
    required this.newTheme,
  });

  @override
  String toString() {
    return 'ChangeUITheme{newTheme: $newTheme}';
  }
}
