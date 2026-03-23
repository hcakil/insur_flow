import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../controllers/settings_controller.dart';

class SettingsTabBar extends GetView<SettingsController> {
  const SettingsTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final active = controller.activeTab.value;
      return LayoutBuilder(
        builder: (context, c) {
          final useWrap = c.maxWidth < 720;
          final children = List.generate(SettingsController.tabLabels.length, (i) {
            final isActive = i == active;
            return Padding(
              padding: const EdgeInsets.only(right: 8, bottom: 8),
              child: Material(
                color: isActive
                    ? const Color(0xFFF3F4F6)
                    : Colors.transparent,
                shape: const StadiumBorder(),
                child: InkWell(
                  onTap: () => controller.setActiveTab(i),
                  customBorder: const StadiumBorder(),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isActive ? AppColors.active : Colors.transparent,
                        width: isActive ? 1.2 : 0,
                      ),
                    ),
                    child: Text(
                      SettingsController.tabLabels[i],
                      style: AppTextStyles.caption.copyWith(
                        fontWeight:
                            isActive ? FontWeight.w700 : FontWeight.w500,
                        color: isActive
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            );
          });

          if (useWrap) {
            return Wrap(children: children);
          }
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: children),
          );
        },
      );
    });
  }
}
