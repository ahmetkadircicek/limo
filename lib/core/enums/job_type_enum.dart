/// Enum for different job types
enum JobType {
  pointToPoint('Point to Point'),
  fullDay('Full Day'),
  hourly('Hourly'),
  custom('Custom');

  const JobType(this.displayName);

  final String displayName;

  @override
  String toString() => displayName;
}
