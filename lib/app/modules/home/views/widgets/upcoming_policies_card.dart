import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../controllers/home_controller.dart';
import 'dashboard_card.dart';

class UpcomingPoliciesCard extends GetView<HomeController> {
  const UpcomingPoliciesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      title: 'Yaklaşan Poliçeler',
      padding: EdgeInsets.zero,
      child: Obx(() {
        if (controller.upcomingPolicies.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.policy_outlined,
                      size: 48,
                      color: AppColors.textSecondary.withValues(alpha: 0.4)),
                  const SizedBox(height: 12),
                  Text('Yaklaşan poliçe bulunmuyor',
                      style: AppTextStyles.bodySecondary),
                ],
              ),
            ),
          );
        }

        return Column(
          children: controller.upcomingPolicies
              .map((policy) => _PolicyTile(
                    customerName: policy.customerName ?? '—',
                    type: policy.type,
                    expiryDate: policy.endDate,
                  ))
              .toList(),
        );
      }),
    );
  }
}

class _PolicyTile extends StatelessWidget {
  final String customerName;
  final String type;
  final DateTime expiryDate;

  const _PolicyTile({
    required this.customerName,
    required this.type,
    required this.expiryDate,
  });

  @override
  Widget build(BuildContext context) {
    final daysLeft = expiryDate.difference(DateTime.now()).inDays;
    final dateStr = DateFormat('dd MMM yyyy', 'tr_TR').format(expiryDate);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.divider.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: daysLeft <= 3
                  ? const Color(0xFFFEE2E2)
                  : const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.description_outlined,
              size: 20,
              color: daysLeft <= 3
                  ? const Color(0xFFEF4444)
                  : const Color(0xFFF59E0B),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(customerName, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(type, style: AppTextStyles.caption),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(dateStr, style: AppTextStyles.caption),
              const SizedBox(height: 2),
              Text(
                '$daysLeft gün kaldı',
                style: AppTextStyles.caption.copyWith(
                  color: daysLeft <= 3
                      ? const Color(0xFFEF4444)
                      : const Color(0xFFF59E0B),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
