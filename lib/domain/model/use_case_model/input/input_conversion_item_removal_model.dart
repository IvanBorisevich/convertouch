import 'package:convertouch/domain/model/use_case_model/output/output_conversion_model.dart';

class InputConversionItemRemovalModel {
  final int id;
  final OutputConversionModel conversion;

  const InputConversionItemRemovalModel({
    required this.id,
    required this.conversion,
  });

  @override
  String toString() {
    return 'InputConversionItemRemovalModel{'
        'id: $id, '
        'conversion: $conversion}';
  }
}