import 'package:collection/collection.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/input_box_icon_model.dart';
import 'package:flutter/material.dart';

const _debugMode = true;
const double _dividerWidth = 2;
const double _innermostSpacing = 10;
const double _defaultIconSpacing = 5;
const double _defaultOutermostSpacingWithoutIcons = 12;
const double _defaultOutermostSpacingWithIcons = 7;
const double defaultBorderRadius = 15;

class InputBoxIconWrapper extends StatelessWidget {
  final List<InputBoxIconModel> prefixIconsModels;
  final List<InputBoxIconModel> suffixIconsModels;
  final double? iconSpacing;
  final double? outermostSpacingWithoutIcons;
  final double? outermostSpacingWithIcons;
  final Color dividerColor;
  final Widget? child;
  final Widget Function(double leftPadding, double rightPadding)? childBuilder;

  const InputBoxIconWrapper({
    this.prefixIconsModels = const [],
    this.suffixIconsModels = const [],
    this.iconSpacing,
    this.outermostSpacingWithoutIcons,
    this.outermostSpacingWithIcons,
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
    double resultIconSpacing = iconSpacing ?? _defaultIconSpacing;
    double resultOutermostSpacingWithoutIcons =
        outermostSpacingWithoutIcons ?? _defaultOutermostSpacingWithoutIcons;
    double resultOutermostSpacingWithIcons =
        outermostSpacingWithIcons ?? _defaultOutermostSpacingWithIcons;

    final visiblePrefixIconsModels =
        prefixIconsModels.where((iconModel) => iconModel.visible).toList();
    final visibleSuffixIconsModels =
        suffixIconsModels.where((iconModel) => iconModel.visible).toList();

    double prefixIconsTotalWidth = _getIconsTotalWidth(
      visiblePrefixIconsModels,
      iconType: IconType.prefix,
      iconSpacing: resultIconSpacing,
      outermostSpacingWithoutIcons: resultOutermostSpacingWithoutIcons,
      outermostSpacingWithIcons: resultOutermostSpacingWithIcons,
    );

    double suffixIconsTotalWidth = _getIconsTotalWidth(
      visibleSuffixIconsModels,
      iconType: IconType.suffix,
      iconSpacing: resultIconSpacing,
      outermostSpacingWithoutIcons: resultOutermostSpacingWithoutIcons,
      outermostSpacingWithIcons: resultOutermostSpacingWithIcons,
    );

    bool visiblePrefixIconsExist = visiblePrefixIconsModels.isNotEmpty;
    bool visibleSuffixIconsExist = visibleSuffixIconsModels.isNotEmpty;

    List<Widget> prefixIcons = visiblePrefixIconsExist
        ? visiblePrefixIconsModels
            .mapIndexed(
              (index, model) => _InputBoxIcon.prefix(
                model: model,
                spacing: resultIconSpacing,
                outermostSpacing: resultOutermostSpacingWithIcons,
                isInnermost: index == visiblePrefixIconsModels.length - 1,
                isOutermost: index == 0,
                dividerColor: dividerColor,
              ),
            )
            .toList()
        : [SizedBox(width: resultOutermostSpacingWithoutIcons)];

    List<Widget> suffixIcons = visibleSuffixIconsExist
        ? visibleSuffixIconsModels
            .mapIndexed(
              (index, model) => _InputBoxIcon.suffix(
                model: model,
                spacing: resultIconSpacing,
                outermostSpacing: resultOutermostSpacingWithIcons,
                isInnermost: index == 0,
                isOutermost: index == visibleSuffixIconsModels.length - 1,
                dividerColor: dividerColor,
              ),
            )
            .toList()
        : [SizedBox(width: resultOutermostSpacingWithoutIcons)];

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
  required double iconSpacing,
  required double outermostSpacingWithoutIcons,
  required double outermostSpacingWithIcons,
}) {
  if (visibleIcons.isEmpty) {
    return outermostSpacingWithoutIcons;
  }

  return outermostSpacingWithIcons +
      visibleIcons.mapIndexed((index, iconModel) {
        bool isOutermost = iconType == IconType.prefix && index == 0 ||
            iconType == IconType.suffix && index == visibleIcons.length - 1;
        bool isInnermost =
            iconType == IconType.prefix && index == visibleIcons.length - 1 ||
                iconType == IconType.suffix && index == 0;

        double outermostSpacing = isOutermost ? 0 : iconSpacing;
        double iconWidth = iconModel.width;
        double dividerSpacing = iconModel.hasDivider
            ? iconSpacing
            : (isInnermost ? _innermostSpacing : 0);
        double dividerWidth = iconModel.hasDivider ? _dividerWidth : 0;
        double innermostSpacing =
            iconModel.hasDivider && isInnermost ? _innermostSpacing : 0;

        return outermostSpacing +
            iconWidth +
            dividerSpacing +
            dividerWidth +
            innermostSpacing;
      }).reduce((value, width) => value + width);
}

class _InputBoxIcon extends StatelessWidget {
  const _InputBoxIcon.prefix({
    required this.model,
    required this.spacing,
    required this.outermostSpacing,
    required this.isInnermost,
    required this.isOutermost,
    required this.dividerColor,
  }) : iconType = IconType.prefix;

  const _InputBoxIcon.suffix({
    required this.model,
    required this.spacing,
    required this.outermostSpacing,
    required this.isInnermost,
    required this.isOutermost,
    required this.dividerColor,
  }) : iconType = IconType.suffix;

  final InputBoxIconModel model;
  final IconType iconType;
  final double spacing;
  final double outermostSpacing;
  final bool isInnermost;
  final bool isOutermost;
  final Color dividerColor;

  @override
  Widget build(BuildContext context) {
    if (!model.visible) {
      return const SizedBox.shrink();
    }

    return _wrapInGestureDetector(
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

  Widget _wrapInGestureDetector({required Widget child}) {
    return model.onTap != null
        ? GestureDetector(
            onTap: model.onTap,
            child: child,
          )
        : child;
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
                      width: _innermostSpacing,
                      color: _debugMode ? Colors.orange : Colors.transparent,
                    )
                  : const SizedBox.shrink()),
          model.hasDivider ? _divider() : const SizedBox.shrink(),
          model.hasDivider && isInnermost
              ? Container(
                  width: _innermostSpacing,
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
                width: _innermostSpacing,
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
                    width: _innermostSpacing,
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
