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

  const ConvertouchException._({
    required this.message,
    this.severity = ExceptionSeverity.errorNewPage,
    required this.stackTrace,
    required this.dateTime,
    this.handlingAction,
  });

  factory ConvertouchException({
    required String message,
    StackTrace? stackTrace,
    ExceptionSeverity severity = ExceptionSeverity.errorNewPage,
    ConvertouchSysAction? handlingAction,
  }) {
    return ConvertouchException._(
      message: message,
      stackTrace: stackTrace,
      severity: severity,
      dateTime: DateTime.now(),
      handlingAction: handlingAction,
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
