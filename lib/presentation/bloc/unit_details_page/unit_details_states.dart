import 'package:convertouch/domain/model/unit_details_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';

abstract class UnitDetailsState extends ConvertouchState {
  const UnitDetailsState();
}

class UnitDetailsReady extends UnitDetailsState {
  final UnitDetailsModel draftDetails;
  final UnitDetailsModel savedDetails;
  final UnitModel? unitToBeSaved;
  final bool editMode;
  final bool showConversionRule;

  const UnitDetailsReady({
    required this.draftDetails,
    required this.savedDetails,
    this.unitToBeSaved,
    required this.editMode,
    required this.showConversionRule,
  });

  @override
  List<Object?> get props => [
        draftDetails,
        savedDetails,
        unitToBeSaved,
        editMode,
        showConversionRule,
      ];

  @override
  String toString() {
    return 'UnitDetailsReady{'
        'savedDetails: $savedDetails, '
        'draftDetails: $draftDetails, '
        'unitToBeSaved: $unitToBeSaved, '
        'editMode: $editMode}';
  }
}

class UnitDetailsNotificationState extends ConvertouchNotificationState
    implements UnitDetailsState {
  const UnitDetailsNotificationState({
    required super.exception,
  });
}

class UnitDetailsErrorState extends ConvertouchErrorState
    implements UnitDetailsState {
  const UnitDetailsErrorState({
    required super.exception,
    required super.lastSuccessfulState,
  });

  @override
  String toString() {
    return 'UnitDetailsErrorState{'
        'exception: $exception}';
  }
}
