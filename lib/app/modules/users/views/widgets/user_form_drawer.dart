import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../controllers/users_controller.dart';

/// Sağdan açılan kullanıcı ekleme / düzenleme paneli (≈400–500px).
class UserFormDrawer extends GetView<UsersController> {
  const UserFormDrawer({super.key});

  static const _border = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(color: Color(0xFFE5E7EB)),
  );

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.isUserFormDrawerOpen.value) {
        return const SizedBox.shrink();
      }
      final w = MediaQuery.sizeOf(context).width;
      final panelW = min(480.0, max(400.0, w * 0.42));

      return Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: controller.closeUserFormDrawer,
              child: Container(color: Colors.black.withValues(alpha: 0.35)),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: panelW,
            child: Material(
              color: AppColors.white,
              elevation: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 8, 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Obx(() {
                            final edit = controller.isEditingMode;
                            return Text(
                              edit
                                  ? 'Kullanıcıyı Düzenle'
                                  : 'Yeni Kullanıcı Ekle',
                              style: AppTextStyles.heading.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            );
                          }),
                        ),
                        IconButton(
                          onPressed: controller.closeUserFormDrawer,
                          icon: const Icon(Icons.close,
                              color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _label('İsim Soyisim'),
                          const SizedBox(height: 6),
                          TextField(
                            controller: controller.nameController,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFFAFAFA),
                              border: _border,
                              enabledBorder: _border,
                              focusedBorder: _border,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _label('E-posta'),
                          const SizedBox(height: 6),
                          TextField(
                            controller: controller.emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFFAFAFA),
                              border: _border,
                              enabledBorder: _border,
                              focusedBorder: _border,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _label('Şifre'),
                          const SizedBox(height: 6),
                          TextField(
                            controller: controller.passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              hintText: 'En az 6 karakter',
                              filled: true,
                              fillColor: Color(0xFFFAFAFA),
                              border: _border,
                              enabledBorder: _border,
                              focusedBorder: _border,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _label('Rol'),
                          const SizedBox(height: 6),
                          Obx(() {
                            return DropdownButtonFormField<String>(
                              value: controller.selectedRole.value,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Color(0xFFFAFAFA),
                                border: _border,
                                enabledBorder: _border,
                                focusedBorder: _border,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: UsersController.roleAdmin,
                                  child: Text('Admin'),
                                ),
                                DropdownMenuItem(
                                  value: UsersController.roleUser,
                                  child: Text('User'),
                                ),
                              ],
                              onChanged: (v) {
                                if (v != null) {
                                  controller.selectedRole.value = v;
                                }
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Obx(() {
                        final edit = controller.isEditingMode;
                        return FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.active,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: controller.submitUserForm,
                          child: Text(
                              edit ? 'Güncelle' : 'Kullanıcı Oluştur'),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _label(String text) {
    return Text(
      text,
      style: AppTextStyles.body.copyWith(
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        fontSize: 13,
      ),
    );
  }
}
