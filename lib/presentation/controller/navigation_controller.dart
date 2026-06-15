import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final navigationController = di.locator.get<NavigationController>();

class NavigationController {
  const NavigationController();

  void navigateBack(BuildContext context, {bool closeUiElements = false}) {
    BlocProvider.of<NavigationBloc>(context).add(
      NavigateBack(closeUiElements: closeUiElements),
    );
  }

  void navigateTo(
    BuildContext context, {
    required PageName pageName,
    bool replace = false,
    bool closeUiElements = false,
  }) {
    BlocProvider.of<NavigationBloc>(context).add(
      NavigateToPage(
        targetPageName: pageName,
        replace: replace,
        closeUiElements: closeUiElements,
      ),
    );
  }

  void showException(
    BuildContext context, {
    required ConvertouchException exception,
    bool closeUiElements = false,
  }) {
    BlocProvider.of<NavigationBloc>(context).add(
      ShowException(
        exception: exception,
        closeUiElements: closeUiElements,
      ),
    );
  }
}
