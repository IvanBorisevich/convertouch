import 'package:convertouch/domain/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconUtils {
  static const double defaultIconSize = 25;
  static const IconData defaultUnitGroupIconData =
      Icons.dashboard_customize_outlined;
  static const String defaultUnitGroupIconAssetName = "unit-group.png";

  const IconUtils._();

  static ImageIcon? getIcon(
    String? iconName, {
    Color? color,
    double size = defaultIconSize,
  }) {
    if (iconName == null) {
      return null;
    }
    return ImageIcon(
      AssetImage(
        "$iconAssetsPathPrefix/$iconName",
      ),
      color: color,
      size: size,
    );
  }

  static Widget getSvgIcon(
    String iconName, {
    Color color = Colors.black,
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return SvgPicture.asset(
      "$iconAssetsPathPrefix/$iconName",
      colorFilter: ColorFilter.mode(
        color,
        BlendMode.srcIn,
      ),
      alignment: alignment,
      width: defaultIconSize,
    );
  }

  static Widget getSuffixSvgIcon(
    String iconName, {
    Color color = Colors.black,
  }) {
    return getSvgIcon(
      iconName,
      color: color,
      alignment: Alignment.centerRight,
    );
  }

  static Widget getUnitGroupIcon({
    String? iconName,
    IconData iconData = defaultUnitGroupIconData,
    Color? color,
    double size = defaultIconSize,
  }) {
    return getIcon(
          iconName ?? defaultUnitGroupIconAssetName,
          color: color,
          size: size,
        ) ??
        Icon(
          iconData,
          color: color,
          size: size,
        );
  }
}
