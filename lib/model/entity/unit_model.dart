import 'package:convertouch/model/entity/id_name_model.dart';

class UnitModel extends IdNameModel {
  UnitModel(super.id, super.name, this._abbreviation);

  final String _abbreviation;

  String get abbreviation {
    return _abbreviation;
  }
}