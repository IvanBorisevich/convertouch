import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/utils/icon_utils.dart';
import 'package:flutter/material.dart';

class ConvertouchAboutDialog extends StatelessWidget {
  final String applicationVersion;
  final String applicationLegalese;
  final SettingsColorScheme colors;

  const ConvertouchAboutDialog({
    required this.applicationLegalese,
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
      backgroundColor: colors.settingItem.background.regular,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 2,
            ),
            child: IconUtils.getImage(
              "app-logo.png",
              size: 35,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appName,
                style: TextStyle(
                  fontSize: 21,
                  color: colors.settingItem.foreground.regular,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0,
                ),
              ),
              Text(
                applicationVersion,
                style: TextStyle(
                  fontSize: 12,
                  color: colors.settingItem.foreground.regular,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  applicationLegalese,
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.settingItem.foreground.regular,
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
              applicationLegalese: applicationLegalese,
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
