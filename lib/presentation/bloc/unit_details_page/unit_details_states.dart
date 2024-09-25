import 'package:convertouch/domain/model/use_case_model/output/output_unit_details_model.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';

abstract class UnitDetailsState extends ConvertouchState {
  const UnitDetailsState();
}

class UnitDetailsInitialState extends UnitDetailsState {
  const UnitDetailsInitialState();

  @override
  String toString() {
    return 'UnitDetailsInitialState{}';
  }
}

class UnitDetailsReady extends UnitDetailsState {
  final OutputUnitDetailsModel details;

  const UnitDetailsReady({
    required this.details,
  });

  @override
  List<Object?> get props => [
        details,
      ];

  @override
  String toString() {
    return 'UnitDetailsReady{details: $details}';
  }
}
