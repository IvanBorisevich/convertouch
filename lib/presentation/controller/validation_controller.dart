import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/utils/input_validators/input_validator.dart';
import 'package:convertouch/presentation/bloc/common/input_validation/input_validation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/input_validation/input_validation_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final validationController = di.locator.get<ValidationController>();

class ValidationController {
  const ValidationController();

  void validateInput(
    BuildContext context, {
    required String value,
    required Key key,
    required List<InputValidator> validators,
    void Function({ConvertouchException? info})? onSuccess,
  }) {
    BlocProvider.of<InputValidationBloc>(context).add(
      ValidateInput(
        key: key,
        input: value,
        validators: validators,
        onSuccess: onSuccess,
      ),
    );
  }

  void resetValidation(BuildContext context, {required Key key}) {
    BlocProvider.of<InputValidationBloc>(context).add(
      ResetValidation(key: key),
    );
  }
}
