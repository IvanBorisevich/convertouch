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
  final bool conversionRuleVisible;
  final bool conversionRuleEnabled;
  final String? note;

  const UnitDetailsReady({
    required this.draftDetails,
    required this.savedDetails,
    this.unitToBeSaved,
    required this.editMode,
    required this.conversionRuleVisible,
    required this.conversionRuleEnabled,
    this.note,
  });

  @override
  List<Object?> get props => [
        draftDetails,
        savedDetails,
        unitToBeSaved,
        editMode,
        conversionRuleVisible,
        conversionRuleEnabled,
        note,
      ];

  @override
  String toString() {
    return 'UnitDetailsReady{'
        'savedDetails: $savedDetails, '
        'draftDetails: $draftDetails, '
        'unitToBeSaved: $unitToBeSaved, '
        'editMode: $editMode, '
        'note: $note}';
  }
}
