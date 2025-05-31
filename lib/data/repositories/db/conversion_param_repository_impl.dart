import 'package:collection/collection.dart';
import 'package:convertouch/data/dao/conversion_param_dao.dart';
import 'package:convertouch/data/dao/unit_dao.dart';
import 'package:convertouch/data/translators/conversion_param_translator.dart';
import 'package:convertouch/data/translators/unit_translator.dart';
import 'package:convertouch/domain/model/conversion_param_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/repositories/conversion_param_repository.dart';
import 'package:either_dart/either.dart';

class ConversionParamRepositoryImpl extends ConversionParamRepository {
  final ConversionParamDao conversionParamDao;
  final UnitDao unitDao;

  const ConversionParamRepositoryImpl({
    required this.conversionParamDao,
    required this.unitDao,
  });

  @override
  Future<Either<ConvertouchException, List<ConversionParamModel>>> get(
    int setId,
  ) async {
    try {
      final params = await conversionParamDao.get(setId);
      final paramDefaultUnitIds =
          params.map((p) => p.defaultUnitId).nonNulls.toList();
      final defaultUnits = await unitDao.getUnitsByIds(paramDefaultUnitIds);

      return Right(
        params.map((paramEntity) {
          var param = ConversionParamTranslator.I.toModel(paramEntity);

          if (paramEntity.defaultUnitId != null) {
            final defaultUnitEntity = defaultUnits
                .firstWhereOrNull((u) => u.id == paramEntity.defaultUnitId);

            return param.copyWith(
              defaultUnit: defaultUnitEntity != null
                  ? UnitTranslator.I.toModel(defaultUnitEntity)
                  : null,
            );
          }

          return param;
        }).toList(),
      );
    } catch (e, stackTrace) {
      return Left(
        DatabaseException(
          message: "Error when fetching conversion params by set id = "
              "$setId",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }
}
