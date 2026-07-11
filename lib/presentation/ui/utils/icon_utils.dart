import 'package:convertouch/domain/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconUtils {
  static const double defaultIconSize = 25;

  const IconUtils._();

  static Image getImage(
    String imageName, {
    double size = defaultIconSize,
  }) {
    String resultIconName = idToIconName[imageName] ?? imageName;

    return Image.asset(
      "$iconAssetsPathPrefix/$resultIconName",
      width: size,
      height: size,
    );
  }

  static Widget getSvgImage(
    String imageName, {
    double? size,
  }) {
    String resultImageName = idToIconName[imageName] ?? imageName;

    return SvgPicture.asset(
      "$iconAssetsPathPrefix/$resultImageName",
      width: size ?? defaultIconSize,
      height: size ?? defaultIconSize,
    );
  }

  static Widget getSvgIcon(
    String iconName, {
    AlignmentGeometry alignment = Alignment.center,
    Color? color,
    double? size,
  }) {
    String resultIconName = idToIconName[iconName] ?? iconName;

    return SvgPicture.asset(
      "$iconAssetsPathPrefix/$resultIconName",
      colorFilter: ColorFilter.mode(
        color ?? Colors.black,
        BlendMode.srcIn,
      ),
      alignment: alignment,
      width: size ?? defaultIconSize,
      height: size ?? defaultIconSize,
    );
  }

  static Widget getGroupIcon({
    String? iconName,
    AlignmentGeometry alignment = Alignment.center,
    Color? color,
    double? size,
  }) {
    return getSvgIcon(
      iconName ?? IconKeys.defaultGroup,
      alignment: alignment,
      color: color,
      size: size,
    );
  }

  static Widget getParamSetIcon({
    String? iconName,
    AlignmentGeometry alignment = Alignment.center,
    Color? color,
    double? size,
  }) {
    return getSvgIcon(
      iconName ?? IconKeys.parameters,
      alignment: alignment,
      color: color,
      size: size,
    );
  }
}
