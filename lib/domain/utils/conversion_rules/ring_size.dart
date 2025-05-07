import 'dart:math';

import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/utils/mapping_table.dart';

const int millimetersInMeter = 1000;

Map<String, String>? getRingSizesMapByParams(
  ConversionParamSetValueModel params,
  String paramName,
) {
  return _ringSizes.getRowByParams(
    params,
    filter: (params, criterion) {
      var diameterParam = params.getParam(ParamNames.diameter);
      ValueModel? diameter = diameterParam?.val;

      if (diameter == null) {
        return false;
      }

      double normalizedDiameter = paramName == ParamNames.diameter
          ? diameter.numVal! *
              diameterParam!.unit!.coefficient! *
              millimetersInMeter
          : diameter.numVal! *
              diameterParam!.unit!.coefficient! *
              millimetersInMeter /
              pi;

      return criterion.contains(normalizedDiameter, includeRight: false);
    },
  );
}

Map<String, String>? getRingSizesMapByValue(ConversionUnitValueModel value) {
  return _ringSizes.getRowByValue(value);
}

const MappingTable<NumRangeCriterion, CountryCode> _ringSizes = MappingTable(
  unitCodeByKey: CountryCode.nameOf,
  keyByUnitCode: CountryCode.valueOf,
  rows: [
    MappingRow(
      criterion: NumRangeCriterion(14, 14.5),
      row: {
        CountryCode.us: 3,
        CountryCode.uk: "F",
        CountryCode.de: 44,
        CountryCode.fr: 44,
        CountryCode.it: 4,
        CountryCode.jp: 4,
      },
    ),
    MappingRow(
      criterion: NumRangeCriterion(14.5, 15),
      row: {
        CountryCode.us: 3.5,
        CountryCode.uk: "G",
        CountryCode.de: null,
        CountryCode.fr: null,
        CountryCode.it: 5.5,
        CountryCode.jp: 5,
      },
    ),
    MappingRow(
      criterion: NumRangeCriterion(15, 15.3),
      row: {
        CountryCode.us: 4,
        CountryCode.uk: "H",
        CountryCode.de: 47,
        CountryCode.fr: 46.5,
        CountryCode.it: 7,
        CountryCode.jp: 7,
      },
    ),
  ],
);
