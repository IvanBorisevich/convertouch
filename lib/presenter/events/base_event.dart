import 'package:equatable/equatable.dart';

abstract class ConvertouchEvent extends Equatable {
  const ConvertouchEvent({
    this.triggeredBy
  });

  final String? triggeredBy;

  @override
  List<Object> get props => [];
}