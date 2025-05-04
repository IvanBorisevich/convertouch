import 'package:collection/collection.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/model/value_range.dart';

Map<String, String>? getClothingSizesMap(ConversionParamSetValueModel params) {
  Gender? gender = Gender.valueOf(params.getValue(ParamNames.gender)?.raw);
  Garment? garment = Garment.valueOf(params.getValue(ParamNames.garment)?.raw);
  var heightParam = params.getParam(ParamNames.height);
  ValueModel? height = heightParam?.value ?? heightParam?.defaultValue;

  if (gender == null || garment == null || height == null) {
    return null;
  }

  var normalizedHeight = height.numVal! * heightParam!.unit!.coefficient!;
  var sizeMaps = clothingSizes[gender]?[garment] ?? [];

  if (sizeMaps.isEmpty) {
    return null;
  }

  return sizeMaps
      .firstWhereOrNull(
          (m) => m.height.contains(normalizedHeight, includeLeft: false))
      ?.sizeMap
      .map((k, v) =>
          MapEntry(k.name, k != CountryCode.inter ? v.toString() : v));
}

enum Gender {
  male("Male"),
  female("Female");

  final String name;

  const Gender(this.name);

  static Gender? valueOf(String? name) {
    return values.firstWhereOrNull((element) => name == element.name);
  }
}

enum Garment {
  shirt("Shirt"),
  trousers("Trousers");

  final String name;

  const Garment(this.name);

  static Garment? valueOf(String? name) {
    return values.firstWhereOrNull((element) => name == element.name);
  }
}

class MappingRow {
  final NumValueRange height;
  final Map<CountryCode, dynamic> sizeMap;

  const MappingRow({
    required this.height,
    required this.sizeMap,
  });
}

const Map<Gender, Map<Garment, List<MappingRow>>> clothingSizes = {
  Gender.male: {
    Garment.shirt: [
      MappingRow(
        height: NumValueRange(0, 1.6),
        sizeMap: {
          CountryCode.inter: "XXS",
          CountryCode.ru: 38,
          CountryCode.eu: 32,
          CountryCode.uk: 4,
          CountryCode.us: 0,
          CountryCode.it: 36,
          CountryCode.fr: 30,
          CountryCode.jp: 3,
        },
      ),
      MappingRow(
        height: NumValueRange(1.6, 1.7),
        sizeMap: {
          CountryCode.inter: "XS",
          CountryCode.ru: 40,
          CountryCode.eu: 34,
          CountryCode.uk: 6,
          CountryCode.us: 2,
          CountryCode.it: 38,
          CountryCode.fr: 34,
          CountryCode.jp: 7,
        },
      ),
    ]
  },
};
