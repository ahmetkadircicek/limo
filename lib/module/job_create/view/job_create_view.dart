import 'package:flutter/material.dart';
import 'package:limo/core/providers/job_type_provider.dart';
import 'package:limo/core/providers/brand_provider.dart';
import 'package:limo/core/providers/category_provider.dart';
import 'package:limo/core/providers/model_provider.dart';
import 'package:limo/core/providers/user_provider.dart';
import 'package:limo/module/job_create/view_mixin/job_create_view_mixin.dart';
import 'package:limo/module/job_create/view_model/job_create_view_model.dart';
import 'package:limo/module/job_create/widgets/location_search_field.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:intl/intl.dart';
import 'package:limo/shared/constants/radius_constants.dart';
import 'package:limo/shared/constants/widget_constants.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:limo/shared/extensions/context_typography_extension.dart';
import 'package:limo/shared/models/car_requirement_model.dart';
import 'package:limo/shared/models/brand_model.dart';
import 'package:limo/shared/models/category_model.dart';
import 'package:limo/shared/models/model_model.dart';
import 'package:limo/shared/models/job_type_model.dart';
import 'package:limo/shared/widgets/app_snackbar.dart';
import 'package:limo/shared/widgets/form/shared_dropdown_field.dart';
import 'package:limo/shared/widgets/form/shared_read_only_field.dart';
import 'package:limo/shared/widgets/form/shared_text_field.dart';
import 'package:limo/shared/widgets/shared_async_status_builder.dart';
import 'package:limo/shared/widgets/shared_button.dart';
import 'package:limo/shared/widgets/shared_card.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:limo/core/navigation/route_paths.dart';

part '../section/car_requirements_section.dart';
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
      final provider = context.read<JobTypeProvider>();
      final type = provider.selected;
      if (type != null) {
        context.read<JobCreateViewModel>().setJobType(type, resetForm: false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<JobCreateViewModel>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Form(
            key: jobFormKey,
            child: ListView.separated(
              padding: PaddingConstants.all24,
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return const _UserInfoSection();
                  case 1:
                    return _JobDetailsSection(
                      jobTypeValidator: validateJobType,
                    );
                  case 2:
                    return const _CarRequirementsSection();
                  case 3:
                    return _ActionsSection(
                      isSubmitting: vm.submitting,
                      onSubmit: () async {
                        final valid = validateJob(vm);
                        if (!valid) return;
                        final success = await vm.submit(context);
                        if (!context.mounted) return;
                        if (success) {
                          AppSnackbar.success(message: 'Job created');
                          jobFormKey.currentState?.reset();
                          FocusScope.of(context).unfocus();
                          // Navigate to Jobs; JobsView will auto-refresh on init.
                          context.go(RoutePaths.home);
                        }
                      },
                    );
                  default:
                    return const SizedBox.shrink();
                }
              },
              separatorBuilder:
                  (context, index) =>
                      const SizedBox(height: PaddingConstants.p16),
              itemCount: 4,
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
  final bool isRequired;

  const _DateField({
    required this.label,
    required this.value,
    required this.onPick,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final txt = value == null
        ? 'Select $label'
        : DateFormat('MM/dd/yyyy h:mm a', 'en_US').format(value!);

    return SizedBox(
      height: WidgetConstants.formFieldHeight,
      child: InkWell(
        onTap: onPick,
        borderRadius: BorderRadius.circular(RadiusConstants.standardRadius),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: isRequired ? null : label,
            label: isRequired ? _labelWithAsterisk(context, label) : null,
            hintText: 'Select $label',
            hintStyle: context.callout,
            suffixIcon: Icon(
              Icons.calendar_today_outlined,
              color: context.onSurfaceVariant,
            ),
            enabled: true,
          ),
          isEmpty: value == null,
          child:
              value == null
                  ? const SizedBox.shrink()
                  : Text(
                    txt,
                    style: context.callout.copyWith(color: context.onSurface),
                  ),
        ),
      ),
    );
  }
}

Widget _labelWithAsterisk(BuildContext context, String text) {
  return RichText(
    text: TextSpan(
      style: context.callout,
      children: [
        TextSpan(text: text),
        TextSpan(
          text: '*',
          style: context.callout.copyWith(color: context.error),
        ),
      ],
    ),
  );
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

Future<DateTime?> _pickDateTime(
  BuildContext context, {
  DateTime? initial,
  DateTime? firstDate,
}) async {
  final date = await _pickDate(context, initial: initial, firstDate: firstDate);
  if (date == null) return null;
  final time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(initial ?? DateTime.now()),
  );
  if (time == null) return null;
  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}

class _ActionsSection extends StatelessWidget {
  final bool isSubmitting;
  final Future<void> Function() onSubmit;

  const _ActionsSection({required this.isSubmitting, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    final background = context.primary;
    final foreground = context.onPrimary;
    return Padding(
      padding: PaddingConstants.bottom16,
      child: SharedButton(
        text: 'Create',
        backgroundColor: background,
        foregroundColor: foreground,
        isLoading: isSubmitting,
        onPressed:
            isSubmitting
                ? null
                : () async {
                  await onSubmit();
                },
      ),
    );
  }
}
