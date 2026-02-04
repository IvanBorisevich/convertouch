import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/presentation/ui/model/input_box_model.dart';

class ListBoxModel extends InputBoxModel {
  final ListValueModel? value;
  final List<ListValueModel> listValues;
  final ConvertouchListType listType;
  final String searchHint;
  final bool searchEnabled;

  const ListBoxModel({
    this.value,
    required this.listType,
    super.hint = 'N/A',
    super.readonly,
    super.labelText,
    this.listValues = const [],
    this.searchHint = 'Search...',
    this.searchEnabled = true,
  });
}
