// shared/models/job_type_model.dart
class JobTypeModel {
  final int jobTypeId;
  final String jobTypeName;

  JobTypeModel({required this.jobTypeId, required this.jobTypeName});

  factory JobTypeModel.fromJson(Map<String, dynamic> json) {
    return JobTypeModel(
      jobTypeId: json['job_type_id'] as int,
      jobTypeName: json['job_type_name'] as String,
    );
  }
}
