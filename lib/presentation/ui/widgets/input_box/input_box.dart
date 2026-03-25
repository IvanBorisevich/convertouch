import 'package:collection/collection.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/utils/input_validators/input_validator.dart';
import 'package:convertouch/presentation/bloc/common/input_validation/input_validation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/input_validation/input_validation_events.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_states.dart';
import 'package:convertouch/presentation/ui/constants/input_box_constants.dart';
import 'package:convertouch/presentation/ui/model/input_box_model.dart';
import 'package:convertouch/presentation/ui/model/list_box_model.dart';
import 'package:convertouch/presentation/ui/model/text_box_model.dart';
import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/mixin/focus_node_mixin.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/mixin/text_controller_mixin.dart';
import 'package:convertouch/presentation/ui/widgets/input_validation_tooltip.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_tooltip/super_tooltip.dart';

class ConvertouchInputBox<M extends InputBoxModel> extends StatefulWidget {
  const ConvertouchInputBox({
    required this.model,
    this.focusNode,
    this.autofocus = false,
    this.tooltipDirection = TooltipDirection.down,
    this.controller,
    this.onValueChanged,
    this.onValueFocused,
    this.onValueUnfocused,
    this.onValueCleaned,
    this.validators = const [],
    this.borderRadius = InputBoxConstants.defaultBorderRadius,
    this.borderWidth = 1,
    required this.colors,
    this.prefixWidgets = const [],
    this.suffixWidgets = const [],
    this.prefixRightmostDividerVisible = true,
    this.suffixLeftmostDividerVisible = true,
    this.inputFieldMargin = InputBoxConstants.defaultInputFieldMargin,
    this.fontSize = InputBoxConstants.defaultFontSize,
    this.letterSpacing,
    this.changeValueOnFocusChanged = false,
    this.floatingLabelBehavior,
    super.key,
  });

  final M model;
  final FocusNode? focusNode;
  final bool autofocus;
  final TooltipDirection tooltipDirection;
  final TextEditingController? controller;
  final void Function(dynamic)? onValueChanged;
  final void Function(dynamic)? onValueFocused;
  final void Function(dynamic)? onValueUnfocused;
  final void Function()? onValueCleaned;
  final List<InputValidator> validators;
  final BorderRadius borderRadius;
  final double borderWidth;
  final InputBoxColorScheme colors;
  final List<Widget?> prefixWidgets;
  final List<Widget?> suffixWidgets;
  final bool prefixRightmostDividerVisible;
  final bool suffixLeftmostDividerVisible;
  final EdgeInsets inputFieldMargin;
  final double fontSize;
  final double? letterSpacing;
  final bool changeValueOnFocusChanged;
  final FloatingLabelBehavior? floatingLabelBehavior;

  @override
  State<ConvertouchInputBox<M>> createState() => _ConvertouchInputBoxState<M>();
}

class _ConvertouchInputBoxState<M extends InputBoxModel>
    extends State<ConvertouchInputBox<M>> with FocusNodeMixin {
  Key? _validationKey;
  late final FocusNode _focusNode;
  void Function()? _focusListener;

  late Color _backgroundColor;
  late Color _foregroundColor;
  late Color _hintColor;
  late Color _labelColor;
  late Color _borderColor;
  late Color _dividerColor;

  @override
  void initState() {
    super.initState();

    _setInitialColors();

    if (widget.validators.isNotEmpty) {
      _validationKey = UniqueKey();
    }

    _focusNode = initOrGetFocusNode(initial: widget.focusNode);
    _focusListener = addFocusListener(
      focusNode: _focusNode,
      onFocusSelected: () {
        setState(() {
          _setFocusedColors();
        });
      },
      onFocusLeft: () {
        _setInitialColors();
      },
    );
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      disposeFocusNode(
        focusNode: _focusNode,
        listener: _focusListener,
      );
    }

    super.dispose();
  }

  void _setInitialColors() {
    if (widget.model.readonly) {
      _backgroundColor = widget.colors.textBox.background.disabled;
      _foregroundColor = widget.colors.textBox.foreground.disabled;
      _hintColor = widget.colors.textBox.hint.disabled;
      _labelColor = widget.colors.textBox.label.disabled;
      _borderColor = widget.colors.textBox.border.disabled;
      _dividerColor = widget.colors.divider.disabled;
    } else {
      _backgroundColor = widget.colors.textBox.background.regular;
      _foregroundColor = widget.colors.textBox.foreground.regular;
      _hintColor = widget.colors.textBox.hint.regular;
      _labelColor = widget.colors.textBox.label.regular;
      _borderColor = widget.colors.textBox.border.regular;
      _dividerColor = widget.colors.divider.regular;
    }
  }

  void _setFocusedColors() {
    _backgroundColor = widget.colors.textBox.background.focused;
    _foregroundColor = widget.colors.textBox.foreground.focused;
    _hintColor = widget.colors.textBox.hint.focused;
    _labelColor = widget.colors.textBox.label.focused;
    _borderColor = widget.colors.textBox.border.focused;
    _dividerColor = widget.colors.divider.focused;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: widget.borderRadius,
        border: widget.borderWidth > 0
            ? Border.all(
                color: _borderColor,
                width: widget.borderWidth,
              )
            : null,
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            ...widget.prefixWidgets.mapIndexed(
              (index, prefixWidget) => prefixWidget != null
                  ? Row(
                      children: [
                        prefixWidget,
                        index < widget.prefixWidgets.length - 1 ||
                                index == widget.prefixWidgets.length - 1 &&
                                    widget.prefixRightmostDividerVisible
                            ? _verticalDivider()
                            : const SizedBox.shrink(),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
            Expanded(
              child: _inputFieldWrapper(
                contentPadding: widget.inputFieldMargin,
                child: _inputField(widget.model),
              ),
            ),
            _suffixCloseIcon(),
            ...widget.suffixWidgets.mapIndexed(
              (index, suffixWidget) => suffixWidget != null
                  ? Row(
                      children: [
                        index < widget.suffixWidgets.length - 1 ||
                                index == widget.suffixWidgets.length - 1 &&
                                    widget.suffixLeftmostDividerVisible
                            ? _verticalDivider()
                            : const SizedBox.shrink(),
                        suffixWidget,
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _verticalDivider() {
    return VerticalDivider(
      color: _dividerColor,
      indent: 10,
      endIndent: 10,
      width: 2,
      thickness: 2,
    );
  }

  Widget _inputFieldWrapper({
    required Widget child,
    EdgeInsetsGeometry? contentPadding,
  }) {
    return _validationWrapper(
      child: GestureDetector(
        onTap: () {
          _focusNode.requestFocus();
        },
        child: Container(
          padding: contentPadding,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _inputField(M model) {
    if (model is TextBoxModel) {
      return _TextField(
        model: model,
        autofocus: widget.autofocus,
        controller: widget.controller,
        focusNode: _focusNode,
        validators: widget.validators,
        changeValueOnFocusChanged: widget.changeValueOnFocusChanged,
        onValueChanged: widget.onValueChanged,
        onValueFocused: _wrapWithValidation(
          context: context,
          func: widget.onValueFocused,
        ),
        onValueUnfocused: _wrapWithValidationReset(
          context: context,
          func: widget.onValueUnfocused,
        ),
        onValueCleaned: widget.onValueCleaned,
        foregroundColor: _foregroundColor,
        hintColor: _hintColor,
        labelColor: _labelColor,
        fontSize: widget.fontSize,
        margin: widget.inputFieldMargin,
        borderRadius: widget.borderRadius,
      );
    }

    if (model is ListBoxModel) {
      return _ListField(
        model: model,
        controller: widget.controller,
        onValueChanged: widget.onValueChanged,
        foregroundColor: _foregroundColor,
        hintColor: _hintColor,
        labelColor: _labelColor,
        fontSize: widget.fontSize,
        margin: widget.inputFieldMargin,
        borderRadius: widget.borderRadius,
        dropdownColors: widget.colors.dropdown,
      );
    }

    throw Exception(
      "Cannot create input box by model of type ${widget.model.runtimeType}",
    );
  }

  Widget _suffixCloseIcon() {
    if (!_focusNode.hasFocus ||
        widget.controller == null ||
        widget.controller!.text.isEmpty) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: widget.onValueCleaned,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7),
        child: Container(
          decoration: BoxDecoration(
            color: _foregroundColor,
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(2),
          child: Icon(
            Icons.close_rounded,
            color: _backgroundColor,
            size: 12,
          ),
        ),
      ),
    );
  }

  Widget _validationWrapper({
    required Widget child,
  }) {
    if (_validationKey == null) {
      return child;
    }

    return InputValidationTooltip(
      validationKey: _validationKey!,
      focusNode: _focusNode,
      colors: widget.colors.textBox.tooltip,
      tooltipDirection: widget.tooltipDirection,
      child: child,
    );
  }

  void Function(dynamic)? _wrapWithValidation({
    required BuildContext context,
    required void Function(dynamic)? func,
    bool validateEmptyValue = false,
  }) {
    if (_validationKey == null) {
      return func;
    }

    return (value) {
      if (!validateEmptyValue && (value == null || value.isEmpty)) {
        return func?.call(value);
      }

      BlocProvider.of<InputValidationBloc>(context).add(
        ValidateInput(
          key: _validationKey!,
          input: value,
          validators: widget.validators,
          onSuccess: () {
            func?.call(value);
          },
        ),
      );
    };
  }

  void Function(dynamic)? _wrapWithValidationReset({
    required BuildContext context,
    required void Function(dynamic)? func,
  }) {
    return (value) {
      if (_validationKey != null) {
        BlocProvider.of<InputValidationBloc>(context).add(
          ResetValidation(key: _validationKey!),
        );
      }

      return func?.call(value);
    };
  }
}

// Text field -----------------------------------------------------------------

class _TextField extends StatefulWidget {
  const _TextField({
    required this.model,
    this.controller,
    required this.autofocus,
    required this.focusNode,
    this.validators = const [],
    this.changeValueOnFocusChanged = true,
    this.onValueChanged,
    this.onValueFocused,
    this.onValueUnfocused,
    this.onValueCleaned,
    required this.foregroundColor,
    required this.hintColor,
    required this.labelColor,
    required this.fontSize,
    required this.margin,
    required this.borderRadius,
  });

  final TextBoxModel model;
  final TextEditingController? controller;
  final bool autofocus;
  final FocusNode focusNode;
  final List<InputValidator> validators;
  final bool changeValueOnFocusChanged;
  final void Function(String)? onValueChanged;
  final void Function(String)? onValueFocused;
  final void Function(String)? onValueUnfocused;
  final void Function()? onValueCleaned;
  final Color foregroundColor;
  final Color hintColor;
  final Color labelColor;
  final double fontSize;
  final EdgeInsets margin;
  final BorderRadius borderRadius;

  @override
  State<StatefulWidget> createState() => _TextFieldState();
}

class _TextFieldState extends State<_TextField>
    with FocusNodeMixin, TextControllerMixin {
  late TextEditingController _controller;
  late void Function() _focusListener;

  String? _hint;

  @override
  void initState() {
    _hint = widget.model.hintUnfocused;

    _controller = initOrGetController(
      initial: widget.controller,
      initialValue:
          widget.autofocus ? widget.model.value : widget.model.valueUnfocused,
    );

    _focusListener = addFocusListener(
      focusNode: widget.focusNode,
      onFocusSelected: () {
        widget.onValueFocused?.call(_controller.text);

        if (widget.changeValueOnFocusChanged) {
          updateTextControllerValue(
            _controller,
            value: widget.model.value,
          );
        }

        setState(() {
          _hint = widget.model.hint;
        });
      },
      onFocusLeft: () {
        widget.onValueUnfocused?.call(_controller.text);

        if (widget.changeValueOnFocusChanged) {
          updateTextControllerValue(
            _controller,
            value: widget.model.valueUnfocused,
          );
        }

        setState(() {
          _hint = widget.model.hintUnfocused;
        });
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      disposeTextController(
        controller: _controller,
      );
    }

    widget.focusNode.removeListener(_focusListener);

    super.dispose();
  }

  @override
  void didUpdateWidget(_TextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    _updateTextBox(
      oldModel: oldWidget.model,
      newModel: widget.model,
    );
  }

  void _updateTextBox({
    required TextBoxModel oldModel,
    required TextBoxModel newModel,
  }) {
    if (widget.focusNode.hasFocus && newModel.value != oldModel.value) {
      updateTextControllerValue(
        _controller,
        value: newModel.value,
      );
    } else if (!widget.focusNode.hasFocus &&
        newModel.valueUnfocused != oldModel.valueUnfocused) {
      updateTextControllerValue(
        _controller,
        value: newModel.valueUnfocused,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    RegExp? inputRegExp = inputValueTypeToRegExpMap[widget.model.valueType];

    return TextField(
      readOnly: widget.model.readonly,
      maxLength: widget.model.maxTextLength,
      textAlignVertical: TextAlignVertical.center,
      obscureText: false,
      autofocus: widget.autofocus,
      focusNode: widget.focusNode,
      controller: _controller,
      inputFormatters: inputRegExp != null
          ? [FilteringTextInputFormatter.allow(inputRegExp)]
          : null,
      keyboardType: inputValueTypeToKeyboardTypeMap[widget.model.valueType],
      onChanged: widget.onValueChanged,
      decoration: _inputFieldDecoration(
        context,
        margin: widget.margin,
        fontSize: widget.fontSize,
        borderRadius: widget.borderRadius,
        labelText: widget.model.labelText,
        hintText: _hint,
        hintColor: widget.hintColor,
        labelColor: widget.labelColor,
      ).copyWith(
        counterText: "",
        suffixText: widget.model.textLengthCounterVisible
            ? '${_controller.text.length}/${widget.model.maxTextLength}'
            : null,
      ),
      style: _inputFieldTextStyle(
        fontSize: widget.fontSize,
        foregroundColor: widget.foregroundColor,
      ),
      textAlign: TextAlign.start,
    );
  }
}

// List field -----------------------------------------------------------------

class _ListField extends StatefulWidget {
  const _ListField({
    required this.model,
    this.controller,
    this.onValueChanged,
    required this.foregroundColor,
    required this.hintColor,
    required this.labelColor,
    required this.fontSize,
    required this.margin,
    required this.borderRadius,
    required this.dropdownColors,
  });

  final ListBoxModel model;
  final TextEditingController? controller;
  final void Function(String)? onValueChanged;
  final Color foregroundColor;
  final Color hintColor;
  final Color labelColor;
  final double fontSize;
  final EdgeInsets margin;
  final BorderRadius borderRadius;
  final DropdownColorScheme dropdownColors;

  @override
  State<StatefulWidget> createState() => _ListFieldState();
}

class _ListFieldState extends State<_ListField> with FocusNodeMixin {
  late bool _isDropdownOpen;

  TextEditingController? _dropdownSearchController;
  FocusNode? _dropdownSearchFocusNode;
  String? _hint;

  @override
  void initState() {
    super.initState();

    _hint = widget.model.hint;
    _isDropdownOpen = false;

    _dropdownSearchFocusNode = initOrGetFocusNode();

    if (widget.model.searchEnabled) {
      _dropdownSearchController = TextEditingController();
      _dropdownSearchFocusNode = initOrGetFocusNode();
    }
  }

  @override
  void dispose() {
    disposeFocusNode(focusNode: _dropdownSearchFocusNode);
    _dropdownSearchController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NavigationBloc, NavigationState>(
      listener: (_, navigationState) {
        if (_isDropdownOpen) {
          Navigator.of(context).pop();
        }
      },
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField2<ListValueModel>(
          isExpanded: true,
          decoration: _inputFieldDecoration(
            context,
            margin: widget.margin,
            fontSize: widget.fontSize,
            borderRadius: widget.borderRadius,
            labelText: widget.model.labelText,
            hintText: _hint,
            hintColor: widget.hintColor,
            labelColor: widget.labelColor,
          ),
          style: _inputFieldTextStyle(
            fontSize: widget.fontSize,
            foregroundColor: widget.foregroundColor,
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
                        fontSize: widget.fontSize,
                        color: widget.dropdownColors.foreground.regular,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) {
              widget.onValueChanged?.call(value.value);
            }
          },
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
                    widget.model.value?.itemName ?? _hint ?? '',
                    style: _inputFieldTextStyle(
                      fontSize: widget.fontSize,
                      foregroundColor: widget.foregroundColor,
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
              color: widget.foregroundColor,
            ),
            iconSize: 20,
          ),
          dropdownStyleData: DropdownStyleData(
            scrollbarTheme: ScrollbarThemeData(
              thickness: WidgetStateProperty.all(4),
              thumbColor: WidgetStateProperty.all(
                widget.dropdownColors.foreground.regular,
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
              color: widget.dropdownColors.background.regular,
            ),
            padding: EdgeInsets.zero,
          ),
          menuItemStyleData: const MenuItemStyleData(
            padding: EdgeInsets.zero,
          ),
          buttonStyleData: const ButtonStyleData(
            padding: EdgeInsets.zero,
          ),
          dropdownSearchData: _dropdownSearchController != null &&
                  _dropdownSearchFocusNode != null
              ? DropdownSearchData(
                  searchController: _dropdownSearchController,
                  searchInnerWidgetHeight: 80,
                  searchInnerWidget: Container(
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 4,
                      right: 8,
                      left: 8,
                    ),
                    child: ConvertouchInputBox(
                      model: TextBoxModel(
                        hint: widget.model.searchHint,
                        hintUnfocused: widget.model.searchHint,
                        valueType: widget.model.listType.listValuesType,
                      ),
                      colors: InputBoxColorScheme(
                        textBox: widget.dropdownColors.searchBox,
                      ),
                      inputFieldMargin: const EdgeInsets.symmetric(
                        vertical: 7,
                        horizontal: 5,
                      ),
                      prefixWidgets: [
                        Padding(
                          padding: const EdgeInsets.only(left: 7),
                          child: Icon(
                            Icons.search,
                            color: widget.foregroundColor,
                            size: 20,
                          ),
                        ),
                      ],
                      prefixRightmostDividerVisible: false,
                      controller: _dropdownSearchController,
                      fontSize: 15,
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
              _dropdownSearchController?.clear();
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

// Shared methods -------------------------------------------------------------

InputDecoration _inputFieldDecoration(
  BuildContext context, {
  required EdgeInsets margin,
  required double fontSize,
  required BorderRadius borderRadius,
  required String? labelText,
  required String? hintText,
  required Color? hintColor,
  required Color? labelColor,
  FloatingLabelBehavior? floatingLabelBehavior,
}) {
  return InputDecoration(
    border: OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide.none,
    ),
    label: labelText != null && labelColor != null
        ? Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width / 2,
            ),
            child: Text(
              labelText,
              maxLines: 1,
              softWrap: false,
              style: TextStyle(
                fontSize: 15,
                overflow: TextOverflow.fade,
                fontWeight: FontWeight.w600,
                foreground: Paint()..color = labelColor,
              ),
            ),
          )
        : null,
    floatingLabelBehavior: floatingLabelBehavior,
    alignLabelWithHint: true,
    isDense: true,
    contentPadding: labelText != null
        ? const EdgeInsets.symmetric(
            vertical: InputBoxConstants.labeledInputFieldVerticalPadding,
          )
        : EdgeInsets.zero,
    filled: true,
    fillColor: Colors.transparent,
    constraints: BoxConstraints(
      maxHeight:
          fontSize * InputBoxConstants.textHeightCoefficient + margin.vertical,
    ),
    hintText: hintText,
    hintStyle: hintColor != null
        ? TextStyle(
            foreground: Paint()..color = hintColor,
          )
        : null,
  );
}

TextStyle _inputFieldTextStyle({
  required double fontSize,
  required Color foregroundColor,
}) {
  return TextStyle(
    fontSize: fontSize,
    fontWeight: FontWeight.w500,
    fontFamily: quicksandFontFamily,
    overflow: TextOverflow.fade,
    height: InputBoxConstants.textHeightCoefficient,
    foreground: Paint()..color = foregroundColor,
  );
}
