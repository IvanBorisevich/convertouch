import 'dart:developer';

import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/utils/input_validators/input_validator.dart';
import 'package:convertouch/domain/utils/list_values_utils.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_events.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_states.dart';
import 'package:convertouch/presentation/bloc/common/items_list/list_values_bloc.dart';
import 'package:convertouch/presentation/bloc/common/root_screen/root_screen_bloc.dart';
import 'package:convertouch/presentation/bloc/common/root_screen/root_screen_states.dart';
import 'package:convertouch/presentation/controller/validation_controller.dart';
import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
import 'package:convertouch/presentation/ui/utils/common_utils.dart';
import 'package:convertouch/presentation/ui/widgets/dialog/failure_dialog.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/input_box_icon_model.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/input_box_icon_wrapper.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/mixin/focus_node_mixin.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/mixin/text_controller_mixin.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/outline_input_border_ext.dart';
import 'package:convertouch/presentation/ui/widgets/input_validation_tooltip.dart';
import 'package:convertouch/presentation/ui/widgets/svg_icon.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_tooltip/super_tooltip.dart';

const Map<ConvertouchValueType, TextInputType> _valueTypeToKeyboardType = {
  ConvertouchValueType.text: TextInputType.text,
  ConvertouchValueType.integer: TextInputType.numberWithOptions(
    signed: true,
    decimal: false,
  ),
  ConvertouchValueType.integerNonNegative: TextInputType.numberWithOptions(
    signed: false,
    decimal: false,
  ),
  ConvertouchValueType.decimal: TextInputType.numberWithOptions(
    signed: true,
    decimal: true,
  ),
  ConvertouchValueType.decimalNonNegative: TextInputType.numberWithOptions(
    signed: false,
    decimal: true,
  ),
  ConvertouchValueType.hexadecimal: TextInputType.text,
};

final Map<ConvertouchValueType, RegExp> _valueTypeToRegExp = {
  ConvertouchValueType.text: RegExp(r'(^[\S ]+$)'),
  ConvertouchValueType.integer: RegExp(r'(^[.-]?$)|(^-?\d+$)'),
  ConvertouchValueType.integerNonNegative: RegExp(r'(^\d+$)'),
  ConvertouchValueType.decimal: RegExp(r'(^[.-]?$)|(^-?\d+\.?\d*$)'),
  ConvertouchValueType.decimalNonNegative: RegExp(r'(^\d+\.?\d*$)'),
  ConvertouchValueType.hexadecimal: RegExp(r'^0[xX][\da-fA-F]+$'),
};

const double _defaultFontSize = 18;
const double _defaultDropdownItemFontSize = 17;
const double _refreshButtonWidth = 25;

const String _defaultSearchHint = "Search...";
const ValueModel _noValueHint = ValueModel.rawStr('-');
const double _defaultListItemHeight = 45;
const String _fetchErrorMsg = "Something went wrong during fetch";

class ConvertouchInputBox<M extends ItemValueModel> extends StatefulWidget {
  const ConvertouchInputBox({
    required this.model,
    this.conversionGroupName,
    this.conversionParams,
    this.focusNode,
    this.autofocus = false,
    this.readonly = false,
    this.tooltipDirection = TooltipDirection.down,
    this.controller,
    this.onValueChanged,
    this.onValueFocused,
    this.onValueUnfocused,
    this.validators = const [],
    this.borderWidth = 1,
    required this.colors,
    required this.dialogColors,
    this.prefixIcons = const [],
    this.suffixIcons = const [],
    this.iconsSpacing,
    this.outermostSpacingWithoutIcons,
    this.outermostSpacingWithIcons,
    this.fontSize = _defaultFontSize,
    this.floatingLabelBehavior,
    this.labelText,
    this.maxTextLength,
    this.textLengthCounterVisible = false,
    required this.theme,
    super.key,
  });

  final M model;
  final String? conversionGroupName;
  final ConversionParamSetValueModel? conversionParams;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool readonly;
  final TooltipDirection tooltipDirection;
  final TextEditingController? controller;
  final void Function(
    ValueModel?, {
    ListValuesFetchResult? listValues,
  })? onValueChanged;
  final void Function(ValueModel?)? onValueFocused;
  final void Function(ValueModel?)? onValueUnfocused;
  final List<InputValidator> validators;
  final double borderWidth;
  final InputBoxColorScheme colors;
  final WidgetColorScheme dialogColors;
  final List<InputBoxIconModel> prefixIcons;
  final List<InputBoxIconModel> suffixIcons;
  final double? iconsSpacing;
  final double? outermostSpacingWithoutIcons;
  final double? outermostSpacingWithIcons;
  final double fontSize;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final String? labelText;
  final int? maxTextLength;
  final bool textLengthCounterVisible;
  final ConvertouchUITheme theme;

  @override
  State<ConvertouchInputBox<M>> createState() => _ConvertouchInputBoxState<M>();
}

class _ConvertouchInputBoxState<M extends ItemValueModel>
    extends State<ConvertouchInputBox<M>>
    with FocusNodeMixin, TextControllerMixin {
  Key? _validationKey;
  late final FocusNode _focusNode;
  void Function()? _focusListener;
  late final TextEditingController _controller;

  late Color _backgroundColor;
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

    _focusNode = initOrGetFocusNode(initial: widget.focusNode);
    _controller = initOrGetController(initial: widget.controller);

    _setColors();

    _focusListener = addFocusListener(
      focusNode: _focusNode,
      onFocusSelected: () {
        if (!mounted || widget.readonly) return;

        setState(() {
          _setColors();
        });
      },
      onFocusLeft: () {
        if (!mounted || widget.readonly) return;

        setState(() {
          _setColors();
        });
      },
    );
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      disposeTextController(
        controller: _controller,
      );
    }

    if (widget.focusNode == null) {
      disposeFocusNode(
        focusNode: _focusNode,
        listener: _focusListener,
      );
    }

    super.dispose();
  }

  @override
  void didUpdateWidget(ConvertouchInputBox<M> oldWidget) {
    super.didUpdateWidget(oldWidget);

    log("input box didUpdateWidget(), widget model: ${widget.model}");

    if (widget.colors != oldWidget.colors || widget.model != oldWidget.model) {
      _setColors();
    }
  }

  void _setColors() {
    if (widget.readonly) {
      _backgroundColor = widget.colors.textBox.background.disabled;
      _foregroundColor = widget.colors.textBox.foreground.disabled;
      _hintColor = widget.colors.textBox.hint.disabled;
      _labelColor = widget.colors.textBox.label.disabled;
      _borderColor = widget.colors.textBox.border.disabled;
      _dividerColor = widget.colors.divider.disabled;
    } else if (_focusNode.hasFocus) {
      _backgroundColor = widget.colors.textBox.background.focused;
      _foregroundColor = widget.colors.textBox.foreground.focused;
      _hintColor = widget.colors.textBox.hint.focused;
      _labelColor = widget.colors.textBox.label.focused;
      _borderColor = widget.colors.textBox.border.focused;
      _dividerColor = widget.colors.divider.focused;
    } else {
      _backgroundColor = widget.colors.textBox.background.regular;
      _foregroundColor = widget.colors.textBox.foreground.regular;
      _hintColor = widget.colors.textBox.hint.regular;
      _labelColor = widget.colors.textBox.label.regular;
      _borderColor = widget.colors.textBox.border.regular;
      _dividerColor = widget.colors.divider.regular;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(defaultBorderRadius),
        ),
        border: widget.borderWidth > 0
            ? Border.all(
                color: _borderColor,
                width: widget.borderWidth,
              )
            : null,
      ),
      child: _inputField(context),
    );
  }

  Widget _inputField(BuildContext context) {
    if (widget.model.listType == null) {
      return _TextField(
        model: widget.model,
        validationKey: _validationKey,
        tooltipDirection: widget.tooltipDirection,
        conversionGroupName: widget.conversionGroupName,
        conversionParams: widget.conversionParams,
        readonly: widget.readonly,
        maxTextLength: widget.maxTextLength,
        textLengthCounterVisible:
            !widget.readonly && widget.textLengthCounterVisible,
        labelText: widget.labelText,
        autofocus: widget.autofocus,
        controller: _controller,
        focusNode: _focusNode,
        validators: widget.validators,
        onValueChanged: widget.onValueChanged,
        onValueFocused: widget.onValueFocused,
        onValueUnfocused: widget.onValueUnfocused,
        prefixIcons: widget.prefixIcons,
        suffixIcons: widget.suffixIcons,
        iconsSpacing: widget.iconsSpacing,
        outermostSpacingWithoutIcons: widget.outermostSpacingWithoutIcons,
        outermostSpacingWithIcons: widget.outermostSpacingWithIcons,
        backgroundColor: _backgroundColor,
        foregroundColor: _foregroundColor,
        hintColor: _hintColor,
        labelColor: _labelColor,
        dividerColor: _dividerColor,
        dialogColors: widget.dialogColors,
        tooltipColors: widget.colors.textBox.tooltip,
        fontSize: widget.fontSize,
        floatingLabelBehavior: widget.floatingLabelBehavior,
      );
    } else {
      return _ListField(
        model: widget.model,
        conversionGroupName: widget.conversionGroupName,
        conversionParams: widget.conversionParams,
        labelText: widget.labelText,
        controller: widget.controller,
        onValueChanged: widget.onValueChanged,
        prefixIcons: widget.prefixIcons,
        suffixIcons: widget.suffixIcons,
        iconsSpacing: widget.iconsSpacing,
        outermostSpacingWithoutIcons: widget.outermostSpacingWithoutIcons,
        outermostSpacingWithIcons: widget.outermostSpacingWithIcons,
        foregroundColor: _foregroundColor,
        warningColor: widget.colors.textBox.foreground.warning,
        hintColor: _hintColor,
        labelColor: _labelColor,
        dividerColor: _dividerColor,
        fontSize: widget.fontSize,
        dropdownColors: widget.colors.dropdown,
        dialogColors: widget.dialogColors,
        floatingLabelBehavior: widget.floatingLabelBehavior,
        theme: widget.theme,
      );
    }
  }
}

// Text field -----------------------------------------------------------------

class _TextField<M extends ItemValueModel> extends StatefulWidget {
  const _TextField({
    required this.model,
    this.validationKey,
    this.validators = const [],
    this.tooltipDirection = TooltipDirection.down,
    this.conversionGroupName,
    this.conversionParams,
    required this.controller,
    required this.autofocus,
    required this.focusNode,
    this.onValueChanged,
    this.onValueFocused,
    this.onValueUnfocused,
    this.prefixIcons = const [],
    this.suffixIcons = const [],
    this.iconsSpacing,
    this.outermostSpacingWithoutIcons,
    this.outermostSpacingWithIcons,
    this.labelText,
    this.readonly = false,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.hintColor,
    required this.labelColor,
    required this.dividerColor,
    required this.dialogColors,
    required this.tooltipColors,
    required this.fontSize,
    this.maxTextLength,
    this.textLengthCounterVisible = false,
    this.floatingLabelBehavior,
  });

  final M model;
  final Key? validationKey;
  final List<InputValidator> validators;
  final TooltipDirection tooltipDirection;
  final String? conversionGroupName;
  final ConversionParamSetValueModel? conversionParams;
  final TextEditingController controller;
  final bool autofocus;
  final FocusNode focusNode;
  final void Function(ValueModel?)? onValueChanged;
  final void Function(ValueModel?)? onValueFocused;
  final void Function(ValueModel?)? onValueUnfocused;
  final List<InputBoxIconModel> prefixIcons;
  final List<InputBoxIconModel> suffixIcons;
  final double? iconsSpacing;
  final double? outermostSpacingWithoutIcons;
  final double? outermostSpacingWithIcons;
  final String? labelText;
  final bool readonly;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color hintColor;
  final Color labelColor;
  final Color dividerColor;
  final WidgetColorScheme dialogColors;
  final NotificationColorScheme tooltipColors;
  final double fontSize;
  final int? maxTextLength;
  final bool textLengthCounterVisible;
  final FloatingLabelBehavior? floatingLabelBehavior;

  @override
  State<_TextField<M>> createState() => _TextFieldState<M>();
}

class _TextFieldState<M extends ItemValueModel> extends State<_TextField<M>>
    with FocusNodeMixin, TextControllerMixin {
  late void Function() _focusListener;

  void Function(ValueModel?)? _onValueChanged;
  void Function(ValueModel?)? _onValueFocused;
  void Function(ValueModel?)? _onValueUnfocused;

  late final ValueNotifier<bool> _closeIconVisibilityNotifier;

  late String? _labelText;
  late String? _hint;

  @override
  void initState() {
    super.initState();

    _labelText = widget.labelText ?? widget.model.name;
    _hint = _getHint(widget.model, focused: widget.autofocus);

    _closeIconVisibilityNotifier = ValueNotifier(false);

    _onValueChanged = _wrapWithValidation(
      context: context,
      validationKey: widget.validationKey,
      validators: widget.validators,
      func: (value) {
        _closeIconVisibilityNotifier.value = !widget.readonly &&
            widget.model.listType == null &&
            value != null &&
            value.hasRawValue;
        widget.onValueChanged?.call(value);
      },
    );

    _onValueFocused = _wrapWithValidation(
      context: context,
      validationKey: widget.validationKey,
      validators: widget.validators,
      func: widget.onValueFocused,
    );

    _onValueUnfocused = _wrapWithValidationReset(
      context: context,
      validationKey: widget.validationKey,
      func: widget.onValueUnfocused,
    );

    initTextControllerValue(
      widget.controller,
      _getMainValue(widget.model, focused: widget.autofocus),
    );

    _focusListener = addFocusListener(
      focusNode: widget.focusNode,
      onFocusSelected: () {
        if (!mounted || widget.readonly) return;

        _closeIconVisibilityNotifier.value = widget.controller.text.isNotEmpty;

        _onValueFocused?.call(widget.model.value);

        setState(() {
          _hint = _getHint(widget.model, focused: true);
        });
      },
      onFocusLeft: () {
        if (!mounted || widget.readonly) return;

        _closeIconVisibilityNotifier.value = false;

        _onValueUnfocused?.call(widget.model.defaultValue);

        setState(() {
          _hint = _getHint(widget.model, focused: false);
        });
      },
    );
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_focusListener);

    _closeIconVisibilityNotifier.dispose();

    super.dispose();
  }

  @override
  void didUpdateWidget(_TextField<M> oldWidget) {
    super.didUpdateWidget(oldWidget);

    log("text field didUpdateWidget(), widget model: ${widget.model}");

    _labelText = widget.labelText ?? widget.model.name;

    if (widget.model.value != oldWidget.model.value) {
      updateTextControllerValue(
        widget.controller,
        _getMainValue(widget.model, focused: widget.focusNode.hasFocus),
      );
    }

    if (widget.model.defaultValue != oldWidget.model.defaultValue) {
      _hint = _getHint(widget.model, focused: widget.focusNode.hasFocus);
    }
  }

  String _getMainValue(M model, {required bool focused}) {
    return (focused ? model.value?.raw : model.value?.alt) ?? "";
  }

  String? _getHint(M model, {required bool focused}) {
    return (focused ? model.defaultValue?.raw : model.defaultValue?.alt) ??
        _noValueHint.raw;
  }

  @override
  Widget build(BuildContext context) {
    RegExp? inputRegExp = _valueTypeToRegExp[widget.model.valueType];

    return ValueListenableBuilder(
      valueListenable: _closeIconVisibilityNotifier,
      builder: (_, closeIconVisible, child) {
        return InputBoxIconWrapper(
          iconSpacing: widget.iconsSpacing,
          outermostSpacingWithoutIcons: widget.outermostSpacingWithoutIcons,
          outermostSpacingWithIcons: widget.outermostSpacingWithIcons,
          dividerColor: widget.dividerColor,
          prefixIconsModels: widget.prefixIcons,
          suffixIconsModels: [
            InputBoxIconModel.icon(
              width: 28,
              visible: closeIconVisible,
              onTap: () {
                widget.controller.clear();
                _wrapWithValidationReset(
                  context: context,
                  validationKey: widget.validationKey,
                  func: _onValueChanged,
                )?.call(null);
              },
              builder: () => Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: widget.foregroundColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close_rounded,
                  color: widget.backgroundColor,
                  size: 12,
                ),
              ),
            ),
            ...widget.suffixIcons,
          ],
          child: _validationWrapper(
            validationKey: widget.validationKey,
            focusNode: widget.focusNode,
            tooltipDirection: widget.tooltipDirection,
            tooltipColors: widget.tooltipColors,
            child: GestureDetector(
              onTap: () {
                widget.focusNode.requestFocus();
              },
              child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(defaultBorderRadius),
                  ),
                ),
                child: TextField(
                  readOnly: widget.readonly,
                  maxLength: widget.maxTextLength,
                  textAlignVertical: TextAlignVertical.center,
                  obscureText: false,
                  autofocus: widget.autofocus,
                  focusNode: widget.focusNode,
                  controller: widget.controller,
                  inputFormatters: inputRegExp != null
                      ? [FilteringTextInputFormatter.allow(inputRegExp)]
                      : null,
                  keyboardType:
                      _valueTypeToKeyboardType[widget.model.valueType],
                  onChanged: (value) {
                    _onValueChanged?.call(ValueModel.str(value));
                  },
                  decoration: _inputFieldDecoration(
                    context,
                    labelText: _labelText,
                    hintText: _hint,
                    hintColor: widget.hintColor,
                    labelColor: widget.labelColor,
                    floatingLabelBehavior: widget.floatingLabelBehavior,
                    contentPadding: const EdgeInsets.only(
                      top: 5,
                      bottom: 12,
                    ),
                  ).copyWith(
                    suffixText: widget.textLengthCounterVisible
                        ? '${widget.controller.text.length}/${widget.maxTextLength}'
                        : null,
                  ),
                  style: _inputFieldTextStyle(
                    fontSize: widget.fontSize,
                    foregroundColor: widget.foregroundColor,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// List field -----------------------------------------------------------------

class _ListField<M extends ItemValueModel> extends StatefulWidget {
  const _ListField({
    required this.model,
    this.conversionGroupName,
    this.conversionParams,
    this.controller,
    this.onValueChanged,
    this.prefixIcons = const [],
    this.suffixIcons = const [],
    this.iconsSpacing,
    this.outermostSpacingWithoutIcons,
    this.outermostSpacingWithIcons,
    this.labelText,
    required this.foregroundColor,
    required this.warningColor,
    required this.hintColor,
    required this.labelColor,
    required this.dividerColor,
    required this.fontSize,
    required this.dropdownColors,
    required this.dialogColors,
    this.floatingLabelBehavior,
    required this.theme,
  });

  final M model;
  final String? conversionGroupName;
  final ConversionParamSetValueModel? conversionParams;
  final TextEditingController? controller;
  final void Function(
    ValueModel?, {
    ListValuesFetchResult? listValues,
  })? onValueChanged;
  final List<InputBoxIconModel> prefixIcons;
  final List<InputBoxIconModel> suffixIcons;
  final double? iconsSpacing;
  final double? outermostSpacingWithoutIcons;
  final double? outermostSpacingWithIcons;
  final String? labelText;
  final Color foregroundColor;
  final Color warningColor;
  final Color hintColor;
  final Color labelColor;
  final Color dividerColor;
  final double fontSize;
  final DropdownColorScheme dropdownColors;
  final WidgetColorScheme dialogColors;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final ConvertouchUITheme theme;

  @override
  State<_ListField<M>> createState() => _ListFieldState<M>();
}

class _ListFieldState<M extends ItemValueModel> extends State<_ListField<M>>
    with FocusNodeMixin {
  late bool _isDropdownStateChangedProgrammatically;
  late String? _labelText;

  late final ValueNotifier<bool> _dropdownIsOpenNotifier;
  late final ValueNotifier<ListValuesFetchResult?> _listValuesNotifier;
  late final ValueNotifier<ValueModel?> _selectedMainValueNotifier;
  late final ValueNotifier<ValueModel> _hintNotifier;
  late final ValueNotifier<Object?> _openDropdownNotifier;

  TextEditingController? _dropdownSearchController;
  FocusNode? _dropdownSearchFocusNode;

  @override
  void initState() {
    super.initState();

    _labelText = widget.labelText ?? widget.model.name;
    _isDropdownStateChangedProgrammatically = false;

    _dropdownIsOpenNotifier = ValueNotifier(false);
    _listValuesNotifier = ValueNotifier(widget.model.listValuesFetchResult);
    _selectedMainValueNotifier = ValueNotifier(null);
    _hintNotifier = ValueNotifier(_noValueHint);

    log("list field initState(), widget model: ${widget.model}");

    _distributeSelectedValue(
      currentSelectedValue: widget.model.value,
      listValuesFetchResult: widget.model.listValuesFetchResult,
    );

    _openDropdownNotifier = ValueNotifier<Object?>(null);

    if (widget.model.listValuesFetchResult?.searchable == true) {
      _initDropdownSearch();
    }
  }

  bool _fetchNewListValues(ListValuesFetchResult? listValuesFetchResult) {
    return listValuesFetchResult == null ||
        listValuesFetchResult.isEmpty &&
            !listValuesFetchResult.hasReachedMax &&
            !listValuesFetchResult.isFailed;
  }

  void _distributeSelectedValue({
    required ValueModel? currentSelectedValue,
    required ListValuesFetchResult? listValuesFetchResult,
  }) {
    log("Distribute selected value: $currentSelectedValue\n"
        "list values: $listValuesFetchResult");

    bool showUnknownSelectedValue = currentSelectedValue != null &&
        (listValuesFetchResult == null ||
            listValuesFetchResult.isEmpty ||
            listValuesFetchResult.selectedItem == null);

    ValueModel? mainValue =
        showUnknownSelectedValue ? null : currentSelectedValue;
    ValueModel hintValue =
        showUnknownSelectedValue ? currentSelectedValue : _noValueHint;

    log("Distributed values, main: $mainValue, hint: $hintValue");

    _selectedMainValueNotifier.value = mainValue;
    _hintNotifier.value = hintValue;
  }

  void _initDropdownSearch() {
    _dropdownSearchController ??= TextEditingController();
    _dropdownSearchFocusNode ??= initOrGetFocusNode();
  }

  @override
  void dispose() {
    disposeFocusNode(focusNode: _dropdownSearchFocusNode);
    _openDropdownNotifier.dispose();
    _dropdownSearchController?.dispose();
    _selectedMainValueNotifier.dispose();
    _hintNotifier.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_ListField<M> oldWidget) {
    super.didUpdateWidget(oldWidget);

    log("list field didUpdateWidget(), widget model: ${widget.model}");

    _labelText = widget.labelText ?? widget.model.name;
    _listValuesNotifier.value = widget.model.listValuesFetchResult;

    _distributeSelectedValue(
      currentSelectedValue: widget.model.value,
      listValuesFetchResult: widget.model.listValuesFetchResult,
    );

    if (widget.model.listValuesFetchResult?.searchable == true) {
      _initDropdownSearch();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<RootScreenBloc, RootScreenState>(
          listener: (_, rootScreenState) {
            if (_dropdownIsOpenNotifier.value) {
              Navigator.of(context).pop();
            }
          },
        ),
        BlocListener<ListValuesBloc,
            ItemsFetched<ValueModel, ListValuesFetchParams>>(
          listener: (_, listValuesFetchState) {
            final listFetchResult = listValuesFetchState.itemsFetch;
            final fetchParams = listFetchResult.fetchParams;
            final validatedSelectedValue = listFetchResult.selectedItem;

            if (fetchParams == null || fetchParams.itemId != widget.model.id) {
              return;
            }

            _listValuesNotifier.value = listFetchResult;

            log("ListValuesBloc listener, "
                "list values fetched: $listFetchResult");

            if (listFetchResult.isLoading) {
              return;
            }

            if (listFetchResult.isSuccess) {
              widget.onValueChanged?.call(
                validatedSelectedValue,
                listValues: listFetchResult,
              );

              _distributeSelectedValue(
                currentSelectedValue: validatedSelectedValue,
                listValuesFetchResult: listFetchResult,
              );

              log("Separated values: "
                  "main value: ${_selectedMainValueNotifier.value}, "
                  "hint: ${_hintNotifier.value}");

              if (listFetchResult.searchable) {
                _initDropdownSearch();
              }
            }

            _refreshDropdown();
          },
        ),
      ],
      child: ValueListenableBuilder(
        valueListenable: _listValuesNotifier,
        builder: (_, listValuesFetchResult, child) {
          final items = _buildDropdownItems(context, listValuesFetchResult);

          return ValueListenableBuilder(
            valueListenable: _selectedMainValueNotifier,
            builder: (_, selectedValue, child) {
              return DropdownButtonHideUnderline(
                child: ValueListenableBuilder(
                  valueListenable: _hintNotifier,
                  builder: (_, hint, child) {
                    bool selectedValueIconVisible =
                        widget.model.listType!.defaultIconUri != null &&
                            (selectedValue ?? hint) != _noValueHint;

                    return ValueListenableBuilder(
                      valueListenable: _dropdownIsOpenNotifier,
                      builder: (_, isDropdownOpen, child) {
                        return InputBoxIconWrapper(
                          iconSpacing: widget.iconsSpacing,
                          outermostSpacingWithoutIcons:
                              widget.outermostSpacingWithoutIcons,
                          outermostSpacingWithIcons:
                              widget.outermostSpacingWithIcons,
                          dividerColor: widget.dividerColor,
                          prefixIconsModels: [
                            ...widget.prefixIcons,
                            InputBoxIconModel.icon(
                              width: 30,
                              visible: selectedValueIconVisible,
                              builder: () => ConvertouchSvgIcon(
                                uri: (selectedValue ?? hint).iconUri,
                                defaultUri:
                                    widget.model.listType!.defaultIconUri,
                                defaultColor:
                                    widget.dropdownColors.icon.regular,
                              ),
                            ),
                          ],
                          suffixIconsModels: [
                            _suffixRefreshIcon(
                              context,
                              listValuesFetchResult: listValuesFetchResult,
                              isDropdownOpen: isDropdownOpen,
                            ),
                            ...widget.suffixIcons,
                          ],
                          childBuilder: (leftPadding, rightPadding) =>
                              DropdownButtonFormField2<ValueModel>(
                            items: items,
                            valueListenable: _selectedMainValueNotifier,
                            openDropdownListenable: _openDropdownNotifier,
                            isExpanded: true,
                            decoration: _inputFieldDecoration(
                              context,
                              labelText: _labelText,
                              labelColor: widget.labelColor,
                              floatingLabelBehavior:
                                  widget.floatingLabelBehavior,
                              contentPadding: EdgeInsets.only(
                                left: leftPadding,
                                right: rightPadding,
                                top: 5,
                                bottom: 12,
                              ),
                            ),
                            style: _inputFieldTextStyle(
                              fontSize: widget.fontSize,
                              foregroundColor: widget.foregroundColor,
                            ),
                            onChanged: (selectedValue) {
                              if (selectedValue != null &&
                                  selectedValue !=
                                      _selectedMainValueNotifier.value) {
                                log("Change selected list value to: $selectedValue");

                                _selectedMainValueNotifier.value =
                                    selectedValue;
                                widget.onValueChanged?.call(selectedValue);
                              }
                            },
                            hint: Text(
                              hint.itemName,
                              style: _inputFieldTextStyle(
                                fontSize: widget.fontSize,
                                foregroundColor: hint != _noValueHint
                                    ? widget.foregroundColor
                                    : widget.hintColor,
                              ),
                            ),
                            /*
                         WA to align paddings between
                        DropdownButtonFormField2, its label over the border
                        and DropdownMenuItem
                      */
                            selectedItemBuilder: (context) {
                              return (listValuesFetchResult?.items ?? []).map(
                                (value) {
                                  final resultValue =
                                      selectedValue ?? _noValueHint;

                                  return Text(
                                    resultValue.itemName,
                                    style: _inputFieldTextStyle(
                                      fontSize: widget.fontSize,
                                      foregroundColor:
                                          resultValue != _noValueHint
                                              ? widget.foregroundColor
                                              : widget.hintColor,
                                    ),
                                  );
                                },
                              ).toList();
                            },
                            iconStyleData: const IconStyleData(
                              icon: SizedBox.shrink(),
                            ),
                            dropdownStyleData: DropdownStyleData(
                              scrollbarTheme: ScrollbarThemeData(
                                thickness: WidgetStateProperty.all(4),
                                thumbColor: WidgetStateProperty.all(
                                  widget.dropdownColors.foreground.regular,
                                ),
                                trackColor:
                                    WidgetStateProperty.all(Colors.transparent),
                                trackBorderColor:
                                    WidgetStateProperty.all(Colors.transparent),
                                trackVisibility: WidgetStateProperty.all(true),
                                radius: const Radius.circular(10),
                              ),
                              maxHeight: 250,
                              elevation: 0,
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(17)),
                                color: widget.dropdownColors.background.regular,
                              ),
                              padding: EdgeInsets.zero,
                              openInterval:
                                  const Interval(0, 0.5, curve: Curves.ease),
                              offset: const Offset(0, -5.5),
                            ),
                            menuItemStyleData: MenuItemStyleData(
                              padding: EdgeInsets.zero,
                              selectedMenuItemBuilder: (_, child) {
                                return Container(
                                  color: widget.dropdownColors.selectedItem
                                      .background.regular,
                                  child: Row(
                                    children: [
                                      Expanded(child: child),
                                      Icon(
                                        Icons.check_circle_rounded,
                                        size: 20,
                                        color: widget
                                            .dropdownColors.foreground.regular,
                                      ),
                                      const SizedBox(width: 12),
                                    ],
                                  ),
                                );
                              },
                            ),
                            buttonStyleData: const FormFieldButtonStyleData(
                              padding: EdgeInsets.zero,
                            ),
                            dropdownSearchData: _dropdownSearchController !=
                                        null &&
                                    _dropdownSearchFocusNode != null
                                ? DropdownSearchData(
                                    searchController: _dropdownSearchController,
                                    searchBarWidgetHeight: 80,
                                    searchBarWidget: Container(
                                      padding: const EdgeInsets.all(7),
                                      child: ConvertouchInputBox(
                                        model: const ItemValueModel(
                                          defaultValue: ValueModel.rawStr(
                                            _defaultSearchHint,
                                          ),
                                        ),
                                        colors: InputBoxColorScheme(
                                          textBox:
                                              widget.dropdownColors.searchBox,
                                        ),
                                        dialogColors: widget.dialogColors,
                                        prefixIcons: [
                                          InputBoxIconModel.icon(
                                            builder: () => Icon(
                                              Icons.search,
                                              color: widget.foregroundColor,
                                              size: 20,
                                            ),
                                          ),
                                        ],
                                        controller: _dropdownSearchController,
                                        focusNode: _dropdownSearchFocusNode,
                                        fontSize: 15,
                                        theme: widget.theme,
                                      ),
                                    ),
                                    searchMatchFn: (item, searchValue) {
                                      return listValuesFuncSets[
                                                  widget.model.listType]
                                              ?.searchStringPredicate(
                                                  searchValue, item.value) ??
                                          false;
                                    },
                                    noResultsWidget: _noResultsWidget(),
                                  )
                                : null,
                            onMenuStateChange: (isOpen) {
                              if (!mounted) {
                                return;
                              }

                              if (_isDropdownStateChangedProgrammatically) {
                                if (isOpen) {
                                  _isDropdownStateChangedProgrammatically =
                                      false;
                                }

                                return;
                              }

                              if (isOpen) {
                                if (_fetchNewListValues(
                                    listValuesFetchResult)) {
                                  log("Fetch new list values, "
                                      "list type = ${widget.model.listType}");

                                  _fetchListValues(
                                    context,
                                    fetchParams: ListValuesFetchParams(
                                      itemId: widget.model.id,
                                      listType: widget.model.listType!,
                                      conversionGroupName:
                                          widget.conversionGroupName,
                                      conversionParams: widget.conversionParams,
                                      leaveUnknownSelectedValue:
                                          widget.model.listType!.fetchedViaApi,
                                    ),
                                    selectedValue: selectedValue ??
                                        (hint != _noValueHint ? hint : null),
                                  );
                                }
                              } else {
                                _dropdownSearchController?.clear();
                              }

                              _dropdownIsOpenNotifier.value = isOpen;
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _refreshDropdown() {
    /* WA to refresh dropdown list values instantly */
    if (_dropdownIsOpenNotifier.value) {
      log("[${DateTime.now()}] Auto-closing the dropdown when list fetch finished");

      _isDropdownStateChangedProgrammatically = true;

      Navigator.of(context).pop();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          log("[${DateTime.now()}] Auto-opening the dropdown when list fetch finished");
          _openDropdownNotifier.value = Object();
        }
      });
    }
  }

  InputBoxIconModel _suffixRefreshIcon(
    BuildContext context, {
    ListValuesFetchResult? listValuesFetchResult,
    bool isDropdownOpen = false,
  }) {
    if (listValuesFetchResult == null || isDropdownOpen) {
      return _defaultSuffixIcon();
    }

    if (listValuesFetchResult.isFailed) {
      return InputBoxIconModel.icon(
        width: 30,
        builder: () => _refreshFailureItem(
          context,
          listValuesFetchResult: listValuesFetchResult,
          child: _refreshFailureIcon(
            padding: const EdgeInsets.only(right: 10),
          ),
        ),
      );
    }

    if (listValuesFetchResult.isLoading) {
      return InputBoxIconModel.icon(
        width: 30,
        builder: () => _refreshInProgressIcon(
          size: 20,
          padding: const EdgeInsets.only(right: 10),
        ),
      );
    }

    return _defaultSuffixIcon();
  }

  InputBoxIconModel _defaultSuffixIcon() {
    return InputBoxIconModel.icon(
      width: 28,
      builder: () => Icon(
        Icons.expand_more_rounded,
        color: widget.foregroundColor,
        size: 23,
      ),
    );
  }

  List<DropdownItem<ValueModel>>? _buildDropdownItems(
    BuildContext context,
    ListValuesFetchResult? listValuesFetchResult,
  ) {
    if (listValuesFetchResult == null || listValuesFetchResult.isLoading) {
      log("Show dropdown item 'refresh in progress'");

      return [
        DropdownItem<ValueModel>(
          enabled: false,
          alignment: Alignment.center,
          height: 40,
          child: _refreshInProgressIcon(
            size: 20,
          ),
        ),
      ];
    }

    if (listValuesFetchResult.isFailed) {
      log("Show dropdown item 'refresh failure'");

      return [
        DropdownItem(
          height: _defaultListItemHeight,
          enabled: false,
          child: _refreshFailureItem(
            context,
            listValuesFetchResult: listValuesFetchResult,
            onHandle: () {
              Navigator.of(context).pop();
            },
            child: Container(
              alignment: Alignment.center,
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 17),
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        "Refresh failed",
                        style: _inputFieldTextStyle(
                          fontSize: _defaultDropdownItemFontSize,
                          fontWeight: FontWeight.w600,
                          foregroundColor: widget.warningColor,
                        ),
                      ),
                    ),
                  ),
                  _refreshFailureIcon(size: 20),
                ],
              ),
            ),
          ),
        ),
      ];
    }

    if (listValuesFetchResult.isFinalEmpty) {
      log("Show dropdown item 'no result'");

      return [
        DropdownItem(
          height: _defaultListItemHeight,
          enabled: false,
          child: _noResultsWidget(),
        ),
      ];
    }

    log("Show dropdown items, list type: ${widget.model.listType}");

    return listValuesFetchResult.items.map((value) {
      return DropdownItem(
        value: value,
        height: _defaultListItemHeight,
        child: Padding(
          padding: const EdgeInsets.only(left: 14),
          child: Row(
            children: [
              widget.model.listType!.defaultIconUri != null &&
                      value != _noValueHint
                  ? Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ConvertouchSvgIcon(
                        uri: value.iconUri,
                        defaultUri: widget.model.listType!.defaultIconUri,
                        defaultColor: widget.dropdownColors.icon.regular,
                      ),
                    )
                  : const SizedBox.shrink(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text(
                    value.itemName,
                    style: _inputFieldTextStyle(
                      fontSize: _defaultDropdownItemFontSize,
                      foregroundColor: value != _noValueHint
                          ? widget.foregroundColor
                          : widget.hintColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _refreshFailureItem(
    BuildContext context, {
    required ListValuesFetchResult listValuesFetchResult,
    required Widget child,
    void Function()? onHandle,
  }) {
    return GestureDetector(
      onTap: () {
        showConvertouchDialog(
          currentTheme: ConvertouchUITheme.dark,
          context: context,
          builder: (_, setStateDialog) {
            return ConvertouchFailureDialog(
              title: "Refresh failed",
              handlerFunc: () {
                _fetchListValues(
                  context,
                  fetchParams: listValuesFetchResult.fetchParams,
                  selectedValue: listValuesFetchResult.selectedItem,
                );

                onHandle?.call();
              },
              handlerActionName: "Retry",
              content: Text(
                listValuesFetchResult.error?.message ?? _fetchErrorMsg,
                style: _inputFieldTextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  foregroundColor: widget.dialogColors.foreground.regular,
                ),
              ),
              colors: widget.dialogColors,
            );
          },
        ).then((returnedValue) {});
      },
      child: child,
    );
  }

  void _fetchListValues(
    BuildContext context, {
    required ListValuesFetchParams? fetchParams,
    required ValueModel? selectedValue,
  }) {
    BlocProvider.of<ListValuesBloc>(context).add(
      FetchItems<ValueModel, ListValuesFetchParams>(
        fetchParams: fetchParams,
        emitLoadingState: true,
        selectedItem: selectedValue,
      ),
    );
  }

  Widget _refreshFailureIcon({
    double size = _refreshButtonWidth,
    EdgeInsets padding = EdgeInsets.zero,
  }) {
    return Padding(
      padding: padding,
      child: Container(
        width: size,
        height: size,
        color: Colors.transparent,
        alignment: Alignment.center,
        child: Icon(
          Icons.sync_problem_rounded,
          color: widget.warningColor,
          size: size,
        ),
      ),
    );
  }

  Widget _refreshInProgressIcon({
    double size = _refreshButtonWidth,
    EdgeInsets padding = const EdgeInsets.all(2),
  }) {
    return Padding(
      padding: padding,
      child: Container(
        width: size,
        height: size,
        color: Colors.transparent,
        alignment: Alignment.center,
        child: CircularProgressIndicator(
          strokeCap: StrokeCap.round,
          strokeWidth: 2,
          color: widget.foregroundColor,
        ),
      ),
    );
  }

  Widget _noResultsWidget() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: Text(
        'No Items',
        style: _inputFieldTextStyle(
          fontSize: _defaultDropdownItemFontSize,
          fontWeight: FontWeight.w600,
          foregroundColor: widget.dropdownColors.foreground.regular,
        ),
      ),
    );
  }
}

// Shared --------------------------------------------------------------------

InputDecoration _inputFieldDecoration(
  BuildContext context, {
  String? labelText,
  String? hintText,
  Color? hintColor,
  required Color? labelColor,
  required EdgeInsets contentPadding,
  FloatingLabelBehavior? floatingLabelBehavior,
}) {
  return InputDecoration(
    border: labelText != null
        ? const CustomOutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(defaultBorderRadius),
            ),
            borderSide: BorderSide.none,
          )
        : const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(defaultBorderRadius),
            ),
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
                fontSize: 17,
                overflow: TextOverflow.fade,
                fontWeight: FontWeight.w600,
                foreground: Paint()..color = labelColor,
                letterSpacing: 0,
              ),
            ),
          )
        : null,
    floatingLabelBehavior: floatingLabelBehavior,
    contentPadding: contentPadding,
    filled: true,
    isDense: true,
    fillColor: Colors.transparent,
    counterText: "",
    hintText: hintText,
    hintStyle: hintColor != null
        ? TextStyle(
            foreground: Paint()..color = hintColor,
            letterSpacing: 0,
          )
        : null,
  );
}

TextStyle _inputFieldTextStyle({
  required double fontSize,
  required Color foregroundColor,
  FontWeight fontWeight = FontWeight.w500,
}) {
  return TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight,
    fontFamily: quicksandFontFamily,
    overflow: TextOverflow.fade,
    foreground: Paint()..color = foregroundColor,
    letterSpacing: 0,
  );
}

Widget _validationWrapper({
  required Key? validationKey,
  required FocusNode focusNode,
  required TooltipDirection tooltipDirection,
  required NotificationColorScheme tooltipColors,
  required Widget child,
}) {
  if (validationKey == null) {
    return child;
  }

  return InputValidationTooltip(
    validationKey: validationKey,
    focusNode: focusNode,
    colors: tooltipColors,
    tooltipDirection: tooltipDirection,
    child: child,
  );
}

void Function(ValueModel?)? _wrapWithValidation({
  required BuildContext context,
  required Key? validationKey,
  required List<InputValidator> validators,
  required void Function(ValueModel?)? func,
  bool validateEmptyValue = false,
}) {
  if (validationKey == null) {
    return func;
  }

  return (value) {
    if (!validateEmptyValue && (value == null || !value.hasRawValue)) {
      return _wrapWithValidationReset(
        context: context,
        validationKey: validationKey,
        func: func,
      )?.call(value);
    }

    validationController.validateInput(
      context,
      value: value?.raw ?? "",
      key: validationKey,
      validators: validators,
      onSuccess: ({info}) {
        func?.call(value);
      },
    );
  };
}

void Function(ValueModel?)? _wrapWithValidationReset({
  required BuildContext context,
  required Key? validationKey,
  required void Function(ValueModel?)? func,
}) {
  return (value) {
    if (validationKey != null) {
      validationController.resetValidation(context, key: validationKey);
    }

    return func?.call(value);
  };
}
