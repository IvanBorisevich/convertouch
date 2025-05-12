import 'package:collection/collection.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';

abstract interface class Criterion {
  const Criterion();
}

class NumRangeCriterion extends Criterion {
  final num left;
  final num right;

  const NumRangeCriterion(this.left, this.right);

  bool contains(
    num? value, {
    bool includeLeft = true,
    bool includeRight = true,
  }) {
    if (value == null) {
      return false;
    }

    bool isMoreThanLeft = includeLeft ? left <= value : left < value;
    bool isLessThanRight = includeRight ? right >= value : right > value;
    return isMoreThanLeft && isLessThanRight;
  }
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

  Map<String, String>? getRowByParams(
    ConversionParamSetValueModel params, {
    required bool Function(ConversionParamSetValueModel, T) filter,
  }) {
    if (rows.isEmpty) {
      return null;
    }

    return rows
        .firstWhereOrNull((row) => filter.call(params, row.criterion))
        ?.transform(unitCodeByKey);
  }

  T? getCriterionByValue(ConversionUnitValueModel value) {
    return _getTableRowByValue(value)?.criterion;
  }

  Map<String, String>? getMappingByValue(ConversionUnitValueModel value) {
    return _getTableRowByValue(value)?.transform(unitCodeByKey);
  }

  MappingRow<T, K>? _getTableRowByValue(ConversionUnitValueModel value) {
    if (rows.isEmpty) {
      return null;
    }

    K codeKey = keyByUnitCode?.call(value.unit.code) ?? (value.unit.code as K);

    return rows.firstWhereOrNull((row) =>
        row.row[codeKey] == value.numVal || row.row[codeKey] == value.raw);
  }
}
