import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';

class CronModel extends IdNameItemModel {
  final String expression;

  const CronModel({
    super.id,
    required super.name,
    required this.expression,
    super.itemType = ItemType.cron,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    expression,
    itemType,
  ];

  @override
  String toString() {
    return 'CronModel{'
        'id: $id, '
        'name: $name, '
        'expression: $expression}';
  }
}