import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
import 'package:convertouch/presentation/ui/widgets/svg_icon.dart';
import 'package:flutter/material.dart';

final _appLegalese = "© ${DateTime.now().year} johnbor7";

class ConvertouchAboutDialog extends StatelessWidget {
  final String applicationVersion;
  final SettingItemColorScheme colors;

  const ConvertouchAboutDialog({
    required this.applicationVersion,
    required this.colors,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      backgroundColor: colors.background.regular,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 2,
            ),
            child: ConvertouchSvgIcon(
              uri: IconKeys.appLogo,
              size: 45,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appName,
                style: TextStyle(
                  fontSize: 21,
                  color: colors.foreground.regular,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0,
                ),
              ),
              Text(
                applicationVersion,
                style: TextStyle(
                  fontSize: 14,
                  color: colors.foreground.regular,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  _appLegalese,
                  style: TextStyle(
                    fontSize: 14,
                    color: colors.foreground.regular,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      titlePadding: const EdgeInsets.only(
        top: 10,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 10),
      actionsPadding: const EdgeInsets.only(
        right: 10,
        bottom: 5,
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'View Licenses',
            style: TextStyle(
              color: colors.selectedValue.regular,
              fontWeight: FontWeight.w600,
            ),
          ),
          onPressed: () {
            showLicensePage(
              context: context,
              applicationName: appName,
              applicationVersion: applicationVersion,
              applicationLegalese: _appLegalese,
            );
          },
        ),
        TextButton(
          child: Text(
            'Close',
            style: TextStyle(
              color: colors.selectedValue.regular,
              fontWeight: FontWeight.w600,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
