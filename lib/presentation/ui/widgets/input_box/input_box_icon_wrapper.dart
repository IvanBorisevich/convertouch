import 'package:convertouch/presentation/ui/widgets/input_box/input_box_icon.dart';
import 'package:flutter/material.dart';

const double _dividerSpacing = 7;
const double _iconSpacing = 10;
const double _dividerWidth = 2;
const double _childSpacingWithoutIcons = 15;

class InputBoxIconWrapper extends StatelessWidget {
  final List<InputBoxIconModel> prefixIconsModels;
  final List<InputBoxIconModel> suffixIconsModels;
  final Color dividerColor;
  final Widget child;

  const InputBoxIconWrapper({
    this.prefixIconsModels = const [],
    this.suffixIconsModels = const [],
    this.dividerColor = Colors.transparent,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double prefixIconsTotalWidth = _getIconsTotalWidth(prefixIconsModels);
    double suffixIconsTotalWidth = _getIconsTotalWidth(suffixIconsModels);

    bool visiblePrefixIconsExist =
        prefixIconsModels.isNotEmpty && prefixIconsTotalWidth > 0;
    bool visibleSuffixIconsExist =
        suffixIconsModels.isNotEmpty && suffixIconsTotalWidth > 0;

    return IntrinsicHeight(
      child: Row(
        children: [
          ...(visiblePrefixIconsExist
              ? prefixIconsModels
                  .map(
                    (model) => _InputBoxIcon.prefix(
                      model: model,
                      dividerColor: dividerColor,
                    ),
                  )
                  .toList()
              : [const SizedBox.shrink()]),
          visiblePrefixIconsExist
              ? const SizedBox(width: _iconSpacing)
              : const SizedBox(width: _childSpacingWithoutIcons),
          Expanded(child: child),
          visibleSuffixIconsExist
              ? const SizedBox(width: _iconSpacing)
              : const SizedBox(width: _childSpacingWithoutIcons),
          ...(visibleSuffixIconsExist
              ? suffixIconsModels
                  .map(
                    (model) => _InputBoxIcon.suffix(
                      model: model,
                      dividerColor: dividerColor,
                    ),
                  )
                  .toList()
              : [const SizedBox.shrink()]),
        ],
      ),
    );
  }
}

double _getIconsTotalWidth(List<InputBoxIconModel> icons) {
  final visibleIcons = icons.where((item) => item.visible);

  if (visibleIcons.isEmpty) {
    return 0;
  }

  return visibleIcons
      .map((item) => item.width)
      .reduce((value, width) => value + width);
}

class _InputBoxIcon extends StatelessWidget {
  const _InputBoxIcon.prefix({
    required this.model,
    this.dividerColor = Colors.transparent,
  }) : iconType = IconType.prefix;

  const _InputBoxIcon.suffix({
    required this.model,
    this.dividerColor = Colors.transparent,
  }) : iconType = IconType.suffix;

  final InputBoxIconModel model;
  final IconType iconType;
  final Color dividerColor;

  @override
  Widget build(BuildContext context) {
    if (!model.visible) {
      return const SizedBox.shrink();
    }

    return _wrapInGestureDetector(
      child: _wrapInDivider(
        child: Container(
          width: model.width,
          height: model.height ?? double.infinity,
          padding: EdgeInsets.only(
            left: iconType == IconType.prefix ? _iconSpacing : 0,
            right: iconType == IconType.suffix ? _iconSpacing : 0,
          ),
          decoration: const BoxDecoration(
            // color: Colors.green,
            color: Colors.transparent,
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

  Widget _wrapInDivider({required Widget child}) {
    if (!model.hasDivider) {
      return child;
    }

    if (iconType == IconType.suffix) {
      return Row(
        children: [
          _divider(),
          const SizedBox(width: _dividerSpacing),
          child,
        ],
      );
    }

    return Row(
      children: [
        child,
        const SizedBox(width: _dividerSpacing),
        _divider(),
      ],
    );
  }

  VerticalDivider _divider() {
    return VerticalDivider(
      color: dividerColor,
      indent: 10,
      endIndent: 10,
      width: _dividerWidth,
      thickness: 2,
    );
  }
}
