import 'package:convertouch/presentation/bloc/side_menu/side_menu_bloc.dart';
import 'package:convertouch/presentation/bloc/side_menu/side_menu_events.dart';
import 'package:convertouch/presentation/bloc/side_menu/side_menu_states.dart';
import 'package:convertouch/presentation/pages/style/model/side_menu_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchSideMenu extends StatefulWidget {
  final ConvertouchSideMenuColors colors;
  final double headerHeight;
  final double widthPercentage;

  const ConvertouchSideMenu({
    required this.colors,
    this.headerHeight = 50,
    this.widthPercentage = 0.8,
    super.key,
  });

  @override
  State createState() => _ConvertouchSideMenuState();
}

class _ConvertouchSideMenuState extends State<ConvertouchSideMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _sideMenuAnimationController;
  late CurvedAnimation _curvedAnimation;

  @override
  void initState() {
    super.initState();
    _sideMenuAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _curvedAnimation = CurvedAnimation(
      parent: _sideMenuAnimationController,
      curve: Curves.linear,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double pageWidth = MediaQuery.of(context).size.width;
    return BlocBuilder<SideMenuBloc, SideMenuState>(
      builder: (_, sideMenuState) {
        if (sideMenuState is SideMenuOpened) {
          _sideMenuAnimationController.forward();
        } else if (sideMenuState is SideMenuClosed) {
          _sideMenuAnimationController.reverse();
        }
        return GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.velocity.pixelsPerSecond.dx < 0) {
              BlocProvider.of<SideMenuBloc>(context).add(
                const CloseSideMenu(),
              );
            }
          },
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1, 0),
              end: Offset.zero,
            ).animate(_curvedAnimation),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      BlocProvider.of<SideMenuBloc>(context).add(
                        const CloseSideMenu(),
                      );
                    },
                    child: Container(
                      width: pageWidth,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  Container(
                    width: pageWidth * widget.widthPercentage,
                    decoration: BoxDecoration(
                      color: widget.colors.backgroundColor,
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: widget.headerHeight,
                          decoration: BoxDecoration(
                            color: widget.colors.headerColor,
                          ),
                          child: Center(
                            child: Text(
                              "Menu",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w600,
                                color: widget.colors.contentColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ConvertouchSideMenuItem(
                          leadingIconData: Icons.dark_mode_outlined,
                          trailing: Switch(
                            value: true,
                            activeTrackColor: widget.colors.headerColor,
                            activeColor: widget.colors.activeSwitcherColor,
                            onChanged: (bool value) {},
                          ),
                          contentColor: widget.colors.contentColor,
                          title: "Dark Mode",
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        ConvertouchSideMenuItem(
                          leadingIconData: Icons.settings,
                          title: "Settings",
                          contentColor: widget.colors.contentColor,
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        ConvertouchSideMenuItem(
                          leadingIconData: Icons.exit_to_app,
                          title: "Exit",
                          contentColor: widget.colors.contentColor,
                          onTap: () {
                            SystemNavigator.pop();
                          },
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Divider(color: widget.colors.footerDividerColor),
                                  const SizedBox(height: 7),
                                  Text(
                                    "v.1.0.0",
                                    style: TextStyle(
                                      color: widget.colors.contentColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _sideMenuAnimationController.dispose();
    super.dispose();
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
