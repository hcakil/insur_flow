import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/layout/top_nav_bar.dart';
import '../controllers/settings_controller.dart';
import 'widgets/announcements_tab_panel.dart';
import 'widgets/bookmarks_settings_tab_panel.dart';
import 'widgets/companies_policy_types_tab_panel.dart';
import 'widgets/customer_statuses_tab_panel.dart';
import 'widgets/customer_tags_tab_panel.dart';
import 'widgets/policy_fields_tab_panel.dart';
import 'widgets/professions_tab_panel.dart';
import 'widgets/settings_tab_bar.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const TopNavBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width > 1100 ? 40 : 20,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Ayarlar',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      fontSize: 26,
                    ),
              ),
              const SizedBox(height: 16),
              const SettingsTabBar(),
              const SizedBox(height: 24),
              Expanded(
                child: Obx(() {
                  switch (controller.activeTab.value) {
                    case 0:
                      return const ProfessionsTabPanel();
                    case 1:
                      return const CustomerStatusesTabPanel();
                    case 2:
                      return const CustomerTagsTabPanel();
                    case 3:
                      return const CompaniesPolicyTypesTabPanel();
                    case 4:
                      return const PolicyFieldsTabPanel();
                    case 5:
                      return const BookmarksSettingsTabPanel();
                    case 6:
                      return const AnnouncementsTabPanel();
                    default:
                      return const SizedBox.shrink();
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
