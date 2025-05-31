import 'package:convertouch/domain/constants/constants.dart';

const conversionParamsV1 = [
  {
    "name": ParamSetNames.byHeight,
    "unitGroupName": GroupNames.clothesSize,
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
        "calculable": true,
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
  {
    "name": ParamSetNames.byCircumference,
    "unitGroupName": GroupNames.ringSize,
    "mandatory": false,
    "params": [
      {
        "name": ParamNames.circumference,
        "calculable": true,
        "valueType": ConvertouchValueType.decimalPositive,
        "unitGroupName": GroupNames.length,
        "defaultUnitCode": "mm",
        "possibleUnitCodes": [
          "mm",
          "cm",
          "in",
        ],
      }
    ]
  },
  {
    "name": ParamSetNames.byDiameter,
    "unitGroupName": GroupNames.ringSize,
    "mandatory": false,
    "params": [
      {
        "name": ParamNames.diameter,
        "calculable": true,
        "valueType": ConvertouchValueType.decimalPositive,
        "unitGroupName": GroupNames.length,
        "defaultUnitCode": "mm",
        "possibleUnitCodes": [
          "mm",
          "cm",
          "in",
        ],
      }
    ]
  },
  {
    "name": ParamSetNames.barbellWeight,
    "unitGroupName": GroupNames.mass,
    "mandatory": false,
    "params": [
      {
        "name": ParamNames.barWeight,
        "calculable": false,
        "valueType": ConvertouchValueType.decimalPositive,
        "listType": ConvertouchListType.barbellBarWeight,
        "unitGroupName": GroupNames.mass,
        "defaultUnitCode": "kg",
        "possibleUnitCodes": [
          "kg",
          "lb.",
        ],
      },
      {
        "name": ParamNames.oneSideWeight,
        "calculable": true,
        "valueType": ConvertouchValueType.decimalPositive,
        "unitGroupName": GroupNames.mass,
        "defaultUnitCode": "kg",
        "possibleUnitCodes": [
          "kg",
          "lb.",
        ],
      }
    ]
  },
];
