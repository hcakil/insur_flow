import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/policy_files_helper.dart';
import '../../../data/dummy/policy_seed_data.dart';
import '../../../data/models/policy_model.dart';

class PoliciesController extends GetxController {
  final policies = <PolicyModel>[].obs;

  /// Arama (Poliçe No / müşteri) — "Ara" ile güncellenir
  final searchQuery = ''.obs;

  /// Şirket, tip, durum — anlık filtre
  final selectedCompany = 'Tümü'.obs;
  final selectedType = 'Tümü'.obs;
  final selectedStatus = 'Tümü'.obs;

  /// "Kalan Gün" max değeri — "Ara" ile `remainingDays` Rx'e yazılır
  final remainingDays = ''.obs;

  late final TextEditingController searchController;
  late final TextEditingController maxDaysController;

  @override
  void onInit() {
    super.onInit();
    searchController = TextEditingController();
    maxDaysController = TextEditingController();
    policies.assignAll(PolicySeedData.all(DateTime.now()));
  }

  @override
  void onClose() {
    searchController.dispose();
    maxDaysController.dispose();
    super.onClose();
  }

  List<String> get companyOptions {
    final set = policies.map((p) => p.company).toSet().toList()..sort();
    return ['Tümü', ...set];
  }

  List<String> get typeOptions {
    final set = policies.map((p) => p.type).toSet().toList()..sort();
    return ['Tümü', ...set];
  }

  List<String> get statusOptions {
    final set = policies.map((p) => p.status).toSet().toList()..sort();
    return ['Tümü', ...set];
  }

  List<PolicyModel> get filteredPolicies {
    var list = policies.toList();
    final q = searchQuery.value.toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((p) {
        final name = (p.customerName ?? '').toLowerCase();
        return p.policyNumber.toLowerCase().contains(q) || name.contains(q);
      }).toList();
    }
    if (selectedCompany.value != 'Tümü') {
      list = list.where((p) => p.company == selectedCompany.value).toList();
    }
    if (selectedType.value != 'Tümü') {
      list = list.where((p) => p.type == selectedType.value).toList();
    }
    if (selectedStatus.value != 'Tümü') {
      list = list.where((p) => p.status == selectedStatus.value).toList();
    }
    final maxD = int.tryParse(remainingDays.value.trim());
    if (maxD != null && maxD >= 0) {
      final now = DateTime.now();
      list = list.where((p) {
        final days = p.endDate.difference(now).inDays;
        return days <= maxD;
      }).toList();
    }
    return list;
  }

  void applyFilters() {
    searchQuery.value = searchController.text.trim();
    remainingDays.value = maxDaysController.text.trim();
    policies.refresh();
  }

  void resetFilters() {
    searchController.clear();
    maxDaysController.clear();
    searchQuery.value = '';
    remainingDays.value = '';
    selectedCompany.value = 'Tümü';
    selectedType.value = 'Tümü';
    selectedStatus.value = 'Tümü';
    policies.refresh();
  }

  int daysLeft(PolicyModel p) => p.endDate.difference(DateTime.now()).inDays;

  void showPolicyFilesDialog(String policyNo) {
    PolicyFilesHelper.showPolicyFilesDialog(policyNo);
  }

  void onPolicyEdit(PolicyModel p) {
    Get.snackbar('Poliçe', 'Düzenle: ${p.policyNumber}');
  }

  void onPolicyRenew(PolicyModel p) {
    Get.snackbar('Poliçe', 'Yenile: ${p.policyNumber}');
  }

  void onPolicyNoRenew(PolicyModel p) {
    Get.snackbar('Poliçe', 'Yenilenmeyecek: ${p.policyNumber}');
  }

  void onPolicyCancel(PolicyModel p) {
    Get.snackbar('Poliçe', 'İptal: ${p.policyNumber}');
  }

  void onPolicyDelete(PolicyModel p) {
    Get.dialog<void>(
      AlertDialog(
        title: const Text('Poliçeyi sil'),
        content: Text('${p.policyNumber} silinsin mi?'),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Vazgeç')),
          TextButton(
            onPressed: () {
              policies.removeWhere((x) => x.id == p.id);
              policies.refresh();
              Get.back();
              Get.snackbar('Silindi', 'Poliçe kaldırıldı');
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }
}
