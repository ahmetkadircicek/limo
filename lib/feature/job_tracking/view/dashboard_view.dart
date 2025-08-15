import 'package:flutter/material.dart';
import 'package:limo/core/constants/padding_constants.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/shared/app_components.dart';

class JobTrackingView extends StatefulWidget {
  const JobTrackingView({super.key});

  @override
  State<JobTrackingView> createState() => _JobTrackingViewState();
}

class _JobTrackingViewState extends State<JobTrackingView> {
  int _selectedSegment = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: Padding(
          padding: PaddingConstants.allL,
          child: Column(
            children: [
              // Segment Control
              _buildSegmentedControl(),

              const SizedBox(height: 20),

              // Content based on selection
              Expanded(
                child: _buildContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentedControl() {
    return AppCard.secondary(
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: _buildSegmentButton('Active Jobs', 0),
          ),
          Expanded(
            child: _buildSegmentButton('Past Jobs', 1),
          ),
          Expanded(
            child: _buildSegmentButton('Offers', 2),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentButton(String title, int index) {
    final isSelected = _selectedSegment == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSegment = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? context.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: AppText.body(
          title,
          textAlign: TextAlign.center,
          color: isSelected ? context.onPrimary : context.onSurface,
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedSegment) {
      case 0:
        return _buildActiveJobs();
      case 1:
        return _buildPastJobs();
      case 2:
        return _buildOffers();
      default:
        return _buildActiveJobs();
    }
  }

  Widget _buildActiveJobs() {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return Padding(
          padding: PaddingConstants.onlyBottomM,
          child: AppCard.primary(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText.heading(
                      'Job #${1000 + index}',
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: context.secondary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: AppText.caption(
                        'Active',
                        color: context.secondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                AppText.body('Istanbul → Ankara'),
                const SizedBox(height: 4),
                AppText.caption(
                  'Truck • 1 Vehicle • \$${(500 + index * 100)}',
                  color: context.onSurface.withValues(alpha: 0.6),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPastJobs() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: PaddingConstants.onlyBottomM,
          child: AppCard.primary(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText.heading(
                      'Job #${900 + index}',
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: AppText.caption(
                        'Completed',
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                AppText.body('Bursa → Izmir'),
                const SizedBox(height: 4),
                AppText.caption(
                  'Truck • 2 Vehicles • \$${(800 + index * 150)}',
                  color: context.onSurface.withValues(alpha: 0.6),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOffers() {
    return ListView.builder(
      itemCount: 4,
      itemBuilder: (context, index) {
        return Padding(
          padding: PaddingConstants.onlyBottomM,
          child: AppCard.primary(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText.heading(
                      'Offer #${200 + index}',
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: AppText.caption(
                        'Pending',
                        color: Colors.orange[700],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                AppText.body('Antalya → Trabzon'),
                const SizedBox(height: 4),
                AppText.caption(
                  'Van • 1 Vehicle • \$${(300 + index * 75)}',
                  color: context.onSurface.withValues(alpha: 0.6),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: AppButton.tertiary(
                        'Reject',
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AppButton.primary(
                        'Accept',
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
