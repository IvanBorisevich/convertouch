import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/presentation/ui/model/element_model.dart';
import 'package:convertouch/presentation/ui/model/input_box_model.dart';

class ConversionItemModel<M extends InputBoxModel> implements ElementModel {
  final M inputBoxModel;
  final double? min;
  final double? max;
  final UnitModel? unit;
  final int? index;
  final bool draggable;
  final bool removable;
  final bool isSource;
  final bool isLast;

  const ConversionItemModel({
    required this.inputBoxModel,
    this.min,
    this.max,
    this.unit,
    this.index,
    this.draggable = true,
    this.removable = true,
    this.isSource = false,
    this.isLast = false,
  });

  static ConversionItemModel<T>
      ofValue<T extends InputBoxModel, M extends ConversionItemValueModel>(
    M model, {
    bool readonly = false,
    int? index,
    bool draggable = false,
    bool removable = false,
    bool isSource = false,
    bool isLast = false,
  }) {
    return ConversionItemModel(
      inputBoxModel: InputBoxModel.ofValue(model, readonly: readonly),
      unit: model.unitItem,
      min: model.min,
      max: model.max,
      index: index,
      draggable: draggable,
      removable: removable,
      isSource: isSource,
      isLast: isLast,
    );
  }
}
