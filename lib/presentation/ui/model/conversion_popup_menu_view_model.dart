import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:equatable/equatable.dart';

class ConversionPopupMenuViewModel extends Equatable {
  final bool paramsCanBeAdded;
  final bool paramsCanBeRemoved;
  final bool paramsOptionsExist;
  final List<int> addedParamSetIds;
  final UnitGroupModel unitGroup;

  const ConversionPopupMenuViewModel({
    this.paramsCanBeAdded = false,
    this.paramsCanBeRemoved = false,
    this.paramsOptionsExist = false,
    this.addedParamSetIds = const [],
    required this.unitGroup,
  });

  @override
  List<Object?> get props => [
        paramsCanBeAdded,
        paramsCanBeRemoved,
        paramsOptionsExist,
        addedParamSetIds,
        unitGroup,
      ];
}
