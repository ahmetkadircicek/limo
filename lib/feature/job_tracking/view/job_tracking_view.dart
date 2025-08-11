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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: Padding(
          padding: PaddingConstants.allL,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.title(
                'İş Takip',
                color: context.onSurface,
              ),

              const SizedBox(height: 20),

              // Current Status
              AppCard.primary(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.subtitle(
                      'Mevcut Durum',
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: context.secondary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: AppText.body(
                            'İstanbul, Türkiye',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: Colors.grey[600],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: AppText.body(
                            'Son güncelleme: 2 saat önce',
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Progress
              AppCard.secondary(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.subtitle(
                      'İlerleme',
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: 0.6,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation(context.secondary),
                    ),
                    const SizedBox(height: 8),
                    AppText.caption(
                      '%60 tamamlandı',
                      color: context.secondary,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Actions
              AppButton.primary(
                'Konumu Güncelle',
                width: double.infinity,
                onPressed: () {
                  // Update location
                },
              ),

              // Bottom padding for navigation bar
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
