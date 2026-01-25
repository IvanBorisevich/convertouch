import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/ui/constants/input_box_constants.dart';
import 'package:convertouch/presentation/ui/model/conversion_item_model.dart';
import 'package:convertouch/presentation/ui/model/input_box_model.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/utils/icon_utils.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/input_box.dart';
import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

enum ControlPosition {
  left,
  right;
}

class ConvertouchConversionItem<M extends InputBoxModel>
    extends StatefulWidget {
  static const double _defaultSpacing = 7;

  final ConversionItemModel<M> model;
  final void Function()? onUnitItemTap;
  final void Function(dynamic)? onValueChanged;
  final void Function(dynamic)? onValueFocused;
  final void Function()? onItemRemoved;
  final double spacing;
  final double horizontalPadding;
  final ConversionItemColorScheme colors;

  const ConvertouchConversionItem(
    this.model, {
    this.onUnitItemTap,
    this.onValueChanged,
    this.onValueFocused,
    this.onItemRemoved,
    this.spacing = _defaultSpacing,
    this.horizontalPadding = _defaultSpacing,
    required this.colors,
    super.key,
  });

  @override
  State<ConvertouchConversionItem<M>> createState() =>
      _ConvertouchConversionItemState<M>();
}

class _ConvertouchConversionItemState<M extends InputBoxModel>
    extends State<ConvertouchConversionItem<M>> {
  static const double _unitButtonWidth = 90;
  static const double _unitButtonBorderRadius = 15;
  static const double _containerHeight = InputBoxConstants.defaultHeight;
  static const double _wrapContainerHeight =
      _containerHeight + ConvertouchConversionItem._defaultSpacing * 2;

  @override
  Widget build(BuildContext context) {
    var unitButtonColor = widget.colors.unitButton;
    var textBoxColor = widget.colors.textBox;
    var handlerColor = widget.colors.handler;
    var wrapBackgroundColor = widget.colors.wrapBackground;

    return Container(
      height: _wrapContainerHeight,
      padding: const EdgeInsets.symmetric(
        vertical: ConvertouchConversionItem._defaultSpacing,
      ),
      decoration: BoxDecoration(
        color: widget.model.isSource
            ? wrapBackgroundColor.regular
            : Colors.transparent,
      ),
      child: Row(
        children: [
          SizedBox(width: widget.horizontalPadding),
          widget.model.draggable && widget.model.index != null
              ? ReorderableDragStartListener(
                  index: widget.model.index!,
                  child: _handler(
                    iconLogo: !widget.model.isSource
                        ? Icons.drag_indicator_outlined
                        : null,
                    textLogo: widget.model.isSource ? '𝑥' : null,
                    handlerColor: handlerColor,
                    controlPosition: ControlPosition.left,
                  ),
                )
              : const SizedBox.shrink(),
          Expanded(
            child: ConvertouchInputBox(
              model: widget.model.inputBoxModel,
              tooltipDirection: widget.model.isLast
                  ? TooltipDirection.up
                  : TooltipDirection.down,
              onValueChanged: widget.onValueChanged,
              onFocusSelected: widget.onValueFocused,
              suffixIcon: _suffixIcon(),
              colors: textBoxColor,
              labelPadding: widget.model.isSource
                  ? const EdgeInsets.symmetric(horizontal: 4)
                  : null,
            ),
          ),
          widget.model.unit != null
              ? Container(
                  width: _unitButtonWidth,
                  height: InputBoxConstants.defaultHeight,
                  padding: EdgeInsets.only(left: widget.spacing),
                  child: TextButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      widget.onUnitItemTap?.call();
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        widget.model.isSource
                            ? unitButtonColor.background.selected
                            : unitButtonColor.background.regular,
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          side: BorderSide(
                            color: widget.model.isSource
                                ? unitButtonColor.border.selected
                                : unitButtonColor.border.regular,
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(_unitButtonBorderRadius),
                          ),
                        ),
                      ),
                    ),
                    child: Text(
                      widget.model.unit!.code,
                      style: TextStyle(
                        color: unitButtonColor.foreground.regular,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          widget.model.removable
              ? _handler(
                  iconLogo: Icons.remove,
                  handlerColor: handlerColor,
                  controlPosition: ControlPosition.right,
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    widget.onItemRemoved?.call();
                  },
                )
              : const SizedBox.shrink(),
          SizedBox(width: widget.horizontalPadding),
        ],
      ),
    );
  }

  Widget _handler({
    IconData? iconLogo,
    String? textLogo,
    required ControlPosition controlPosition,
    required ConvertouchColorScheme handlerColor,
    void Function()? onTap,
  }) {
    Color background = widget.model.isSource
        ? handlerColor.background.selected
        : handlerColor.background.regular;

    Color foreground = widget.model.isSource
        ? handlerColor.foreground.selected
        : handlerColor.foreground.regular;

    Widget? handlerLogo() {
      if (textLogo != null) {
        return Container(
          padding: const EdgeInsets.only(left: 2),
          child: Text(
            textLogo,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              height: -0.3,
              color: foreground,
            ),
          ),
        );
      }

      if (iconLogo != null) {
        return Icon(
          iconLogo,
          color: foreground,
        );
      }

      return null;
    }

    return Padding(
      padding: EdgeInsets.only(
        left: controlPosition == ControlPosition.right ? widget.spacing : 0,
        right: controlPosition == ControlPosition.left ? widget.spacing : 0,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: background,
            borderRadius: const BorderRadius.all(Radius.circular(16)),
          ),
          child: handlerLogo(),
        ),
      ),
    );
  }

  Widget? _suffixIcon() {
    if (widget.model.unit != null && !widget.model.unit!.invertible) {
      return Padding(
        padding: const EdgeInsets.all(9),
        child: IconUtils.getSuffixSvgIcon(
          IconNames.oneWayConversion,
          color: widget.colors.textBox.foreground.regular,
        ),
      );
    }

    return null;
  }
}
