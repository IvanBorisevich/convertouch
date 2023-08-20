import 'package:equatable/equatable.dart';

abstract class FailureEntity extends Equatable {
  final String message;
  const FailureEntity(this.message);

  @override
  List<Object> get props => [message];
}

class DatabaseFailureEntity extends FailureEntity {
  const DatabaseFailureEntity(String message) : super(message);
}