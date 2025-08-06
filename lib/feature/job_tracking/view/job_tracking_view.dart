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
          children: [
            const SizedBox(height: 16),
            _buildSegmentedButtons(),
            const SizedBox(height: 16),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentedButtons() {
    return ElevatedMaterial(
      child: Row(
        children: [
          Expanded(
            child: _buildSegmentButton(
              'RECEIVED JOBS',
              0,
              isLeft: true,
            ),
          ),
          Expanded(
            child: _buildSegmentButton(
              'MY OFFERS',
              1,
            ),
          ),
          Expanded(
            child: _buildSegmentButton(
              'MY LISTINGS',
              2,
              isRight: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentButton(
    String text,
    int index, {
    bool isLeft = false,
    bool isRight = false,
  }) {
    final isSelected = selectedIndex == index;

    BorderRadius borderRadius;
    if (isLeft) {
      borderRadius = const BorderRadius.only(
        topLeft: Radius.circular(8),
        bottomLeft: Radius.circular(8),
      );
    } else if (isRight) {
      borderRadius = const BorderRadius.only(
        topRight: Radius.circular(8),
        bottomRight: Radius.circular(8),
      );
    } else {
      borderRadius = BorderRadius.zero;
    }

    return SizedBox(
      height: GeneralConstants.heightMedium,
      child: TextButton(
        onPressed: () {
          setState(() {
            selectedIndex = index;
          });
        },
        style: TextButton.styleFrom(
          backgroundColor: isSelected ? context.primary : context.secondary,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
        ),
        child: FittedBox(
          child: GeneralText(
            text: text,
            color: context.surface,
            fontSize: GeneralConstants.fontSizeExtraSmall,
            fontWeight: GeneralConstants.fontWeightBold,
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (selectedIndex) {
      case 0:
        return _buildReceivedJobs();
      case 1:
        return _buildMyOffers();
      case 2:
        return _buildMyListings();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildReceivedJobs() {
    final receivedJobs = _getMockReceivedJobs();

    if (receivedJobs.isEmpty) {
      return _buildEmptyState('No received jobs yet');
    }

    return ListView.builder(
      itemCount: receivedJobs.length,
      itemBuilder: (context, index) {
        final job = receivedJobs[index];
        return _buildJobCard(job, index);
      },
    );
  }

  Widget _buildMyOffers() {
    return _buildEmptyState('No offers submitted yet');
  }

  Widget _buildMyListings() {
    final myListings = _getMockMyListings();

    if (myListings.isEmpty) {
      return _buildEmptyState('No job listings created yet');
    }

    return ListView.builder(
      itemCount: myListings.length,
      itemBuilder: (context, index) {
        final job = myListings[index];
        return _buildJobCard(job, index);
      },
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: PaddingConstants.allLarge,
        child: GeneralText(
          text: message,
          fontSize: GeneralConstants.fontSizeSmall,
          color: context.secondary,
          fontWeight: GeneralConstants.fontWeightRegular,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildJobCard(Map<String, dynamic> job, int index) {
    return Padding(
      padding: PaddingConstants.symmetricVerticalSmall / 2,
      child: ElevatedMaterial(
        child: Container(
          padding: PaddingConstants.allMedium,
          decoration: BoxDecoration(
            color: index.isEven
                ? context.secondary.withValues(alpha: 0.01)
                : context.secondary.withValues(alpha: 0.06),
            borderRadius: GeneralConstants.borderRadius,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: GeneralText(
                      text: job['title'] as String,
                      fontSize: GeneralConstants.fontSizeSmall,
                      fontWeight: GeneralConstants.fontWeightBold,
                      color: context.onSurface,
                    ),
                  ),
                  _buildStatusChip(job['status'] as String),
                ],
              ),
              const SizedBox(height: 8),
              _buildJobInfo(Icons.business, job['company'] as String),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: _buildJobInfo(
                        Icons.monetization_on, job['price'] as String),
                  ),
                  Expanded(
                    child: _buildJobInfo(
                        Icons.calendar_today, job['date'] as String),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJobInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: context.secondary,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: GeneralText(
            text: text,
            fontSize: GeneralConstants.fontSizeExtraSmall,
            color: context.secondary,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    Color statusColor;
    switch (status.toLowerCase()) {
      case 'pending':
        statusColor = Colors.orange;
        break;
      case 'accepted':
        statusColor = Colors.green;
        break;
      case 'rejected':
        statusColor = Colors.red;
        break;
      case 'completed':
        statusColor = Colors.blue;
        break;
      default:
        statusColor = context.secondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: GeneralText(
        text: status.toUpperCase(),
        fontSize: GeneralConstants.fontSizeExtraSmall,
        color: statusColor,
        fontWeight: GeneralConstants.fontWeightBold,
      ),
    );
  }

  List<Map<String, dynamic>> _getMockReceivedJobs() {
    return [
      {
        'title': 'Istanbul - Ankara Transport',
        'company': 'ABC Logistics',
        'price': '₺2,500',
        'date': '25/12/2024',
        'status': 'Pending',
      },
      {
        'title': 'Airport Transfer Service',
        'company': 'XYZ Transport',
        'price': '₺150',
        'date': '24/12/2024',
        'status': 'Accepted',
      },
    ];
  }

  List<Map<String, dynamic>> _getMockMyListings() {
    return [
      {
        'title': 'Besiktas - Galata Transport',
        'company': 'My Company',
        'price': '₺300',
        'date': '27/12/2024',
        'status': 'Active',
      },
      {
        'title': 'Hotel Transfer Service',
        'company': 'My Company',
        'price': '₺200',
        'date': '21/12/2024',
        'status': 'Completed',
      },
    ];
  }
}
