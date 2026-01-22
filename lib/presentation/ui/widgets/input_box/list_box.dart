import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_states.dart';
import 'package:convertouch/presentation/ui/constants/input_box_constants.dart';
import 'package:convertouch/presentation/ui/model/list_box_model.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/mixin/focus_node_mixin.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/mixin/items_lazy_loading_mixin.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchListBox extends StatefulWidget {
  final ListBoxModel model;
  final FocusNode? focusNode;
  final bool autofocus;
  final void Function(ListValueModel?)? onValueChanged;
  final void Function()? onFocusSelected;
  final void Function()? onFocusLeft;
  final double borderRadius;
  final InputBoxColorScheme colors;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry contentPadding;
  final double height;
  final double fontSize;
  final EdgeInsetsGeometry? labelPadding;

  const ConvertouchListBox({
    required this.model,
    this.focusNode,
    this.autofocus = false,
    this.onValueChanged,
    this.onFocusSelected,
    this.onFocusLeft,
    this.borderRadius = InputBoxConstants.defaultBorderRadius,
    required this.colors,
    this.prefixIcon,
    this.suffixIcon,
    this.contentPadding = InputBoxConstants.defaultContentPadding,
    this.height = InputBoxConstants.defaultHeight,
    this.fontSize = InputBoxConstants.defaultFontSize,
    this.labelPadding,
    super.key,
  });

  @override
  State<ConvertouchListBox> createState() => _ConvertouchListBoxState();
}

class _ConvertouchListBoxState extends State<ConvertouchListBox>
    with ItemsLazyLoadingMixin, FocusNodeMixin {
  static const String defaultHint = 'N/A';
  static const String defaultDropdownSearchHint = 'Search item...';

  final TextEditingController _dropdownSearchController =
      TextEditingController();

  late bool _isDropdownOpen;
  late final FocusNode _focusNode;
  void Function()? _focusListener;

  @override
  void initState() {
    _isDropdownOpen = false;

    _focusNode = initOrGetFocusNode(widget.focusNode);

    if (!widget.model.readonly) {
      _focusListener = addFocusListener(
        focusNode: _focusNode,
        onFocusSelected: widget.onFocusSelected,
        onFocusLeft: widget.onFocusLeft,
      );
    }

    super.initState();
  }

  @override
  void dispose() {
    disposeFocusNode(
      focusNode: _focusNode,
      focusListener: _focusListener,
    );
    _dropdownSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color borderColor;
    Color foregroundColor;
    Color hintColor;
    ConvertouchColorScheme dropdownMenu = widget.colors.dropdown;

    if (widget.model.readonly) {
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

    return BlocListener<NavigationBloc, NavigationState>(
      listener: (_, navigationState) {
        if (_isDropdownOpen) {
          Navigator.of(context).pop();
        }
      },
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField2<ListValueModel>(
          isExpanded: true,
          decoration: InputDecoration(
            contentPadding: widget.contentPadding,
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(widget.borderRadius)),
              borderSide: BorderSide(
                color: borderColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(widget.borderRadius)),
              borderSide: BorderSide(
                color: borderColor,
              ),
            ),
            label: Container(
              padding: widget.labelPadding,
              decoration: BoxDecoration(
                color: widget.colors.background.regular,
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width / 2,
              ),
              child: Text(
                widget.model.labelText,
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
            filled: true,
            fillColor: widget.colors.background.regular,
          ),
          hint: Text(
            defaultHint,
            style: TextStyle(
              fontSize: 16,
              color: hintColor,
            ),
          ),
          value: widget.model.value,
          items: widget.model.listValues
              .map(
                (value) => DropdownMenuItem(
                  value: value,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 17),
                    child: Text(
                      value.itemName,
                      style: TextStyle(
                        fontSize: 16,
                        color: dropdownMenu.foreground.regular,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: widget.onValueChanged,
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
            return widget.model.listValues.map(
              (value) {
                return Container(
                  padding: EdgeInsets.zero,
                  child: Text(
                    widget.model.value?.itemName ?? defaultHint,
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
            scrollbarTheme: ScrollbarThemeData(
              thickness: WidgetStateProperty.all(4),
              thumbColor: WidgetStateProperty.all(
                dropdownMenu.foreground.regular,
              ),
              trackColor: WidgetStateProperty.all(Colors.transparent),
              trackBorderColor: WidgetStateProperty.all(Colors.transparent),
              trackVisibility: WidgetStateProperty.all(true),
              radius: const Radius.circular(10),
            ),
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
          dropdownSearchData: DropdownSearchData(
            searchController: _dropdownSearchController,
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
                controller: _dropdownSearchController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 17,
                    vertical: 8,
                  ),
                  hintText: defaultDropdownSearchHint,
                  hintStyle: TextStyle(fontSize: 15),
                  border: OutlineInputBorder(
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
          ),
          onMenuStateChange: (isOpen) {
            if (!isOpen) {
              _dropdownSearchController.clear();
            }

            setState(() {
              _isDropdownOpen = isOpen;
            });
          },
        ),
      ),
    );
  }
}
