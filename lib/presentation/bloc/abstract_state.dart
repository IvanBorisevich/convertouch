import 'package:convertouch/domain/model/exception_model.dart';
import 'package:equatable/equatable.dart';

abstract class ConvertouchState extends Equatable {
  const ConvertouchState();

  @override
  List<Object?> get props => [];
}

abstract class ConvertouchErrorState extends ConvertouchState {
  final ConvertouchException exception;
  final ConvertouchState lastSuccessfulState;

  const ConvertouchErrorState({
    required this.exception,
    required this.lastSuccessfulState,
  });

  @override
  List<Object?> get props => [
    exception,
    lastSuccessfulState,
  ];
}

abstract class ConvertouchNotificationState extends ConvertouchState {
  final String message;
  final ExceptionSeverity severity;

  const ConvertouchNotificationState({
    required this.message,
    this.severity = ExceptionSeverity.info,
  });

  @override
  List<Object?> get props => [
    message,
    severity,
  ];
}
