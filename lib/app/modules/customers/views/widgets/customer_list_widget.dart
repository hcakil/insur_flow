import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../data/models/customer_model.dart';
import '../../controllers/customers_controller.dart';

class CustomerListWidget extends GetWidget<CustomersController> {
  const CustomerListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.scaffold,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: _BlackButton(
                    label: 'Tek Müşteri',
                    onTap: () => controller.openCustomerFormDrawer(null),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _OutlinedButton(
                    label: 'Toplu Ekle',
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Obx(() {
              return DropdownButtonFormField<String>(
                value: controller.listFilter.value,
                decoration: InputDecoration(
                  labelText: 'Filtrele',
                  filled: true,
                  fillColor: AppColors.card,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.divider),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: CustomersController.listFilterOptions
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) controller.setListFilter(v);
                },
              );
            }),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Obx(() {
              final items = controller.paginatedCustomers;
              if (items.isEmpty) {
                return Center(
                  child: Text(
                    'Müşteri bulunamadı',
                    style: AppTextStyles.bodySecondary,
                  ),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 6),
                itemBuilder: (context, index) {
                  final c = items[index];
                  return _CustomerRow(customer: c);
                },
              );
            }),
          ),
          _PaginationBar(),
        ],
      ),
    );
  }
}

class _CustomerRow extends GetWidget<CustomersController> {
  final CustomerModel customer;
  const _CustomerRow({required this.customer});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = controller.selectedCustomer.value?.id == customer.id;
      return Material(
        color: selected
            ? AppColors.divider.withValues(alpha: 0.35)
            : AppColors.card,
        borderRadius: BorderRadius.circular(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => controller.selectCustomer(customer),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              customer.name,
                              style: AppTextStyles.body
                                  .copyWith(fontWeight: FontWeight.w600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${customer.identityNumber} · ${customer.phone}',
                              style: AppTextStyles.caption,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        alignment: WrapAlignment.end,
                        children: customer.tags
                            .map(
                              (t) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: CustomersController.tagBackground(t),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  t,
                                  style: AppTextStyles.caption.copyWith(
                                    color: CustomersController.tagForeground(t),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4, right: 4),
              child: _CustomerActionsMenu(customer: customer),
            ),
          ],
        ),
      );
    });
  }
}

class _CustomerActionsMenu extends GetWidget<CustomersController> {
  final CustomerModel customer;
  const _CustomerActionsMenu({required this.customer});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'İşlemler',
      padding: EdgeInsets.zero,
      icon: const Icon(Icons.more_horiz, color: AppColors.textSecondary),
      offset: const Offset(0, 36),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onSelected: (value) {
        switch (value) {
          case 'edit':
            controller.openCustomerFormDrawer(customer);
            break;
          case 'notebook':
            controller.openCustomerNotebook(customer: customer);
            break;
          case 'delete':
            controller.deleteCustomer(customer);
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit_outlined, size: 18, color: AppColors.textPrimary),
              SizedBox(width: 10),
              Text('Düzenle'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'notebook',
          child: Row(
            children: [
              Icon(Icons.menu_book_outlined, size: 18, color: AppColors.textPrimary),
              SizedBox(width: 10),
              Text('Not Defteri'),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline, size: 18, color: Colors.red.shade600),
              const SizedBox(width: 10),
              Text(
                'Sil',
                style: TextStyle(
                  color: Colors.red.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PaginationBar extends GetWidget<CustomersController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final page = controller.currentPage.value;
      final total = controller.totalPages;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.card,
          border: Border(
            top: BorderSide(color: AppColors.divider.withValues(alpha: 0.6)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Sayfa $page / $total',
              style: AppTextStyles.caption,
            ),
            Row(
              children: [
                IconButton(
                  onPressed: page > 1 ? () => controller.goToPage(page - 1) : null,
                  icon: const Icon(Icons.chevron_left, size: 22),
                ),
                IconButton(
                  onPressed: page < total ? () => controller.goToPage(page + 1) : null,
                  icon: const Icon(Icons.chevron_right, size: 22),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class _BlackButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _BlackButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.active,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.button.copyWith(fontSize: 13),
            ),
          ),
        ),
      ),
    );
  }
}

class _OutlinedButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _OutlinedButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.divider),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
