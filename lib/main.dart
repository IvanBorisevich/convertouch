import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/item_type.dart';
import 'package:convertouch/presenter/bloc/app_bar_buttons_bloc.dart';
import 'package:convertouch/presenter/bloc/converted_items_bloc.dart';
import 'package:convertouch/presenter/bloc/menu_view_bloc.dart';
import 'package:convertouch/presenter/bloc/menu_items_bloc.dart';
import 'package:convertouch/presenter/bloc/app_bloc.dart';
import 'package:convertouch/presenter/bloc_observer.dart';
import 'package:convertouch/presenter/events/menu_items_fetch_event.dart';
import 'package:convertouch/presenter/states/app_state.dart';
import 'package:convertouch/view/app_bar.dart';
import 'package:convertouch/view/converted_items/converted_items_page.dart';
import 'package:convertouch/view/menu_items/menu_items_page.dart';
import 'package:convertouch/view/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchApp extends StatelessWidget {
  const ConvertouchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: quicksandFontFamily),
        home: const SafeArea(
          child: ConvertouchScaffold(),
        ));
  }
}

class ConvertouchScaffold extends StatelessWidget {
  const ConvertouchScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AppBloc()),
        BlocProvider(create: (context) => AppBarButtonsBloc()),
        BlocProvider(create: (context) => MenuViewBloc()),
        BlocProvider(
            create: (context) => MenuItemsBloc()
              ..add(const MenuItemsFetchEvent(ItemType.unitGroup))),
        BlocProvider(create: (context) => ConvertedItemsBloc()),
      ],
      child: Scaffold(
        body: Column(
          children: [
            const ConvertouchAppBar(),
            const ConvertouchSearchBar(),
            _buildPageContent()
          ],
        ),
        floatingActionButton: _buildFloatingButton(),
      ),
    );
  }

  Widget _buildFloatingButton() {
    return BlocBuilder<AppBloc, AppState>(builder: (_, scaffoldChangedState) {
      return Visibility(
        visible: scaffoldChangedState.isFloatingButtonVisible,
        child: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
      );
    });
  }

  Widget _buildPageContent() {
    return Expanded(
      child: BlocBuilder<AppBloc, AppState>(builder: (_, appState) {
        return LayoutBuilder(builder: (context, constraints) {
          switch (appState.pageId) {
            case convertedItemsPageId:
              return const ConvertouchConvertedUnitsPage();
            case unitGroupItemsPageId:
            case unitItemsPageId:
            default:
              return const ConvertouchItemsMenuPage();
          }
        });
      }),
    );
  }
}

void main() {
  Bloc.observer = ConvertouchBlocObserver();
  runApp(const ConvertouchApp());
}
