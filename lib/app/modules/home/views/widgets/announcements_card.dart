import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../controllers/home_controller.dart';
import 'dashboard_card.dart';

class AnnouncementsCard extends GetView<HomeController> {
  const AnnouncementsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      title: 'InsurFlow Sigorta Duyurular',
      child: Obx(() {
        if (controller.announcements.isEmpty) {
          return Center(
            child: Column(
              children: [
                const SizedBox(height: 16),
                Icon(Icons.campaign_outlined, size: 48, color: AppColors.textSecondary.withValues(alpha: 0.4)),
                const SizedBox(height: 12),
                Text('Duyuru bulunmuyor', style: AppTextStyles.bodySecondary),
                const SizedBox(height: 16),
              ],
            ),
          );
        }

        return Column(
          children:
              controller.announcements
                  .map(
                    (a) =>
                        Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(a, style: AppTextStyles.body)),
                  )
                  .toList(),
        );
      }),
    );
  }
}
