import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/repositories/conversion_repository.dart';
import 'package:either_dart/either.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConversionRepositoryImpl extends ConversionRepository {
  const ConversionRepositoryImpl();

  @override
  Future<Either<Failure, ConversionModel>> fetchLastConversion() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      int? sourceUnitId = prefs.getInt(sourceUnitIdKey);
      String? sourceValue = prefs.getString(sourceValueKey);
      List<int>? targetUnitIds = prefs
          .getStringList(targetUnitIdsKey)
          ?.map((str) => int.parse(str))
          .toList();
      int? conversionUnitGroupId = prefs.getInt(conversionUnitGroupIdKey);

      return Right(
        ConversionModel(
          sourceUnitId: sourceUnitId,
          sourceValue: sourceValue,
          targetUnitIds: targetUnitIds,
          conversionUnitGroupId: conversionUnitGroupId,
        ),
      );
    } catch (e) {
      return Left(
        InternalFailure(
          "Error when fetching conversion properties: $e",
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> saveConversion(
    ConversionModel conversion,
  ) async {
    try {
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
      return const Right(null);
    } catch (e) {
      return Left(
        InternalFailure("Error when saving conversion properties: $e"),
      );
    }
  }
}
