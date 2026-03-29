import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/presentation/ui/constants/input_box_constants.dart';
import 'package:convertouch/presentation/ui/model/element_model.dart';
import 'package:convertouch/presentation/ui/model/list_box_model.dart';
import 'package:convertouch/presentation/ui/model/text_box_model.dart';

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
    if (model is ConversionUnitValueModel) {
      return _ofUnitValue(model, readonly: readonly);
    }

    if (model is ConversionParamValueModel) {
      return _ofParamValue(model, readonly: readonly);
    }

    throw Exception("Cannot create input box model "
        "by conversion item model type ${model.runtimeType}");
  }

  static T _ofUnitValue<T extends InputBoxModel>(
    ConversionUnitValueModel model, {
    bool readonly = false,
  }) {
    if (model.listValues?.items != null && model.listValues!.items.isNotEmpty) {
      return ListBoxModel(
        value: model.value?.toListValueModel(),
        listValues: model.listValues!.items,
        listType: model.listType!,
        readonly: readonly,
        labelText: model.unit.itemName,
        searchEnabled: model.listValues!.items.length >
            InputBoxConstants.nonSearchableListItemsMinLimit,
      ) as T;
    }

    return TextBoxModel(
      value: model.value?.raw,
      hint: model.defaultValue?.raw,
      readonly: readonly,
      labelText: model.unit.itemName,
      valueUnfocused: model.value?.alt ?? model.value?.raw,
      hintUnfocused: model.defaultValue?.alt ?? model.defaultValue?.raw,
      valueType: model.valueType,
    ) as T;
  }

  static T _ofParamValue<T extends InputBoxModel>(
    ConversionParamValueModel model, {
    bool readonly = false,
  }) {
    if (model.listValues?.items != null && model.listValues!.items.isNotEmpty) {
      return ListBoxModel(
        value: model.value?.toListValueModel(),
        listValues: model.listValues!.items,
        listType: model.listType!,
        labelText: model.param.name,
        readonly: readonly,
        searchEnabled: model.listValues!.items.length >
            InputBoxConstants.nonSearchableListItemsMinLimit,
      ) as T;
    }

    return TextBoxModel(
      value: model.value?.raw,
      hint: model.defaultValue?.raw,
      readonly: readonly,
      valueUnfocused: model.value?.alt ?? model.value?.raw,
      hintUnfocused: model.defaultValue?.alt ?? model.defaultValue?.raw,
      labelText: model.param.name,
      valueType: model.valueType,
    ) as T;
  }
}
