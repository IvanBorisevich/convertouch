import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';

abstract class ConversionState extends ConvertouchState {
  const ConversionState();
}

class ConversionBuilt extends ConversionState {
  final ConversionModel conversion;
  final bool rebuildUnitValues;
  final bool rebuildParams;

  const ConversionBuilt({
    required this.conversion,
    this.rebuildUnitValues = true,
    this.rebuildParams = true,
  });

  @override
  List<Object?> get props => [
        conversion,
        rebuildUnitValues,
        rebuildParams,
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
    return 'ConversionBuilt{'
        'conversion: $conversion, '
        'rebuildUnitValues: $rebuildUnitValues, '
        'rebuildParams: $rebuildParams}';
  }
}
