import 'package:collection/collection.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/utils/mapping_table.dart';

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

Map<String, String>? getClothingSizesMap(ConversionParamSetValueModel params) {
  Gender? gender = Gender.valueOf(params.getValue(ParamNames.gender)?.raw);
  Garment? garment = Garment.valueOf(params.getValue(ParamNames.garment)?.raw);

  return _clothingSizes[gender]?[garment]?.getRowByParams(
    params,
    filter: (params, criterion) {
      var heightParam = params.getParam(ParamNames.height);

      if (heightParam == null || heightParam.unit?.coefficient == null) {
        return false;
      }

      ValueModel? height = heightParam.value ?? heightParam.defaultValue;
      double? normalizedHeight = height != null
          ? height.numVal! * heightParam.unit!.coefficient!
          : null;

      return criterion.contains(normalizedHeight, includeLeft: false);
    },
  );
}

const Map<Gender, Map<Garment, MappingTable<NumRangeCriterion, CountryCode>>>
    _clothingSizes = {
  Gender.male: {
    Garment.shirt: MappingTable(
      unitCodeByKey: CountryCode.nameOf,
      keyByUnitCode: CountryCode.valueOf,
      rows: [
        MappingRow(
          criterion: NumRangeCriterion(0, 1.6),
          row: {
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
          criterion: NumRangeCriterion(1.6, 1.7),
          row: {
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
      ],
    )
  },
};
