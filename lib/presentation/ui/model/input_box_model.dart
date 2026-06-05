import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/presentation/ui/model/element_model.dart';
import 'package:rxdart/rxdart.dart';

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
        selectedValue: model.value,
        listValuesBatchStream: model.listValuesBatchStream,
        listType: model.listType!,
        readonly: model.listValuesFetchResult?.items == null ||
            model.listValuesFetchResult!.items.isEmpty,
        labelText: _getLabelText(model),
        searchEnabled: model.listValuesFetchResult!.items.length >
            _nonSearchableListItemsMinLimit,
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

class TextBoxModel extends InputBoxModel {
  static const TextBoxModel empty = TextBoxModel();

  final String? value;
  final String? valueUnfocused;
  final String? hintUnfocused;
  final ConvertouchValueType valueType;
  final int? maxTextLength;
  final bool textLengthCounterVisible;

  const TextBoxModel({
    this.value,
    this.valueUnfocused,
    super.hint,
    this.hintUnfocused,
    super.readonly,
    super.labelText,
    this.valueType = ConvertouchValueType.text,
    this.maxTextLength,
    this.textLengthCounterVisible = false,
  });

  @override
  String toString() {
    return 'TextBoxModel{'
        'value: $value, '
        'valueUnfocused: $valueUnfocused, '
        'hint: $hint, '
        'hintUnfocused: $hintUnfocused, '
        'readonly: $readonly, '
        'labelText: $labelText, '
        'valueType: $valueType, '
        'maxTextLength: $maxTextLength, '
        'textLengthCounterVisible: $textLengthCounterVisible}';
  }
}

class ListBoxModel extends InputBoxModel {
  final ValueModel? selectedValue;
  final BehaviorSubject<ListValuesFetchResult?> listValuesBatchStream;
  final ConvertouchListType listType;
  final String? searchHint;
  final bool searchEnabled;

  const ListBoxModel({
    this.selectedValue,
    required this.listType,
    super.readonly,
    super.labelText,
    required this.listValuesBatchStream,
    this.searchHint,
    this.searchEnabled = true,
  });

  @override
  String toString() {
    return 'ListBoxModel{'
        'labelText: $labelText, '
        'readonly: $readonly, '
        'listValue: $selectedValue, '
        'listValuesBatchStream: $listValuesBatchStream, '
        'listType: $listType, '
        'searchHint: $searchHint, '
        'searchEnabled: $searchEnabled}';
  }
}
