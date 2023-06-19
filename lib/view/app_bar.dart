import 'package:convertouch/model/app_bar_action.dart';
import 'package:convertouch/model/app_bar_button_side.dart';
import 'package:convertouch/model/util/app_util.dart';
import 'package:convertouch/presenter/bloc/app_bar_buttons_bloc.dart';
import 'package:convertouch/presenter/bloc/app_bloc.dart';
import 'package:convertouch/presenter/states/app_bar_button_state.dart';
import 'package:convertouch/presenter/states/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchAppBar extends StatelessWidget {
  const ConvertouchAppBar({super.key});

  static const Map<ConvertouchAction, IconData> appBarIconMap = {
    ConvertouchAction.menu: Icons.menu,
    ConvertouchAction.apply: Icons.check,
    ConvertouchAction.select: Icons.check,
    ConvertouchAction.remove: Icons.delete_outline_rounded,
    ConvertouchAction.back: Icons.arrow_back_rounded,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: const BoxDecoration(
        color: Color(0xFFDEE9FF),
      ),
      child: Row(
        children: [
          _buildAppBarButton(context, AppBarButtonSide.left),
          _buildAppBarTitle(),
          _buildAppBarButton(context, AppBarButtonSide.right),
        ],
      ),
    );
  }

  Widget _buildAppBarButton(BuildContext context, AppBarButtonSide appBarButtonSide) {
    return BlocBuilder<AppBarButtonsBloc, AppBarButtonState>(
        builder: (_, appBarButtonState) {
      return Container(
        width: 55,
        alignment: Alignment.center,
        child: Visibility(
          visible: appBarButtonState.isButtonVisible &&
              appBarButtonState.buttonSide == appBarButtonSide,
          child: IconButton(
            icon: Icon(
              appBarIconMap[appBarButtonState.buttonAction],
              color: const Color(0xFF426F99),
            ),
            onPressed: () { },
          ),
        ),
      );
    });
  }

  Widget _buildAppBarTitle() {
    return BlocBuilder<AppBloc, AppState>(builder: (_, appState) {
      return Expanded(
        child: Container(
          alignment: Alignment.center,
          child: Text(
            getPageTitle(appState.pageId),
            style: const TextStyle(
                color: Color(0xFF426F99),
                fontSize: 20,
                fontWeight: FontWeight.w600),
          ),
        ),
      );
    });
  }
}
