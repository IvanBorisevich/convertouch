import 'package:equatable/equatable.dart';

abstract class ConvertouchBlocState extends Equatable {
  const ConvertouchBlocState({
    this.triggeredBy,
  });

  final String? triggeredBy;

  @override
  List<Object> get props => [];
}