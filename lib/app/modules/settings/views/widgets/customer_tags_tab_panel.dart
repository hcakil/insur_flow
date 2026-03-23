import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../data/models/customer_tag_model.dart';
import '../../controllers/settings_controller.dart';

class CustomerTagsTabPanel extends GetView<SettingsController> {
  const CustomerTagsTabPanel({super.key});

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
        final table = const _TagsTable();

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
          'Yeni Etiket Ekle',
          style: AppTextStyles.heading.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Etiket Adı',
          style: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                controller: controller.tagNameController,
                decoration: const InputDecoration(
                  hintText: 'Örn: VIP',
                  filled: true,
                  fillColor: AppColors.white,
                  border: _fieldBorder,
                  enabledBorder: _fieldBorder,
                  focusedBorder: _fieldBorder,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 10),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.active,
                foregroundColor: AppColors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: controller.addCustomerTag,
              child: const Text('Ekle'),
            ),
          ],
        ),
      ],
    );
  }
}

class _TagsTable extends GetView<SettingsController> {
  const _TagsTable();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final list = controller.customerTags;
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
              child: Text(
                'Etiket Adı',
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.separated(
                itemCount: list.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, indent: 16, endIndent: 16),
                itemBuilder: (_, i) => _TagRow(model: list[i]),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _TagRow extends GetView<SettingsController> {
  final CustomerTagModel model;
  const _TagRow({required this.model});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Expanded(child: Text(model.name, style: AppTextStyles.body)),
          IconButton(
            tooltip: 'Düzenle',
            onPressed: () => controller.editCustomerTag(model),
            icon: const Icon(Icons.edit_outlined, size: 20),
            color: AppColors.textSecondary,
          ),
          IconButton(
            tooltip: 'Sil',
            onPressed: () => controller.deleteCustomerTag(model),
            icon: Icon(Icons.delete_outline, size: 20, color: Colors.red.shade600),
          ),
        ],
      ),
    );
  }
}
