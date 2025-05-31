import 'package:floor/floor.dart';

const forUpdate = 'FOR_UPDATE';

abstract class ConvertouchEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  const ConvertouchEntity({
    this.id,
  });

  Map<String, dynamic> toRow();
}

int? bool2int(bool? value, {int? ifNull}) {
  return value != null ? (value ? 1 : 0) : ifNull;
}

bool int2bool(int? value, {bool ifNull = false}) {
  return value != null ? value == 1 : ifNull;
}

Map<String, dynamic> minify(
  Map<String, dynamic> row, {
  List<String> excludedColumns = const [],
}) {
  var result = Map.from(row);
  result.removeWhere((k, v) => excludedColumns.contains(k) || v == null);
  return result.map(
    (k, v) => MapEntry(k, ['', -1].contains(v) ? null : v),
  );
}
