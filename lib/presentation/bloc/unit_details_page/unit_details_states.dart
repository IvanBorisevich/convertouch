import 'package:convertouch/domain/model/unit_details_model.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';

abstract class UnitDetailsState extends ConvertouchState {
  const UnitDetailsState();
}

class UnitDetailsReady extends UnitDetailsState {
  final UnitDetailsModel unitDetails;

  const UnitDetailsReady({
    required this.unitDetails,
  });

  @override
  List<Object?> get props => [
        unitDetails,
      ];

  @override
  String toString() {
    return 'UnitDetailsReady{'
        'unitDetails: $unitDetails}';
  }
}

class UnitDetailsNotificationState extends ConvertouchNotificationState
    implements UnitDetailsState {
  const UnitDetailsNotificationState({
    required super.message,
  });

  @override
  String toString() {
    return 'UnitDetailsNotificationState{'
        'message: $message}';
  }
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
