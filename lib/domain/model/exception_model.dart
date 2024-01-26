import 'package:equatable/equatable.dart';

enum ExceptionSeverity {
  error,
  warning,
  info,
}

abstract class ConvertouchException extends Equatable {
  final String message;
  final ExceptionSeverity severity;

  const ConvertouchException({
    required this.message,
    this.severity = ExceptionSeverity.error,
  });

  @override
  List<Object> get props => [
    message,
    severity,
  ];

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
  });
}

class PreferencesException extends ConvertouchException {
  const PreferencesException({
    required super.message,
    super.severity,
  });
}

class InternalException extends ConvertouchException {
  const InternalException({
    required super.message,
    super.severity,
  });
}

class NetworkException extends ConvertouchException {
  const NetworkException({
    required super.message,
    super.severity,
  });
}
