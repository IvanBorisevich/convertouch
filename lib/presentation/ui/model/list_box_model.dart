import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/presentation/ui/model/input_box_model.dart';

class ListBoxModel extends InputBoxModel {
  final ListValueModel? value;
  final List<ListValueModel> listValues;

  const ListBoxModel({
    this.value,
    super.readonly,
    super.labelText,
    this.listValues = const [],
  });
}
