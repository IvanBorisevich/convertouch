import 'package:convertouch/domain/model/use_case_model/input/input_validation_model.dart';
import 'package:convertouch/domain/use_cases/common/validate_input_use_case.dart';
import 'package:convertouch/domain/utils/input_validators/model/input_validator_result.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/common/input_validation/input_validation_events.dart';
import 'package:convertouch/presentation/bloc/common/input_validation/input_validation_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InputValidationBloc
    extends ConvertouchBloc<InputValidationEvent, InputValidationState> {
  final ValidateInputUseCase validateInputUseCase;

  InputValidationBloc({
    required this.validateInputUseCase,
  }) : super(const InputValidationSuccess()) {
    on<ValidateInput>(_onValidateInput);
    on<ResetValidation>(_onResetValidation);
  }

  _onValidateInput(
    ValidateInput event,
    Emitter<InputValidationState> emit,
  ) async {
    final validationResult = await validateInputUseCase.execute(
      InputValidationModel(
        input: event.input,
        validators: event.validators,
      ),
    );

    InputValidatorResult validation = ObjectUtils.tryGet(validationResult);

    if (!validation.successful) {
      emit(InputValidationErrorState(validation.message!));
    } else {
      emit(const InputValidationSuccess());

      if (validation.proceedOnSuccess) {
        await event.onSuccess?.call();
      }
    }
  }

  _onResetValidation(
    ResetValidation event,
    Emitter<InputValidationState> emit,
  ) async {
    emit(const InputValidationSuccess());
  }

  Future<void> interceptWithValidation({
    bool validate = true,
    required ValidateInput validationEvent,
    required Future<void> Function() funcWithoutValidation,
  }) async {
    if (validate) {
      add(validationEvent);
    } else {
      await funcWithoutValidation.call();
    }
  }
}
