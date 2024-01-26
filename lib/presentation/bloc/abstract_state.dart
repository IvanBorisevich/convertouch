import 'package:convertouch/domain/model/exception_model.dart';
import 'package:equatable/equatable.dart';

abstract class ConvertouchState extends Equatable {
  const ConvertouchState();

  @override
  List<Object?> get props => [];
}

abstract class ConvertouchErrorState extends ConvertouchState {
  final ConvertouchException exception;

  const ConvertouchErrorState({
    required this.exception,
  });

  @override
  List<Object?> get props => [
    exception,
  ];
}