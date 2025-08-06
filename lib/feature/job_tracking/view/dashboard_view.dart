import 'package:flutter/material.dart';
import 'package:soforvarcom/core/constants/general_constants.dart';
import 'package:soforvarcom/core/constants/padding_constants.dart';
import 'package:soforvarcom/core/extensions/general_extensions.dart';
import 'package:soforvarcom/shared/elevated_material.dart';
import 'package:soforvarcom/shared/general_text.dart';

class JobTrackingView extends StatefulWidget {
  const JobTrackingView({super.key});

  @override
  State<JobTrackingView> createState() => _JobTrackingViewState();
}

class _JobTrackingViewState extends State<JobTrackingView> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.surfaceContainer,
      child: Padding(
        padding: PaddingConstants.allMedium,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            _CustomSegmentedButton(
              selectedIndex: selectedIndex,
              onItemTapped: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),
            context.spacerHeight(2),
            Expanded(child: _JobTrackingLists(selectedIndex: selectedIndex)),
          ],
        ),
      ),
    );
  }
}

class _JobTrackingLists extends StatelessWidget {
  final int selectedIndex;

  const _JobTrackingLists({required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (selectedIndex == 0) const _ReceivedJobs(),
        if (selectedIndex == 1) const _SentOffers(),
        if (selectedIndex == 2) const _MyJobs(),
      ],
    );
  }
}

class _ReceivedJobs extends StatelessWidget {
  const _ReceivedJobs();

  @override
  Widget build(BuildContext context) {
    // Mock received jobs
    final receivedJobs = [
      {
        'title': 'Istanbul - Ankara Transportation',
        'company': 'ABC Logistics',
        'price': '₺2,500',
        'date': '25/12/2024',
        'status': 'Pending',
        'statusColor': Colors.orange,
      },
      {
        'title': 'Airport Transfer Service',
        'company': 'XYZ Transport',
        'price': '₺150',
        'date': '24/12/2024',
        'status': 'Accepted',
        'statusColor': Colors.green,
      },
      {
        'title': 'City Tour Guide Transport',
        'company': 'City Tours',
        'price': '₺75/hour',
        'date': '23/12/2024',
        'status': 'Rejected',
        'statusColor': Colors.red,
      },
    ];

    return ListView.builder(
      itemCount: receivedJobs.length,
      itemBuilder: (context, index) {
        final job = receivedJobs[index];
        return _JobTrackingCard(
          title: job['title'] as String,
          subtitle: job['company'] as String,
          price: job['price'] as String,
          date: job['date'] as String,
          status: job['status'] as String,
          statusColor: job['statusColor'] as Color,
        );
      },
    );
  }
}

class _SentOffers extends StatelessWidget {
  const _SentOffers();

  @override
  Widget build(BuildContext context) {
    // Empty offers list - show message like in the screenshot
    return Center(
      child: Padding(
        padding: PaddingConstants.allLarge,
        child: GeneralText(
          text: 'Kayıtlı teklifiniz bulunmamaktadır.',
          fontSize: GeneralConstants.fontSizeSmall,
          color: context.primary,
          fontWeight: GeneralConstants.fontWeightRegular,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _MyJobs extends StatelessWidget {
  const _MyJobs();

  @override
  Widget build(BuildContext context) {
    // Mock my jobs
    final myJobs = [
      {
        'title': 'Besiktas - Galata Transport',
        'company': 'My Job',
        'price': '₺300',
        'date': '27/12/2024',
        'status': 'Active',
        'statusColor': Colors.green,
      },
      {
        'title': 'Hotel Transfer Service',
        'company': 'My Job',
        'price': '₺200',
        'date': '21/12/2024',
        'status': 'Completed',
        'statusColor': Colors.blue,
      },
    ];

    return ListView.builder(
      itemCount: myJobs.length,
      itemBuilder: (context, index) {
        final job = myJobs[index];
        return _JobTrackingCard(
          title: job['title'] as String,
          subtitle: job['company'] as String,
          price: job['price'] as String,
          date: job['date'] as String,
          status: job['status'] as String,
          statusColor: job['statusColor'] as Color,
        );
      },
    );
  }
}

class _JobTrackingCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;
  final String date;
  final String status;
  final Color statusColor;

  const _JobTrackingCard({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.date,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PaddingConstants.symmetricVerticalSmall / 2,
      child: ElevatedMaterial(
        child: Container(
          padding: PaddingConstants.allMedium,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: GeneralText(
                      text: title,
                      fontSize: GeneralConstants.fontSizeSmall,
                      fontWeight: GeneralConstants.fontWeightBold,
                      color: context.onSurface,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: GeneralText(
                      text: status,
                      fontSize: GeneralConstants.fontSizeExtraSmall,
                      color: statusColor,
                      fontWeight: GeneralConstants.fontWeightBold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.business,
                    size: 16,
                    color: context.secondary,
                  ),
                  const SizedBox(width: 4),
                  GeneralText(
                    text: subtitle,
                    fontSize: GeneralConstants.fontSizeExtraSmall,
                    color: context.secondary,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.monetization_on,
                    size: 16,
                    color: context.secondary,
                  ),
                  const SizedBox(width: 4),
                  GeneralText(
                    text: price,
                    fontSize: GeneralConstants.fontSizeExtraSmall,
                    color: context.secondary,
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: context.secondary,
                  ),
                  const SizedBox(width: 4),
                  GeneralText(
                    text: date,
                    fontSize: GeneralConstants.fontSizeExtraSmall,
                    color: context.secondary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomSegmentedButton extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const _CustomSegmentedButton({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedMaterial(
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: GeneralConstants.heightMedium,
              child: TextButton(
                onPressed: () => onItemTapped(0),
                style: TextButton.styleFrom(
                  foregroundColor: context.surface,
                  shape: _shapeLeft(),
                  backgroundColor: _backgroundColor(0, context),
                ),
                child: FittedBox(
                  child: GeneralText(
                    text: 'ALINAN İŞLER',
                    color: context.surface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: GeneralConstants.heightMedium,
              child: TextButton(
                onPressed: () => onItemTapped(1),
                style: TextButton.styleFrom(
                  foregroundColor: context.surface,
                  shape: _shape(),
                  backgroundColor: _backgroundColor(1, context),
                ),
                child: FittedBox(
                  child: GeneralText(
                    text: 'TEKLİFLERİM',
                    color: context.surface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: GeneralConstants.heightMedium,
              child: TextButton(
                onPressed: () => onItemTapped(2),
                style: TextButton.styleFrom(
                  foregroundColor: context.surface,
                  shape: _shapeRight(),
                  backgroundColor: _backgroundColor(2, context),
                ),
                child: FittedBox(
                  child: GeneralText(
                    text: 'YÜK İLANLARIM',
                    color: context.surface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _backgroundColor(int index, BuildContext context) {
    return selectedIndex == index ? context.primary : context.secondary;
  }

  RoundedRectangleBorder _shape() {
    return const RoundedRectangleBorder(borderRadius: BorderRadius.zero);
  }

  RoundedRectangleBorder _shapeLeft() {
    return const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(8.0),
        bottomLeft: Radius.circular(8.0),
      ),
    );
  }

  RoundedRectangleBorder _shapeRight() {
    return const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(8.0),
        bottomRight: Radius.circular(8.0),
      ),
    );
  }
}
