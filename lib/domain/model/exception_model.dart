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

  const ConvertouchException({
    required this.message,
    this.severity = ExceptionSeverity.error,
    required this.stackTrace,
  });

  @override
  List<Object?> get props => [
    message,
    severity,
    stackTrace,
  ];

  bool get isError => severity == ExceptionSeverity.error;

  bool get isWarning => severity == ExceptionSeverity.warning;

  bool get isInfo => severity == ExceptionSeverity.info;

  @override
  String toString() {
    return 'ConvertouchException{'
        'message: $message, '
        'severity: $severity}';
  }
}

class DatabaseException extends ConvertouchException {
  const DatabaseException({
    required super.message,
    super.severity,
    required super.stackTrace,
  });
}

class InternalException extends ConvertouchException {
  const InternalException({
    required super.message,
    super.severity,
    required super.stackTrace,
  });
}

class NetworkException extends ConvertouchException {
  const NetworkException({
    required super.message,
    super.severity,
    required super.stackTrace,
  });
}
