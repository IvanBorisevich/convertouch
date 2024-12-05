import 'package:convertouch/domain/constants/constants.dart';
import 'package:equatable/equatable.dart';

enum ExceptionSeverity {
  error,
  warning,
  info,
}

class ConvertouchException extends Equatable {
  final String message;
  final ExceptionSeverity severity;
  final StackTrace? stackTrace;
  final DateTime dateTime;
  final ConvertouchSysAction? handlingAction;

  const ConvertouchException({
    required this.message,
    this.severity = ExceptionSeverity.error,
    required this.stackTrace,
    required this.dateTime,
    this.handlingAction,
  });

  @override
  List<Object?> get props => [
        message,
        severity,
        stackTrace,
        dateTime,
        handlingAction,
      ];

  bool get isError => severity == ExceptionSeverity.error;

  bool get isWarning => severity == ExceptionSeverity.warning;

  bool get isInfo => severity == ExceptionSeverity.info;

  @override
  String toString() {
    return 'ConvertouchException{'
        'message: $message, '
        'stackTrace: $stackTrace, '
        'severity: $severity}';
  }
}

class DatabaseException extends ConvertouchException {
  const DatabaseException({
    required super.message,
    super.severity,
    required super.stackTrace,
    required super.dateTime,
    super.handlingAction,
  });
}

class InternalException extends ConvertouchException {
  const InternalException({
    required super.message,
    super.severity,
    required super.stackTrace,
    required super.dateTime,
    super.handlingAction,
  });
}

class NetworkException extends ConvertouchException {
  const NetworkException({
    required super.message,
    super.severity,
    required super.stackTrace,
    required super.dateTime,
    super.handlingAction,
  });
}
