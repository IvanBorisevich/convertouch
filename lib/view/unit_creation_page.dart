import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/unit_group_model.dart';
import 'package:convertouch/model/entity/unit_model.dart';
import 'package:convertouch/model/entity/unit_value_model.dart';
import 'package:convertouch/model/util/menu_util.dart';
import 'package:convertouch/presenter/bloc/units_menu_bloc.dart';
import 'package:convertouch/presenter/events/units_menu_events.dart';
import 'package:convertouch/presenter/states/units_menu_states.dart';
import 'package:convertouch/view/items_model/unit_value_list_item.dart';
import 'package:convertouch/view/items_model/menu_list_item.dart';
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
  static const BorderRadius _fieldRadius = BorderRadius.all(Radius.circular(8));

  final _unitNameFieldController = TextEditingController();
  final _unitAbbrFieldController = TextEditingController();

  String _unitName = "";
  String _unitAbbr = "";
  String _unitAbbrHint = "";

  @override
  Widget build(BuildContext context) {
    UnitGroupModel unitGroup =
        ModalRoute.of(context)!.settings.arguments as UnitGroupModel;

    return BlocListener<UnitsMenuBloc, UnitsMenuState>(
      listener: (_, unitsMenuState) {
        if (unitsMenuState is UnitsFetched && unitsMenuState.isBackNavigation) {
          Navigator.of(context).pop();
        } else if (unitsMenuState is UnitExists) {
          showAlertDialog(
              context, "Unit '${unitsMenuState.unitName}' already exist");
        }
      },
      child: ConvertouchScaffold(
        pageTitle: "New Unit",
        appBarLeftWidget: backIcon(context),
        appBarRightWidgets: [
          checkIcon(context, _unitName.isNotEmpty, () {
            FocusScope.of(context).unfocus();
            BlocProvider.of<UnitsMenuBloc>(context).add(AddUnit(
                unitName: _unitName,
                unitAbbreviation:
                    _unitAbbr.isNotEmpty ? _unitAbbr : _unitAbbrHint,
                unitGroupId: unitGroup.id));
            BlocProvider.of<UnitsMenuBloc>(context).add(
                FetchUnits(unitGroupId: unitGroup.id, isBackNavigation: true));
          }),
        ],
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsetsDirectional.fromSTEB(7, 10, 7, 0),
            child: Column(children: [
              ConvertouchMenuListItem(unitGroup),
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
                if (unitGroup.ciUnit != null && _unitName.isNotEmpty) {
                  return Column(children: [
                    Row(children: const [
                      Expanded(
                          child: Divider(
                              color: Color(0xFF426F99), thickness: 1.2)),
                      SizedBox(width: 7),
                      Text(
                        "Set unit value equivalent",
                        style: TextStyle(
                            color: Color(0xFF426F99),
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(width: 7),
                      Expanded(
                          child: Divider(
                        color: Color(0xFF426F99),
                        thickness: 1.2,
                      )),
                    ]),
                    const SizedBox(height: 25),
                    ConvertouchUnitValueListItem(UnitValueModel(
                        UnitModel.withoutId(_unitName,
                            _unitAbbr.isNotEmpty ? _unitAbbr : _unitAbbrHint),
                        "1")),
                    const SizedBox(height: 9),
                    ConvertouchUnitValueListItem(
                        UnitValueModel(unitGroup.ciUnit!, "1")),
                    const SizedBox(height: 25),
                  ]);
                } else {
                  return const SizedBox();
                }
              }),
            ]),
          ),
        ),
      ),
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
            borderRadius: _fieldRadius,
            borderSide: BorderSide(color: Color(0xFF426F99))),
        focusedBorder: const OutlineInputBorder(
            borderRadius: _fieldRadius,
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
