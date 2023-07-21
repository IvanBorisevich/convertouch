import 'package:convertouch/presenter/bloc/unit_groups_bloc.dart';
import 'package:convertouch/presenter/events/unit_groups_events.dart';
import 'package:convertouch/view/scaffold/bloc_wrappers.dart';
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
    return wrapIntoUnitGroupCreationPageListener(
        context,
        ConvertouchScaffold(
          pageTitle: "New Unit Group",
          appBarRightWidgets: [
            checkIcon(context, _isApplyButtonEnabled, () {
              BlocProvider.of<UnitGroupsBloc>(context).add(AddUnitGroup(
                  unitGroupName: _controller.text
              ));
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
        ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
