import 'package:collection/collection.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/num_range.dart';
import 'package:convertouch/domain/utils/mapping_table.dart';

const int _cmInMeter = 100;

enum Person {
  man("Man"),
  woman("Woman");

  final String name;

  const Person(this.name);

  static Person? valueOf(String? name) {
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

class ClothingSizeCriterion extends Criterion {
  final NumRange heightCmRange;
  final NumRange? waistCmRange;

  const ClothingSizeCriterion({
    required this.heightCmRange,
    this.waistCmRange,
  });

  @override
  bool matches(ConversionParamSetValueModel params) {
    var heightParam = params.getParam(ParamNames.height);

    if (heightParam == null ||
        heightParam.unit?.coefficient == null ||
        heightParam.numVal == null) {
      return false;
    }

    double normalizedHeight =
        heightParam.numVal! * heightParam.unit!.coefficient! * _cmInMeter;
    bool heightMatches =
        heightCmRange.contains(normalizedHeight, includeLeft: false);

    var waistParam = params.getParam(ParamNames.waist);
    bool waistMatches = waistCmRange == null ||
        waistCmRange!.contains(waistParam?.numVal, includeLeft: false);

    return heightMatches && waistMatches;
  }
}

Map<String, String>? getClothingSizesMap(ConversionParamSetValueModel params) {
  Person? person = Person.valueOf(params.getValue(ParamNames.person)?.raw);
  Garment? garment = Garment.valueOf(params.getValue(ParamNames.garment)?.raw);

  return _clothingSizes[person]?[garment]?.getRowByParams(params);
}

const Map<Person,
        Map<Garment, MappingTable<ClothingSizeCriterion, CountryCode>>>
    _clothingSizes = {
  Person.man: {
    Garment.shirt: MappingTable(
      unitCodeByKey: CountryCode.nameOf,
      keyByUnitCode: CountryCode.valueOf,
      rows: [
        MappingRow(
          criterion: ClothingSizeCriterion(
            heightCmRange: NumRange(0, 164),
            waistCmRange: NumRange(0, 74),
          ),
          row: {
            CountryCode.inter: "XXS",
            CountryCode.ru: 42,
            CountryCode.eu: 42,
            CountryCode.uk: 26,
            CountryCode.us: 28,
            CountryCode.it: 42,
            CountryCode.fr: 34,
            CountryCode.es: 34,
            CountryCode.de: 40,
            CountryCode.jp: "S",
          },
        ),
        MappingRow(
          criterion: ClothingSizeCriterion(
            heightCmRange: NumRange(164, 170),
            waistCmRange: NumRange(74, 78),
          ),
          row: {
            CountryCode.inter: "XS",
            CountryCode.ru: 44,
            CountryCode.eu: 44,
            CountryCode.uk: 28,
            CountryCode.us: 30,
            CountryCode.it: 44,
            CountryCode.fr: 36,
            CountryCode.es: 36,
            CountryCode.de: 42,
            CountryCode.jp: "M",
          },
        ),
        MappingRow(
          criterion: ClothingSizeCriterion(
            heightCmRange: NumRange(170, 176),
            waistCmRange: NumRange(78, 82),
          ),
          row: {
            CountryCode.inter: "S",
            CountryCode.ru: 46,
            CountryCode.eu: 46,
            CountryCode.uk: 30,
            CountryCode.us: 32,
            CountryCode.it: 46,
            CountryCode.fr: 38,
            CountryCode.es: 38,
            CountryCode.de: 44,
            CountryCode.jp: "L",
          },
        ),
        MappingRow(
          criterion: ClothingSizeCriterion(
            heightCmRange: NumRange(174, 180),
            waistCmRange: NumRange(82, 86),
          ),
          row: {
            CountryCode.inter: "M",
            CountryCode.ru: 48,
            CountryCode.eu: 48,
            CountryCode.uk: 32,
            CountryCode.us: 34,
            CountryCode.it: 48,
            CountryCode.fr: 40,
            CountryCode.es: 40,
            CountryCode.de: 46,
            CountryCode.jp: "LL",
          },
        ),
        MappingRow(
          criterion: ClothingSizeCriterion(
            heightCmRange: NumRange(178, 184),
            waistCmRange: NumRange(86, 90),
          ),
          row: {
            CountryCode.inter: "L",
            CountryCode.ru: 50,
            CountryCode.eu: 50,
            CountryCode.uk: 34,
            CountryCode.us: 36,
            CountryCode.it: 50,
            CountryCode.fr: 42,
            CountryCode.es: 42,
            CountryCode.de: 48,
            CountryCode.jp: "3L",
          },
        ),
        MappingRow(
          criterion: ClothingSizeCriterion(
            heightCmRange: NumRange(182, 188),
            waistCmRange: NumRange(90, 94),
          ),
          row: {
            CountryCode.inter: "XL",
            CountryCode.ru: 52,
            CountryCode.eu: 52,
            CountryCode.uk: 36,
            CountryCode.us: 38,
            CountryCode.it: 52,
            CountryCode.fr: 44,
            CountryCode.es: 44,
            CountryCode.de: 50,
            CountryCode.jp: "4L",
          },
        ),
        MappingRow(
          criterion: ClothingSizeCriterion(
            heightCmRange: NumRange(186, 192),
            waistCmRange: NumRange(94, 98),
          ),
          row: {
            CountryCode.inter: "XXL",
            CountryCode.ru: 54,
            CountryCode.eu: 54,
            CountryCode.uk: 38,
            CountryCode.us: 40,
            CountryCode.it: 54,
            CountryCode.fr: 46,
            CountryCode.es: 46,
            CountryCode.de: 52,
            CountryCode.jp: "5L",
          },
        ),
        MappingRow(
          criterion: ClothingSizeCriterion(
            heightCmRange: NumRange(190, double.infinity),
            waistCmRange: NumRange(98, double.infinity),
          ),
          row: {
            CountryCode.inter: "3XL",
            CountryCode.ru: 56,
            CountryCode.eu: 56,
            CountryCode.uk: 40,
            CountryCode.us: 42,
            CountryCode.it: 56,
            CountryCode.fr: 48,
            CountryCode.es: 48,
            CountryCode.de: 54,
            CountryCode.jp: "6L",
          },
        ),
      ],
    ),
    Garment.trousers: MappingTable(
      unitCodeByKey: CountryCode.nameOf,
      keyByUnitCode: CountryCode.valueOf,
      rows: [
        MappingRow(
          criterion: ClothingSizeCriterion(
            heightCmRange: NumRange(0, 164),
            waistCmRange: NumRange(0, 74),
          ),
          row: {
            CountryCode.inter: "XS",
            CountryCode.ru: 44,
            CountryCode.eu: 44,
            CountryCode.uk: 28,
            CountryCode.us: 28,
            CountryCode.it: 44,
            CountryCode.fr: 36,
            CountryCode.es: 36,
            CountryCode.de: 44,
            CountryCode.jp: "S",
          },
        ),
        MappingRow(
          criterion: ClothingSizeCriterion(
            heightCmRange: NumRange(164, 170),
            waistCmRange: NumRange(74, 78),
          ),
          row: {
            CountryCode.inter: "S",
            CountryCode.ru: 46,
            CountryCode.eu: 46,
            CountryCode.uk: 30,
            CountryCode.us: 30,
            CountryCode.it: 46,
            CountryCode.fr: 38,
            CountryCode.es: 38,
            CountryCode.de: 46,
            CountryCode.jp: "M",
          },
        ),
        MappingRow(
          criterion: ClothingSizeCriterion(
            heightCmRange: NumRange(170, 176),
            waistCmRange: NumRange(78, 82),
          ),
          row: {
            CountryCode.inter: "M",
            CountryCode.ru: 48,
            CountryCode.eu: 48,
            CountryCode.uk: 32,
            CountryCode.us: 32,
            CountryCode.it: 48,
            CountryCode.fr: 40,
            CountryCode.es: 40,
            CountryCode.de: 48,
            CountryCode.jp: "L",
          },
        ),
        MappingRow(
          criterion: ClothingSizeCriterion(
            heightCmRange: NumRange(176, 182),
            waistCmRange: NumRange(82, 86),
          ),
          row: {
            CountryCode.inter: "L",
            CountryCode.ru: 50,
            CountryCode.eu: 50,
            CountryCode.uk: 34,
            CountryCode.us: 34,
            CountryCode.it: 50,
            CountryCode.fr: 42,
            CountryCode.es: 42,
            CountryCode.de: 50,
            CountryCode.jp: "LL",
          },
        ),
        MappingRow(
          criterion: ClothingSizeCriterion(
            heightCmRange: NumRange(180, 186),
            waistCmRange: NumRange(86, 90),
          ),
          row: {
            CountryCode.inter: "XL",
            CountryCode.ru: 52,
            CountryCode.eu: 52,
            CountryCode.uk: 36,
            CountryCode.us: 36,
            CountryCode.it: 52,
            CountryCode.fr: 44,
            CountryCode.es: 44,
            CountryCode.de: 52,
            CountryCode.jp: "3L",
          },
        ),
        MappingRow(
          criterion: ClothingSizeCriterion(
            heightCmRange: NumRange(184, 190),
            waistCmRange: NumRange(90, 94),
          ),
          row: {
            CountryCode.inter: "XXL",
            CountryCode.ru: 54,
            CountryCode.eu: 54,
            CountryCode.uk: 38,
            CountryCode.us: 38,
            CountryCode.it: 54,
            CountryCode.fr: 46,
            CountryCode.es: 46,
            CountryCode.de: 54,
            CountryCode.jp: "4L",
          },
        ),
        MappingRow(
          criterion: ClothingSizeCriterion(
            heightCmRange: NumRange(188, double.infinity),
            waistCmRange: NumRange(94, double.infinity),
          ),
          row: {
            CountryCode.inter: "3XL",
            CountryCode.ru: 56,
            CountryCode.eu: 56,
            CountryCode.uk: 40,
            CountryCode.us: 40,
            CountryCode.it: 56,
            CountryCode.fr: 48,
            CountryCode.es: 48,
            CountryCode.de: 56,
            CountryCode.jp: "5L",
          },
        ),
      ],
    ),
  },
  Person.woman: {
    Garment.shirt: MappingTable(
      unitCodeByKey: CountryCode.nameOf,
      keyByUnitCode: CountryCode.valueOf,
      rows: [
        MappingRow(
          criterion: ClothingSizeCriterion(
            heightCmRange: NumRange(0, 156),
            waistCmRange: NumRange(58, 62),
          ),
          row: {
            CountryCode.inter: "XXS",
            CountryCode.ru: 40,
            CountryCode.eu: 34,
            CountryCode.uk: 6,
            CountryCode.us: 2,
            CountryCode.it: 38,
            CountryCode.fr: 34,
            CountryCode.es: 34,
            CountryCode.de: 32,
            CountryCode.jp: "S",
          },
        ),
        MappingRow(
          criterion: ClothingSizeCriterion(
            heightCmRange: NumRange(156, 162),
            waistCmRange: NumRange(62, 66),
          ),
          row: {
            CountryCode.inter: "XS",
            CountryCode.ru: 42,
            CountryCode.eu: 36,
            CountryCode.uk: 8,
            CountryCode.us: 4,
            CountryCode.it: 40,
            CountryCode.fr: 36,
            CountryCode.es: 36,
            CountryCode.de: 34,
            CountryCode.jp: "M",
          },
        ),
        MappingRow(
          criterion: ClothingSizeCriterion(
            heightCmRange: NumRange(162, 168),
            waistCmRange: NumRange(66, 70),
          ),
          row: {
            CountryCode.inter: "S",
            CountryCode.ru: 44,
            CountryCode.eu: 38,
            CountryCode.uk: 10,
            CountryCode.us: 6,
            CountryCode.it: 42,
            CountryCode.fr: 38,
            CountryCode.es: 38,
            CountryCode.de: 36,
            CountryCode.jp: "L",
          },
        ),
        MappingRow(
          criterion: ClothingSizeCriterion(
            heightCmRange: NumRange(168, 174),
            waistCmRange: NumRange(70, 74),
          ),
          row: {
            CountryCode.inter: "M",
            CountryCode.ru: 46,
            CountryCode.eu: 40,
            CountryCode.uk: 12,
            CountryCode.us: 8,
            CountryCode.it: 44,
            CountryCode.fr: 40,
            CountryCode.es: 40,
            CountryCode.de: 38,
            CountryCode.jp: "LL",
          },
        ),
        MappingRow(
          criterion: ClothingSizeCriterion(
            heightCmRange: NumRange(174, 180),
            waistCmRange: NumRange(74, 78),
          ),
          row: {
            CountryCode.inter: "L",
            CountryCode.ru: 48,
            CountryCode.eu: 42,
            CountryCode.uk: 14,
            CountryCode.us: 10,
            CountryCode.it: 46,
            CountryCode.fr: 42,
            CountryCode.es: 42,
            CountryCode.de: 40,
            CountryCode.jp: "3L",
          },
        ),
        MappingRow(
          criterion: ClothingSizeCriterion(
            heightCmRange: NumRange(180, 186),
            waistCmRange: NumRange(78, 82),
          ),
          row: {
            CountryCode.inter: "XL",
            CountryCode.ru: 50,
            CountryCode.eu: 44,
            CountryCode.uk: 16,
            CountryCode.us: 12,
            CountryCode.it: 48,
            CountryCode.fr: 44,
            CountryCode.es: 44,
            CountryCode.de: 42,
            CountryCode.jp: "4L",
          },
        ),
        MappingRow(
          criterion: ClothingSizeCriterion(
            heightCmRange: NumRange(186, double.infinity),
            waistCmRange: NumRange(82, double.infinity),
          ),
          row: {
            CountryCode.inter: "XXL",
            CountryCode.ru: 52,
            CountryCode.eu: 46,
            CountryCode.uk: 18,
            CountryCode.us: 14,
            CountryCode.it: 50,
            CountryCode.fr: 46,
            CountryCode.es: 46,
            CountryCode.de: 44,
            CountryCode.jp: "5L",
          },
        ),
      ],
    ),
    Garment.trousers: MappingTable(
      unitCodeByKey: CountryCode.nameOf,
      keyByUnitCode: CountryCode.valueOf,
      rows: [
        MappingRow(
          criterion: ClothingSizeCriterion(
            heightCmRange: NumRange(0, 156),
            waistCmRange: NumRange(0, 62),
          ),
          row: {
            CountryCode.inter: "XXS",
            CountryCode.ru: 40,
            CountryCode.eu: 34,
            CountryCode.uk: 6,
            CountryCode.us: 2,
            CountryCode.it: 38,
            CountryCode.fr: 34,
            CountryCode.es: 34,
            CountryCode.de: 32,
            CountryCode.jp: "S",
          },
        ),
        MappingRow(
          criterion: ClothingSizeCriterion(
            heightCmRange: NumRange(156, 162),
            waistCmRange: NumRange(62, 66),
          ),
          row: {
            CountryCode.inter: "XS",
            CountryCode.ru: 42,
            CountryCode.eu: 36,
            CountryCode.uk: 8,
            CountryCode.us: 4,
            CountryCode.it: 40,
            CountryCode.fr: 36,
            CountryCode.es: 36,
            CountryCode.de: 34,
            CountryCode.jp: "M",
          },
        ),
        MappingRow(
          criterion: ClothingSizeCriterion(
            heightCmRange: NumRange(162, 168),
            waistCmRange: NumRange(66, 70),
          ),
          row: {
            CountryCode.inter: "S",
            CountryCode.ru: 44,
            CountryCode.eu: 38,
            CountryCode.uk: 10,
            CountryCode.us: 6,
            CountryCode.it: 42,
            CountryCode.fr: 38,
            CountryCode.es: 38,
            CountryCode.de: 36,
            CountryCode.jp: "L",
          },
        ),
        MappingRow(
          criterion: ClothingSizeCriterion(
            heightCmRange: NumRange(168, 174),
            waistCmRange: NumRange(70, 74),
          ),
          row: {
            CountryCode.inter: "M",
            CountryCode.ru: 46,
            CountryCode.eu: 40,
            CountryCode.uk: 12,
            CountryCode.us: 8,
            CountryCode.it: 44,
            CountryCode.fr: 40,
            CountryCode.es: 40,
            CountryCode.de: 38,
            CountryCode.jp: "LL",
          },
        ),
        MappingRow(
          criterion: ClothingSizeCriterion(
            heightCmRange: NumRange(174, 180),
            waistCmRange: NumRange(74, 78),
          ),
          row: {
            CountryCode.inter: "L",
            CountryCode.ru: 48,
            CountryCode.eu: 42,
            CountryCode.uk: 14,
            CountryCode.us: 10,
            CountryCode.it: 46,
            CountryCode.fr: 42,
            CountryCode.es: 42,
            CountryCode.de: 40,
            CountryCode.jp: "3L",
          },
        ),
        MappingRow(
          criterion: ClothingSizeCriterion(
            heightCmRange: NumRange(180, 186),
            waistCmRange: NumRange(78, 82),
          ),
          row: {
            CountryCode.inter: "XL",
            CountryCode.ru: 50,
            CountryCode.eu: 44,
            CountryCode.uk: 16,
            CountryCode.us: 12,
            CountryCode.it: 48,
            CountryCode.fr: 44,
            CountryCode.es: 44,
            CountryCode.de: 42,
            CountryCode.jp: "4L",
          },
        ),
        MappingRow(
          criterion: ClothingSizeCriterion(
            heightCmRange: NumRange(186, double.infinity),
            waistCmRange: NumRange(82, double.infinity),
          ),
          row: {
            CountryCode.inter: "XXL",
            CountryCode.ru: 52,
            CountryCode.eu: 46,
            CountryCode.uk: 18,
            CountryCode.us: 14,
            CountryCode.it: 50,
            CountryCode.fr: 46,
            CountryCode.es: 46,
            CountryCode.de: 44,
            CountryCode.jp: "5L",
          },
        ),
      ],
    ),
  },
};
