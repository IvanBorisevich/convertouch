import 'package:collection/collection.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';

abstract class Criterion {
  const Criterion();

  bool matches(ConversionParamSetValueModel params);
}

class MappingRow<T extends Criterion, K> {
  final T criterion;
  final Map<K, dynamic> row;

  const MappingRow({
    required this.criterion,
    required this.row,
  });

  Map<String, String>? transform(String Function(K)? key) {
    var result = row.map(
      (k, v) => MapEntry(
        key?.call(k) ?? k.toString(),
        v != null ? v.toString() : "",
      ),
    );

    result.removeWhere((k, v) => v.isEmpty);
    return result;
  }
}

class MappingTable<T extends Criterion, K> {
  final List<MappingRow<T, K>> rows;
  final String Function(K)? unitCodeByKey;
  final K Function(String)? keyByUnitCode;

  const MappingTable({
    required this.rows,
    this.unitCodeByKey,
    this.keyByUnitCode,
  });

  Map<String, String>? getRowByParams(ConversionParamSetValueModel params) {
    if (rows.isEmpty) {
      return null;
    }

    return rows
        .firstWhereOrNull((row) => row.criterion.matches(params))
        ?.transform(unitCodeByKey);
  }

  T? getCriterionByValue(ValueModel? value, UnitModel unit) {
    return _getTableRowByValue(value, unit)?.criterion;
  }

  Map<String, String>? getMappingByValue(ValueModel? value, UnitModel unit) {
    return _getTableRowByValue(value, unit)?.transform(unitCodeByKey);
  }

  MappingRow<T, K>? _getTableRowByValue(ValueModel? value, UnitModel unit) {
    if (rows.isEmpty) {
      return null;
    }

    K codeKey = keyByUnitCode?.call(unit.code) ?? (unit.code as K);

    return rows.firstWhereOrNull((row) =>
        row.row[codeKey] == value?.numVal || row.row[codeKey] == value?.raw);
  }
}
