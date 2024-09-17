class JobResultModel {
  final double progressPercent;

  const JobResultModel({
    required this.progressPercent,
  });

  const JobResultModel.start() : progressPercent = 0.0;

  const JobResultModel.finish() : progressPercent = 1.0;

  const JobResultModel.noResult() : progressPercent = -1;

  @override
  String toString() {
    return 'JobResultModel{progressPercent: $progressPercent}';
  }
}
