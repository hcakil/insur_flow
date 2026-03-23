import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../tickets/controllers/tickets_controller.dart';
import '../../controllers/home_controller.dart';
import 'dashboard_card.dart';

class SupportTicketsCard extends GetView<HomeController> {
  const SupportTicketsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final ticketsController = Get.find<TicketsController>();
    return DashboardCard(
      title: 'Destek Taleplerim',
      trailing: Material(
        color: AppColors.active,
        shape: const StadiumBorder(),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: ticketsController.openCreateTicketDrawer,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add, color: AppColors.white, size: 16),
                const SizedBox(width: 4),
                Text('Talep Oluştur', style: AppTextStyles.button),
              ],
            ),
          ),
        ),
      ),
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Obx(() => _buildTabs(ticketsController)),
          const SizedBox(height: 40),
          Obx(() {
            final list = ticketsController.activeTickets;
            if (list.isEmpty) {
              return Column(
                children: [
                  Icon(
                    Icons.support_agent_outlined,
                    size: 48,
                    color: AppColors.textSecondary.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Henüz bir talebiniz yok',
                    style: AppTextStyles.bodySecondary,
                  ),
                ],
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: list
                  .take(3)
                  .map(
                    (t) => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 6,
                      ),
                      child: Text(
                        t.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption,
                      ),
                    ),
                  )
                  .toList(),
            );
          }),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildTabs(TicketsController tc) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Row(
        children: [
          _TabItem(
            label: 'Aktif (${tc.activeTickets.length})',
            isActive: controller.selectedTicketTab.value == 0,
            onTap: () => controller.switchTicketTab(0),
          ),
          const SizedBox(width: 8),
          _TabItem(
            label: 'Gizlenen (${tc.hiddenTickets.length})',
            isActive: controller.selectedTicketTab.value == 1,
            onTap: () => controller.switchTicketTab(1),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.active
              : AppColors.scaffold,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: isActive ? AppColors.white : AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
