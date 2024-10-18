import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';

abstract class ConversionState extends ConvertouchState {
  const ConversionState();
}

class ConversionInProgress extends ConversionState {
  const ConversionInProgress();

  @override
  String toString() {
    return 'ConversionInProgress{}';
  }
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
      conversion: ConversionModel.fromJson(json["conversion"]) ??
          const ConversionModel(),
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
