import 'package:collection/collection.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_values_model.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/conversion_item.dart';
import 'package:flutter/material.dart';

class ConversionParamsView extends StatelessWidget {
  final ConversionParamSetValuesModel? paramSetValues;
  final void Function()? onParamSetChange;
  final void Function(ConversionParamValueModel)? onParamUnitTap;
  final void Function(ConversionParamValueModel, String)? onValueChanged;
  final ConvertouchUITheme theme;

  const ConversionParamsView({
    this.paramSetValues,
    this.onParamSetChange,
    this.onParamUnitTap,
    this.onValueChanged,
    required this.theme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (paramSetValues == null) {
      return const SizedBox.shrink();
    }

    ParamSetPanelColorScheme colors = paramSetColors[theme]!;

    return ExpansionTileTheme(
      data: ExpansionTileThemeData(
        backgroundColor: colors.background.regular,
        collapsedBackgroundColor: colors.background.regular,
        textColor: colors.foreground.regular,
        collapsedTextColor: colors.foreground.regular,
        iconColor: colors.icon.foreground.regular,
        collapsedIconColor: colors.icon.foreground.regular,
        collapsedShape: const RoundedRectangleBorder(
          side: BorderSide.none,
        ),
        shape: const RoundedRectangleBorder(
          side: BorderSide.none,
        ),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 20),
        childrenPadding: const EdgeInsets.only(
          top: 5,
          left: 10,
          right: 10,
          bottom: 12,
        ),
        title: const Text(
          "Conversion Parameters",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
        trailing: GestureDetector(
          onTap: onParamSetChange,
          child: Container(
            decoration: BoxDecoration(
              color: colors.icon.background.regular,
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
            child: const Icon(Icons.chevron_right_rounded),
          ),
        ),
        children: paramSetValues!.values
            .mapIndexed(
              (index, item) => Container(
                padding: index == 0
                    ? EdgeInsets.zero
                    : const EdgeInsets.only(top: 10),
                child: ConvertouchConversionItem(
                  item,
                  controlsVisible: false,
                  itemNameFunc: (item) => item.param.name,
                  unitItemCodeFunc: null,
                  onTap: () {
                    onParamUnitTap?.call(item);
                  },
                  onValueChanged: (value) {
                    onValueChanged?.call(item, value);
                  },
                  colors: conversionItemColors[theme]!,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
