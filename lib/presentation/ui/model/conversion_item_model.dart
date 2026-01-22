import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/presentation/ui/model/element_model.dart';
import 'package:convertouch/presentation/ui/model/input_box_model.dart';

class ConversionItemModel<M extends InputBoxModel> implements ElementModel {
  final M inputBoxModel;
  final UnitModel? unit;
  final int? index;
  final bool draggable;
  final bool removable;
  final bool isSource;
  final bool isLast;

  const ConversionItemModel({
    required this.inputBoxModel,
    this.unit,
    this.index,
    this.draggable = true,
    this.removable = true,
    this.isSource = false,
    this.isLast = false,
  });
}
