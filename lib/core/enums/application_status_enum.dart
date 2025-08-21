/// Enum for job application statuses
enum ApplicationStatus {
  pending('Pending'),
  accepted('Accepted'),
  rejected('Rejected'),
  cancelled('Cancelled'),
  completed('Completed');

  const ApplicationStatus(this.displayName);

  final String displayName;

  @override
  String toString() => displayName;
}
