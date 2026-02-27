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
import 'package:convertouch/presentation/ui/widgets/items_view/mixin/items_lazy_loading_mixin.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_tooltip/super_tooltip.dart';

class ConvertouchInputBox<M extends InputBoxModel> extends StatefulWidget {
  final M model;
  final FocusNode? focusNode;
  final bool autofocus;
  final TooltipDirection tooltipDirection;
  final TextEditingController? textController;
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
  final EdgeInsets contentPadding;
  final EdgeInsets? labelPadding;
  final double fontSize;
  final double? letterSpacing;
  final bool changeValueOnFocusChanged;

  const ConvertouchInputBox({
    required this.model,
    this.focusNode,
    this.autofocus = false,
    this.tooltipDirection = TooltipDirection.down,
    this.textController,
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
    this.contentPadding = InputBoxConstants.defaultContentPadding,
    this.labelPadding,
    this.fontSize = InputBoxConstants.defaultFontSize,
    this.letterSpacing,
    this.changeValueOnFocusChanged = false,
    super.key,
  });

  @override
  State<ConvertouchInputBox<M>> createState() => _ConvertouchInputBoxState<M>();
}

class _ConvertouchInputBoxState<M extends InputBoxModel>
    extends State<ConvertouchInputBox<M>>
    with FocusNodeMixin, TextControllerMixin, ItemsLazyLoadingMixin {
  static const double _textHeightCoefficient = 1.2;

  Key? _validationKey;

  late final FocusNode _focusNode;
  void Function()? _focusListener;

  late bool _isDropdownOpen;
  late final TextEditingController _dropdownSearchController;

  late final TextEditingController _textController;

  String? _hint;

  late Color _foregroundColor;
  late Color _hintColor;
  late Color _labelColor;
  late Color _borderColor;
  late Color _dividerColor;

  @override
  void initState() {
    super.initState();

    if (widget.validators.isNotEmpty) {
      _validationKey = UniqueKey();
    }

    _setInitialColors();

    _focusNode = initOrGetFocusNode(widget.focusNode);

    if (widget.model is TextBoxModel) {
      _initTextBoxState(widget.model as TextBoxModel);
    } else if (widget.model is ListBoxModel) {
      _initListBoxState(widget.model as ListBoxModel);
    }
  }

  void _initTextBoxState(TextBoxModel model) {
    _hint = model.hintUnfocused;

    _textController = initOrGetController(
      widget.textController,
      initialValue: widget.autofocus ? model.value : model.valueUnfocused,
    );

    _focusListener = addFocusListener(
      focusNode: _focusNode,
      onFocusSelected: () {
        _wrapWithValidation(
          context: context,
          func: widget.onValueFocused,
        )?.call(_textController.text);

        if (widget.changeValueOnFocusChanged) {
          updateTextControllerValue(
            _textController,
            value: model.value,
          );
        }

        setState(() {
          _hint = model.hint;
          _setFocusedColors();
        });
      },
      onFocusLeft: () {
        _wrapWithValidationReset(
          context: context,
          func: widget.onValueUnfocused,
        )?.call(_textController.text);

        if (widget.changeValueOnFocusChanged) {
          updateTextControllerValue(
            _textController,
            value: model.valueUnfocused,
          );
        }

        setState(() {
          _hint = model.hintUnfocused;
          _setInitialColors();
        });
      },
    );
  }

  void _initListBoxState(ListBoxModel model) {
    _hint = model.hint;
    _dropdownSearchController = TextEditingController();
    _isDropdownOpen = false;

    _focusListener = addFocusListener(
      focusNode: _focusNode,
      onFocusSelected: () {
        setState(() {
          _setFocusedColors();
        });
      },
      onFocusLeft: () {
        setState(() {
          _setInitialColors();
        });
      },
    );
  }

  @override
  void dispose() {
    if (widget.model is TextBoxModel) {
      _disposeTextBox();
    } else if (widget.model is ListBoxModel) {
      _disposeListBox();
    }

    if (widget.focusNode == null) {
      disposeFocusNode(
        focusNode: _focusNode,
        listener: _focusListener,
      );
    }

    super.dispose();
  }

  void _disposeTextBox() {
    if (widget.textController == null) {
      disposeTextController(
        controller: _textController,
      );
    }
  }

  void _disposeListBox() {
    _dropdownSearchController.dispose();
  }

  @override
  void didUpdateWidget(ConvertouchInputBox<M> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.model is TextBoxModel) {
      _updateTextBox(
        oldModel: oldWidget.model as TextBoxModel,
        newModel: widget.model as TextBoxModel,
      );
    }
  }

  void _updateTextBox({
    required TextBoxModel oldModel,
    required TextBoxModel newModel,
  }) {
    if (_focusNode.hasFocus && newModel.value != oldModel.value) {
      updateTextControllerValue(
        _textController,
        value: newModel.value,
      );
    } else if (!_focusNode.hasFocus &&
        newModel.valueUnfocused != oldModel.valueUnfocused) {
      updateTextControllerValue(
        _textController,
        value: newModel.valueUnfocused,
      );
    }
  }

  void _setInitialColors() {
    if (widget.model.readonly) {
      _foregroundColor = widget.colors.textBox.foreground.disabled;
      _hintColor = widget.colors.textBox.hint.disabled;
      _labelColor = widget.colors.textBox.label.disabled;
      _borderColor = widget.colors.textBox.border.disabled;
      _dividerColor = widget.colors.divider.disabled;
    } else {
      _foregroundColor = widget.colors.textBox.foreground.regular;
      _hintColor = widget.colors.textBox.hint.regular;
      _labelColor = widget.colors.textBox.label.regular;
      _borderColor = widget.colors.textBox.border.regular;
      _dividerColor = widget.colors.divider.regular;
    }
  }

  void _setFocusedColors() {
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
        color: widget.colors.textBox.background.regular,
        borderRadius: widget.borderRadius,
        border: Border.all(
          color: _borderColor,
          width: widget.borderWidth,
        ),
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
                contentPadding: widget.contentPadding,
                child: _inputField(context),
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

  Widget _inputField(BuildContext context) {
    if (widget.model is TextBoxModel) {
      return _textField(
        context,
        model: widget.model as TextBoxModel,
        controller: _textController,
        onValueChanged: _wrapWithValidation(
          context: context,
          func: widget.onValueChanged,
        ),
      );
    }

    if (widget.model is ListBoxModel) {
      return _listField(
        context,
        model: widget.model as ListBoxModel,
        onValueChanged: widget.onValueChanged,
      );
    }

    throw Exception(
        "Cannot create input box by model of type ${widget.model.runtimeType}");
  }

  Widget _textField(
    BuildContext context, {
    required TextBoxModel model,
    required TextEditingController controller,
    void Function(String)? onValueChanged,
  }) {
    RegExp? inputRegExp = inputValueTypeToRegExpMap[model.valueType];

    return TextField(
      readOnly: model.readonly,
      maxLength: model.maxTextLength,
      textAlignVertical: TextAlignVertical.center,
      obscureText: false,
      autofocus: widget.autofocus,
      focusNode: _focusNode,
      controller: controller,
      inputFormatters: inputRegExp != null
          ? [FilteringTextInputFormatter.allow(inputRegExp)]
          : null,
      keyboardType: inputValueTypeToKeyboardTypeMap[model.valueType],
      onChanged: onValueChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: widget.borderRadius,
          borderSide: BorderSide.none,
        ),
        label: model.labelText != null
            ? Container(
                padding: widget.labelPadding,
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width / 2,
                ),
                child: Text(
                  model.labelText!,
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    foreground: Paint()..color = _labelColor,
                  ),
                ),
              )
            : null,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        alignLabelWithHint: true,
        hintText: _hint,
        hintStyle: TextStyle(
          foreground: Paint()..color = _hintColor,
        ),
        isDense: true,
        counterText: "",
        contentPadding: const EdgeInsets.symmetric(vertical: 7),
        suffixText: model.textLengthCounterVisible
            ? '${controller.text.length}/${model.maxTextLength}'
            : null,
        filled: true,
        fillColor: widget.colors.textBox.background.regular,
        constraints: BoxConstraints(
          maxHeight: widget.fontSize * _textHeightCoefficient +
              widget.contentPadding.vertical,
        ),
      ),
      style: TextStyle(
        foreground: Paint()..color = _foregroundColor,
        fontSize: widget.fontSize,
        fontWeight: FontWeight.w500,
        fontFamily: quicksandFontFamily,
        letterSpacing: widget.letterSpacing,
        height: _textHeightCoefficient,
      ),
      textAlign: TextAlign.start,
    );
  }

  Widget _listField(
    BuildContext context, {
    required ListBoxModel model,
    void Function(ListValueModel?)? onValueChanged,
  }) {
    DropdownColorScheme dropdownMenu = widget.colors.dropdown;

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
            border: OutlineInputBorder(
              borderRadius: widget.borderRadius,
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 7),
            isDense: true,
            label: model.labelText != null
                ? Container(
                    padding: widget.labelPadding,
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width / 2,
                    ),
                    child: Text(
                      model.labelText!,
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        foreground: Paint()..color = _labelColor,
                      ),
                    ),
                  )
                : null,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            filled: true,
            fillColor: widget.colors.textBox.background.regular,
            constraints: BoxConstraints(
              maxHeight: widget.fontSize * _textHeightCoefficient +
                  widget.contentPadding.vertical,
            ),
          ),
          style: TextStyle(
            fontSize: widget.fontSize,
            fontWeight: FontWeight.w500,
            fontFamily: quicksandFontFamily,
            height: _textHeightCoefficient,
          ),
          hint: _hint != null
              ? Text(
                  _hint!,
                  style: TextStyle(
                    fontSize: 16,
                    color: _hintColor,
                  ),
                )
              : null,
          value: model.value,
          items: model.listValues
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
          onChanged: onValueChanged,
          /*
        selectedItemBuilder is used as a workaround in order to align paddings between
        DropdownButtonFormField2, its label over the border and DropdownMenuItem
         */
          selectedItemBuilder: (context) {
            return model.listValues.map(
              (value) {
                return Container(
                  padding: EdgeInsets.zero,
                  child: Text(
                    model.value?.itemName ?? _hint ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w600,
                      foreground: Paint()..color = _foregroundColor,
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
              color: _foregroundColor,
            ),
            iconSize: 20,
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
          dropdownSearchData: model.searchEnabled
              ? DropdownSearchData(
                  searchController: _dropdownSearchController,
                  searchInnerWidgetHeight: 60,
                  searchInnerWidget: Container(
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 4,
                      right: 8,
                      left: 8,
                    ),
                    child: _inputFieldWrapper(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      child: _textField(
                        context,
                        model: TextBoxModel(
                          hint: model.searchHint,
                          hintUnfocused: model.searchHint,
                          valueType: model.listType.listValuesType,
                        ),
                        controller: _dropdownSearchController,
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

  Widget _suffixCloseIcon() {
    if (!_focusNode.hasFocus || _textController.text.isEmpty) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () {
        _textController.clear();
        widget.onValueCleaned?.call();
        _wrapWithValidationReset(
          context: context,
          func: widget.onValueChanged,
        )?.call(null);
      },
      child: Padding(
        padding: EdgeInsets.only(right: widget.contentPadding.right),
        child: Container(
          decoration: BoxDecoration(
            color: widget.colors.textBox.foreground.regular,
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(2),
          child: Icon(
            Icons.close_rounded,
            color: widget.colors.textBox.background.regular,
            size: 12,
          ),
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
    if (_validationKey != null) {
      BlocProvider.of<InputValidationBloc>(context).add(
        ResetValidation(key: _validationKey!),
      );
    }

    return func;
  }
}
