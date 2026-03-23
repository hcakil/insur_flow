import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../controllers/customers_controller.dart';
import 'policy_table_widget.dart';

class CustomerDetailPanelWidget extends GetWidget<CustomersController> {
  const CustomerDetailPanelWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.scaffold,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Obx(() {
              final c = controller.selectedCustomer.value;
              final count = c == null
                  ? 0
                  : controller.policyCountFor(c);
              return Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          c?.name ?? 'Müşteri seçin',
                          style: AppTextStyles.heading.copyWith(fontSize: 22),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          c == null
                              ? '—'
                              : 'Toplam $count poliçe',
                          style: AppTextStyles.bodySecondary,
                        ),
                      ],
                    ),
                  ),
                  Material(
                    color: AppColors.active,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: c == null ? null : controller.openPolicyDrawer,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.add, color: AppColors.white, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              '+ Poliçe Ekle',
                              style: AppTextStyles.button.copyWith(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Obx(() {
              return Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: controller.statusFilter.value,
                      decoration: _filterDecoration('Durum'),
                      items: CustomersController.statusFilterOptions
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) controller.setStatusFilter(v);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: controller.daysLeftFilter.value,
                      decoration: _filterDecoration('Kalan Gün'),
                      items: CustomersController.daysFilterOptions
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) controller.setDaysFilter(v);
                      },
                    ),
                  ),
                ],
              );
            }),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: const PolicyTableWidget(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _filterDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: AppColors.card,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}
