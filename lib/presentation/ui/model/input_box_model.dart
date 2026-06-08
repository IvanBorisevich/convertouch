import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/presentation/ui/model/element_model.dart';
import 'package:rxdart/rxdart.dart';

const int _nonSearchableListItemsMinLimit = 5;

abstract class InputBoxModel implements ElementModel {
  final String? itemId;
  final BehaviorSubject<ValueModel?> valueStream;
  final String? labelText;
  final bool readonly;

  const InputBoxModel({
    this.itemId,
    required this.valueStream,
    this.labelText,
    this.readonly = false,
  });

  static T ofValue<T extends InputBoxModel, M extends ConversionItemValueModel>(
    M model, {
    bool readonly = false,
  }) {
    if (model.listType != null) {
      return ListBoxModel(
        itemId: model.itemId,
        valueStream: model.valueStream,
        listValuesBatchStream: model.listValuesBatchStream,
        listType: model.listType!,
        readonly: !model.listType!.fetchedViaApi &&
            (model.listValuesFetchResult?.items == null ||
                model.listValuesFetchResult!.items.isEmpty),
        labelText: _getLabelText(model),
        searchEnabled: model.listValuesFetchResult?.items != null &&
            model.listValuesFetchResult!.items.length >
                _nonSearchableListItemsMinLimit,
      ) as T;
    } else {
      return TextBoxModel(
        itemId: model.itemId,
        valueStream: model.valueStream,
        hintStream: model.defaultValueStream,
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
  final BehaviorSubject<ValueModel?> hintStream;
  final ConvertouchValueType valueType;
  final int? maxTextLength;
  final bool textLengthCounterVisible;

  const TextBoxModel({
    super.itemId,
    required super.valueStream,
    required this.hintStream,
    super.readonly,
    super.labelText,
    this.valueType = ConvertouchValueType.text,
    this.maxTextLength,
    this.textLengthCounterVisible = false,
  });

  @override
  String toString() {
    return 'TextBoxModel{'
        'value: ${valueStream.valueOrNull}, '
        'hint: ${hintStream.valueOrNull}, '
        'readonly: $readonly, '
        'labelText: $labelText, '
        'valueType: $valueType, '
        'maxTextLength: $maxTextLength, '
        'textLengthCounterVisible: $textLengthCounterVisible}';
  }
}

class ListBoxModel extends InputBoxModel {
  final BehaviorSubject<ListValuesFetchResult?> listValuesBatchStream;
  final ConvertouchListType listType;
  final String? searchHint;
  final bool searchEnabled;

  const ListBoxModel({
    super.itemId,
    required super.valueStream,
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
        'listValue: ${valueStream.valueOrNull}, '
        'listValuesBatchStream: $listValuesBatchStream, '
        'listType: $listType, '
        'searchHint: $searchHint, '
        'searchEnabled: $searchEnabled}';
  }
}
