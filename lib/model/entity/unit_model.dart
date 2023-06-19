import 'package:convertouch/model/entity/item_model.dart';
import 'package:convertouch/model/item_type.dart';

class UnitModel extends ItemModel {
  const UnitModel(
      int id,
      String name,
      String abbreviation
      ) :
        _abbreviation = abbreviation,
        super(id, name, ItemType.unit);

  final String _abbreviation;

  String get abbreviation => _abbreviation;
}
