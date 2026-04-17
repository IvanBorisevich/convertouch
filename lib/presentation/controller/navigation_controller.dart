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

  void navigateBack(BuildContext context) {
    BlocProvider.of<NavigationBloc>(context).add(
      const NavigateBack(),
    );
  }

  void navigateTo(
    BuildContext context, {
    required PageName pageName,
    bool replace = false,
  }) {
    BlocProvider.of<NavigationBloc>(context).add(
      NavigateToPage(
        pageName: pageName,
        replace: replace,
      ),
    );
  }

  void showException(
    BuildContext context, {
    required ConvertouchException exception,
  }) {
    BlocProvider.of<NavigationBloc>(context).add(
      ShowException(exception: exception),
    );
  }
}
