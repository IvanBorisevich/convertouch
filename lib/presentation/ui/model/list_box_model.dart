import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/list_value_model.dart';
import 'package:convertouch/presentation/ui/model/input_box_model.dart';

class ListBoxModel extends InputBoxModel {
  final ListValueModel? listValue;
  final List<ListValueModel> listValues;
  final ConvertouchListType listType;
  final String? searchHint;
  final bool searchEnabled;

  const ListBoxModel({
    this.listValue,
    required this.listType,
    super.readonly,
    super.labelText,
    this.listValues = const [],
    this.searchHint,
    this.searchEnabled = true,
  });
}
