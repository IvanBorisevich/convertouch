import 'package:collection/collection.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/input_box_icon_model.dart';
import 'package:flutter/material.dart';

const _debugMode = false;
const double _dividerWidth = 2;
const double _innermostSpacing = 7;
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
  final Widget child;

  const InputBoxIconWrapper({
    this.prefixIconsModels = const [],
    this.suffixIconsModels = const [],
    this.iconSpacing,
    this.outermostSpacingWithoutIcons,
    this.outermostSpacingWithIcons,
    this.dividerColor = Colors.transparent,
    required this.child,
    super.key,
  });

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

    return IntrinsicHeight(
      child: Row(
        children: [
          ...(visiblePrefixIconsExist
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
              : [SizedBox(width: resultOutermostSpacingWithoutIcons)]),
          Expanded(child: child),
          ...(visibleSuffixIconsExist
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
              : [SizedBox(width: resultOutermostSpacingWithoutIcons)]),
        ],
      ),
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

  double result = outermostSpacingWithIcons +
      visibleIcons
          .map(
            (iconModel) => iconModel.hasDivider
                ? iconModel.width + _dividerWidth
                : iconModel.width + iconSpacing,
          )
          .reduce((value, width) => value + width);

  InputBoxIconModel innermostIcon =
      iconType == IconType.prefix ? visibleIcons.last : visibleIcons.first;

  if (innermostIcon.hasDivider) {
    result += _innermostSpacing;
  }

  return result;
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
