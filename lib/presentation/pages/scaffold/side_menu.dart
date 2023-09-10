import 'package:convertouch/domain/constants.dart';
import 'package:convertouch/presentation/pages/style/model/side_menu_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConvertouchSideMenu extends StatelessWidget {
  final ConvertouchSideMenuColors colors;

  const ConvertouchSideMenu({
    required this.colors,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          color: colors.backgroundColor,
        ),
        child: Column(
          children: <Widget>[
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: colors.headerColor,
              ),
              child: Center(
                child: Text(
                  appName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: colors.contentColor,
                  ),
                ),
              ),
              // onTap: () {
              //   Navigator.of(context).pop();
              // }
            ),
            const SizedBox(height: 8),
            ConvertouchSideMenuItem(
              leadingIconData: Icons.dark_mode_outlined,
              trailing: Switch(
                value: true,
                activeTrackColor: colors.headerColor,
                activeColor: colors.activeSwitcherColor,
                onChanged: (bool value) {},
              ),
              contentColor: colors.contentColor,
              title: "Dark Mode",
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            ConvertouchSideMenuItem(
              leadingIconData: Icons.settings,
              title: "Settings",
              contentColor: colors.contentColor,
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            ConvertouchSideMenuItem(
              leadingIconData: Icons.exit_to_app,
              title: "Exit",
              contentColor: colors.contentColor,
              onTap: () {
                SystemNavigator.pop();
              },
            ),
            Expanded(child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Divider(color: colors.footerDividerColor),
                    const SizedBox(height: 7),
                    Text("v.1.0.0", style: TextStyle(
                      color: colors.contentColor,
                      fontWeight: FontWeight.w600,
                    ),),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class ConvertouchSideMenuItem extends StatelessWidget {
  final IconData leadingIconData;
  final String title;
  final Color contentColor;
  final Widget? trailing;
  final double padding;
  final double paddingBetweenSpaceAndTitle;
  final void Function()? onTap;

  const ConvertouchSideMenuItem({
    required this.leadingIconData,
    required this.title,
    required this.contentColor,
    this.trailing,
    this.padding = 5,
    this.paddingBetweenSpaceAndTitle = 5,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.fromLTRB(padding, 0, padding, padding),
        child: Row(
          children: [
            IconButton(
              onPressed: null,
              icon: Icon(
                leadingIconData,
                color: contentColor,
              ),
            ),
            SizedBox(width: paddingBetweenSpaceAndTitle),
            Text(
              title,
              style: TextStyle(
                color: contentColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: trailing,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
