import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../data/models/policy_field_setting_model.dart';
import '../../../../data/models/policy_type_setting_model.dart';
import '../../controllers/settings_controller.dart';

/// Tab 4: Sol %20 poliçe tipi menüsü, sağ %80 alan listesi
class PolicyFieldsTabPanel extends GetView<SettingsController> {
  const PolicyFieldsTabPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final right = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Obx(() {
                final name = controller.selectedPolicyTypeDisplayName;
                return Text(
                  '$name Alanları',
                  style: AppTextStyles.heading.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                );
              }),
            ),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.active,
                foregroundColor: AppColors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => _openAddFieldDialog(context, controller),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Alan Ekle'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Expanded(child: _PolicyFieldsTable()),
      ],
    );

    return LayoutBuilder(
      builder: (context, c) {
        if (c.maxWidth < 900) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 200, child: _PolicyTypeSideMenu()),
              const SizedBox(height: 16),
              Expanded(child: right),
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: _PolicyTypeSideMenu(),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 8,
              child: right,
            ),
          ],
        );
      },
    );
  }

  static void _openAddFieldDialog(BuildContext context, SettingsController c) {
    c.policyFieldNameController.clear();
    c.policyFieldOptionsController.clear();
    c.selectedFieldType.value = 'Metin';
    c.policyFieldIsRequired.value = true;

    Get.dialog<void>(
      AlertDialog(
        title: const Text('Yeni alan'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: c.policyFieldNameController,
                decoration: const InputDecoration(
                  labelText: 'Alan adı',
                  hintText: 'Örn: İletişim Numarası',
                ),
              ),
              const SizedBox(height: 12),
              Obx(() {
                return DropdownButtonFormField<String>(
                  value: c.selectedFieldType.value,
                  decoration: const InputDecoration(labelText: 'Tip'),
                  items: SettingsController.fieldTypes
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) c.selectedFieldType.value = v;
                  },
                );
              }),
              const SizedBox(height: 12),
              TextField(
                controller: c.policyFieldOptionsController,
                decoration: const InputDecoration(
                  labelText: 'Seçenekler (opsiyonel)',
                  hintText: 'Virgülle ayırın',
                ),
              ),
              const SizedBox(height: 8),
              Obx(() {
                return CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Zorunlu'),
                  value: c.policyFieldIsRequired.value,
                  onChanged: (v) =>
                      c.policyFieldIsRequired.value = v ?? true,
                );
              }),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('İptal')),
          FilledButton(
            onPressed: () {
              if (c.addPolicyField()) Get.back();
            },
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }
}

class _PolicyTypeSideMenu extends GetView<SettingsController> {
  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Text(
              'Poliçe Tipleri',
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Obx(() {
              final types = controller.policyTypesSettings;
              final selected = controller.selectedPolicyTypeIdForFields.value;
              return ListView.builder(
                itemCount: types.length,
                itemBuilder: (context, i) {
                  final PolicyTypeSettingModel pt = types[i];
                  final isSel = selected == pt.id;
                  return Material(
                    color: isSel
                        ? const Color(0xFFF3F4F6)
                        : Colors.transparent,
                    child: InkWell(
                      onTap: () =>
                          controller.selectPolicyTypeForFields(pt.id),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        child: Text(
                          pt.name,
                          style: AppTextStyles.body.copyWith(
                            fontWeight:
                                isSel ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _PolicyFieldsTable extends GetView<SettingsController> {
  const _PolicyFieldsTable();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final rows = controller.fieldsForSelectedPolicyType;
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Alan Adı',
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Tip',
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Seçenekler',
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: Text(
                      'Zorunlu',
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 72),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: rows.isEmpty
                  ? Center(
                      child: Text(
                        'Bu tip için alan tanımlı değil.',
                        style: AppTextStyles.bodySecondary,
                      ),
                    )
                  : ListView.separated(
                      itemCount: rows.length,
                      separatorBuilder: (_, __) =>
                          const Divider(height: 1, indent: 8, endIndent: 8),
                      itemBuilder: (_, i) => _FieldRow(rows[i]),
                    ),
            ),
          ],
        ),
      );
    });
  }
}

class _FieldRow extends GetView<SettingsController> {
  final PolicyFieldSettingModel field;
  const _FieldRow(this.field);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.drag_indicator,
              color: AppColors.textSecondary, size: 20),
          const SizedBox(width: 4),
          Expanded(
            flex: 2,
            child: Text(field.fieldName, style: AppTextStyles.body),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                field.fieldType,
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              field.options?.isNotEmpty == true ? field.options! : '—',
              style: AppTextStyles.caption,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: 100,
            child: field.isRequired ? _reqPill(true) : _reqPill(false),
          ),
          IconButton(
            tooltip: 'Düzenle',
            onPressed: () => controller.editPolicyField(field),
            icon: const Icon(Icons.edit_outlined, size: 18),
            color: AppColors.textSecondary,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
          IconButton(
            tooltip: 'Sil',
            onPressed: () => controller.deletePolicyField(field),
            icon: Icon(Icons.delete_outline, size: 18, color: Colors.red.shade600),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }

  Widget _reqPill(bool required) {
    if (required) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.active,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          'Zorunlu',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
            fontSize: 11,
          ),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Opsiyonel',
        style: AppTextStyles.caption.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }
}
