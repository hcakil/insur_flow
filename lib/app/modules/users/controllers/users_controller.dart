import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/user_model.dart';

class UsersController extends GetxController {
  static const roleAdmin = 'Admin';
  static const roleUser = 'User';

  final users = <UserModel>[].obs;

  final isUserFormDrawerOpen = false.obs;
  final editingUser = Rxn<UserModel>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final selectedRole = roleAdmin.obs;

  bool get isEditingMode => editingUser.value != null;

  @override
  void onInit() {
    super.onInit();
    _seedUsers();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void _seedUsers() {
    users.assignAll([
      UserModel(
        id: 'U-001',
        fullName: 'Rıdvan Pazarlıoğlu',
        email: 'r.pazarlioglu90@gmail.com',
        role: roleAdmin,
        status: 'Aktif',
        createdAt: DateTime(2025, 12, 30),
      ),
      UserModel(
        id: 'U-002',
        fullName: 'Ayşe Yılmaz',
        email: 'ayse.yilmaz@example.com',
        role: roleUser,
        status: 'Aktif',
        createdAt: DateTime(2025, 11, 15),
      ),
      UserModel(
        id: 'U-003',
        fullName: 'Mehmet Kaya',
        email: 'mehmet.kaya@example.com',
        role: roleUser,
        status: 'Aktif',
        createdAt: DateTime(2026, 1, 8),
      ),
    ]);
  }

  void openUserFormDrawer(UserModel? user) {
    editingUser.value = user;
    if (user != null) {
      nameController.text = user.fullName;
      emailController.text = user.email;
      passwordController.clear();
      selectedRole.value = user.role == roleAdmin ? roleAdmin : roleUser;
    } else {
      nameController.clear();
      emailController.clear();
      passwordController.clear();
      selectedRole.value = roleUser;
    }
    isUserFormDrawerOpen.value = true;
  }

  void closeUserFormDrawer() {
    isUserFormDrawerOpen.value = false;
    editingUser.value = null;
  }

  void submitUserForm() {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (name.isEmpty || email.isEmpty) {
      Get.snackbar(
        'Eksik bilgi',
        'İsim ve e-posta zorunludur.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(12),
      );
      return;
    }

    if (!isEditingMode) {
      if (password.length < 6) {
        Get.snackbar(
          'Şifre',
          'Şifre en az 6 karakter olmalıdır.',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(12),
        );
        return;
      }
    } else if (password.isNotEmpty && password.length < 6) {
      Get.snackbar(
        'Şifre',
        'Şifre en az 6 karakter olmalıdır.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(12),
      );
      return;
    }

    if (isEditingMode) {
      final u = editingUser.value!;
      final idx = users.indexWhere((x) => x.id == u.id);
      if (idx >= 0) {
        users[idx] = UserModel(
          id: u.id,
          fullName: name,
          email: email,
          role: selectedRole.value,
          status: u.status,
          createdAt: u.createdAt,
        );
        users.refresh();
      }
      Get.snackbar('Güncellendi', name,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(12));
    } else {
      final id = 'U-${DateTime.now().millisecondsSinceEpoch}';
      users.insert(
        0,
        UserModel(
          id: id,
          fullName: name,
          email: email,
          role: selectedRole.value,
          status: 'Aktif',
          createdAt: DateTime.now(),
        ),
      );
      Get.snackbar('Kullanıcı oluşturuldu', name,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(12));
    }
    closeUserFormDrawer();
  }

  void onResetPassword(UserModel u) {
    Get.dialog<void>(
      AlertDialog(
        title: const Text('Şifre sıfırlama'),
        content: Text('${u.email} için sıfırlama bağlantısı gönderilsin mi?'),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('İptal')),
          FilledButton(
            onPressed: () {
              Get.back();
              Get.snackbar('Bilgi', 'Şifre sıfırlama e-postası gönderildi.',
                  snackPosition: SnackPosition.BOTTOM,
                  margin: const EdgeInsets.all(12));
            },
            child: const Text('Gönder'),
          ),
        ],
      ),
    );
  }

  void onDeactivate(UserModel u) {
    final idx = users.indexWhere((x) => x.id == u.id);
    if (idx < 0) return;
    users[idx] = UserModel(
      id: u.id,
      fullName: u.fullName,
      email: u.email,
      role: u.role,
      status: 'Pasif',
      createdAt: u.createdAt,
    );
    users.refresh();
    Get.snackbar('Pasife alındı', u.fullName,
        snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(12));
  }

  void deleteUser(UserModel u) {
    Get.dialog<void>(
      AlertDialog(
        title: const Text('Kullanıcıyı sil'),
        content: Text('${u.fullName} kalıcı olarak silinsin mi?'),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('İptal')),
          TextButton(
            onPressed: () {
              users.removeWhere((x) => x.id == u.id);
              Get.back();
              Get.snackbar('Silindi', u.fullName,
                  snackPosition: SnackPosition.BOTTOM,
                  margin: const EdgeInsets.all(12));
            },
            child: Text('Sil', style: TextStyle(color: Colors.red.shade700)),
          ),
        ],
      ),
    );
  }
}
