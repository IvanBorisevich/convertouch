import 'package:convertouch/domain/model/conversion_model.dart';

abstract class ConversionDao {
  const ConversionDao();

  Future<ConversionModel> fetchConversion();

  Future<void> saveConversion(ConversionModel conversion);
}