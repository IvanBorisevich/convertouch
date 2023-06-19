import 'package:convertouch/model/entity/unit_model.dart';

class UnitValueModel {
  UnitValueModel(this._unit, this._value);

  final UnitModel _unit;
  final String _value;

  UnitModel get unit => _unit;

  String get value => _value;
}