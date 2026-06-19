import 'package:convertouch/presentation/controller/navigation_controller.dart';
import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
import 'package:flutter/material.dart';

class ConvertouchPage extends StatelessWidget {
  final Widget body;
  final String? title;
  final Widget? titleWidget;
  final Widget? appBarLeadingWidget;
  final List<Widget>? appBarTrailingWidgets;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation floatingButtonLocation;
  final PageColorScheme colors;
  final Function()? onBackIconTap;

  const ConvertouchPage({
    required this.body,
    this.title,
    this.titleWidget,
    this.appBarLeadingWidget,
    this.appBarTrailingWidgets,
    this.floatingActionButton,
    this.floatingButtonLocation = FloatingActionButtonLocation.endFloat,
    required this.colors,
    this.onBackIconTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: colors.body.background.regular,
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          elevation: 0,
          leading: Builder(
            builder: (context) {
              if (appBarLeadingWidget != null) {
                return appBarLeadingWidget!;
              } else if (ModalRoute.of(context)?.canPop == true) {
                return IconButton(
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: colors.appBar.foreground.regular,
                  ),
                  onPressed: onBackIconTap ??
                      () {
                        navigationController.navigateBack(context);
                      },
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
          centerTitle: true,
          title: titleWidget ??
              (title != null
                  ? Text(
                      title!,
                      style: TextStyle(
                        color: colors.appBar.foreground.regular,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : null),
          actions: appBarTrailingWidgets,
        ),
        body: body,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(right: 20, bottom: 15),
          child: floatingActionButton,
        ),
        floatingActionButtonLocation: floatingButtonLocation,
      ),
    );
  }
}
