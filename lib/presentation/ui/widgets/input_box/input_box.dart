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
    this.changeValueOnFocusChanged = false,
    this.floatingLabelBehavior,
    super.key,
  });

  final M model;
  final FocusNode? focusNode;
  final bool autofocus;
  final TooltipDirection tooltipDirection;
  final TextEditingController? controller;
  final void Function(String)? onValueChanged;
  final void Function(String)? onValueFocused;
  final void Function(String)? onValueUnfocused;
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
  final bool changeValueOnFocusChanged;
  final FloatingLabelBehavior? floatingLabelBehavior;

  @override
  State<ConvertouchInputBox<M>> createState() => _ConvertouchInputBoxState<M>();
}

class _ConvertouchInputBoxState<M extends InputBoxModel>
    extends State<ConvertouchInputBox<M>>
    with FocusNodeMixin, TextControllerMixin {
  Key? _validationKey;
  late final FocusNode _focusNode;
  void Function()? _focusListener;
  late final TextEditingController _controller;
  late final void Function() _controllerListener;
  late final ValueNotifier<bool> _closeIconNotifier;

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
    _controller = initOrGetController(initial: widget.controller);
    _closeIconNotifier = ValueNotifier(false);

    _focusListener = addFocusListener(
      focusNode: _focusNode,
      onFocusSelected: () {
        if (!mounted) return;

        _closeIconNotifier.value =
            widget.model is! ListBoxModel && _controller.text.isNotEmpty;

        setState(() {
          _setFocusedColors();
        });
      },
      onFocusLeft: () {
        if (!mounted) return;

        _closeIconNotifier.value = false;

        setState(() {
          _setInitialColors();
        });
      },
    );

    _controllerListener = addTextListener(
      controller: _controller,
      onValueChanged: () {
        if (!mounted) return;

        _closeIconNotifier.value = widget.model is! ListBoxModel &&
            _focusNode.hasFocus &&
            _controller.text.isNotEmpty;
      },
    );
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      disposeTextController(
        controller: _controller,
        listener: _controllerListener,
      );
    }

    if (widget.focusNode == null) {
      disposeFocusNode(
        focusNode: _focusNode,
        listener: _focusListener,
      );
    }

    _closeIconNotifier.dispose();

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
              child: _validationWrapper(
                child: GestureDetector(
                  onTap: () {
                    _focusNode.requestFocus();
                  },
                  child: Container(
                    padding: widget.inputFieldMargin,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: widget.borderRadius,
                    ),
                    child: _inputField(widget.model),
                  ),
                ),
              ),
            ),
            _suffixCloseIcon(context),
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

  Widget _inputField(M model) {
    if (model is TextBoxModel) {
      return _TextField(
        model: model,
        autofocus: widget.autofocus,
        controller: _controller,
        focusNode: _focusNode,
        validators: widget.validators,
        changeValueOnFocusChanged: widget.changeValueOnFocusChanged,
        onValueChanged: _wrapWithValidation(
          context: context,
          func: widget.onValueChanged,
        ),
        onValueFocused: _wrapWithValidation(
          context: context,
          func: widget.onValueFocused,
        ),
        onValueUnfocused: _wrapWithValidationReset(
          context: context,
          func: widget.onValueUnfocused,
        ),
        foregroundColor: _foregroundColor,
        hintColor: _hintColor,
        labelColor: _labelColor,
        fontSize: widget.fontSize,
        margin: widget.inputFieldMargin,
        borderRadius: widget.borderRadius,
        floatingLabelBehavior: widget.floatingLabelBehavior,
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
        floatingLabelBehavior: widget.floatingLabelBehavior,
      );
    }

    throw Exception(
      "Cannot create input box by model of type ${widget.model.runtimeType}",
    );
  }

  Widget _suffixCloseIcon(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _closeIconNotifier,
      builder: (_, value, child) {
        if (!value) {
          return const SizedBox.shrink();
        }

        return GestureDetector(
          onTap: () {
            _controller.clear();
            _wrapWithValidationReset(
              context: context,
              func: widget.onValueChanged,
            )?.call("");
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 7),
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: _foregroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close_rounded,
                color: _backgroundColor,
                size: 12,
              ),
            ),
          ),
        );
      },
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

  void Function(String)? _wrapWithValidation({
    required BuildContext context,
    required void Function(String)? func,
    bool validateEmptyValue = false,
  }) {
    if (_validationKey == null) {
      return func;
    }

    return (value) {
      if (!validateEmptyValue && value.isEmpty) {
        return _wrapWithValidationReset(
          context: context,
          func: func,
        )?.call(value);
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

  void Function(String)? _wrapWithValidationReset({
    required BuildContext context,
    required void Function(String)? func,
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
    required this.controller,
    required this.autofocus,
    required this.focusNode,
    this.validators = const [],
    this.changeValueOnFocusChanged = true,
    this.onValueChanged,
    this.onValueFocused,
    this.onValueUnfocused,
    required this.foregroundColor,
    required this.hintColor,
    required this.labelColor,
    required this.fontSize,
    required this.margin,
    required this.borderRadius,
    this.floatingLabelBehavior,
  });

  final TextBoxModel model;
  final TextEditingController controller;
  final bool autofocus;
  final FocusNode focusNode;
  final List<InputValidator> validators;
  final bool changeValueOnFocusChanged;
  final void Function(String)? onValueChanged;
  final void Function(String)? onValueFocused;
  final void Function(String)? onValueUnfocused;
  final Color foregroundColor;
  final Color hintColor;
  final Color labelColor;
  final double fontSize;
  final EdgeInsets margin;
  final BorderRadius borderRadius;
  final FloatingLabelBehavior? floatingLabelBehavior;

  @override
  State<StatefulWidget> createState() => _TextFieldState();
}

class _TextFieldState extends State<_TextField>
    with FocusNodeMixin, TextControllerMixin {
  late void Function() _focusListener;

  String? _hint;

  @override
  void initState() {
    _hint = widget.model.hintUnfocused;

    initControllerValue(
      widget.controller,
      widget.autofocus ? widget.model.value : widget.model.valueUnfocused,
    );

    _focusListener = addFocusListener(
      focusNode: widget.focusNode,
      onFocusSelected: () {
        widget.onValueFocused?.call(widget.controller.text);

        if (widget.changeValueOnFocusChanged) {
          updateTextControllerValue(
            widget.controller,
            value: widget.model.value,
          );
        }

        setState(() {
          _hint = widget.model.hint;
        });
      },
      onFocusLeft: () {
        widget.onValueUnfocused?.call(widget.controller.text);

        if (widget.changeValueOnFocusChanged) {
          updateTextControllerValue(
            widget.controller,
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
        widget.controller,
        value: newModel.value,
      );
    } else if (!widget.focusNode.hasFocus &&
        newModel.valueUnfocused != oldModel.valueUnfocused) {
      updateTextControllerValue(
        widget.controller,
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
      controller: widget.controller,
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
        floatingLabelBehavior: widget.floatingLabelBehavior,
      ).copyWith(
        counterText: "",
        suffixText: widget.model.textLengthCounterVisible
            ? '${widget.controller.text.length}/${widget.model.maxTextLength}'
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
    this.floatingLabelBehavior,
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
  final FloatingLabelBehavior? floatingLabelBehavior;

  @override
  State<StatefulWidget> createState() => _ListFieldState();
}

class _ListFieldState extends State<_ListField> with FocusNodeMixin {
  late bool _isDropdownOpen;
  late ValueNotifier<ListValueModel?> _selectedValueNotifier;

  TextEditingController? _dropdownSearchController;
  FocusNode? _dropdownSearchFocusNode;
  String? _hint;

  @override
  void initState() {
    super.initState();

    _hint = widget.model.hint;
    _isDropdownOpen = false;
    _selectedValueNotifier = ValueNotifier(widget.model.value);

    if (widget.model.searchEnabled) {
      _dropdownSearchController = TextEditingController();
      _dropdownSearchFocusNode = initOrGetFocusNode();
    }
  }

  @override
  void dispose() {
    disposeFocusNode(focusNode: _dropdownSearchFocusNode);
    _dropdownSearchController?.dispose();
    _selectedValueNotifier.dispose();
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
            floatingLabelBehavior: widget.floatingLabelBehavior,
          ),
          style: _inputFieldTextStyle(
            fontSize: widget.fontSize,
            foregroundColor: widget.foregroundColor,
          ),
          valueListenable: _selectedValueNotifier,
          items: widget.model.listValues
              .map(
                (value) => DropdownItem(
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
          buttonStyleData: const FormFieldButtonStyleData(
            padding: EdgeInsets.zero,
          ),
          dropdownSearchData: _dropdownSearchController != null &&
                  _dropdownSearchFocusNode != null
              ? DropdownSearchData(
                  searchController: _dropdownSearchController,
                  searchBarWidgetHeight: 80,
                  searchBarWidget: Container(
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 0,
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
                      focusNode: _dropdownSearchFocusNode,
                      fontSize: 15,
                    ),
                  ),
                  searchMatchFn: (item, searchValue) {
                    return item.value?.value
                            .toLowerCase()
                            .contains(searchValue.toLowerCase()) ??
                        false;
                  },
                  noResultsWidget: const DropdownItem(
                    enabled: false,
                    alignment: Alignment.center,
                    height: 30,
                    child: Text(
                      "No items found",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
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
