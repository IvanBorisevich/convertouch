import 'package:collection/collection.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_param_set_values_model.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:convertouch/presentation/ui/utils/icon_utils.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/conversion_item.dart';
import 'package:flutter/material.dart';

class ConversionParamsView extends StatelessWidget {
  final ConversionParamSetValuesModel paramSetValues;
  final ConvertouchUITheme theme;

  const ConversionParamsView({
    required this.paramSetValues,
    required this.theme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTileTheme(
      data: ExpansionTileThemeData(
        backgroundColor: Color(0xff9bb7ff),
        collapsedBackgroundColor: Color(0xff9bb7ff),
        textColor: Color(0xFF1D5180),
        collapsedTextColor: Color(0xFF1D5180),
        iconColor: Color(0xFF1E5C93),
        collapsedIconColor: Color(0xFF1E5C93),
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.only(left: 20, right: 20),
        childrenPadding: EdgeInsets.only(
          top: 5,
          left: 10,
          right: 10,
          bottom: 10,
        ),
        title: Text(
          "Conversion Parameters",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
        trailing: IconUtils.getIcon(
          IconNames.preferences,
          size: 20,
        ),
        children: paramSetValues.values
            .mapIndexed(
              (index, item) => Container(
                padding:
                    index == 0 ? EdgeInsets.zero : EdgeInsets.only(top: 10),
                child: ConvertouchConversionItem(
                  item,
                  controlsVisible: false,
                  itemNameFunc: (item) => item.param.name,
                  unitItemCodeFunc: null,
                  colors: conversionItemColors[theme]!,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
