import 'dart:developer';

import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/items_list/dropdown_bloc.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_events.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchListBox extends StatefulWidget {
  static const double defaultHeight = 55;

  final String? value;
  final FocusNode? focusNode;
  final ConvertouchListType listType;
  final UnitModel? itemUnit;
  final String label;
  final bool autofocus;
  final bool disabled;
  final bool dropdownSearchVisible;
  final String? dropdownSearchHint;
  final void Function(String)? onChanged;
  final void Function()? onFocusSelected;
  final void Function()? onFocusLeft;
  final double borderRadius;
  final InputBoxColorScheme colors;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double height;
  final double fontSize;

  const ConvertouchListBox({
    this.value,
    required this.listType,
    this.itemUnit,
    this.focusNode,
    this.label = "",
    this.autofocus = false,
    this.disabled = false,
    this.dropdownSearchVisible = false,
    this.dropdownSearchHint,
    this.onChanged,
    this.onFocusSelected,
    this.onFocusLeft,
    this.borderRadius = 15,
    required this.colors,
    this.prefixIcon,
    this.suffixIcon,
    this.height = defaultHeight,
    this.fontSize = 17,
    super.key,
  });

  @override
  State<ConvertouchListBox> createState() => _ConvertouchListBoxState();
}

class _ConvertouchListBoxState extends State<ConvertouchListBox> {
  static const String hintText = 'N/A';

  final TextEditingController dropdownSearchController =
      TextEditingController();

  late final DropdownBloc _bloc;
  late final FocusNode _focusNode;
  FocusNode? _defaultFocusNode;

  @override
  void initState() {
    _bloc = BlocProvider.of<DropdownBloc>(context)
      ..add(
        FetchItems(
          listType: widget.listType,
          listItemUnit: widget.itemUnit,
          onFirstFetch: () {
            _bloc.add(
              SelectListValue(
                value: widget.value,
                listType: widget.listType,
              ),
            );
          },
        ),
      );
    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
    } else {
      _defaultFocusNode = FocusNode();
      _focusNode = _defaultFocusNode!;
    }

    _focusNode.addListener(_focusListener);

    super.initState();
  }

  @override
  void didUpdateWidget(ConvertouchListBox oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.itemUnit != oldWidget.itemUnit) {
      log("Item unit has been changed");
      _bloc.add(
        FetchItems(
          listType: widget.listType,
          listItemUnit: widget.itemUnit,
          onFirstFetch: () {
            _bloc.add(
              SelectListValue(
                value: widget.value,
                listType: widget.listType,
              ),
            );
          },
        ),
      );
    }

    if (widget.value != oldWidget.value) {
      log("Value has been changed");
      _bloc.add(
        SelectListValue(
          value: widget.value,
          listType: widget.listType,
        ),
      );
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_focusListener);
    _defaultFocusNode?.dispose();
    dropdownSearchController.dispose();
    super.dispose();
  }

  void _focusListener() {
    if (widget.disabled) {
      return;
    }

    if (_focusNode.hasFocus) {
      widget.onFocusSelected?.call();
    } else {
      widget.onFocusLeft?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    Color borderColor;
    Color foregroundColor;
    Color hintColor;
    ConvertouchColorScheme dropdownMenu = widget.colors.dropdown;

    if (widget.disabled) {
      borderColor = widget.colors.border.disabled;
      foregroundColor = widget.colors.foreground.disabled;
      hintColor = widget.colors.hint.disabled;
    } else if (_focusNode.hasFocus) {
      borderColor = widget.colors.border.focused;
      foregroundColor = widget.colors.foreground.focused;
      hintColor = widget.colors.hint.focused;
    } else {
      borderColor = widget.colors.border.regular;
      foregroundColor = widget.colors.foreground.regular;
      hintColor = widget.colors.hint.regular;
    }

    return dropdownBlocBuilder(
      bloc: _bloc,
      builderFunc: (dropdownState) {
        return DropdownButtonHideUnderline(
          child: DropdownButtonFormField2<ListValueModel>(
            isExpanded: true,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(17),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(
                  color: borderColor, //widget.colors.border.regular,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(
                  color: borderColor,
                ),
              ),
              label: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width / 2,
                ),
                child: Text(
                  widget.label,
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    foreground: Paint()..color = borderColor,
                  ),
                ),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            hint: Text(
              hintText,
              style: TextStyle(
                fontSize: 16,
                color: hintColor,
              ),
            ),
            value: dropdownState.selectedItem,
            items: dropdownState.pageItems
                .map(
                  (value) => DropdownMenuItem(
                    value: value,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 17),
                      child: Text(
                        value.name,
                        style: TextStyle(
                          fontSize: 16,
                          color: dropdownMenu.foreground.regular,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: (item) {
              _bloc.add(
                SelectListValue(
                  value: item?.value,
                  listType: widget.listType,
                  onItemSelect: (listValue) {
                    widget.onChanged?.call(listValue?.value ?? "");
                  },
                ),
              );
            },
            style: TextStyle(
              fontSize: widget.fontSize,
              fontWeight: FontWeight.w500,
              fontFamily: quicksandFontFamily,
            ),
            /*
        selectedItemBuilder is used as a workaround in order to align paddings between
        DropdownButtonFormField2, its label over the border and DropdownMenuItem
         */
            selectedItemBuilder: (context) {
              return dropdownState.pageItems.map(
                (value) {
                  return Container(
                    padding: EdgeInsets.zero,
                    child: Text(
                      dropdownState.selectedItem?.name ?? hintText,
                      style: TextStyle(
                        fontSize: 16,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w600,
                        foreground: Paint()..color = foregroundColor,
                      ),
                      maxLines: 1,
                    ),
                  );
                },
              ).toList();
            },
            iconStyleData: IconStyleData(
              icon: Icon(
                Icons.expand_more_rounded,
                color: foregroundColor,
              ),
              iconSize: 24,
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 250,
              elevation: 0,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(17)),
                color: dropdownMenu.background.regular,
              ),
              padding: EdgeInsets.zero,
            ),
            menuItemStyleData: const MenuItemStyleData(
              padding: EdgeInsets.zero,
            ),
            buttonStyleData: const ButtonStyleData(
              padding: EdgeInsets.zero,
            ),
            dropdownSearchData: widget.dropdownSearchVisible
                ? DropdownSearchData(
                    searchController: dropdownSearchController,
                    searchInnerWidgetHeight: 60,
                    searchInnerWidget: Container(
                      height: 60,
                      padding: const EdgeInsets.only(
                        top: 8,
                        bottom: 4,
                        right: 8,
                        left: 8,
                      ),
                      child: TextFormField(
                        maxLines: 1,
                        controller: dropdownSearchController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 17,
                            vertical: 8,
                          ),
                          hintText: widget.dropdownSearchHint ??
                              'Search for an item...',
                          hintStyle: const TextStyle(fontSize: 15),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                        ),
                      ),
                    ),
                    searchMatchFn: (item, searchValue) {
                      return item.value?.value
                              .toLowerCase()
                              .contains(searchValue.toLowerCase()) ??
                          false;
                    },
                  )
                : null,
            onMenuStateChange: (isOpen) {
              if (!isOpen) {
                dropdownSearchController.clear();
              }
            },
          ),
        );
      },
    );
  }
}
