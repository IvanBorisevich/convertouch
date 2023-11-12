import 'package:convertouch/presentation/bloc/base_state.dart';

class AppState extends ConvertouchBlocState {
  final bool removalMode;
  final List<int> selectedItemIdsForRemoval;

  const AppState({
    this.removalMode = false,
    this.selectedItemIdsForRemoval = const [],
  });

  @override
  List<Object?> get props => [
    removalMode,
    selectedItemIdsForRemoval,
  ];

  @override
  String toString() {
    return 'AppState{'
        'removalMode: $removalMode, '
        'selectedItemIdsForRemoval: $selectedItemIdsForRemoval'
        '}';
  }
}

class AppStateProcessing extends AppState {
  const AppStateProcessing();
}

