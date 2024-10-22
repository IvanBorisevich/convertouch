import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';

abstract class ConversionState extends ConvertouchState {
  const ConversionState();
}

class ConversionBuilt extends ConversionState {
  final ConversionModel conversion;
  final bool showRefreshButton;

  const ConversionBuilt({
    required this.conversion,
    this.showRefreshButton = false,
  });

  @override
  List<Object?> get props => [
        conversion,
        showRefreshButton,
      ];

  Map<String, dynamic> toJson() {
    return {
      "conversion": conversion.toJson(),
      "showRefreshButton": showRefreshButton,
    };
  }

  static ConversionBuilt? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return ConversionBuilt(
      conversion:
          ConversionModel.fromJson(json["conversion"]) ?? ConversionModel.none,
      showRefreshButton: json["showRefreshButton"] ?? false,
    );
  }

  @override
  String toString() {
    return 'ConversionBuilt{'
        'showRefreshButton: $showRefreshButton, '
        'conversion: $conversion}';
  }
}
