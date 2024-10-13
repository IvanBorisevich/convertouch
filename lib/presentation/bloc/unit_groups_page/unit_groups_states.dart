import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';

abstract class UnitGroupsState extends ConvertouchState {
  const UnitGroupsState();
}

class UnitGroupsFetched extends UnitGroupsState {
  final List<UnitGroupModel> unitGroups;
  final String? searchString;

  const UnitGroupsFetched({
    required this.unitGroups,
    this.searchString,
  });

  @override
  List<Object?> get props => [
        unitGroups,
        searchString,
      ];

  @override
  String toString() {
    return 'UnitGroupsFetched{unitGroups: $unitGroups}';
  }
}
