import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';

abstract class ConversionState extends ConvertouchState {
  const ConversionState();
}

class ConversionBuilt extends ConversionState {
  final ConversionModel conversion;
  final bool rebuildUnitValues;

  const ConversionBuilt({
    required this.conversion,
    this.rebuildUnitValues = false,
  });

  @override
  List<Object?> get props => [
        conversion,
        rebuildUnitValues,
      ];

  Map<String, dynamic> toJson() {
    return {
      "conversion": conversion.toJson(),
    };
  }

  static ConversionBuilt? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return ConversionBuilt(
      conversion:
          ConversionModel.fromJson(json["conversion"]) ?? ConversionModel.none,
    );
  }

  @override
  String toString() {
    return 'ConversionBuilt{conversion: $conversion}';
  }
}
