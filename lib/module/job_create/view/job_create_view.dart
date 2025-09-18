import 'package:flutter/material.dart';
import 'package:limo/core/providers/job_type_provider.dart';
import 'package:limo/core/providers/user_provider.dart';
import 'package:limo/module/address_picker/address_picker_view.dart'; // used inside sections (Navigator.push)
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:limo/shared/models/picked_location_model.dart';
import 'package:limo/shared/widgets/shared_card.dart';
import 'package:provider/provider.dart';

import '../view_model/job_create_view_model.dart';

// Sections (keep file names as created in your project)
part '../section/actions_section.dart';
part '../section/address_section.dart';
part '../section/job_details_section.dart';
part '../section/user_info_section.dart';

/// Job create page composed of multiple sections.
/// Uses Provider for state (JobCreateViewModel) and JobTypeProvider for dropdown data.
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

class _JobCreateScaffoldState extends State<_JobCreateScaffold> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Load job types
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<JobTypeProvider>().loadJobTypes(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // dismiss keyboard
      child: Scaffold(
        backgroundColor: context.surfaceContainer,
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                _UserInfoSection(),
                SizedBox(height: 12),
                _JobDetailsSection(),
                SizedBox(height: 12),
                _LocationsSection(),
                SizedBox(height: 12),
                _ActionsSection(),
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

    return InkWell(
      onTap: onPick,
      borderRadius: BorderRadius.circular(8),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        child: Text(txt, style: Theme.of(context).textTheme.bodyMedium),
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
