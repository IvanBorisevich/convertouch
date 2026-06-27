import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/domain/model/value_model.dart';

class InputListValueValidationModel {
  final ListValuesFetchParams? fetchParams;
  final ValueModel? value;

  const InputListValueValidationModel({
    required this.fetchParams,
    required this.value,
  });
}