import 'package:flutter/material.dart';

const double inputBoxIconDefaultWidth = 40;
const double defaultBorderRadius = 15;

Widget _emptyBuilder() => const SizedBox.shrink();

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

  const ConvertouchInputBoxIcon.empty({
    this.visible = true,
    super.key,
  })  : iconType = IconType.prefix,
        width = 12,
        height = null,
        onTap = null,
        builder = _emptyBuilder,
        dividerVisible = false,
        dividerColor = Colors.transparent;

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

    return Row(
      children: [
        dividerVisible && iconType == IconType.suffix
            ? _divider()
            : const SizedBox.shrink(),
        _wrapInGestureDetector(
          child: Container(
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
        ),
        dividerVisible && iconType == IconType.prefix
            ? _divider()
            : const SizedBox.shrink(),
      ],
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

  Widget _divider() {
    return VerticalDivider(
      color: dividerColor,
      indent: 10,
      endIndent: 10,
      width: 2,
      thickness: 2,
    );
  }
}
