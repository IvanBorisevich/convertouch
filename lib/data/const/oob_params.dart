import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/conversion_param_constants/clothing_size.dart';

const conversionParamsV1 = [
  {
    "name": GroupNames.clothingSize,
    "unitGroupName": GroupNames.clothingSize,
    "mandatory": true,
    "params": [
      {
        "name": genderParamName,
        "calculable": false,
        "listType": ConvertouchListValueType.gender,
      },
      {
        "name": garmentParamName,
        "calculable": false,
        "listType": ConvertouchListValueType.garment,
      },
      {
        "name": heightParamName,
        "calculable": false,
        "unitGroupName": GroupNames.length,
        "selectedUnitCode": "cm",
        "possibleUnitCodes": [
          "cm",
          "m",
          "ft",
          "in",
        ],
      }
    ],
  }
];
