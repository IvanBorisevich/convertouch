import 'package:convertouch/data/dao/conversion_dao.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String sourceUnitIdKey = 'sourceUnitId';
const String sourceValueKey = 'sourceValue';
const String targetUnitIdsKey = 'targetUnitIds';
const String conversionUnitGroupIdKey = 'conversionUnitGroupId';

class ConversionDaoImpl extends ConversionDao {
  const ConversionDaoImpl();

  @override
  Future<ConversionModel> fetchConversion() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int? sourceUnitId = prefs.getInt(sourceUnitIdKey);
    String? sourceValue = prefs.getString(sourceValueKey);
    List<int>? targetUnitIds = prefs
        .getStringList(targetUnitIdsKey)
        ?.map((str) => int.parse(str))
        .toList();
    int? conversionUnitGroupId = prefs.getInt(conversionUnitGroupIdKey);

    return Future.sync(
      () => ConversionModel(
        sourceUnitId: sourceUnitId,
        sourceValue: sourceValue,
        targetUnitIds: targetUnitIds,
        conversionUnitGroupId: conversionUnitGroupId,
      ),
    );
  }

  @override
  Future<void> saveConversion(ConversionModel conversion) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (conversion.sourceUnitId != null) {
      prefs.setInt(
        sourceUnitIdKey,
        conversion.sourceUnitId!,
      );
    }

    if (conversion.sourceValue != null) {
      prefs.setString(
        sourceValueKey,
        conversion.sourceValue!,
      );
    }

    if (conversion.targetUnitIds != null) {
      prefs.setStringList(
        targetUnitIdsKey,
        conversion.targetUnitIds!.map((id) => id.toString()).toList(),
      );
    }

    if (conversion.conversionUnitGroupId != null) {
      prefs.setInt(
        conversionUnitGroupIdKey,
        conversion.conversionUnitGroupId!,
      );
    }
  }
}
