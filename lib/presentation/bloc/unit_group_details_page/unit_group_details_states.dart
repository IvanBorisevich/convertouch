import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';

abstract class UnitGroupDetailsState extends ConvertouchState {
  const UnitGroupDetailsState();
}

class UnitGroupDetailsReady extends UnitGroupDetailsState {
  final UnitGroupModel savedGroup;
  final UnitGroupModel draftGroup;
  final bool isExistingGroup;
  final bool canChangedBeSaved;

  const UnitGroupDetailsReady({
    required this.savedGroup,
    required this.draftGroup,
    required this.isExistingGroup,
    required this.canChangedBeSaved,
  });

  @override
  List<Object?> get props => [
    savedGroup,
    draftGroup,
    isExistingGroup,
    canChangedBeSaved,
  ];

  @override
  String toString() {
    return 'UnitGroupDetailsReady{'
        'savedGroup: $savedGroup, '
        'draftGroup: $draftGroup, '
        'isExistingGroup: $isExistingGroup, '
        'canChangedBeSaved: $canChangedBeSaved}';
  }
}