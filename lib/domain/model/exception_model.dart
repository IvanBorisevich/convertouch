import 'package:convertouch/domain/constants/constants.dart';
import 'package:equatable/equatable.dart';

enum ExceptionSeverity {
  errorNewPage,
  errorNotification,
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
    this.severity = ExceptionSeverity.errorNewPage,
    required this.stackTrace,
    required this.dateTime,
    this.handlingAction,
  });

  factory ConvertouchException.compact({
    required String message,
    ExceptionSeverity severity = ExceptionSeverity.warning,
  }) {
    return ConvertouchException(
      message: message,
      stackTrace: null,
      dateTime: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        message,
        severity,
        stackTrace,
        dateTime,
        handlingAction,
      ];

  bool get isErrorNewPage => severity == ExceptionSeverity.errorNewPage;

  bool get isErrorNotification =>
      severity == ExceptionSeverity.errorNotification;

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
