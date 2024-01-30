import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';

class AppState extends ConvertouchState {
  final ConvertouchUITheme theme;

  const AppState({
    this.theme = ConvertouchUITheme.light,
  });

  @override
  List<Object?> get props => [
        theme,
      ];

  @override
  String toString() {
    return 'AppState{'
        'theme: $theme}';
  }
}
