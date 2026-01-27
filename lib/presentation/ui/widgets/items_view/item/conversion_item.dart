import 'package:convertouch/presentation/ui/constants/conversion_item_constants.dart';
import 'package:convertouch/presentation/ui/constants/input_box_constants.dart';
import 'package:convertouch/presentation/ui/model/conversion_item_model.dart';
import 'package:convertouch/presentation/ui/model/input_box_model.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/input_box.dart';
import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

class ConvertouchConversionItem<M extends InputBoxModel>
    extends StatefulWidget {
  final ConversionItemModel<M> model;
  final void Function()? onUnitItemTap;
  final void Function(dynamic)? onValueChanged;
  final void Function(dynamic)? onValueFocused;
  final void Function()? onItemRemoved;
  final ConversionItemColorScheme colors;

  const ConvertouchConversionItem(
    this.model, {
    this.onUnitItemTap,
    this.onValueChanged,
    this.onValueFocused,
    this.onItemRemoved,
    required this.colors,
    super.key,
  });

  @override
  State<ConvertouchConversionItem<M>> createState() =>
      _ConvertouchConversionItemState<M>();
}

class _ConvertouchConversionItemState<M extends InputBoxModel>
    extends State<ConvertouchConversionItem<M>> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: InputBoxConstants.defaultHeight,
      decoration: BoxDecoration(
        borderRadius: InputBoxConstants.defaultBorderRadius,
        border: Border.all(
          color: widget.colors.textBox.border.regular,
          width: 1,
        ),
        color: widget.colors.textBox.background.regular,
      ),
      child: Row(
        children: [
          _prefixWidget(
            visible: widget.model.draggable && widget.model.index != null,
            widget: ReorderableDragStartListener(
              index: widget.model.index!,
              child: Container(
                width: 32,
                padding: const EdgeInsets.only(left: 3),
                alignment: Alignment.center,
                child: widget.model.isSource
                    ? Container(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: null,
                          child: Text(
                            '𝑥',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              height: -0.3,
                              color: widget.colors.handler.foreground.regular,
                            ),
                          ),
                        ),
                      )
                    : Icon(
                        Icons.drag_indicator_outlined,
                        color: widget.colors.handler.foreground.regular,
                        size: 20,
                      ),
              ),
            ),
          ),
          Expanded(
            child: ConvertouchInputBox(
              model: widget.model.inputBoxModel,
              borderWidth: 0,
              borderRadius: InputBoxConstants.defaultBorderRadius,
              tooltipDirection: widget.model.isLast
                  ? TooltipDirection.up
                  : TooltipDirection.down,
              onValueChanged: widget.onValueChanged,
              onFocusSelected: widget.onValueFocused,
              colors: widget.colors.textBox,
              labelPadding: const EdgeInsets.only(
                left: 4,
                right: 4,
                bottom: 4,
              ),
              contentPaddingLeft: 12,
              contentPaddingRight: 12,
            ),
          ),
          Container(
            width: 34,
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              icon: Icon(
                Icons.copy_rounded,
                color: widget.colors.handler.foreground.regular,
                size: 19,
              ),
            ),
          ),
          _suffixWidget(
            visible: widget.model.unit != null,
            widget: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                widget.onUnitItemTap?.call();
              },
              child: Container(
                alignment: Alignment.center,
                width: ConversionItemConstants.defaultUnitButtonWidth,
                decoration: const BoxDecoration(
                  borderRadius: InputBoxConstants.defaultBorderRadius,
                ),
                child: Text(
                  widget.model.unit!.code,
                  style: TextStyle(
                    color: widget.colors.unitButton.foreground.regular,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                ),
              ),
            ),
          ),
          _suffixWidget(
            visible: widget.model.removable,
            widget: Container(
              padding: const EdgeInsets.only(right: 1),
              width: 32,
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  widget.onItemRemoved?.call();
                },
                icon: Icon(
                  Icons.remove,
                  color: widget.colors.handler.foreground.regular,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    // return Container(
    //   height: _wrapContainerHeight,
    //   padding: const EdgeInsets.symmetric(
    //     vertical: ConvertouchConversionItem._defaultSpacing,
    //   ),
    //   decoration: BoxDecoration(
    //     color: widget.model.isSource
    //         ? wrapBackgroundColor.regular
    //         : Colors.transparent,
    //   ),
    //   child: Row(
    //     children: [
    //       SizedBox(width: widget.horizontalPadding),
    //       widget.model.draggable && widget.model.index != null
    //           ? ReorderableDragStartListener(
    //               index: widget.model.index!,
    //               child: _handler(
    //                 iconLogo: !widget.model.isSource
    //                     ? Icons.drag_indicator_outlined
    //                     : null,
    //                 textLogo: widget.model.isSource ? '𝑥' : null,
    //                 handlerColor: handlerColor,
    //                 controlPosition: ControlPosition.left,
    //               ),
    //             )
    //           : const SizedBox.shrink(),
    //       Expanded(
    //         child: ConvertouchInputBox(
    //           model: widget.model.inputBoxModel,
    //           tooltipDirection: widget.model.isLast
    //               ? TooltipDirection.up
    //               : TooltipDirection.down,
    //           onValueChanged: widget.onValueChanged,
    //           onFocusSelected: widget.onValueFocused,
    //           suffixIcon: _suffixIcon(),
    //           colors: textBoxColor,
    //           labelPadding: widget.model.isSource
    //               ? const EdgeInsets.symmetric(horizontal: 4)
    //               : null,
    //         ),
    //       ),
    //       widget.model.unit != null
    //           ? Container(
    //               width: _unitButtonWidth,
    //               height: InputBoxConstants.defaultHeight,
    //               padding: EdgeInsets.only(left: widget.spacing),
    //               child: TextButton(
    //                 onPressed: () {
    //                   FocusScope.of(context).unfocus();
    //                   widget.onUnitItemTap?.call();
    //                 },
    //                 style: ButtonStyle(
    //                   backgroundColor: WidgetStateProperty.all(
    //                     widget.model.isSource
    //                         ? unitButtonColor.background.selected
    //                         : unitButtonColor.background.regular,
    //                   ),
    //                   shape: WidgetStateProperty.all(
    //                     RoundedRectangleBorder(
    //                       side: BorderSide(
    //                         color: widget.model.isSource
    //                             ? unitButtonColor.border.selected
    //                             : unitButtonColor.border.regular,
    //                         width: 1,
    //                       ),
    //                       borderRadius: const BorderRadius.all(
    //                         Radius.circular(_unitButtonBorderRadius),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //                 child: Text(
    //                   widget.model.unit!.code,
    //                   style: TextStyle(
    //                     color: unitButtonColor.foreground.regular,
    //                     fontSize: 15,
    //                     fontWeight: FontWeight.w700,
    //                   ),
    //                   maxLines: 1,
    //                 ),
    //               ),
    //             )
    //           : const SizedBox.shrink(),
    //       widget.model.removable
    //           ? _handler(
    //               iconLogo: Icons.remove,
    //               handlerColor: handlerColor,
    //               controlPosition: ControlPosition.right,
    //               onTap: () {
    //                 FocusScope.of(context).unfocus();
    //                 widget.onItemRemoved?.call();
    //               },
    //             )
    //           : const SizedBox.shrink(),
    //       SizedBox(width: widget.horizontalPadding),
    //     ],
    //   ),
    // );
  }

  Widget _prefixWidget({
    required Widget widget,
    bool visible = true,
  }) {
    if (visible) {
      return Row(
        children: [
          widget,
          _verticalDivider(),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Widget _suffixWidget({
    required Widget widget,
    bool visible = true,
  }) {
    if (visible) {
      return Row(
        children: [
          _verticalDivider(),
          widget,
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Widget _verticalDivider() {
    return VerticalDivider(
      color: widget.colors.divider.regular,
      indent: 10,
      endIndent: 10,
      width: 2,
      thickness: 2,
    );
  }
}
