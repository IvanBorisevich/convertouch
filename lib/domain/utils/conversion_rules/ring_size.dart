import 'dart:math';

import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/num_range.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/utils/mapping_table.dart';

const int _mmInMeter = 1000;

class RingSizeCriterion extends Criterion {
  final NumRange diameterCmRange;

  const RingSizeCriterion({
    required this.diameterCmRange,
  });

  @override
  bool matches(ConversionParamSetValueModel params) {
    String paramSetName = params.paramSet.name;

    if (paramSetName == ParamSetNames.byDiameter) {
      return diameterCmRange.contains(
          _getDiameterCm(params.getParam(ParamNames.diameter)),
          includeRight: false);
    }

    if (paramSetName == ParamSetNames.byCircumference) {
      return diameterCmRange.contains(
          _getDiameterCm(params.getParam(ParamNames.circumference)),
          includeRight: false);
    }

    return false;
  }

  double? _getDiameterCm(ConversionParamValueModel? paramValue) {
    if (paramValue == null || paramValue.numVal == null) {
      return null;
    }

    double coefficient = paramValue.unit!.coefficient!;

    return paramValue.param.name == ParamNames.diameter
        ? paramValue.numVal! * coefficient * _mmInMeter
        : paramValue.numVal! * coefficient * _mmInMeter / pi;
  }
}

Map<String, String>? getRingSizesMap(
  ConversionParamSetValueModel params,
) {
  return _ringSizes.getRowByParams(params);
}

Map<String, String>? getRingSizesMapByValue(ConversionUnitValueModel value) {
  return _ringSizes.getMappingByValue(value);
}

ValueModel? getDiameterByValue({
  required ConversionUnitValueModel value,
  required List<ConversionParamValueModel> paramValues,
}) {
  var criterion = _ringSizes.getCriterionByValue(value);
  return ValueModel.any(criterion?.diameterCmRange.left);
}

ValueModel? getCircumferenceByValue({
  required ConversionUnitValueModel value,
  required List<ConversionParamValueModel> paramValues,
}) {
  var criterion = _ringSizes.getCriterionByValue(value);
  return criterion?.diameterCmRange.left != null
      ? ValueModel.any(criterion!.diameterCmRange.left * pi)
      : null;
}

const MappingTable<RingSizeCriterion, CountryCode> _ringSizes = MappingTable(
  unitCodeByKey: CountryCode.nameOf,
  keyByUnitCode: CountryCode.valueOf,
  rows: [
    MappingRow(
      criterion: RingSizeCriterion(
        diameterCmRange: NumRange(14, 14.5),
      ),
      row: {
        CountryCode.us: 3,
        CountryCode.uk: "F",
        CountryCode.de: 44,
        CountryCode.es: 4,
        CountryCode.fr: 44,
        CountryCode.ru: 44,
        CountryCode.it: 4,
        CountryCode.jp: 4,
      },
    ),
    MappingRow(
      criterion: RingSizeCriterion(
        diameterCmRange: NumRange(14.5, 15),
      ),
      row: {
        CountryCode.us: 3.5,
        CountryCode.uk: "G",
        CountryCode.de: null,
        CountryCode.es: null,
        CountryCode.fr: null,
        CountryCode.ru: null,
        CountryCode.it: 5.5,
        CountryCode.jp: 5,
      },
    ),
    MappingRow(
      criterion: RingSizeCriterion(
        diameterCmRange: NumRange(15, 15.3),
      ),
      row: {
        CountryCode.us: 4,
        CountryCode.uk: "H",
        CountryCode.de: 47,
        CountryCode.es: 6.5,
        CountryCode.fr: 46.5,
        CountryCode.ru: 46.5,
        CountryCode.it: 7,
        CountryCode.jp: 7,
      },
    ),
    MappingRow(
      criterion: RingSizeCriterion(
        diameterCmRange: NumRange(15.3, 15.6),
      ),
      row: {
        CountryCode.us: 4.5,
        CountryCode.uk: "I",
        CountryCode.de: 48,
        CountryCode.es: 8,
        CountryCode.fr: 48,
        CountryCode.ru: 48,
        CountryCode.it: 8,
        CountryCode.jp: 8,
      },
    ),
    MappingRow(
      criterion: RingSizeCriterion(
        diameterCmRange: NumRange(15.6, 16.2),
      ),
      row: {
        CountryCode.us: 5,
        CountryCode.uk: "J",
        CountryCode.de: 49,
        CountryCode.es: 9.5,
        CountryCode.fr: 49.5,
        CountryCode.ru: 49.5,
        CountryCode.it: 9,
        CountryCode.jp: 9,
      },
    ),
    MappingRow(
      criterion: RingSizeCriterion(
        diameterCmRange: NumRange(16.2, 16.6),
      ),
      row: {
        CountryCode.us: 5.5,
        CountryCode.uk: "K",
        CountryCode.de: 51,
        CountryCode.es: 10.5,
        CountryCode.fr: 50.5,
        CountryCode.ru: 50.5,
        CountryCode.it: 10,
        CountryCode.jp: 10,
      },
    ),
    MappingRow(
      criterion: RingSizeCriterion(
        diameterCmRange: NumRange(16.6, 16.9),
      ),
      row: {
        CountryCode.us: 6,
        CountryCode.uk: "L",
        CountryCode.de: 52,
        CountryCode.es: 12,
        CountryCode.fr: 52,
        CountryCode.ru: 52,
        CountryCode.it: 11,
        CountryCode.jp: 11,
      },
    ),
    MappingRow(
      criterion: RingSizeCriterion(
        diameterCmRange: NumRange(16.9, 17.2),
      ),
      row: {
        CountryCode.us: 6.5,
        CountryCode.uk: "M",
        CountryCode.de: 53,
        CountryCode.es: 13.5,
        CountryCode.fr: 53,
        CountryCode.ru: 53,
        CountryCode.it: 12.5,
        CountryCode.jp: 13,
      },
    ),
    MappingRow(
      criterion: RingSizeCriterion(
        diameterCmRange: NumRange(17.2, 17.8),
      ),
      row: {
        CountryCode.us: 7,
        CountryCode.uk: "N",
        CountryCode.de: 54,
        CountryCode.es: 14.5,
        CountryCode.fr: 54.5,
        CountryCode.ru: 54.5,
        CountryCode.it: 14,
        CountryCode.jp: 14,
      },
    ),
    MappingRow(
      criterion: RingSizeCriterion(
        diameterCmRange: NumRange(17.8, 18.1),
      ),
      row: {
        CountryCode.us: 7.5,
        CountryCode.uk: "O",
        CountryCode.de: 56,
        CountryCode.es: 16,
        CountryCode.fr: 55.5,
        CountryCode.ru: 55.5,
        CountryCode.it: 15,
        CountryCode.jp: 15,
      },
    ),
    MappingRow(
      criterion: RingSizeCriterion(
        diameterCmRange: NumRange(18.1, 18.5),
      ),
      row: {
        CountryCode.us: 8,
        CountryCode.uk: "P",
        CountryCode.de: 57,
        CountryCode.es: 17,
        CountryCode.fr: 57,
        CountryCode.ru: 57,
        CountryCode.it: 16,
        CountryCode.jp: 16,
      },
    ),
    MappingRow(
      criterion: RingSizeCriterion(
        diameterCmRange: NumRange(18.5, 19.1),
      ),
      row: {
        CountryCode.us: 8.5,
        CountryCode.uk: "Q",
        CountryCode.de: 58,
        CountryCode.es: 18.5,
        CountryCode.fr: 58,
        CountryCode.ru: 58,
        CountryCode.it: 17.5,
        CountryCode.jp: 17,
      },
    ),
    MappingRow(
      criterion: RingSizeCriterion(
        diameterCmRange: NumRange(19.1, 19.4),
      ),
      row: {
        CountryCode.us: 9,
        CountryCode.uk: "R",
        CountryCode.de: 60,
        CountryCode.es: 20,
        CountryCode.fr: 59.5,
        CountryCode.ru: 59.5,
        CountryCode.it: 19,
        CountryCode.jp: 18,
      },
    ),
    MappingRow(
      criterion: RingSizeCriterion(
        diameterCmRange: NumRange(19.4, 19.7),
      ),
      row: {
        CountryCode.us: 9.5,
        CountryCode.uk: "S",
        CountryCode.de: 61,
        CountryCode.es: 21,
        CountryCode.fr: 61,
        CountryCode.ru: 61,
        CountryCode.it: 20,
        CountryCode.jp: 19,
      },
    ),
    MappingRow(
      criterion: RingSizeCriterion(
        diameterCmRange: NumRange(19.7, 20.4),
      ),
      row: {
        CountryCode.us: 10,
        CountryCode.uk: "T",
        CountryCode.de: 62,
        CountryCode.es: 22.5,
        CountryCode.fr: 62,
        CountryCode.ru: 62,
        CountryCode.it: 21.5,
        CountryCode.jp: 20,
      },
    ),
    MappingRow(
      criterion: RingSizeCriterion(
        diameterCmRange: NumRange(20.4, 20.7),
      ),
      row: {
        CountryCode.us: 10.5,
        CountryCode.uk: "U",
        CountryCode.de: 64,
        CountryCode.es: 23.5,
        CountryCode.fr: 63.5,
        CountryCode.ru: 63.5,
        CountryCode.it: 23,
        CountryCode.jp: 22,
      },
    ),
    MappingRow(
      criterion: RingSizeCriterion(
        diameterCmRange: NumRange(20.7, 21),
      ),
      row: {
        CountryCode.us: 11,
        CountryCode.uk: "V",
        CountryCode.de: 65,
        CountryCode.es: 25,
        CountryCode.fr: 64.5,
        CountryCode.ru: 64.5,
        CountryCode.it: 24,
        CountryCode.jp: 23,
      },
    ),
    MappingRow(
      criterion: RingSizeCriterion(
        diameterCmRange: NumRange(21, 21.6),
      ),
      row: {
        CountryCode.us: 11.5,
        CountryCode.uk: "W",
        CountryCode.de: 66,
        CountryCode.es: 26,
        CountryCode.fr: 66,
        CountryCode.ru: 66,
        CountryCode.it: 25,
        CountryCode.jp: 24,
      },
    ),
    MappingRow(
      criterion: RingSizeCriterion(
        diameterCmRange: NumRange(21.6, 22),
      ),
      row: {
        CountryCode.us: 12,
        CountryCode.uk: "X",
        CountryCode.de: 68,
        CountryCode.es: 27.5,
        CountryCode.fr: 67,
        CountryCode.ru: 67,
        CountryCode.it: 26.5,
        CountryCode.jp: 25,
      },
    ),
    MappingRow(
      criterion: RingSizeCriterion(
        diameterCmRange: NumRange(22, 22.3),
      ),
      row: {
        CountryCode.us: 12.5,
        CountryCode.uk: "Y",
        CountryCode.de: 69,
        CountryCode.es: 29,
        CountryCode.fr: 68.5,
        CountryCode.ru: 68.5,
        CountryCode.it: 28,
        CountryCode.jp: 26,
      },
    ),
    MappingRow(
      criterion: RingSizeCriterion(
        diameterCmRange: NumRange(22.3, 22.9),
      ),
      row: {
        CountryCode.us: 13,
        CountryCode.uk: "Z",
        CountryCode.de: 70,
        CountryCode.es: 30,
        CountryCode.fr: 69.5,
        CountryCode.ru: 69.5,
        CountryCode.it: 28.5,
        CountryCode.jp: 27,
      },
    ),
    MappingRow(
      criterion: RingSizeCriterion(
        diameterCmRange: NumRange(22.9, 23.2),
      ),
      row: {
        CountryCode.us: 13.5,
        CountryCode.uk: "Z+2",
        CountryCode.de: 72,
        CountryCode.es: 32,
        CountryCode.fr: 71,
        CountryCode.ru: 71,
        CountryCode.it: 32,
        CountryCode.jp: null,
      },
    ),
    MappingRow(
      criterion: RingSizeCriterion(
        diameterCmRange: NumRange(23.2, 23.6),
      ),
      row: {
        CountryCode.us: 14,
        CountryCode.uk: "Z+3",
        CountryCode.de: 73,
        CountryCode.es: 33,
        CountryCode.fr: 72.5,
        CountryCode.ru: 72.5,
        CountryCode.it: 33,
        CountryCode.jp: null,
      },
    ),
    MappingRow(
      criterion: RingSizeCriterion(
        diameterCmRange: NumRange(23.6, 23.9),
      ),
      row: {
        CountryCode.us: 14.5,
        CountryCode.uk: "Z+4",
        CountryCode.de: 74,
        CountryCode.es: 34.5,
        CountryCode.fr: 73.5,
        CountryCode.ru: 73.5,
        CountryCode.it: null,
        CountryCode.jp: null,
      },
    ),
    MappingRow(
      criterion: RingSizeCriterion(
        diameterCmRange: NumRange(23.9, double.infinity),
      ),
      row: {
        CountryCode.us: 15,
        CountryCode.uk: "Z+5",
        CountryCode.de: null,
        CountryCode.es: 35,
        CountryCode.fr: 75,
        CountryCode.ru: 75,
        CountryCode.it: 35,
        CountryCode.jp: null,
      },
    ),
  ],
);
