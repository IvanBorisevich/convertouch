import 'package:convertouch/di.dart' as di;
import 'package:convertouch/presentation/bloc/common/refresh_button/refresh_button_bloc.dart';
import 'package:convertouch/presentation/bloc/common/refresh_button/refresh_button_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final refreshButtonController = di.locator.get<RefreshButtonController>();

class RefreshButtonController {
  const RefreshButtonController();

  void changeState(
    BuildContext context, {
    required int unitGroupId,
    required bool visible,
    required bool disabled,
  }) {
    BlocProvider.of<RefreshButtonBloc>(context).add(
      visible
          ? ShowRefreshButton(
              unitGroupId: unitGroupId,
              disabled: disabled,
            )
          : HideRefreshButton(unitGroupId: unitGroupId),
    );
  }
}
