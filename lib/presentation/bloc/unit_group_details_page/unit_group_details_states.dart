import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';

abstract class UnitGroupDetailsState extends ConvertouchState {
  const UnitGroupDetailsState();
}

class UnitGroupDetailsReady extends UnitGroupDetailsState {
  final UnitGroupModel savedGroup;
  final UnitGroupModel draftGroup;
  final bool editMode;
  final bool canChangedBeSaved;

  const UnitGroupDetailsReady({
    required this.savedGroup,
    required this.draftGroup,
    required this.editMode,
    required this.canChangedBeSaved,
  });

  @override
  List<Object?> get props => [
    savedGroup,
    draftGroup,
    editMode,
    canChangedBeSaved,
  ];

  @override
  String toString() {
    return 'UnitGroupDetailsReady{'
        'savedGroup: $savedGroup, '
        'draftGroup: $draftGroup, '
        'editMode: $editMode, '
        'canChangedBeSaved: $canChangedBeSaved}';
  }
}

class UnitGroupDetailsErrorState extends ConvertouchErrorState
    implements UnitGroupDetailsState {
  const UnitGroupDetailsErrorState({
    required super.exception,
    required super.lastSuccessfulState,
  });

  @override
  String toString() {
    return 'UnitDetailsErrorState{'
        'exception: $exception}';
  }
}