import 'package:collection/collection.dart';
import 'package:convertouch/presentation/ui/utils/widget_utils.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/input_box_icon_model.dart';
import 'package:flutter/material.dart';

const _debugMode = false;
const double _dividerWidth = 2;
const double defaultBorderRadius = 15;

class InputBoxIconWrapper extends StatelessWidget {
  final InputBoxIconsWrapperModel model;
  final Color dividerColor;
  final Widget? child;
  final Widget Function(double leftPadding, double rightPadding)? childBuilder;

  const InputBoxIconWrapper({
    required this.model,
    this.dividerColor = Colors.transparent,
    this.child,
    this.childBuilder,
    super.key,
  }) : assert(
          (child != null) ^ (childBuilder != null),
          "Either 'child' or 'childBuilder' must be provided",
        );

  @override
  Widget build(BuildContext context) {
    final visiblePrefixIconsModels = model.prefixIconsModels
        .where((iconModel) => iconModel.visible)
        .toList();
    final visibleSuffixIconsModels = model.suffixIconsModels
        .where((iconModel) => iconModel.visible)
        .toList();

    double prefixIconsTotalWidth = _getIconsTotalWidth(
      visiblePrefixIconsModels,
      iconType: IconType.prefix,
      model: model,
    );

    double suffixIconsTotalWidth = _getIconsTotalWidth(
      visibleSuffixIconsModels,
      iconType: IconType.suffix,
      model: model,
    );

    bool visiblePrefixIconsExist = visiblePrefixIconsModels.isNotEmpty;
    bool visibleSuffixIconsExist = visibleSuffixIconsModels.isNotEmpty;

    List<Widget> prefixIcons = visiblePrefixIconsExist
        ? visiblePrefixIconsModels
            .mapIndexed(
              (index, iconModel) => _InputBoxIcon.prefix(
                model: iconModel,
                spacing: model.iconSpacing,
                innermostSpacing: model.innermostSpacing,
                innermostSpacingWithoutDivider:
                    model.innermostSpacingWithoutDivider,
                outermostSpacing: model.outermostSpacingWithIcons,
                isInnermost: index == visiblePrefixIconsModels.length - 1,
                isOutermost: index == 0,
                dividerColor: dividerColor,
              ),
            )
            .toList()
        : [SizedBox(width: model.outermostSpacingWithoutIcons)];

    List<Widget> suffixIcons = visibleSuffixIconsExist
        ? visibleSuffixIconsModels
            .mapIndexed(
              (index, iconModel) => _InputBoxIcon.suffix(
                model: iconModel,
                spacing: model.iconSpacing,
                innermostSpacing: model.innermostSpacing,
                innermostSpacingWithoutDivider:
                    model.innermostSpacingWithoutDivider,
                outermostSpacing: model.outermostSpacingWithIcons,
                isInnermost: index == 0,
                isOutermost: index == visibleSuffixIconsModels.length - 1,
                dividerColor: dividerColor,
              ),
            )
            .toList()
        : [SizedBox(width: model.outermostSpacingWithoutIcons)];

    return IntrinsicHeight(
      child: child != null
          ? _buildViaRow(
              prefixIcons: prefixIcons,
              suffixIcons: suffixIcons,
              child: child!,
            )
          : _buildViaStack(
              prefixIcons: prefixIcons,
              suffixIcons: suffixIcons,
              prefixIconsTotalWidth: prefixIconsTotalWidth,
              suffixIconsTotalWidth: suffixIconsTotalWidth,
              childBuilder: childBuilder!,
            ),
    );
  }

  Widget _buildViaRow({
    required List<Widget> prefixIcons,
    required List<Widget> suffixIcons,
    required Widget child,
  }) {
    return Row(
      children: [
        ...prefixIcons,
        Expanded(child: child),
        ...suffixIcons,
      ],
    );
  }

  Widget _buildViaStack({
    required List<Widget> prefixIcons,
    required List<Widget> suffixIcons,
    required double prefixIconsTotalWidth,
    required double suffixIconsTotalWidth,
    required Widget Function(
      double leftPadding,
      double rightPadding,
    ) childBuilder,
  }) {
    return Stack(
      children: [
        Row(
          children: [
            ...prefixIcons,
            const Expanded(
              child: SizedBox.expand(),
            ),
            ...suffixIcons,
          ],
        ),
        childBuilder.call(
          prefixIconsTotalWidth,
          suffixIconsTotalWidth,
        ),
      ],
    );
  }
}

double _getIconsTotalWidth(
  List<InputBoxIconModel> visibleIcons, {
  required IconType iconType,
  required InputBoxIconsWrapperModel model,
}) {
  if (visibleIcons.isEmpty) {
    return model.outermostSpacingWithoutIcons;
  }

  return model.outermostSpacingWithIcons +
      visibleIcons.mapIndexed((index, iconModel) {
        bool isOutermost = iconType == IconType.prefix && index == 0 ||
            iconType == IconType.suffix && index == visibleIcons.length - 1;
        bool isInnermost =
            iconType == IconType.prefix && index == visibleIcons.length - 1 ||
                iconType == IconType.suffix && index == 0;

        double outermostSpacing = isOutermost ? 0 : model.iconSpacing;
        double iconWidth = iconModel.width;
        double iconSpacingWithDivider = iconModel.hasDivider
            ? model.iconSpacing
            : (isInnermost ? model.innermostSpacingWithoutDivider : 0);
        double dividerWidth = iconModel.hasDivider ? _dividerWidth : 0;
        double dividerInnermostSpacing =
            iconModel.hasDivider && isInnermost ? model.innermostSpacing : 0;

        return outermostSpacing +
            iconWidth +
            iconSpacingWithDivider +
            dividerWidth +
            dividerInnermostSpacing;
      }).reduce((value, width) => value + width);
}

class _InputBoxIcon extends StatelessWidget {
  const _InputBoxIcon.prefix({
    required this.model,
    required this.spacing,
    required this.innermostSpacing,
    required this.innermostSpacingWithoutDivider,
    required this.outermostSpacing,
    required this.isInnermost,
    required this.isOutermost,
    required this.dividerColor,
  }) : iconType = IconType.prefix;

  const _InputBoxIcon.suffix({
    required this.model,
    required this.spacing,
    required this.innermostSpacing,
    required this.innermostSpacingWithoutDivider,
    required this.outermostSpacing,
    required this.isInnermost,
    required this.isOutermost,
    required this.dividerColor,
  }) : iconType = IconType.suffix;

  final InputBoxIconModel model;
  final IconType iconType;
  final double spacing;
  final double innermostSpacing;
  final double innermostSpacingWithoutDivider;
  final double outermostSpacing;
  final bool isInnermost;
  final bool isOutermost;
  final Color dividerColor;

  @override
  Widget build(BuildContext context) {
    if (!model.visible) {
      return const SizedBox.shrink();
    }

    return wrapInGestureDetector(
      onTap: model.onTap,
      child: _wrapInDivider(
        icon: Container(
          width: model.width,
          height: model.height ?? double.infinity,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: _debugMode ? Colors.green : Colors.transparent,
            borderRadius: BorderRadius.all(
              Radius.circular(defaultBorderRadius),
            ),
          ),
          child: model.builder.call(),
        ),
      ),
    );
  }

  Widget _wrapInDivider({required Widget icon}) {
    if (iconType == IconType.prefix) {
      return Row(
        children: [
          Container(
            width: isOutermost ? outermostSpacing : spacing,
            color: _debugMode ? Colors.deepPurpleAccent : Colors.transparent,
          ),
          icon,
          model.hasDivider
              ? Container(
                  width: spacing,
                  color: _debugMode ? Colors.blue : Colors.transparent,
                )
              : (isInnermost
                  ? Container(
                      width: innermostSpacingWithoutDivider,
                      color: _debugMode ? Colors.orange : Colors.transparent,
                    )
                  : const SizedBox.shrink()),
          model.hasDivider ? _divider() : const SizedBox.shrink(),
          model.hasDivider && isInnermost
              ? Container(
                  width: innermostSpacing,
                  color: _debugMode ? Colors.orange : Colors.transparent,
                )
              : const SizedBox.shrink(),
        ],
      );
    }

    return Row(
      children: [
        model.hasDivider && isInnermost
            ? Container(
                width: innermostSpacing,
                color: _debugMode ? Colors.orange : Colors.transparent,
              )
            : const SizedBox.shrink(),
        model.hasDivider ? _divider() : const SizedBox.shrink(),
        model.hasDivider
            ? Container(
                width: spacing,
                color: _debugMode ? Colors.blue : Colors.transparent,
              )
            : (isInnermost
                ? Container(
                    width: innermostSpacingWithoutDivider,
                    color: _debugMode ? Colors.orange : Colors.transparent,
                  )
                : const SizedBox.shrink()),
        icon,
        Container(
          width: isOutermost ? outermostSpacing : spacing,
          color: _debugMode ? Colors.deepPurpleAccent : Colors.transparent,
        ),
      ],
    );
  }

  Widget _divider() {
    return VerticalDivider(
      color: dividerColor,
      indent: 10,
      endIndent: 10,
      width: _dividerWidth,
      thickness: 2,
    );
  }
}
