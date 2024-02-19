import 'package:convertouch/domain/model/use_case_model/output/output_conversion_model.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';

abstract class ConversionState extends ConvertouchState {
  const ConversionState();
}

class ConversionBuilt extends ConversionState {
  final OutputConversionModel conversion;
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
      conversion: OutputConversionModel.fromJson(json["conversion"])!,
      showRefreshButton: json["showRefreshButton"],
    );
  }

  @override
  String toString() {
    return 'ConversionBuilt{'
        'showRefreshButton: $showRefreshButton, '
        'conversion: $conversion}';
  }
}
