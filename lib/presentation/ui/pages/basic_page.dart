import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_events.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchPage extends StatelessWidget {
  final Widget body;
  final String title;
  final Widget? customLeadingIcon;
  final List<Widget>? appBarRightWidgets;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation floatingButtonLocation;
  final void Function()? onItemsRemove;

  const ConvertouchPage({
    required this.body,
    required this.title,
    this.customLeadingIcon,
    this.appBarRightWidgets,
    this.floatingActionButton,
    this.floatingButtonLocation = FloatingActionButtonLocation.endFloat,
    this.onItemsRemove,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return appBlocBuilder(
      builderFunc: (appState) {
        PageColorScheme pageColorScheme = pageColors[appState.theme]!;
        return SafeArea(
          child: Scaffold(
            backgroundColor: pageColorScheme.page.background.regular,
            appBar: AppBar(
              leading: Builder(
                builder: (context) {
                  if (customLeadingIcon != null) {
                    return customLeadingIcon!;
                  } else if (ModalRoute.of(context)?.canPop == true) {
                    return IconButton(
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: pageColorScheme.appBar.foreground.regular,
                      ),
                      onPressed: () {
                        BlocProvider.of<NavigationBloc>(context).add(
                          const NavigateBack(),
                        );
                      },
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
              centerTitle: true,
              title: Text(
                title,
                style: TextStyle(
                  color: pageColorScheme.appBar.foreground.regular,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: pageColorScheme.appBar.background.regular,
              elevation: 0,
              actions: appBarRightWidgets,
            ),
            body: body,
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 15),
              child: floatingActionButton,
            ),
            floatingActionButtonLocation: floatingButtonLocation,
          ),
        );
      },
    );
  }
}
