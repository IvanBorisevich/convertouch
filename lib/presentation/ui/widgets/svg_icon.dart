import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

const double _defaultIconSize = 25;

class ConvertouchSvgIcon extends StatelessWidget {
  final String uri;
  final String? defaultUri;
  final double? size;
  final Color? color;
  final Color? defaultColor;
  final AlignmentGeometry alignment;

  const ConvertouchSvgIcon({
    required this.uri,
    this.defaultUri,
    this.size,
    this.color,
    this.defaultColor,
    this.alignment = Alignment.center,
    super.key,
  });

  const ConvertouchSvgIcon.group({
    String? iconUri,
    this.size,
    this.color,
    this.defaultColor,
    this.alignment = Alignment.center,
    super.key,
  })  : uri = iconUri ?? IconKeys.defaultGroup,
        defaultUri = IconKeys.defaultGroup;

  const ConvertouchSvgIcon.paramSet({
    String? iconUri,
    this.size,
    this.color,
    this.defaultColor,
    this.alignment = Alignment.center,
    super.key,
  })  : uri = iconUri ?? IconKeys.parameters,
        defaultUri = IconKeys.parameters;

  @override
  Widget build(BuildContext context) {
    String? resultIconUri = idToIconName[uri] ?? uri;

    if (StringUtils.isUrl(resultIconUri)) {
      return FutureBuilder<String>(
        future: _getSvgIconMarkupFromNetwork(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.hasError ||
              !snapshot.hasData) {
            String? resultDefaultIconUri =
                idToIconName[defaultUri] ?? defaultUri;

            return _getSvgIconFromAsset(
              resultDefaultIconUri,
              color: color ?? defaultColor,
            );
          }

          return _getSvgIconFromString(snapshot.data!);
        },
      );
    }

    return _getSvgIconFromAsset(
      resultIconUri,
      color: color ?? defaultColor,
    );
  }

  Future<String> _getSvgIconMarkupFromNetwork() async {
    final response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load SVG icon from network');
    }
  }

  Widget _getSvgIconFromString(String markup) {
    return SvgPicture.string(
      markup,
      width: size ?? _defaultIconSize,
      height: size ?? _defaultIconSize,
      alignment: alignment,
      colorFilter: color != null
          ? ColorFilter.mode(
              color!,
              BlendMode.srcIn,
            )
          : null,
    );
  }

  Widget _getSvgIconFromAsset(String? iconUri, {Color? color}) {
    String? resultIconUri = idToIconName[iconUri] ?? iconUri;

    if (resultIconUri == null) {
      return const SizedBox.shrink();
    }

    return SvgPicture.asset(
      "$iconAssetsPathPrefix/$resultIconUri",
      width: size ?? _defaultIconSize,
      height: size ?? _defaultIconSize,
      alignment: alignment,
      colorFilter: color != null
          ? ColorFilter.mode(
              color,
              BlendMode.srcIn,
            )
          : null,
    );
  }
}
