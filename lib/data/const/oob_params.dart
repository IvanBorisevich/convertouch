import 'package:convertouch/domain/constants/constants.dart';

const conversionParamsV1 = [
  {
    "name": ParamSetNames.byHeight,
    "unitGroupName": GroupNames.clothingSize,
    "mandatory": true,
    "params": [
      {
        "name": ParamNames.person,
        "calculable": false,
        "valueType": ConvertouchValueType.text,
        "listType": ConvertouchListType.person,
      },
      {
        "name": ParamNames.garment,
        "calculable": false,
        "valueType": ConvertouchValueType.text,
        "listType": ConvertouchListType.garment,
      },
      {
        "name": ParamNames.height,
        "calculable": false,
        "valueType": ConvertouchValueType.decimalPositive,
        "unitGroupName": GroupNames.length,
        "defaultUnitCode": "cm",
        "possibleUnitCodes": [
          "cm",
          "m",
          "ft",
          "in",
        ],
      }
    ],
  },
];
