import 'package:convertouch/domain/model/use_case_model/output/output_conversion_model.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';

abstract class ConversionState extends ConvertouchState {
  const ConversionState();
}

class ConversionInBuilding extends ConversionState {
  const ConversionInBuilding();

  @override
  String toString() {
    return 'ConversionInBuilding{}';
  }
}

class ConversionBuilt extends ConversionState {
  final OutputConversionModel conversion;

  const ConversionBuilt({
    required this.conversion,
  });

  @override
  List<Object?> get props => [
        conversion,
      ];

  @override
  String toString() {
    return 'ConversionBuilt{'
        'conversion: $conversion}';
  }
}

class ConversionErrorState extends ConversionState {
  final String message;

  const ConversionErrorState({
    required this.message,
  });

  @override
  List<Object> get props => [
        message,
      ];

  @override
  String toString() {
    return 'ConversionErrorState{message: $message}';
  }
}
