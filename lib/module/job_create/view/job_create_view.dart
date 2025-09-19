import 'package:flutter/material.dart';
import 'package:limo/core/providers/job_type_provider.dart';
import 'package:limo/core/providers/user_provider.dart';
import 'package:limo/module/address_picker/address_picker_view.dart'; // used inside sections (Navigator.push)
import 'package:limo/module/job_create/view_mixin/job_create_view_mixin.dart';
import 'package:limo/module/job_create/view_model/job_create_view_model.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/constants/radius_constants.dart';
import 'package:limo/shared/constants/widget_constants.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:limo/shared/models/picked_location_model.dart';
import 'package:limo/shared/widgets/shared_card.dart';
import 'package:limo/shared/widgets/shared_dropdown_field.dart';
import 'package:limo/shared/widgets/shared_selectable_field.dart';
import 'package:provider/provider.dart';

part '../section/job_details_section.dart';
part '../section/user_info_section.dart';

class JobCreateView extends StatelessWidget {
  const JobCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    return ChangeNotifierProvider<JobCreateViewModel>(
      create:
          (_) => JobCreateViewModel(
            userId: user?.userId ?? '',
            userName: user?.userName,
            companyName: user?.companyName,
            contactInfo: user?.phone ?? user?.email,
          ),
      child: const _JobCreateScaffold(),
    );
  }
}

class _JobCreateScaffold extends StatefulWidget {
  const _JobCreateScaffold();

  @override
  State<_JobCreateScaffold> createState() => _JobCreateScaffoldState();
}

class _JobCreateScaffoldState extends State<_JobCreateScaffold>
    with JobCreateViewMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<JobTypeProvider>().loadJobTypes(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<JobCreateViewModel>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: context.surfaceContainer,
        body: SafeArea(
          child: Form(
            key: jobFormKey,
            child: ListView(
              padding: PaddingConstants.all20,
              children: [
                const _UserInfoSection(),
                const SizedBox(height: PaddingConstants.p20),
                _JobDetailsSection(jobTypeValidator: validateJobType),
                const SizedBox(height: PaddingConstants.p20),
                _ActionsSection(
                  isSubmitting: vm.submitting,
                  isFormValid: vm.isValid,
                  onSubmit: () async {
                    final valid = validateJob(vm);
                    if (!valid) return;
                    await vm.submit(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============ SMALL WIDGETS ============

class _DateField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final VoidCallback onPick;

  const _DateField({
    required this.label,
    required this.value,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    final txt =
        value == null
            ? 'Select $label'
            : '${value!.year}-${value!.month.toString().padLeft(2, '0')}-${value!.day.toString().padLeft(2, '0')}';

    final decoration = InputDecoration(
      labelText: label,
      suffixIcon: const Icon(Icons.calendar_today_outlined),
    );

    return SizedBox(
      height: WidgetConstants.formFieldHeight,
      child: InkWell(
        onTap: onPick,
        borderRadius: BorderRadius.circular(RadiusConstants.standardRadius),
        child: InputDecorator(
          decoration: decoration,
          isEmpty: value == null,
          child: Text(txt, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ),
    );
  }
}

// ============ HELPERS (used by sections) ============

Future<DateTime?> _pickDate(
  BuildContext context, {
  DateTime? initial,
  DateTime? firstDate,
}) async {
  final now = DateTime.now();
  final init = initial ?? now.add(const Duration(days: 1));
  final first = firstDate ?? now;
  final last = now.add(const Duration(days: 365));

  return showDatePicker(
    context: context,
    initialDate: init.isBefore(first) ? first : init,
    firstDate: first,
    lastDate: last,
  );
}

class _ActionsSection extends StatelessWidget {
  final bool isSubmitting;
  final bool isFormValid;
  final Future<void> Function() onSubmit;

  const _ActionsSection({
    required this.isSubmitting,
    required this.isFormValid,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: PaddingConstants.bottom16,
      height: 48,
      child: ElevatedButton(
        onPressed:
            isSubmitting
                ? null
                : (isFormValid
                    ? () async {
                      await onSubmit();
                    }
                    : null),
        child:
            isSubmitting
                ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(),
                )
                : const Text('Create'),
      ),
    );
  }
}
