import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_bloc.dart';
import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_events.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:flutter/material.dart';

class CancelItemsSelectionIcon extends StatelessWidget {
  final ItemsSelectionBloc bloc;
  final PageColorScheme pageColorScheme;

  const CancelItemsSelectionIcon({
    required this.bloc,
    required this.pageColorScheme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.clear,
        color: pageColorScheme.appBar.foreground.regular,
      ),
      onPressed: () {
        bloc.add(
          const CancelItemsMarking(),
        );
      },
    );
  }
}
