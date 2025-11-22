import 'package:flutter/material.dart';
import 'package:limo/module/job_details/widgets/job_details_body.dart';
import 'package:provider/provider.dart';
import 'package:limo/shared/models/job_model.dart';
import 'package:limo/module/job_details/view_model/job_details_view_model.dart';
import 'package:limo/shared/widgets/shared_app_bar.dart';
// Diğer widget importları buraya gelecek (aşağıda tanımladık)
class JobDetailsView extends StatelessWidget {
  const JobDetailsView({super.key, required this.job});
  final JobModel job;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => JobDetailsViewModel(job: job),
      child: const Scaffold(
        appBar: SharedAppBar(
          title: 'Job Details',
        ),
        body: JobDetailsBody(),
      ),
    );
  }
}