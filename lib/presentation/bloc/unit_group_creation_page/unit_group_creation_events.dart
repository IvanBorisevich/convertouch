import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/base_event.dart';

abstract class UnitGroupCreationEvent extends ConvertouchCommonEvent {
  const UnitGroupCreationEvent({
    super.currentPageId = unitGroupCreationPageId,
    super.startPageIndex = 1,
  });
}

class AddUnitGroup extends UnitGroupCreationEvent {
  final String unitGroupName;

  const AddUnitGroup({
    required this.unitGroupName,
  });

  @override
  List<Object> get props => [
    unitGroupName,
    super.props,
  ];

  @override
  String toString() {
    return 'AddUnitGroup{'
        'unitGroupName: $unitGroupName, '
        '${super.toString()}}';
  }
}
