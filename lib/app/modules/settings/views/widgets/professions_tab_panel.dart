import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../data/models/profession_model.dart';
import '../../controllers/settings_controller.dart';

class ProfessionsTabPanel extends GetView<SettingsController> {
  const ProfessionsTabPanel({super.key});

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
        final table = const _ProfessionsTable();

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
          'Yeni Meslek Ekle',
          style: AppTextStyles.heading.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Meslek Adı',
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
                controller: controller.professionNameController,
                decoration: const InputDecoration(
                  hintText: 'Örn: Doktor',
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
              onPressed: controller.addProfession,
              child: const Text('Ekle'),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProfessionsTable extends GetView<SettingsController> {
  const _ProfessionsTable();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final list = controller.professions;
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
                'Meslek Adı',
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
                itemBuilder: (context, i) => _ProfessionRow(list[i]),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _ProfessionRow extends GetView<SettingsController> {
  final ProfessionModel profession;
  const _ProfessionRow(this.profession);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              profession.name,
              style: AppTextStyles.body,
            ),
          ),
          IconButton(
            tooltip: 'Düzenle',
            onPressed: () => controller.editProfession(profession),
            icon: const Icon(Icons.edit_outlined, size: 20),
            color: AppColors.textSecondary,
          ),
          IconButton(
            tooltip: 'Sil',
            onPressed: () => controller.deleteProfession(profession),
            icon: Icon(Icons.delete_outline,
                size: 20, color: Colors.red.shade600),
          ),
        ],
      ),
    );
  }
}
