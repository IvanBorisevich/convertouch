import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/presentation/ui/model/element_model.dart';
import 'package:convertouch/presentation/ui/model/list_box_model.dart';
import 'package:convertouch/presentation/ui/model/text_box_model.dart';

abstract class InputBoxModel implements ElementModel {
  final String labelText;
  final bool readonly;

  const InputBoxModel({
    this.labelText = '',
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
        readonly: readonly,
        labelText: model.unit.itemName,
      ) as T;
    }

    return TextBoxModel(
      value: model.value?.raw,
      hint: model.defaultValue?.raw,
      readonly: readonly,
      labelText: model.unit.itemName,
      unfocusedValue: model.value?.alt,
      unfocusedHint: model.defaultValue?.alt,
      initialType: model.valueType,
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
        labelText: model.param.name,
        readonly: readonly,
      ) as T;
    }

    return TextBoxModel(
      value: model.value?.raw,
      hint: model.defaultValue?.raw,
      readonly: readonly,
      unfocusedValue: model.value?.alt,
      unfocusedHint: model.defaultValue?.alt,
      labelText: model.param.name,
      initialType: model.valueType,
    ) as T;
  }
}
