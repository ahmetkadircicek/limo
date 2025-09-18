part of '../view/job_create_view.dart';

class _ActionsSection extends StatelessWidget {
  const _ActionsSection();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<JobCreateViewModel>();
    return SharedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: PaddingConstants.p12,
        children: [
          Text('Actions', style: Theme.of(context).textTheme.titleMedium),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed:
                  vm.isValid && !vm.submitting
                      ? () => vm.submit(context)
                      : null,
              child:
                  vm.submitting
                      ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(),
                      )
                      : const Text('Create'),
            ),
          ),
        ],
      ),
    );
  }
}
