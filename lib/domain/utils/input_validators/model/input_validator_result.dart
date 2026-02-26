class InputValidatorResult {
  final String? message;
  final bool proceedOnSuccess;

  const InputValidatorResult.successful()
      : proceedOnSuccess = true,
        message = null;

  const InputValidatorResult.successfulNoAfterActions()
      : proceedOnSuccess = false,
        message = null;

  const InputValidatorResult.failed(this.message) : proceedOnSuccess = false;

  bool get successful => message == null;

  @override
  String toString() {
    return 'InputValidatorResult{'
        'message: $message, '
        'proceedOnSuccess: $proceedOnSuccess}';
  }
}
