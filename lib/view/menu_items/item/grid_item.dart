import 'package:convertouch/model/app_bar_action.dart';
import 'package:convertouch/model/app_bar_button_side.dart';
import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/item_model.dart';
import 'package:convertouch/model/item_type.dart';
import 'package:convertouch/model/util/menu_items_util.dart';
import 'package:convertouch/presenter/bloc/app_bar_buttons_bloc.dart';
import 'package:convertouch/presenter/bloc/app_bloc.dart';
import 'package:convertouch/presenter/bloc/menu_items_bloc.dart';
import 'package:convertouch/presenter/events/app_bar_button_event.dart';
import 'package:convertouch/presenter/events/app_event.dart';
import 'package:convertouch/presenter/events/menu_items_fetch_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchGridItem extends StatelessWidget {
  const ConvertouchGridItem(this.item, {super.key});

  final ItemModel item;

  Widget buildUnitGroupIconButton() {
    return IconButton(
      onPressed: null,
      icon: ImageIcon(
        AssetImage(getIconPath(item)),
        color: const Color(0xFF366C9F),
        size: 35,
      ),
    );
  }

  Widget buildUnitItemAbbreviation() {
    return Center(
      child: Text(
        toUnit(item).abbreviation,
        style: const TextStyle(
          fontFamily: quicksandFontFamily,
          fontWeight: FontWeight.w700,
          color: Color(0xFF366C9F),
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (item.itemType == ItemType.unitGroup) {
          BlocProvider.of<AppBloc>(context).add(const AppEvent(
              isSearchBarVisible: true,
              isFloatingButtonVisible: true,
              nextPageId: unitItemsPageId));
          BlocProvider.of<AppBarButtonsBloc>(context).add(
              const AppBarButtonEvent(
                  buttonAction: ConvertouchAction.back,
                  buttonSide: AppBarButtonSide.left,
                  isButtonEnabled: true));
          BlocProvider.of<MenuItemsBloc>(context)
              .add(const MenuItemsFetchEvent(ItemType.unit));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF2F5FF),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFC9D5EA),
          ),
        ),
        child: Column(
          children: [
            Flexible(
              flex: 5,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                child: LayoutBuilder(builder: (context, constraints) {
                  if (item.itemType == ItemType.unitGroup) {
                    return buildUnitGroupIconButton();
                  } else {
                    return buildUnitItemAbbreviation();
                  }
                }),
              ),
            ),
            Flexible(
              flex: 3,
              child: Container(
                padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                child: Text(
                  item.name,
                  style: const TextStyle(
                    fontFamily: quicksandFontFamily,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF366C9F),
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: getGridItemNameLinesNumToWrap(item.name),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
