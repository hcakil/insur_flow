import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../controllers/customers_controller.dart';

/// Mus-7-8 — Dış etiket + beyaz alan + gri border / focus siyah
const _kBorderIdle = Color(0xFFE5E7EB);
const _kBorderFocus = Color(0xFF000000);

InputDecoration _drawerFieldDecoration({String? hint}) {
  return InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.white,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: _kBorderIdle, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: _kBorderFocus, width: 1),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: _kBorderIdle, width: 1),
    ),
  );
}

Widget _fieldLabel(String label, {bool required = false}) {
  return Text(
    required ? '$label *' : label,
    style: const TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 13,
      color: Color(0xFF000000),
      height: 1.2,
    ),
  );
}

Widget _labeledField({
  required String label,
  required Widget field,
  bool required = false,
  double gapAfterLabel = 6,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _fieldLabel(label, required: required),
      SizedBox(height: gapAfterLabel),
      field,
    ],
  );
}

/// Müşteri ekle / düzenle — sağdan ~560px panel
class CustomerFormSidePanel extends GetWidget<CustomersController> {
  const CustomerFormSidePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.isCustomerFormDrawerOpen.value) {
        return const SizedBox.shrink();
      }
      final w = MediaQuery.sizeOf(context).width;
      final panelW = min(560.0, w);

      return Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: controller.closeCustomerFormDrawer,
              child: Container(color: Colors.black.withValues(alpha: 0.32)),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: panelW,
            child: Material(
              color: AppColors.card,
              elevation: 18,
              child: const _CustomerFormBody(),
            ),
          ),
        ],
      );
    });
  }
}

class _CustomerFormBody extends GetWidget<CustomersController> {
  const _CustomerFormBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 18, 8, 8),
          child: Obx(() {
            final edit = controller.formCustomer.value;
            final isEdit = edit != null;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEdit ? 'Müşteriyi Düzenle' : 'Yeni Müşteri Ekle',
                        style: AppTextStyles.heading.copyWith(fontSize: 19),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Müşteri bilgilerini güncelleyin ve kaydedin.',
                        style: AppTextStyles.bodySecondary.copyWith(fontSize: 13),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: controller.closeCustomerFormDrawer,
                  icon: const Icon(Icons.close, color: AppColors.textSecondary),
                ),
              ],
            );
          }),
        ),
        const Divider(height: 1),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LayoutBuilder(
                  builder: (context, c) {
                    final row3 = c.maxWidth > 480;
                    if (row3) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _typeDropdown()),
                          const SizedBox(width: 12),
                          Expanded(child: _professionDropdown()),
                          const SizedBox(width: 12),
                          Expanded(child: _statusDropdown()),
                        ],
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _typeDropdown(),
                        const SizedBox(height: 14),
                        _professionDropdown(),
                        const SizedBox(height: 14),
                        _statusDropdown(),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 14),
                LayoutBuilder(
                  builder: (context, c) {
                    final row2 = c.maxWidth > 400;
                    if (row2) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _tagDropdown()),
                          const SizedBox(width: 12),
                          Expanded(child: _referenceField()),
                        ],
                      );
                    }
                    return Column(
                      children: [
                        _tagDropdown(),
                        const SizedBox(height: 14),
                        _referenceField(),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                _labeledField(
                  label: 'Ad Soyad',
                  required: true,
                  field: TextField(
                    controller: controller.custNameController,
                    decoration: _drawerFieldDecoration(),
                  ),
                ),
                const SizedBox(height: 14),
                _labeledField(
                  label: 'T.C. Kimlik Numarası (TCKN)',
                  required: true,
                  field: TextField(
                    controller: controller.custTcknController,
                    keyboardType: TextInputType.number,
                    decoration: _drawerFieldDecoration(),
                  ),
                ),
                const SizedBox(height: 14),
                _labeledField(
                  label: 'Doğum Tarihi',
                  field: TextField(
                    controller: controller.custBirthController,
                    readOnly: true,
                    onTap: controller.pickBirthDate,
                    decoration: _drawerFieldDecoration(hint: 'GG/AA/YYYY').copyWith(
                      suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.textSecondary),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                _labeledField(
                  label: 'Telefon',
                  field: TextField(
                    controller: controller.custPhoneController,
                    keyboardType: TextInputType.phone,
                    decoration: _drawerFieldDecoration(),
                  ),
                ),
                const SizedBox(height: 14),
                _labeledField(
                  label: 'Adres',
                  field: TextField(
                    controller: controller.custAddressController,
                    minLines: 2,
                    maxLines: 5,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: _drawerFieldDecoration(),
                  ),
                ),
                const SizedBox(height: 14),
                _labeledField(
                  label: 'Müşteri Notu',
                  field: TextField(
                    controller: controller.custCustomerNoteController,
                    minLines: 2,
                    maxLines: 5,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: _drawerFieldDecoration(),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: LayoutBuilder(
            builder: (context, c) {
              final narrow = c.maxWidth < 420;
              if (narrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _OutlineActionButton(
                      icon: Icons.menu_book_outlined,
                      label: 'Not Defteri',
                      onTap: () => controller.openCustomerNotebook(),
                    ),
                    const SizedBox(height: 8),
                    _OutlineActionButton(
                      label: 'İptal',
                      onTap: controller.closeCustomerFormDrawer,
                    ),
                    const SizedBox(height: 8),
                    _PrimarySaveButton(),
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(
                    child: _OutlineActionButton(
                      icon: Icons.menu_book_outlined,
                      label: 'Not Defteri',
                      onTap: () => controller.openCustomerNotebook(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _OutlineActionButton(
                      label: 'İptal',
                      onTap: controller.closeCustomerFormDrawer,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(child: _PrimarySaveButton()),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _typeDropdown() {
    return Obx(() => _labeledField(
          label: 'Müşteri Tipi',
          field: DropdownButtonFormField<String>(
            value: controller.selectedCustomerType.value,
            decoration: _drawerFieldDecoration(),
            items: CustomersController.customerTypeOptions
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) {
              if (v != null) controller.selectedCustomerType.value = v;
            },
          ),
        ));
  }

  Widget _professionDropdown() {
    return Obx(() => _labeledField(
          label: 'Meslek',
          field: DropdownButtonFormField<String>(
            isExpanded: true,
            value: controller.selectedProfession.value,
            decoration: _drawerFieldDecoration(),
            items: CustomersController.professionOptions
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) {
              if (v != null) controller.selectedProfession.value = v;
            },
          ),
        ));
  }

  Widget _statusDropdown() {
    return Obx(() => _labeledField(
          label: 'Durum',
          field: DropdownButtonFormField<String>(
            value: controller.selectedStatus.value,
            decoration: _drawerFieldDecoration(),
            items: CustomersController.formStatusOptions
                .map(
                  (e) => DropdownMenuItem<String>(
                    value: e,
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: CustomersController.formStatusDotColor(e),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: Text(e)),
                      ],
                    ),
                  ),
                )
                .toList(),
            selectedItemBuilder: (ctx) => CustomersController.formStatusOptions
                .map(
                  (e) => Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: CustomersController.formStatusDotColor(e),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(e, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                )
                .toList(),
            onChanged: (v) {
              if (v != null) controller.selectedStatus.value = v;
            },
          ),
        ));
  }

  Widget _tagDropdown() {
    return Obx(() => _labeledField(
          label: 'Etiket',
          field: DropdownButtonFormField<String>(
            value: controller.selectedTag.value,
            decoration: _drawerFieldDecoration(),
            items: CustomersController.formTagOptions
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) {
              if (v != null) controller.selectedTag.value = v;
            },
          ),
        ));
  }

  Widget _referenceField() {
    return _labeledField(
      label: 'Referans',
      field: TextField(
        controller: controller.custReferenceController,
        decoration: _drawerFieldDecoration(),
      ),
    );
  }
}

class _OutlineActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final IconData? icon;

  const _OutlineActionButton({
    required this.label,
    required this.onTap,
    this.icon,
  });

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
            border: Border.all(color: AppColors.active, width: 1.2),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: AppColors.textPrimary),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrimarySaveButton extends GetWidget<CustomersController> {
  const _PrimarySaveButton();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.active,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: controller.saveCustomer,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Center(
            child: Obx(() {
              final edit = controller.formCustomer.value;
              return Text(
                edit != null ? 'Güncelle' : 'Kaydet',
                style: AppTextStyles.button,
              );
            }),
          ),
        ),
      ),
    );
  }
}
