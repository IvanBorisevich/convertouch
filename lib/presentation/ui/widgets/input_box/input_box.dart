import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/utils/input_validators/input_validator.dart';
import 'package:convertouch/domain/utils/list_values_utils.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_states.dart';
import 'package:convertouch/presentation/controller/validation_controller.dart';
import 'package:convertouch/presentation/ui/model/input_box_view_model.dart';
import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
import 'package:convertouch/presentation/ui/utils/common_utils.dart';
import 'package:convertouch/presentation/ui/widgets/dialog/failure_dialog.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/mixin/focus_node_mixin.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/mixin/text_controller_mixin.dart';
import 'package:convertouch/presentation/ui/widgets/input_validation_tooltip.dart';
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

const BorderRadius _borderRadius = BorderRadius.all(Radius.circular(15));
const double _textHeightCoefficient = 1.2;

const double _defaultFontSize = 17;
const EdgeInsets _defaultInputFieldMargin = EdgeInsets.symmetric(
  vertical: 10,
  horizontal: 14,
);

const double _refreshButtonWidth = 25;

const String _defaultSearchHint = "Search...";
const String _noValueHint = '-';
const double _defaultListItemHeight = 45;
const String _fetchErrorMsg = "Something went wrong during fetch";

class ConvertouchInputBox<M extends ItemValueModel> extends StatefulWidget {
  const ConvertouchInputBox({
    required this.model,
    this.focusNode,
    this.autofocus = false,
    this.readonly = false,
    this.tooltipDirection = TooltipDirection.down,
    this.controller,
    this.onValueChanged,
    this.onValueFocused,
    this.onValueUnfocused,
    this.onRefreshTap,
    this.validators = const [],
    this.borderWidth = 1,
    required this.colors,
    required this.dialogColors,
    this.prefixWidgets = const [],
    this.suffixWidgets = const [],
    this.prefixRightmostDividerVisible = true,
    this.suffixLeftmostDividerVisible = true,
    this.inputFieldMargin = _defaultInputFieldMargin,
    this.fontSize = _defaultFontSize,
    this.floatingLabelBehavior,
    this.labelText,
    this.maxTextLength,
    this.textLengthCounterVisible = false,
    required this.theme,
    super.key,
  });

  final M model;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool readonly;
  final TooltipDirection tooltipDirection;
  final TextEditingController? controller;
  final void Function(ValueModel)? onValueChanged;
  final void Function(ValueModel)? onValueFocused;
  final void Function(ValueModel)? onValueUnfocused;
  final void Function(ListValuesFetchResult)? onRefreshTap;
  final List<InputValidator> validators;
  final double borderWidth;
  final InputBoxColorScheme colors;
  final WidgetColorScheme dialogColors;
  final List<Widget?> prefixWidgets;
  final List<Widget?> suffixWidgets;
  final bool prefixRightmostDividerVisible;
  final bool suffixLeftmostDividerVisible;
  final EdgeInsets inputFieldMargin;
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
  void Function(ValueModel)? _onValueChanged;
  late final TextEditingController _controller;
  late final ValueNotifier<bool> _closeIconNotifier;
  late final ValueNotifier<bool> _refreshProgressIconNotifier;
  late final ValueNotifier<ListValuesFetchResult?> _listValuesNotifier;
  late InputBoxViewModel _inputBoxModel;

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

    _inputBoxModel = InputBoxViewModel.ofValue(
      widget.model,
      readonly: widget.readonly,
      maxTextLength: widget.maxTextLength,
      textLengthCounterVisible: widget.textLengthCounterVisible,
      labelText: widget.labelText,
    );

    _focusNode = initOrGetFocusNode(initial: widget.focusNode);
    _controller = initOrGetController(initial: widget.controller);

    _closeIconNotifier = ValueNotifier(false);
    _refreshProgressIconNotifier = ValueNotifier(widget.model.listType != null);
    _listValuesNotifier = ValueNotifier(widget.model.listValuesFetchResult);

    _onValueChanged = (value) {
      _closeIconNotifier.value =
          _inputBoxModel is! ListBoxViewModel && value.hasRawValue;
      widget.onValueChanged?.call(value);
    };

    _setColors();

    _focusListener = addFocusListener(
      focusNode: _focusNode,
      onFocusSelected: () {
        if (!mounted) return;

        _closeIconNotifier.value =
            _inputBoxModel is! ListBoxViewModel && _controller.text.isNotEmpty;

        setState(() {
          _setColors();
        });
      },
      onFocusLeft: () {
        if (!mounted) return;

        _closeIconNotifier.value = false;

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

    _closeIconNotifier.dispose();
    _refreshProgressIconNotifier.dispose();
    _listValuesNotifier.dispose();

    super.dispose();
  }

  @override
  void didUpdateWidget(ConvertouchInputBox<M> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.colors != oldWidget.colors || widget.model != oldWidget.model) {
      _setColors();
    }

    if (widget.model != oldWidget.model) {
      _inputBoxModel = InputBoxViewModel.ofValue(
        widget.model,
        readonly: widget.readonly,
        maxTextLength: widget.maxTextLength,
        textLengthCounterVisible: widget.textLengthCounterVisible,
        labelText: widget.labelText,
      );
    }

    _listValuesNotifier.value = widget.model.listValuesFetchResult;
    _refreshProgressIconNotifier.value = widget.model.listType != null;
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
        borderRadius: _borderRadius,
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
                    decoration: const BoxDecoration(
                      borderRadius: _borderRadius,
                    ),
                    child: _inputField(_inputBoxModel, context),
                  ),
                ),
              ),
            ),
            _suffixCloseIcon(context),
            _suffixRefreshIcon(context),
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

  Widget _inputField(InputBoxViewModel model, BuildContext context) {
    if (model is TextBoxViewModel) {
      return _TextField(
        model: model,
        autofocus: widget.autofocus,
        controller: _controller,
        focusNode: _focusNode,
        validators: widget.validators,
        onValueChanged: _wrapWithValidation(
          context: context,
          func: _onValueChanged,
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
        dialogColors: widget.dialogColors,
        fontSize: widget.fontSize,
        margin: widget.inputFieldMargin,
        floatingLabelBehavior: widget.floatingLabelBehavior,
      );
    }

    if (model is ListBoxViewModel) {
      return _ListField(
        model: model,
        controller: widget.controller,
        onValueChanged: _onValueChanged,
        refreshProgressIconNotifier: _refreshProgressIconNotifier,
        listValuesNotifier: _listValuesNotifier,
        foregroundColor: _foregroundColor,
        hintColor: _hintColor,
        labelColor: _labelColor,
        fontSize: widget.fontSize,
        margin: widget.inputFieldMargin,
        dropdownColors: widget.colors.dropdown,
        dialogColors: widget.dialogColors,
        floatingLabelBehavior: widget.floatingLabelBehavior,
        theme: widget.theme,
      );
    }

    throw Exception(
      "Cannot create input box by model of type ${model.runtimeType}",
    );
  }

  Widget _suffixRefreshIcon(BuildContext context) {
    if (widget.model.listType == null ||
        !widget.model.listType!.fetchedViaApi) {
      return const SizedBox.shrink();
    }

    return ValueListenableBuilder(
      valueListenable: _listValuesNotifier,
      builder: (_, listValuesFetchResult, child) {
        if (listValuesFetchResult == null ||
            listValuesFetchResult.status == FetchingStatus.loading) {
          return ValueListenableBuilder(
            valueListenable: _refreshProgressIconNotifier,
            builder: (_, refreshIconVisible, child) {
              if (!refreshIconVisible) {
                return const SizedBox.shrink();
              }

              return Container(
                padding: const EdgeInsets.only(right: 14),
                color: Colors.transparent,
                child: Container(
                  width: _refreshButtonWidth,
                  height: _refreshButtonWidth,
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(2),
                  child: CircularProgressIndicator(
                    strokeCap: StrokeCap.round,
                    strokeWidth: 2,
                    color: _foregroundColor,
                  ),
                ),
              );
            },
          );
        }

        if (listValuesFetchResult.status == FetchingStatus.success) {
          return GestureDetector(
            onTap: () {
              widget.onRefreshTap?.call(listValuesFetchResult);
            },
            child: Container(
              height: double.infinity,
              padding: const EdgeInsets.only(right: 14),
              color: Colors.transparent,
              child: Icon(
                Icons.refresh_rounded,
                color: _foregroundColor,
                size: 25,
              ),
            ),
          );
        }

        if (listValuesFetchResult.status == FetchingStatus.failure) {
          return GestureDetector(
            onTap: () {
              showConvertouchDialog(
                currentTheme: ConvertouchUITheme.dark,
                context: context,
                builder: (context, setStateDialog) {
                  return ConvertouchFailureDialog(
                    title: "Fetch failed",
                    handlerFunc: () {
                      widget.onRefreshTap?.call(listValuesFetchResult);
                    },
                    handlerActionName: "Retry",
                    content: Text(
                      listValuesFetchResult.error?.message ?? _fetchErrorMsg,
                      style: _inputFieldTextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        foregroundColor: widget.dialogColors.foreground.regular,
                      ),
                    ),
                    colors: widget.dialogColors,
                  );
                },
              ).then((returnedValue) {});
            },
            child: Container(
              height: double.infinity,
              padding: const EdgeInsets.only(right: 14),
              color: Colors.transparent,
              child: Icon(
                Icons.sync_problem_rounded,
                color: widget.colors.textBox.foreground.warning,
                size: 25,
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
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
              func: _onValueChanged,
            )?.call(ValueModel.empty);
          },
          child: Container(
            padding: const EdgeInsets.only(right: 14),
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

  void Function(ValueModel)? _wrapWithValidation({
    required BuildContext context,
    required void Function(ValueModel)? func,
    bool validateEmptyValue = false,
  }) {
    if (_validationKey == null) {
      return func;
    }

    return (value) {
      if (!validateEmptyValue && !value.hasRawValue) {
        return _wrapWithValidationReset(
          context: context,
          func: func,
        )?.call(value);
      }

      validationController.validateInput(
        context,
        value: value.raw,
        key: _validationKey!,
        validators: widget.validators,
        onSuccess: ({info}) {
          func?.call(value);
        },
      );
    };
  }

  void Function(ValueModel)? _wrapWithValidationReset({
    required BuildContext context,
    required void Function(ValueModel)? func,
  }) {
    return (value) {
      if (_validationKey != null) {
        validationController.resetValidation(context, key: _validationKey!);
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
    this.onValueChanged,
    this.onValueFocused,
    this.onValueUnfocused,
    required this.foregroundColor,
    required this.hintColor,
    required this.labelColor,
    required this.dialogColors,
    required this.fontSize,
    required this.margin,
    this.floatingLabelBehavior,
  });

  final TextBoxViewModel model;
  final TextEditingController controller;
  final bool autofocus;
  final FocusNode focusNode;
  final List<InputValidator> validators;
  final void Function(ValueModel)? onValueChanged;
  final void Function(ValueModel)? onValueFocused;
  final void Function(ValueModel)? onValueUnfocused;
  final Color foregroundColor;
  final Color hintColor;
  final Color labelColor;
  final WidgetColorScheme dialogColors;
  final double fontSize;
  final EdgeInsets margin;
  final FloatingLabelBehavior? floatingLabelBehavior;

  @override
  State<StatefulWidget> createState() => _TextFieldState();
}

class _TextFieldState extends State<_TextField>
    with FocusNodeMixin, TextControllerMixin {
  late void Function() _focusListener;

  late String? _hint;

  @override
  void initState() {
    super.initState();

    _hint = _getHint(focused: widget.autofocus);

    initTextControllerValue(
        widget.controller, _getMainValue(focused: widget.autofocus));

    _focusListener = addFocusListener(
      focusNode: widget.focusNode,
      onFocusSelected: () {
        widget.onValueFocused?.call(widget.model.value ?? ValueModel.empty);

        setState(() {
          _hint = _getHint(focused: true);
        });
      },
      onFocusLeft: () {
        widget.onValueUnfocused?.call(widget.model.hint ?? ValueModel.empty);

        setState(() {
          _hint = _getHint(focused: false);
        });
      },
    );
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_focusListener);

    super.dispose();
  }

  @override
  void didUpdateWidget(_TextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.model.value != oldWidget.model.value) {
      updateTextControllerValue(
        widget.controller,
        _getMainValue(focused: widget.focusNode.hasFocus),
      );
    }

    if (widget.model.hint != oldWidget.model.hint) {
      _hint = _getHint(focused: widget.focusNode.hasFocus);
    }
  }

  String _getMainValue({required bool focused}) {
    return (focused ? widget.model.value?.raw : widget.model.value?.alt) ?? "";
  }

  String? _getHint({required bool focused}) {
    return (focused ? widget.model.hint?.raw : widget.model.hint?.alt) ??
        _noValueHint;
  }

  @override
  Widget build(BuildContext context) {
    RegExp? inputRegExp = _valueTypeToRegExp[widget.model.valueType];

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
      keyboardType: _valueTypeToKeyboardType[widget.model.valueType],
      onChanged: (value) {
        widget.onValueChanged?.call(ValueModel.str(value));
      },
      decoration: _inputFieldDecoration(
        context,
        margin: widget.margin,
        fontSize: widget.fontSize,
        labelText: widget.model.labelText,
        hintText: _hint,
        hintColor: widget.hintColor,
        labelColor: widget.labelColor,
        floatingLabelBehavior: widget.floatingLabelBehavior,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 4,
        ),
      ).copyWith(
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
    required this.refreshProgressIconNotifier,
    required this.listValuesNotifier,
    required this.foregroundColor,
    required this.hintColor,
    required this.labelColor,
    required this.fontSize,
    required this.margin,
    required this.dropdownColors,
    required this.dialogColors,
    this.floatingLabelBehavior,
    required this.theme,
  });

  final ListBoxViewModel model;
  final TextEditingController? controller;
  final void Function(ValueModel)? onValueChanged;
  final ValueNotifier<bool> refreshProgressIconNotifier;
  final ValueNotifier<ListValuesFetchResult?> listValuesNotifier;
  final Color foregroundColor;
  final Color hintColor;
  final Color labelColor;
  final double fontSize;
  final EdgeInsets margin;
  final DropdownColorScheme dropdownColors;
  final WidgetColorScheme dialogColors;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final ConvertouchUITheme theme;

  @override
  State<StatefulWidget> createState() => _ListFieldState();
}

class _ListFieldState extends State<_ListField> with FocusNodeMixin {
  late bool _isDropdownOpen;
  late bool _isDropdownClosedProgrammatically;

  late final ValueNotifier<ValueModel?> _selectedValueNotifier;
  late final ValueNotifier<Object?> _openDropdownNotifier;

  TextEditingController? _dropdownSearchController;
  FocusNode? _dropdownSearchFocusNode;

  @override
  void initState() {
    super.initState();

    _isDropdownOpen = false;
    _isDropdownClosedProgrammatically = false;

    _selectedValueNotifier = ValueNotifier(_getMainValue());
    widget.listValuesNotifier.addListener(_onListValuesUpdated);

    _openDropdownNotifier = ValueNotifier<Object?>(null);

    if (widget.model.searchEnabled) {
      _dropdownSearchController = TextEditingController();
      _dropdownSearchFocusNode = initOrGetFocusNode();
    }
  }

  ValueModel? _getMainValue() {
    return widget.model.valueExistsForEmptyList ? null : widget.model.value;
  }

  String _getHint() {
    return widget.model.valueExistsForEmptyList
        ? (widget.model.value?.itemName ?? _noValueHint)
        : _noValueHint;
  }

  void _onListValuesUpdated() {
    if (_isDropdownOpen) {
      log("Auto-closing dropdown on list values updated");
      Navigator.of(context).pop();

      setState(() {
        _isDropdownClosedProgrammatically = true;
      });
    }
  }

  @override
  void dispose() {
    disposeFocusNode(focusNode: _dropdownSearchFocusNode);
    widget.listValuesNotifier.removeListener(_onListValuesUpdated);
    _openDropdownNotifier.dispose();
    _dropdownSearchController?.dispose();
    _selectedValueNotifier.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_ListField oldWidget) {
    super.didUpdateWidget(oldWidget);

    _selectedValueNotifier.value = _getMainValue();

    if (widget.model.searchEnabled) {
      _dropdownSearchController ??= TextEditingController();
      _dropdownSearchFocusNode ??= initOrGetFocusNode();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<NavigationBloc, NavigationState>(
          listener: (_, navigationState) {
            if (_isDropdownOpen) {
              Navigator.of(context).pop();
            }
          },
        ),
      ],
      child: ValueListenableBuilder(
        valueListenable: widget.listValuesNotifier,
        builder: (_, listValuesFetchResult, child) {
          final items = _buildDropdownItems(listValuesFetchResult);

          return DropdownButtonHideUnderline(
            child: DropdownButtonFormField2<ValueModel>(
              valueListenable: _selectedValueNotifier,
              items: items,
              openDropdownListenable: _openDropdownNotifier,
              isExpanded: true,
              decoration: _inputFieldDecoration(
                context,
                margin: widget.margin,
                fontSize: widget.fontSize,
                labelText: widget.model.labelText,
                hintText: _getHint(),
                hintColor: widget.model.valueExistsForEmptyList
                    ? widget.foregroundColor
                    : widget.hintColor,
                labelColor: widget.labelColor,
                floatingLabelBehavior: widget.floatingLabelBehavior,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 3,
                ),
              ),
              style: _inputFieldTextStyle(
                fontSize: widget.fontSize,
                foregroundColor: widget.foregroundColor,
              ),
              onChanged: (listValue) {
                if (listValue != null) {
                  _selectedValueNotifier.value = listValue;
                  widget.onValueChanged?.call(listValue);
                }
              },
              /*
        selectedItemBuilder is used as a workaround in order to align paddings between
        DropdownButtonFormField2, its label over the border and DropdownMenuItem
         */
              selectedItemBuilder: (context) {
                return (listValuesFetchResult?.items ?? []).map(
                  (value) {
                    return ValueListenableBuilder(
                      valueListenable: _selectedValueNotifier,
                      builder: (_, selectedValue, child) {
                        return Text(
                          selectedValue?.itemName ?? _noValueHint,
                          style: _inputFieldTextStyle(
                            fontSize: widget.fontSize,
                            foregroundColor: widget.foregroundColor,
                          ),
                          maxLines: 1,
                        );
                      },
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
                openInterval: const Interval(0, 0.5, curve: Curves.ease),
                offset: const Offset(0, -7.5),
              ),
              menuItemStyleData: MenuItemStyleData(
                padding: EdgeInsets.zero,
                selectedMenuItemBuilder: (_, child) {
                  return Container(
                    color:
                        widget.dropdownColors.selectedItem.background.regular,
                    child: Row(
                      children: [
                        Expanded(child: child),
                        Icon(
                          Icons.check_circle_rounded,
                          size: 20,
                          color: widget.dropdownColors.foreground.regular,
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
              dropdownSearchData: _dropdownSearchController != null &&
                      _dropdownSearchFocusNode != null
                  ? DropdownSearchData(
                      searchController: _dropdownSearchController,
                      searchBarWidgetHeight: 80,
                      searchBarWidget: Container(
                        padding: const EdgeInsets.all(7),
                        child: ConvertouchInputBox(
                          model: ItemValueModel(
                            defaultValue: ValueModel.rawStr(
                              widget.model.searchHint ?? _defaultSearchHint,
                            ),
                          ),
                          colors: InputBoxColorScheme(
                            textBox: widget.dropdownColors.searchBox,
                          ),
                          dialogColors: widget.dialogColors,
                          inputFieldMargin: const EdgeInsets.symmetric(
                            vertical: 8,
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
                          theme: widget.theme,
                        ),
                      ),
                      searchMatchFn: (item, searchValue) {
                        return listValuesFuncSets[widget.model.listType]
                                ?.searchFunc(searchValue, item.value) ??
                            false;
                      },
                      noResultsWidget: _noResultDropdownItem,
                    )
                  : null,
              onMenuStateChange: (isOpen) {
                if (!mounted) {
                  return;
                }

                if (!isOpen) {
                  _dropdownSearchController?.clear();
                }

                if (!isOpen && _isDropdownClosedProgrammatically) {
                  log("Auto-reopening dropdown on list values updated");
                  _openDropdownNotifier.value = Object();
                }

                widget.refreshProgressIconNotifier.value = !isOpen;

                setState(() {
                  _isDropdownOpen = isOpen;
                  _isDropdownClosedProgrammatically = false;
                });
              },
            ),
          );
        },
      ),
    );
  }

  List<DropdownItem<ValueModel>>? _buildDropdownItems(
    ListValuesFetchResult? listValuesFetchResult,
  ) {
    if (listValuesFetchResult == null || listValuesFetchResult.isSuccessEmpty) {
      return [
        DropdownItem(
          height: _defaultListItemHeight,
          enabled: false,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 17),
            child: Text(
              'No Items',
              style: _inputFieldTextStyle(
                fontSize: widget.fontSize,
                fontWeight: FontWeight.w600,
                foregroundColor: widget.dropdownColors.foreground.regular,
              ),
            ),
          ),
        ),
      ];
    }

    List<DropdownItem<ValueModel>> items = listValuesFetchResult.items
        .map(
          (value) => DropdownItem(
            value: value,
            height: _defaultListItemHeight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 17),
              child: Text(
                value.itemName,
                style: _inputFieldTextStyle(
                  fontSize: widget.fontSize,
                  foregroundColor: widget.dropdownColors.foreground.regular,
                ),
              ),
            ),
          ),
        )
        .toList();

    if (listValuesFetchResult.status == FetchingStatus.loading) {
      items.add(
        DropdownItem<ValueModel>(
          enabled: false,
          alignment: Alignment.center,
          height: 40,
          child: Container(
            padding: const EdgeInsets.all(2),
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeCap: StrokeCap.round,
              strokeWidth: 2,
              color: widget.dropdownColors.foreground.regular,
            ),
          ),
        ),
      );
    }

    return items;
  }
}

// Shared methods and constants -----------------------------------------------

const DropdownItem _noResultDropdownItem = DropdownItem(
  enabled: false,
  alignment: Alignment.center,
  height: 30,
  child: Text(
    "No items found",
    style: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
    ),
  ),
);

InputDecoration _inputFieldDecoration(
  BuildContext context, {
  required EdgeInsets margin,
  required double fontSize,
  required String? labelText,
  required String? hintText,
  required Color? hintColor,
  required Color? labelColor,
  required EdgeInsets contentPadding,
  FloatingLabelBehavior? floatingLabelBehavior,
}) {
  return InputDecoration(
    border: const OutlineInputBorder(
      borderRadius: _borderRadius,
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
                letterSpacing: 0,
              ),
            ),
          )
        : null,
    floatingLabelBehavior: floatingLabelBehavior,
    alignLabelWithHint: true,
    isDense: true,
    contentPadding: labelText != null ? contentPadding : EdgeInsets.zero,
    filled: true,
    fillColor: Colors.transparent,
    constraints: BoxConstraints(
      maxHeight: fontSize * _textHeightCoefficient + margin.vertical,
    ),
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
    height: _textHeightCoefficient,
    foreground: Paint()..color = foregroundColor,
    letterSpacing: 0,
  );
}
