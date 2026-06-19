import 'package:equatable/equatable.dart';

class AddUnitsButtonViewModel extends Equatable {
  const AddUnitsButtonViewModel({
    required this.unitGroupId,
    this.addedUnitIds = const [],
    this.paramsApplicable = true,
  });

  final int unitGroupId;
  final List<int> addedUnitIds;
  final bool paramsApplicable;

  @override
  List<Object?> get props => [
    unitGroupId,
        addedUnitIds,
        paramsApplicable,
      ];
}
