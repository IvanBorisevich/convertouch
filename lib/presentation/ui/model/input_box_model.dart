import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/presentation/ui/model/element_model.dart';
import 'package:convertouch/presentation/ui/model/list_box_model.dart';
import 'package:convertouch/presentation/ui/model/text_box_model.dart';

const int _nonSearchableListItemsMinLimit = 5;
const String noValueHint = '-';

abstract class InputBoxModel implements ElementModel {
  final String? hint;
  final String? labelText;
  final bool readonly;

  const InputBoxModel({
    this.hint,
    this.labelText,
    this.readonly = false,
  });

  static T ofValue<T extends InputBoxModel, M extends ConversionItemValueModel>(
    M model, {
    bool readonly = false,
  }) {
    if (model.listType != null) {
      return ListBoxModel(
        listValue: model.value?.toListValueModel(),
        listValues: model.listValues!.items,
        listType: model.listType!,
        readonly:
            model.listValues?.items == null || model.listValues!.items.isEmpty,
        labelText: _getLabelText(model),
        searchEnabled:
            model.listValues!.items.length > _nonSearchableListItemsMinLimit,
      ) as T;
    } else {
      return TextBoxModel(
        value: model.value?.raw,
        valueUnfocused: model.value?.alt ?? model.value?.raw,
        hint: model.defaultValue?.raw,
        hintUnfocused:
            model.defaultValue?.alt ?? model.defaultValue?.raw ?? noValueHint,
        readonly: readonly,
        labelText: _getLabelText(model),
        valueType: model.valueType,
      ) as T;
    }
  }

  static String? _getLabelText<M extends ConversionItemValueModel>(M model) {
    if (model is ConversionUnitValueModel) {
      return model.unit.itemName;
    }

    if (model is ConversionParamValueModel) {
      return model.param.name;
    }

    return null;
  }
}
