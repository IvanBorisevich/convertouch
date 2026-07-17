import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/utils/string_utils.dart';
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

  static Widget getSvgIcon(
    String iconUri, {
    AlignmentGeometry alignment = Alignment.center,
    Color? color,
    double? size,
  }) {
    String resultIconUri = idToIconName[iconUri] ?? iconUri;

    if (StringUtils.isUrl(resultIconUri)) {
      return SvgPicture.network(
        resultIconUri,
        width: size ?? defaultIconSize,
        height: size ?? defaultIconSize,
        alignment: alignment,
        colorFilter: color != null
            ? ColorFilter.mode(
                color,
                BlendMode.srcIn,
              )
            : null,
      );
    }

    return SvgPicture.asset(
      "$iconAssetsPathPrefix/$resultIconUri",
      width: size ?? defaultIconSize,
      height: size ?? defaultIconSize,
      alignment: alignment,
      colorFilter: color != null
          ? ColorFilter.mode(
              color,
              BlendMode.srcIn,
            )
          : null,
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
