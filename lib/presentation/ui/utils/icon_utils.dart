import 'package:convertouch/domain/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconUtils {
  static const double defaultIconSize = 25;
  static const String defaultUnitGroupIconAssetName = "unit-group.png";

  const IconUtils._();

  static Image getImage(
    String imageName, {
    double size = defaultIconSize,
  }) {
    return Image.asset(
      "$iconAssetsPathPrefix/$imageName",
      width: size,
      height: size,
    );
  }

  static ImageIcon getIcon(
    String iconName, {
    Color? color,
    double size = defaultIconSize,
  }) {
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
    double size = defaultIconSize,
  }) {
    return SvgPicture.asset(
      "$iconAssetsPathPrefix/$iconName",
      colorFilter: ColorFilter.mode(
        color,
        BlendMode.srcIn,
      ),
      alignment: alignment,
      width: size,
      height: size,
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

  static Widget getItemLogoIcon({
    required String? iconName,
    Color? color,
    double size = defaultIconSize,
  }) {
    return getIcon(
      iconName ?? defaultUnitGroupIconAssetName,
      color: color,
      size: size,
    );
  }
}
