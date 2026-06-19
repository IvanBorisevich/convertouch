import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/domain/model/value_model.dart';

const int _nonSearchableListItemsMinLimit = 5;

abstract class InputBoxViewModel {
  final String? itemId;
  final ValueModel? value;
  final String? labelText;
  final bool readonly;

  const InputBoxViewModel({
    this.itemId,
    this.value,
    this.labelText,
    this.readonly = false,
  });

  static T ofValue<T extends InputBoxViewModel, M extends ItemValueModel>(
    M model, {
    String? labelText,
    bool readonly = false,
    int? maxTextLength,
    bool textLengthCounterVisible = false,
  }) {
    if (model.listType != null) {
      return ListBoxViewModel(
        itemId: model.id,
        value: model.value,
        listValuesFetchResult: model.listValuesFetchResult,
        listType: model.listType!,
        readonly: !model.listType!.fetchedViaApi &&
            (model.listValuesFetchResult?.items == null ||
                model.listValuesFetchResult!.items.isEmpty),
        labelText: labelText ?? model.name,
        searchEnabled: model.listValuesFetchResult?.items != null &&
            model.listValuesFetchResult!.items.length >
                _nonSearchableListItemsMinLimit,
      ) as T;
    } else {
      return TextBoxViewModel(
        itemId: model.id,
        value: model.value,
        hint: model.defaultValue,
        readonly: readonly,
        labelText: labelText ?? model.name,
        valueType: model.valueType,
        maxTextLength: maxTextLength,
        textLengthCounterVisible: textLengthCounterVisible,
      ) as T;
    }
  }
}

class TextBoxViewModel extends InputBoxViewModel {
  final ValueModel? hint;
  final ConvertouchValueType valueType;
  final int? maxTextLength;
  final bool textLengthCounterVisible;

  const TextBoxViewModel({
    super.itemId,
    super.value,
    this.hint,
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
        'hint: $hint, '
        'readonly: $readonly, '
        'labelText: $labelText, '
        'valueType: $valueType, '
        'maxTextLength: $maxTextLength, '
        'textLengthCounterVisible: $textLengthCounterVisible}';
  }
}

class ListBoxViewModel extends InputBoxViewModel {
  final ListValuesFetchResult? listValuesFetchResult;
  final ConvertouchListType listType;
  final String? searchHint;
  final bool searchEnabled;

  const ListBoxViewModel({
    super.itemId,
    super.value,
    required this.listType,
    super.readonly,
    super.labelText,
    required this.listValuesFetchResult,
    this.searchHint,
    this.searchEnabled = true,
  });

  @override
  String toString() {
    return 'ListBoxModel{'
        'labelText: $labelText, '
        'readonly: $readonly, '
        'listValue: $value, '
        'listValuesFetchResult: $listValuesFetchResult, '
        'listType: $listType, '
        'searchHint: $searchHint, '
        'searchEnabled: $searchEnabled}';
  }
}
