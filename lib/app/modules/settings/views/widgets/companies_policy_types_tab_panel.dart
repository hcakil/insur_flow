import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../data/models/insurance_company_model.dart';
import '../../../../data/models/policy_type_setting_model.dart';
import '../../controllers/settings_controller.dart';

/// Tab 3: İki eşit kolon — Sigorta şirketleri + Poliçe tipleri
class CompaniesPolicyTypesTabPanel extends GetView<SettingsController> {
  const CompaniesPolicyTypesTabPanel({super.key});

  static const _fieldBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(color: Color(0xFFE5E7EB)),
  );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        if (c.maxWidth < 900) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _CompaniesColumn(),
                const SizedBox(height: 24),
                const _PolicyTypesColumn(),
              ],
            ),
          );
        }
        return const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _CompaniesColumn()),
            SizedBox(width: 16),
            Expanded(child: _PolicyTypesColumn()),
          ],
        );
      },
    );
  }
}

class _CompaniesColumn extends GetView<SettingsController> {
  const _CompaniesColumn();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Sigorta Şirketleri',
          style: AppTextStyles.heading.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller.companyNameController,
                decoration: const InputDecoration(
                  hintText: 'Şirket adı',
                  filled: true,
                  fillColor: AppColors.white,
                  border: CompaniesPolicyTypesTabPanel._fieldBorder,
                  enabledBorder: CompaniesPolicyTypesTabPanel._fieldBorder,
                  focusedBorder: CompaniesPolicyTypesTabPanel._fieldBorder,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 8),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.active,
                foregroundColor: AppColors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: controller.addInsuranceCompany,
              child: const Text('Ekle'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 360,
          child: Obx(() {
            final list = controller.insuranceCompanies;
            return _BorderedTable(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _tableHeaderRow(
                    children: [
                      const SizedBox(width: 28),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Şirket Adı',
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 72,
                        child: Text(
                          'Durum',
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 88),
                    ],
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView.separated(
                      itemCount: list.length,
                      separatorBuilder: (_, __) =>
                          const Divider(height: 1, indent: 8, endIndent: 8),
                      itemBuilder: (_, i) => _CompanyRow(list[i]),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _CompanyRow extends GetView<SettingsController> {
  final InsuranceCompanyModel company;
  const _CompanyRow(this.company);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          Icon(Icons.drag_indicator, color: AppColors.textSecondary, size: 20),
          const SizedBox(width: 4),
          Expanded(
            flex: 3,
            child: Text(company.name, style: AppTextStyles.body, maxLines: 1),
          ),
          SizedBox(
            width: 72,
            child: Switch.adaptive(
              value: company.isActive,
              onChanged: (_) => controller.toggleInsuranceCompany(company),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          IconButton(
            tooltip: 'Düzenle',
            onPressed: () => controller.editInsuranceCompany(company),
            icon: const Icon(Icons.edit_outlined, size: 18),
            color: AppColors.textSecondary,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
          IconButton(
            tooltip: 'Sil',
            onPressed: () => controller.deleteInsuranceCompany(company),
            icon: Icon(Icons.delete_outline, size: 18, color: Colors.red.shade600),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }
}

class _PolicyTypesColumn extends GetView<SettingsController> {
  const _PolicyTypesColumn();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Poliçe Tipleri',
          style: AppTextStyles.heading.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller.policyTypeNameController,
                decoration: const InputDecoration(
                  hintText: 'Poliçe tipi adı',
                  filled: true,
                  fillColor: AppColors.white,
                  border: CompaniesPolicyTypesTabPanel._fieldBorder,
                  enabledBorder: CompaniesPolicyTypesTabPanel._fieldBorder,
                  focusedBorder: CompaniesPolicyTypesTabPanel._fieldBorder,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 8),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.active,
                foregroundColor: AppColors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: controller.addPolicyTypeSetting,
              child: const Text('Ekle'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 360,
          child: Obx(() {
            final list = controller.policyTypesSettings;
            return _BorderedTable(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _tableHeaderRow(
                    children: [
                      const SizedBox(width: 28),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Poliçe Tipi',
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 72,
                        child: Text(
                          'Durum',
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 88),
                    ],
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView.separated(
                      itemCount: list.length,
                      separatorBuilder: (_, __) =>
                          const Divider(height: 1, indent: 8, endIndent: 8),
                      itemBuilder: (_, i) => _PolicyTypeRow(list[i]),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _PolicyTypeRow extends GetView<SettingsController> {
  final PolicyTypeSettingModel pt;
  const _PolicyTypeRow(this.pt);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          Icon(Icons.drag_indicator, color: AppColors.textSecondary, size: 20),
          const SizedBox(width: 4),
          Expanded(
            flex: 3,
            child: Text(pt.name, style: AppTextStyles.body, maxLines: 1),
          ),
          SizedBox(
            width: 72,
            child: Switch.adaptive(
              value: pt.isActive,
              onChanged: (_) => controller.togglePolicyTypeSetting(pt),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          IconButton(
            tooltip: 'Düzenle',
            onPressed: () => controller.editPolicyTypeSetting(pt),
            icon: const Icon(Icons.edit_outlined, size: 18),
            color: AppColors.textSecondary,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
          IconButton(
            tooltip: 'Sil',
            onPressed: () => controller.deletePolicyTypeSetting(pt),
            icon: Icon(Icons.delete_outline, size: 18, color: Colors.red.shade600),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }
}

Widget _tableHeaderRow({required List<Widget> children}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
    child: Row(children: children),
  );
}

class _BorderedTable extends StatelessWidget {
  final Widget child;
  const _BorderedTable({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.divider),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}
