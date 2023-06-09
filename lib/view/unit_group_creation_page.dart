import 'package:convertouch/model/constant.dart';
import 'package:convertouch/presenter/bloc/unit_groups_menu_bloc.dart';
import 'package:convertouch/presenter/events/unit_groups_menu_events.dart';
import 'package:convertouch/presenter/states/unit_groups_menu_states.dart';
import 'package:convertouch/view/scaffold/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitGroupCreationPage extends StatefulWidget {
  const ConvertouchUnitGroupCreationPage({super.key});

  @override
  State createState() => _ConvertouchUnitGroupCreationPageState();
}

class _ConvertouchUnitGroupCreationPageState
    extends State<ConvertouchUnitGroupCreationPage> {
  static const BorderRadius _fieldRadius = BorderRadius.all(Radius.circular(8));

  final _controller = TextEditingController();

  bool _isApplyButtonEnabled = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<UnitGroupsMenuBloc, UnitGroupsMenuState>(
      listener: (_, unitGroupsMenuState) {
        if (unitGroupsMenuState is UnitGroupsFetched &&
            unitGroupsMenuState.navigationAction == NavigationAction.pop) {
          Navigator.of(context).pop();
        } else if (unitGroupsMenuState is UnitGroupExists) {
          showAlertDialog(
              context,
              "Unit group '${unitGroupsMenuState.unitGroupName}' "
              "already exist");
        }
      },
      child: ConvertouchScaffold(
        pageTitle: "New Unit Group",
        appBarLeftWidget: backIcon(context),
        appBarRightWidgets: [
          checkIcon(context, _isApplyButtonEnabled, () {
            BlocProvider.of<UnitGroupsMenuBloc>(context)
                .add(AddUnitGroup(unitGroupName: _controller.text));
            BlocProvider.of<UnitGroupsMenuBloc>(context).add(
                const FetchUnitGroups(navigationAction: NavigationAction.pop));
          }),
        ],
        body: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsetsDirectional.fromSTEB(7, 8, 7, 0),
                child: TextField(
                  autofocus: true,
                  obscureText: false,
                  controller: _controller,
                  onChanged: (String value) async {
                    setState(() {
                      _isApplyButtonEnabled = value.isNotEmpty;
                    });
                  },
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                        borderRadius: _fieldRadius,
                        borderSide: BorderSide(color: Color(0xFF426F99))),
                    focusedBorder: const OutlineInputBorder(
                        borderRadius: _fieldRadius,
                        borderSide: BorderSide(color: Color(0xFF426F99))),
                    label: Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width / 2),
                      child: const Text("Unit Group Name", maxLines: 1),
                    ),
                    labelStyle: const TextStyle(
                      color: Color(0xFF426F99),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 15.0),
                  ),
                  style: const TextStyle(
                    color: Color(0xFF426F99),
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
