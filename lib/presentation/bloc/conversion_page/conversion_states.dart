import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_conversion_model.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';

abstract class ConversionState extends ConvertouchState {
  const ConversionState();
}

class ConversionInBuilding extends ConversionState {
  const ConversionInBuilding();

  @override
  String toString() {
    return 'ConversionInBuilding{}';
  }
}

class ConversionBuilt extends ConversionState {
  final OutputConversionModel conversion;
  final bool showRefreshButton;
  final RefreshingJobModel? job;

  const ConversionBuilt({
    required this.conversion,
    this.showRefreshButton = false,
    this.job,
  });

  @override
  List<Object?> get props => [
        conversion,
        showRefreshButton,
        job,
      ];

  @override
  String toString() {
    return 'ConversionBuilt{'
        'conversion: $conversion}';
  }
}

class ConversionErrorState extends ConvertouchErrorState
    implements ConversionState {
  const ConversionErrorState({
    required super.exception,
  });

  @override
  String toString() {
    return 'ConversionErrorState{exception: $exception}';
  }
}
