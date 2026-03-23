import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/color_hex.dart';
import '../../../../data/models/customer_status_model.dart';
import '../../controllers/settings_controller.dart';

class CustomerStatusesTabPanel extends GetView<SettingsController> {
  const CustomerStatusesTabPanel({super.key});

  static const _fieldBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(color: Color(0xFFE5E7EB)),
  );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 900;
        final form = _buildForm();
        final table = const _StatusesTable();

        if (narrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              form,
              const SizedBox(height: 20),
              SizedBox(height: 320, child: table),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 3, child: form),
            const SizedBox(width: 24),
            Expanded(flex: 7, child: table),
          ],
        );
      },
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Yeni Durum Ekle',
          style: AppTextStyles.heading.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      children: [
                        const TextSpan(text: 'Durum Adı '),
                        TextSpan(
                          text: '*',
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controller.statusNameController,
                    decoration: const InputDecoration(
                      hintText: 'Örn: Aktif',
                      filled: true,
                      fillColor: AppColors.white,
                      border: _fieldBorder,
                      enabledBorder: _fieldBorder,
                      focusedBorder: _fieldBorder,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Obx(() {
              final hex = controller.selectedColorHex.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Renk',
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Material(
                    color: colorFromHex(hex),
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      onTap: controller.pickStatusColor,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 44,
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.divider,
                            width: 1.5,
                          ),
                        ),
                        child: const Icon(
                          Icons.palette_outlined,
                          color: Colors.white54,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(width: 10),
            Padding(
              padding: const EdgeInsets.only(top: 22),
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.active,
                  foregroundColor: AppColors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: controller.addCustomerStatus,
                child: const Text('Ekle'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatusesTable extends GetView<SettingsController> {
  const _StatusesTable();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final list = controller.customerStatuses;
      return Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Durum Adı',
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Renk',
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 72),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.separated(
                itemCount: list.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, indent: 16, endIndent: 16),
                itemBuilder: (context, i) => _StatusRow(list[i]),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _StatusRow extends GetView<SettingsController> {
  final CustomerStatusModel status;
  const _StatusRow(this.status);

  @override
  Widget build(BuildContext context) {
    final displayHex = status.colorHex.startsWith('#')
        ? status.colorHex.toLowerCase()
        : '#${status.colorHex.toLowerCase()}';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(status.name, style: AppTextStyles.body),
          ),
          Expanded(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 10,
                  backgroundColor: colorFromHex(status.colorHex),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    displayHex,
                    style: AppTextStyles.caption.copyWith(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Düzenle',
            onPressed: () => controller.editCustomerStatus(status),
            icon: const Icon(Icons.edit_outlined, size: 20),
            color: AppColors.textSecondary,
          ),
          IconButton(
            tooltip: 'Sil',
            onPressed: () => controller.deleteCustomerStatus(status),
            icon: Icon(Icons.delete_outline,
                size: 20, color: Colors.red.shade600),
          ),
        ],
      ),
    );
  }
}
