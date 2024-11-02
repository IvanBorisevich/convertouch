import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/menu_item.dart';
import 'package:flutter/material.dart';

class BottomLoader extends StatelessWidget {
  final void Function()? onTap;
  final ListItemColorScheme? colors;

  const BottomLoader({
    this.onTap,
    this.colors,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: colors?.background.regular,
            borderRadius: BorderRadius.circular(
              ConvertouchMenuItem.defaultBorderRadius,
            ),
          ),
          child: Icon(
            Icons.refresh_rounded,
            color: colors?.foreground.regular,
            size: 24,
          ),
        ),
      ),
    );
  }
}
