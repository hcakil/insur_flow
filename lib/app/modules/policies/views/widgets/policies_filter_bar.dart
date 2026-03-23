import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../controllers/policies_controller.dart';

class PoliciesFilterBar extends GetView<PoliciesController> {
  const PoliciesFilterBar({super.key});

  static const _border = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(color: Color(0xFFE5E7EB)),
  );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final wide = c.maxWidth > 1100;
        if (wide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(flex: 3, child: _searchField()),
              const SizedBox(width: 10),
              Expanded(flex: 2, child: _companyDropdown()),
              const SizedBox(width: 10),
              Expanded(flex: 2, child: _typeDropdown()),
              const SizedBox(width: 10),
              Expanded(flex: 2, child: _statusDropdown()),
              const SizedBox(width: 10),
              Expanded(flex: 1, child: _maxDaysField()),
              const SizedBox(width: 10),
              _searchButton(),
              const SizedBox(width: 8),
              _resetButton(),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _searchField(),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _companyDropdown()),
                const SizedBox(width: 8),
                Expanded(child: _typeDropdown()),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _statusDropdown()),
                const SizedBox(width: 8),
                Expanded(child: _maxDaysField()),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _searchButton()),
                const SizedBox(width: 8),
                Expanded(child: _resetButton()),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _searchField() {
    return TextField(
      controller: controller.searchController,
      decoration: InputDecoration(
        hintText: 'Poliçe No',
        filled: true,
        fillColor: Colors.white,
        prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary, size: 22),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        enabledBorder: _border,
        focusedBorder: _border.copyWith(
          borderSide: const BorderSide(color: AppColors.active, width: 1),
        ),
        border: _border,
      ),
      onSubmitted: (_) => controller.applyFilters(),
    );
  }

  Widget _companyDropdown() {
    return Obx(() {
      final opts = controller.companyOptions;
      var v = controller.selectedCompany.value;
      if (!opts.contains(v)) v = 'Tümü';
      return DropdownButtonFormField<String>(
        value: v,
        isExpanded: true,
        decoration: _dropdownDeco('Sigorta Şirketi'),
        items: opts.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: (x) {
          if (x != null) controller.selectedCompany.value = x;
        },
      );
    });
  }

  Widget _typeDropdown() {
    return Obx(() {
      final opts = controller.typeOptions;
      var v = controller.selectedType.value;
      if (!opts.contains(v)) v = 'Tümü';
      return DropdownButtonFormField<String>(
        value: v,
        isExpanded: true,
        decoration: _dropdownDeco('Poliçe Tipi'),
        items: opts.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: (x) {
          if (x != null) controller.selectedType.value = x;
        },
      );
    });
  }

  Widget _statusDropdown() {
    return Obx(() {
      final opts = controller.statusOptions;
      var v = controller.selectedStatus.value;
      if (!opts.contains(v)) v = 'Tümü';
      return DropdownButtonFormField<String>(
        value: v,
        isExpanded: true,
        decoration: _dropdownDeco('Durum'),
        items: opts.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: (x) {
          if (x != null) controller.selectedStatus.value = x;
        },
      );
    });
  }

  InputDecoration _dropdownDeco(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      enabledBorder: _border,
      focusedBorder: _border.copyWith(
        borderSide: const BorderSide(color: AppColors.active, width: 1),
      ),
      border: _border,
    );
  }

  Widget _maxDaysField() {
    return TextField(
      controller: controller.maxDaysController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'Max',
        labelText: 'Kalan Gün',
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        enabledBorder: _border,
        focusedBorder: _border.copyWith(
          borderSide: const BorderSide(color: AppColors.active, width: 1),
        ),
        border: _border,
      ),
      onSubmitted: (_) => controller.applyFilters(),
    );
  }

  Widget _searchButton() {
    return Material(
      color: AppColors.active,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: controller.applyFilters,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.search, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text('Ara', style: AppTextStyles.button.copyWith(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _resetButton() {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: controller.resetFilters,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.active, width: 1.2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.close, color: AppColors.textPrimary, size: 20),
              const SizedBox(width: 6),
              Text(
                'Sıfırla',
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
