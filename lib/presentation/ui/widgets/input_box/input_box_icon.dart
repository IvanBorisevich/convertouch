import 'package:flutter/material.dart';

const double inputBoxIconDefaultWidth = 40;
const double defaultBorderRadius = 15;
const double inputBoxIconSpacing = 7;
const double _dividerWidth = 2;

enum IconType {
  prefix,
  suffix,
}

class ConvertouchInputBoxIcon extends StatelessWidget {
  const ConvertouchInputBoxIcon.prefix({
    required this.builder,
    this.width = inputBoxIconDefaultWidth,
    this.height,
    this.visible = true,
    this.dividerVisible = true,
    this.dividerColor = Colors.transparent,
    this.onTap,
    super.key,
  }) : iconType = IconType.prefix;

  const ConvertouchInputBoxIcon.suffix({
    required this.builder,
    this.width = inputBoxIconDefaultWidth,
    this.height,
    this.visible = true,
    this.dividerVisible = true,
    this.dividerColor = Colors.transparent,
    this.onTap,
    super.key,
  }) : iconType = IconType.suffix;

  final Widget Function() builder;
  final IconType iconType;
  final double width;
  final double? height;
  final bool visible;
  final bool dividerVisible;
  final Color dividerColor;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    if (!visible) {
      return const SizedBox.shrink();
    }

    return _wrapInGestureDetector(
      child: Row(
        children: [
          dividerVisible && iconType == IconType.suffix
              ? _divider()
              : const SizedBox.shrink(),
          Container(
            width: width,
            height: height ?? double.infinity,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              // color: Colors.green,
              color: Colors.transparent,
              borderRadius: BorderRadius.all(
                Radius.circular(defaultBorderRadius),
              ),
            ),
            child: builder.call(),
          ),
          dividerVisible && iconType == IconType.prefix
              ? _divider()
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _wrapInGestureDetector({required Widget child}) {
    return onTap != null
        ? GestureDetector(
            onTap: onTap,
            child: child,
          )
        : child;
  }

  Widget _divider({
    EdgeInsets padding = EdgeInsets.zero,
  }) {
    return Padding(
      padding: padding,
      child: VerticalDivider(
        color: dividerColor,
        indent: 10,
        endIndent: 10,
        width: _dividerWidth,
        thickness: 2,
      ),
    );
  }
}

Widget _defaultBuilder() => const SizedBox.shrink();

class InputBoxIconModel {
  final IconType? iconType;
  final double width;
  final double? height;
  final bool visible;
  final Widget Function() builder;
  final void Function()? onTap;

  const InputBoxIconModel.prefix({
    required this.width,
    this.height,
    required this.builder,
    this.visible = true,
    this.onTap,
  }) : iconType = IconType.prefix;

  const InputBoxIconModel.suffix({
    required this.width,
    this.height,
    required this.builder,
    this.visible = true,
    this.onTap,
  }) : iconType = IconType.suffix;

  const InputBoxIconModel.divider({
    this.visible = true,
  })  : iconType = null,
        width = _dividerWidth,
        height = null,
        builder = _defaultBuilder,
        onTap = null;
}
