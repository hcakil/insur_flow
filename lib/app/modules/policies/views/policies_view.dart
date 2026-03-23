import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/layout/top_nav_bar.dart';
import '../controllers/policies_controller.dart';
import 'widgets/policies_filter_bar.dart';
import 'widgets/policies_table.dart';

class PoliciesView extends GetView<PoliciesController> {
  const PoliciesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: const TopNavBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width > 1200 ? 40 : 20,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Obx(() {
                final n = controller.filteredPolicies.length;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tüm Poliçeler',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            fontSize: 26,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$n poliçe',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textSecondary.withValues(alpha: 0.95),
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 20),
              const PoliciesFilterBar(),
              const SizedBox(height: 20),
              const Expanded(child: PoliciesTable()),
            ],
          ),
        ),
      ),
    );
  }
}
