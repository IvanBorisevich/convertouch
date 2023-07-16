import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/unit_model.dart';
import 'package:convertouch/model/entity/unit_value_model.dart';
import 'package:convertouch/model/util/unit_creation_page_util.dart';
import 'package:convertouch/presenter/bloc/unit_groups_menu_bloc.dart';
import 'package:convertouch/presenter/bloc/units_menu_bloc.dart';
import 'package:convertouch/presenter/events/unit_groups_menu_events.dart';
import 'package:convertouch/presenter/events/units_menu_events.dart';
import 'package:convertouch/presenter/states/unit_groups_menu_states.dart';
import 'package:convertouch/presenter/states/units_menu_states.dart';
import 'package:convertouch/view/items_view/item/unit_group_item.dart';
import 'package:convertouch/view/items_view/item_view_mode/unit_value_list_item.dart';
import 'package:convertouch/view/scaffold/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitCreationPage extends StatefulWidget {
  const ConvertouchUnitCreationPage({super.key});

  @override
  State createState() => _ConvertouchUnitCreationPageState();
}

class _ConvertouchUnitCreationPageState
    extends State<ConvertouchUnitCreationPage> {

  final _unitNameFieldController = TextEditingController();
  final _unitAbbrFieldController = TextEditingController();

  String _unitName = "";
  String _unitAbbr = "";
  String _unitAbbrHint = "";

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UnitsMenuBloc, UnitsMenuState>(
            listener: (_, unitsMenuState) {
          if (unitsMenuState is UnitsFetched &&
              unitsMenuState.navigationAction == NavigationAction.pop) {
            Navigator.of(context).pop();
          } else if (unitsMenuState is UnitExists) {
            showAlertDialog(
                context, "Unit '${unitsMenuState.unitName}' already exist");
          }
        }),
        BlocListener<UnitGroupsMenuBloc, UnitGroupsMenuState>(
          listener: (_, unitGroupsMenuState) {
            if (unitGroupsMenuState is UnitGroupsFetched) {
              Navigator.of(context).pushNamed(unitGroupsPageId);
            }
          },
        )
      ],
      child:
          BlocBuilder<UnitsMenuBloc, UnitsMenuState>(buildWhen: (prev, next) {
        return prev != next && next is UnitsFetched;
      }, builder: (_, unitsFetched) {
        if (unitsFetched is UnitsFetched) {
          return ConvertouchScaffold(
            pageTitle: "New Unit",
            appBarLeftWidget: backIcon(context),
            appBarRightWidgets: [
              checkIcon(context, _unitName.isNotEmpty, () {
                FocusScope.of(context).unfocus();
                BlocProvider.of<UnitsMenuBloc>(context).add(AddUnit(
                    unitName: _unitName,
                    unitAbbreviation:
                        _unitAbbr.isNotEmpty ? _unitAbbr : _unitAbbrHint,
                    unitGroupId: unitsFetched.unitGroup.id));
                BlocProvider.of<UnitsMenuBloc>(context).add(FetchUnits(
                    unitGroupId: unitsFetched.unitGroup.id,
                    navigationAction: NavigationAction.pop));
              }),
            ],
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsetsDirectional.fromSTEB(7, 10, 7, 0),
                child: Column(children: [
                  ConvertouchUnitGroupItem(unitsFetched.unitGroup,
                      onTap: () {
                    BlocProvider.of<UnitGroupsMenuBloc>(context)
                        .add(const FetchUnitGroups());
                  }).buildForList(context),
                  const SizedBox(height: 20),
                  _buildTextField('Unit Name', _unitNameFieldController,
                      (String value) async {
                    setState(() {
                      _unitName = value;
                      _unitAbbrHint = getInitialUnitAbbreviationFromName(value);
                    });
                  }),
                  const SizedBox(height: 12),
                  _buildTextField('Unit Abbreviation', _unitAbbrFieldController,
                      (String value) async {
                    setState(() {
                      _unitAbbr = value;
                    });
                  },
                      maxLength: unitAbbreviationMaxLength,
                      lengthCounterVisible: true,
                      hintTextVisible: true),
                  const SizedBox(height: 25),
                  LayoutBuilder(builder: (context, constraints) {
                    if (unitsFetched.units.isNotEmpty && _unitName.isNotEmpty) {
                      return Column(children: [
                        horizontalDividerWithText("Set unit value equivalent"),
                        const SizedBox(height: 25),
                        ConvertouchUnitValueListItem(
                            UnitValueModel(
                                unit: UnitModel(
                                  name: _unitName,
                                  abbreviation: _unitAbbr.isNotEmpty
                                    ? _unitAbbr
                                    : _unitAbbrHint),
                                value: "1"
                            )
                        ),
                        const SizedBox(height: 9),
                        ConvertouchUnitValueListItem(
                            UnitValueModel(
                                unit: unitsFetched.units[0],
                                value: "1"
                            )
                        ),
                        const SizedBox(height: 25),
                      ]);
                    } else {
                      return const SizedBox();
                    }
                  }),
                ]),
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      }),
    );
  }

  Widget _buildTextField(
      final String label,
      final TextEditingController controller,
      final void Function(String)? onChangedFunc,
      {int? maxLength,
      bool lengthCounterVisible = false,
      bool hintTextVisible = false}) {
    return TextField(
      maxLength: maxLength,
      obscureText: false,
      controller: controller,
      onChanged: onChangedFunc,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: Color(0xFF426F99))),
        focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: Color(0xFF426F99))),
        label: Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2),
          child: Text(label, maxLines: 1),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: const TextStyle(
          color: Color(0xFF426F99),
        ),
        hintText: hintTextVisible ? _unitAbbrHint : null,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
        counterText: "",
        suffixText: lengthCounterVisible
            ? '${controller.text.length.toString()}/${maxLength.toString()}'
            : null,
      ),
      style: const TextStyle(
        color: Color(0xFF426F99),
        fontSize: 17,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.start,
    );
  }

  @override
  void dispose() {
    _unitNameFieldController.dispose();
    _unitAbbrFieldController.dispose();
    super.dispose();
  }
}
