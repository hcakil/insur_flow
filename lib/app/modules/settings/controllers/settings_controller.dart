import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/utils/color_hex.dart';
import '../../../data/models/bookmark_model.dart';
import '../../../data/models/customer_status_model.dart';
import '../../../data/models/customer_tag_model.dart';
import '../../../data/models/insurance_company_model.dart';
import '../../../data/models/policy_field_setting_model.dart';
import '../../../data/models/policy_type_setting_model.dart';
import '../../../data/models/profession_model.dart';
import '../../../data/models/settings_announcement_model.dart';

class SettingsController extends GetxController {
  /// 0: Meslekler … 6: Duyurular
  final activeTab = 0.obs;

  static const defaultStatusColorHex = '#3B82F6';

  final professions = <ProfessionModel>[].obs;
  final professionNameController = TextEditingController();

  final customerStatuses = <CustomerStatusModel>[].obs;
  final statusNameController = TextEditingController();
  final selectedColorHex = defaultStatusColorHex.obs;

  // Tab 2 — Müşteri Etiketleri
  final customerTags = <CustomerTagModel>[].obs;
  final tagNameController = TextEditingController();

  // Tab 3 — Şirket / Poliçe tipleri
  final insuranceCompanies = <InsuranceCompanyModel>[].obs;
  final companyNameController = TextEditingController();
  final policyTypesSettings = <PolicyTypeSettingModel>[].obs;
  final policyTypeNameController = TextEditingController();

  // Tab 4 — Poliçe alanları
  final selectedPolicyTypeIdForFields = ''.obs;
  final policyFields = <PolicyFieldSettingModel>[].obs;
  final policyFieldNameController = TextEditingController();
  final policyFieldOptionsController = TextEditingController();
  final selectedFieldType = 'Metin'.obs;
  final policyFieldIsRequired = true.obs;

  // Tab 5 — Sık kullanılanlar
  final settingsBookmarks = <BookmarkModel>[].obs;
  final bookmarkTitleController = TextEditingController();
  final bookmarkUrlController = TextEditingController();

  // Tab 6 — Duyurular
  final announcements = <SettingsAnnouncementModel>[].obs;
  final announcementTitleController = TextEditingController();
  final announcementContentController = TextEditingController();

  static const tabLabels = [
    'Meslekler',
    'Müşteri Durumları',
    'Müşteri Etiketleri',
    'Şirket/Poliçeler',
    'Poliçe Alanları',
    'Sık Kullanılanlar',
    'Duyurular',
  ];

  static const fieldTypes = ['Metin', 'Sayı'];

  List<PolicyFieldSettingModel> get fieldsForSelectedPolicyType {
    final id = selectedPolicyTypeIdForFields.value;
    return policyFields.where((f) => f.policyTypeId == id).toList();
  }

  String get selectedPolicyTypeDisplayName {
    final id = selectedPolicyTypeIdForFields.value;
    for (final t in policyTypesSettings) {
      if (t.id == id) return t.name;
    }
    return 'Poliçe';
  }

  @override
  void onInit() {
    super.onInit();
    _seedProfessions();
    _seedStatuses();
    _seedTags();
    _seedCompaniesAndPolicyTypes();
    _seedPolicyFields();
    _seedBookmarks();
    if (policyTypesSettings.isNotEmpty) {
      selectedPolicyTypeIdForFields.value = policyTypesSettings.first.id;
    }
  }

  @override
  void onClose() {
    professionNameController.dispose();
    statusNameController.dispose();
    tagNameController.dispose();
    companyNameController.dispose();
    policyTypeNameController.dispose();
    policyFieldNameController.dispose();
    policyFieldOptionsController.dispose();
    bookmarkTitleController.dispose();
    bookmarkUrlController.dispose();
    announcementTitleController.dispose();
    announcementContentController.dispose();
    super.onClose();
  }

  void _seedProfessions() {
    professions.assignAll([
      ProfessionModel(id: 'p1', name: 'Sigortacı'),
      ProfessionModel(id: 'p2', name: 'Diğer'),
      ProfessionModel(id: 'p3', name: 'Mimar'),
      ProfessionModel(id: 'p4', name: 'Doktor'),
      ProfessionModel(id: 'p5', name: 'Avukat'),
    ]);
  }

  void _seedStatuses() {
    customerStatuses.assignAll([
      CustomerStatusModel(id: 's1', name: 'VIP', colorHex: '#3cf6d1'),
      CustomerStatusModel(id: 's2', name: 'Sadık', colorHex: '#8B5CF6'),
      CustomerStatusModel(id: 's3', name: 'Yeni', colorHex: '#F59E0B'),
      CustomerStatusModel(id: 's4', name: 'Riskli', colorHex: '#EF4444'),
    ]);
  }

  void _seedTags() {
    customerTags.assignAll([
      CustomerTagModel(id: 'tg1', name: 'Aktif'),
      CustomerTagModel(id: 'tg2', name: 'Aktif Değil'),
    ]);
  }

  void _seedCompaniesAndPolicyTypes() {
    insuranceCompanies.assignAll([
      InsuranceCompanyModel(id: 'ic1', name: 'Allianz Sigorta', isActive: true),
      InsuranceCompanyModel(id: 'ic2', name: 'Anadolu Sigorta', isActive: true),
      InsuranceCompanyModel(id: 'ic3', name: 'Sompo Sigorta', isActive: true),
      InsuranceCompanyModel(id: 'ic4', name: 'Unico Sigorta', isActive: false),
    ]);
    policyTypesSettings.assignAll([
      PolicyTypeSettingModel(id: 'pt1', name: 'Trafik Sigortası', isActive: true),
      PolicyTypeSettingModel(id: 'pt2', name: 'Kasko Sigortası', isActive: true),
      PolicyTypeSettingModel(id: 'pt3', name: 'Konut Sigortası', isActive: true),
      PolicyTypeSettingModel(id: 'pt4', name: 'DASK', isActive: true),
    ]);
  }

  void _seedPolicyFields() {
    policyFields.assignAll([
      PolicyFieldSettingModel(
        id: 'pf1',
        policyTypeId: 'pt1',
        fieldName: 'İletişim Numarası',
        fieldType: 'Metin',
        options: null,
        isRequired: true,
      ),
      PolicyFieldSettingModel(
        id: 'pf2',
        policyTypeId: 'pt1',
        fieldName: 'Plaka',
        fieldType: 'Metin',
        options: null,
        isRequired: true,
      ),
      PolicyFieldSettingModel(
        id: 'pf3',
        policyTypeId: 'pt2',
        fieldName: 'Araç Değeri',
        fieldType: 'Sayı',
        options: null,
        isRequired: false,
      ),
    ]);
  }

  void _seedBookmarks() {
    settingsBookmarks.assignAll([
      BookmarkModel(
        id: 'bk1',
        title: 'Google',
        url: 'https://www.google.com',
      ),
      BookmarkModel(
        id: 'bk2',
        title: 'SBM',
        url: 'https://www.sbm.org.tr',
      ),
    ]);
  }

  void setActiveTab(int index) {
    if (index >= 0 && index < tabLabels.length) {
      activeTab.value = index;
    }
  }

  void selectPolicyTypeForFields(String id) {
    selectedPolicyTypeIdForFields.value = id;
  }

  // ——— Meslekler ———
  void addProfession() {
    final name = professionNameController.text.trim();
    if (name.isEmpty) {
      Get.snackbar('Uyarı', 'Meslek adı girin.',
          snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(12));
      return;
    }
    professions.add(ProfessionModel(
      id: 'p-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
    ));
    professionNameController.clear();
    Get.snackbar('Eklendi', name,
        snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(12));
  }

  void deleteProfession(ProfessionModel p) {
    professions.removeWhere((x) => x.id == p.id);
    Get.snackbar('Silindi', p.name,
        snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(12));
  }

  Future<void> editProfession(ProfessionModel p) async {
    final ctrl = TextEditingController(text: p.name);
    try {
      final ok = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Meslek düzenle'),
          content: TextField(
            controller: ctrl,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Meslek adı'),
          ),
          actions: [
            TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('İptal')),
            FilledButton(
                onPressed: () => Get.back(result: true),
                child: const Text('Kaydet')),
          ],
        ),
      );
      if (ok == true) {
        final name = ctrl.text.trim();
        if (name.isEmpty) return;
        final i = professions.indexWhere((x) => x.id == p.id);
        if (i >= 0) {
          professions[i] = ProfessionModel(id: p.id, name: name);
          professions.refresh();
        }
      }
    } finally {
      ctrl.dispose();
    }
  }

  // ——— Müşteri durumları ———
  void addCustomerStatus() {
    final name = statusNameController.text.trim();
    if (name.isEmpty) {
      Get.snackbar('Uyarı', 'Durum adı girin.',
          snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(12));
      return;
    }
    final hex = _normalizeHex(selectedColorHex.value);
    customerStatuses.add(CustomerStatusModel(
      id: 's-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      colorHex: hex,
    ));
    statusNameController.clear();
    selectedColorHex.value = defaultStatusColorHex;
    Get.snackbar('Eklendi', name,
        snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(12));
  }

  void deleteCustomerStatus(CustomerStatusModel s) {
    customerStatuses.removeWhere((x) => x.id == s.id);
    Get.snackbar('Silindi', s.name,
        snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(12));
  }

  Future<void> editCustomerStatus(CustomerStatusModel s) async {
    final nameCtrl = TextEditingController(text: s.name);
    final hexCtrl = TextEditingController(text: s.colorHex);
    try {
      final ok = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Durum düzenle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Durum adı'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: hexCtrl,
                decoration: const InputDecoration(
                  labelText: 'Renk (#HEX)',
                  hintText: '#3B82F6',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('İptal')),
            FilledButton(
                onPressed: () => Get.back(result: true),
                child: const Text('Kaydet')),
          ],
        ),
      );
      if (ok == true) {
        final name = nameCtrl.text.trim();
        if (name.isEmpty) return;
        final i = customerStatuses.indexWhere((x) => x.id == s.id);
        if (i >= 0) {
          customerStatuses[i] = CustomerStatusModel(
            id: s.id,
            name: name,
            colorHex: _normalizeHex(hexCtrl.text),
          );
          customerStatuses.refresh();
        }
      }
    } finally {
      nameCtrl.dispose();
      hexCtrl.dispose();
    }
  }

  String _normalizeHex(String raw) {
    var h = raw.trim();
    if (!h.startsWith('#')) h = '#$h';
    return h.toLowerCase();
  }

  void pickStatusColor() {
    final presets = [
      '#3B82F6',
      '#10B981',
      '#F59E0B',
      '#EF4444',
      '#8B5CF6',
      '#EC4899',
      '#3cf6d1',
      '#6366F1',
    ];
    Get.dialog<void>(
      AlertDialog(
        title: const Text('Renk seç'),
        content: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: presets.map((h) {
            return InkWell(
              onTap: () {
                selectedColorHex.value = h;
                Get.back();
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorFromHex(h),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black26),
                ),
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Kapat')),
        ],
      ),
    );
  }

  // ——— Tab 2 Etiketler ———
  void addCustomerTag() {
    final name = tagNameController.text.trim();
    if (name.isEmpty) {
      Get.snackbar('Uyarı', 'Etiket adı girin.',
          snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(12));
      return;
    }
    customerTags.add(CustomerTagModel(
      id: 'tg-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
    ));
    tagNameController.clear();
    Get.snackbar('Eklendi', name,
        snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(12));
  }

  void deleteCustomerTag(CustomerTagModel t) {
    customerTags.removeWhere((x) => x.id == t.id);
    Get.snackbar('Silindi', t.name,
        snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(12));
  }

  Future<void> editCustomerTag(CustomerTagModel t) async {
    final ctrl = TextEditingController(text: t.name);
    try {
      final ok = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Etiket düzenle'),
          content: TextField(
            controller: ctrl,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Etiket adı'),
          ),
          actions: [
            TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('İptal')),
            FilledButton(
                onPressed: () => Get.back(result: true),
                child: const Text('Kaydet')),
          ],
        ),
      );
      if (ok == true) {
        final name = ctrl.text.trim();
        if (name.isEmpty) return;
        final i = customerTags.indexWhere((x) => x.id == t.id);
        if (i >= 0) {
          customerTags[i] = CustomerTagModel(id: t.id, name: name);
          customerTags.refresh();
        }
      }
    } finally {
      ctrl.dispose();
    }
  }

  // ——— Tab 3 Şirketler ———
  void addInsuranceCompany() {
    final name = companyNameController.text.trim();
    if (name.isEmpty) {
      Get.snackbar('Uyarı', 'Şirket adı girin.',
          snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(12));
      return;
    }
    insuranceCompanies.add(InsuranceCompanyModel(
      id: 'ic-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      isActive: true,
    ));
    companyNameController.clear();
    Get.snackbar('Eklendi', name,
        snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(12));
  }

  void toggleInsuranceCompany(InsuranceCompanyModel c) {
    final i = insuranceCompanies.indexWhere((x) => x.id == c.id);
    if (i >= 0) {
      insuranceCompanies[i] = c.copyWith(isActive: !c.isActive);
      insuranceCompanies.refresh();
    }
  }

  void deleteInsuranceCompany(InsuranceCompanyModel c) {
    insuranceCompanies.removeWhere((x) => x.id == c.id);
    Get.snackbar('Silindi', c.name,
        snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(12));
  }

  Future<void> editInsuranceCompany(InsuranceCompanyModel c) async {
    final ctrl = TextEditingController(text: c.name);
    try {
      final ok = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Şirket düzenle'),
          content: TextField(
            controller: ctrl,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Şirket adı'),
          ),
          actions: [
            TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('İptal')),
            FilledButton(
                onPressed: () => Get.back(result: true),
                child: const Text('Kaydet')),
          ],
        ),
      );
      if (ok == true) {
        final name = ctrl.text.trim();
        if (name.isEmpty) return;
        final i = insuranceCompanies.indexWhere((x) => x.id == c.id);
        if (i >= 0) {
          insuranceCompanies[i] = c.copyWith(name: name);
          insuranceCompanies.refresh();
        }
      }
    } finally {
      ctrl.dispose();
    }
  }

  // ——— Tab 3 Poliçe tipleri ———
  void addPolicyTypeSetting() {
    final name = policyTypeNameController.text.trim();
    if (name.isEmpty) {
      Get.snackbar('Uyarı', 'Poliçe tipi adı girin.',
          snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(12));
      return;
    }
    final id = 'pt-${DateTime.now().millisecondsSinceEpoch}';
    policyTypesSettings.add(PolicyTypeSettingModel(
      id: id,
      name: name,
      isActive: true,
    ));
    policyTypeNameController.clear();
    Get.snackbar('Eklendi', name,
        snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(12));
  }

  void togglePolicyTypeSetting(PolicyTypeSettingModel p) {
    final i = policyTypesSettings.indexWhere((x) => x.id == p.id);
    if (i >= 0) {
      policyTypesSettings[i] = p.copyWith(isActive: !p.isActive);
      policyTypesSettings.refresh();
    }
  }

  void deletePolicyTypeSetting(PolicyTypeSettingModel p) {
    policyTypesSettings.removeWhere((x) => x.id == p.id);
    policyFields.removeWhere((f) => f.policyTypeId == p.id);
    if (selectedPolicyTypeIdForFields.value == p.id) {
      selectedPolicyTypeIdForFields.value =
          policyTypesSettings.isNotEmpty ? policyTypesSettings.first.id : '';
    }
    Get.snackbar('Silindi', p.name,
        snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(12));
  }

  Future<void> editPolicyTypeSetting(PolicyTypeSettingModel p) async {
    final ctrl = TextEditingController(text: p.name);
    try {
      final ok = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Poliçe tipi düzenle'),
          content: TextField(
            controller: ctrl,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Poliçe tipi adı'),
          ),
          actions: [
            TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('İptal')),
            FilledButton(
                onPressed: () => Get.back(result: true),
                child: const Text('Kaydet')),
          ],
        ),
      );
      if (ok == true) {
        final name = ctrl.text.trim();
        if (name.isEmpty) return;
        final i = policyTypesSettings.indexWhere((x) => x.id == p.id);
        if (i >= 0) {
          policyTypesSettings[i] = p.copyWith(name: name);
          policyTypesSettings.refresh();
        }
      }
    } finally {
      ctrl.dispose();
    }
  }

  // ——— Tab 4 Alanlar ———
  bool addPolicyField() {
    final name = policyFieldNameController.text.trim();
    final pid = selectedPolicyTypeIdForFields.value;
    if (pid.isEmpty) {
      Get.snackbar('Uyarı', 'Önce poliçe tipi seçin.',
          snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(12));
      return false;
    }
    if (name.isEmpty) {
      Get.snackbar('Uyarı', 'Alan adı girin.',
          snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(12));
      return false;
    }
    final opts = policyFieldOptionsController.text.trim();
    policyFields.add(PolicyFieldSettingModel(
      id: 'pf-${DateTime.now().millisecondsSinceEpoch}',
      policyTypeId: pid,
      fieldName: name,
      fieldType: selectedFieldType.value,
      options: opts.isEmpty ? null : opts,
      isRequired: policyFieldIsRequired.value,
    ));
    policyFieldNameController.clear();
    policyFieldOptionsController.clear();
    policyFieldIsRequired.value = true;
    Get.snackbar('Eklendi', name,
        snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(12));
    return true;
  }

  void deletePolicyField(PolicyFieldSettingModel f) {
    policyFields.removeWhere((x) => x.id == f.id);
    Get.snackbar('Silindi', f.fieldName,
        snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(12));
  }

  Future<void> editPolicyField(PolicyFieldSettingModel f) async {
    final nameCtrl = TextEditingController(text: f.fieldName);
    final optCtrl = TextEditingController(text: f.options ?? '');
    var type = f.fieldType;
    var req = f.isRequired;
    try {
      final ok = await Get.dialog<bool>(
        StatefulBuilder(
          builder: (context, setSt) {
            return AlertDialog(
              title: const Text('Alan düzenle'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(labelText: 'Alan adı'),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: type,
                      decoration: const InputDecoration(labelText: 'Tip'),
                      items: fieldTypes
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) setSt(() => type = v);
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: optCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Seçenekler (opsiyonel)',
                      ),
                    ),
                    const SizedBox(height: 8),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Zorunlu'),
                      value: req,
                      onChanged: (v) => setSt(() => req = v ?? false),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () => Get.back(result: false),
                    child: const Text('İptal')),
                FilledButton(
                    onPressed: () => Get.back(result: true),
                    child: const Text('Kaydet')),
              ],
            );
          },
        ),
      );
      if (ok == true) {
        final n = nameCtrl.text.trim();
        if (n.isEmpty) return;
        final i = policyFields.indexWhere((x) => x.id == f.id);
        if (i >= 0) {
          final o = optCtrl.text.trim();
          policyFields[i] = f.copyWith(
            fieldName: n,
            fieldType: type,
            options: o.isEmpty ? null : o,
            isRequired: req,
          );
          policyFields.refresh();
        }
      }
    } finally {
      nameCtrl.dispose();
      optCtrl.dispose();
    }
  }

  // ——— Tab 5 Yer imleri ———
  Future<void> openBookmarkUrl(String url) async {
    final u = Uri.tryParse(url);
    if (u == null || !u.hasScheme) {
      Get.snackbar('Hata', 'Geçersiz bağlantı',
          snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(12));
      return;
    }
    if (!await launchUrl(u, mode: LaunchMode.externalApplication)) {
      Get.snackbar('Hata', 'Bağlantı açılamadı',
          snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(12));
    }
  }

  void addSettingsBookmark() {
    final title = bookmarkTitleController.text.trim();
    final url = bookmarkUrlController.text.trim();
    if (title.isEmpty || url.isEmpty) {
      Get.snackbar('Uyarı', 'Ad ve link zorunludur.',
          snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(12));
      return;
    }
    var normalized = url;
    if (!normalized.contains('://')) {
      normalized = 'https://$normalized';
    }
    settingsBookmarks.add(BookmarkModel(
      id: 'bk-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      url: normalized,
    ));
    bookmarkTitleController.clear();
    bookmarkUrlController.clear();
    Get.snackbar('Eklendi', title,
        snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(12));
  }

  void deleteSettingsBookmark(BookmarkModel b) {
    settingsBookmarks.removeWhere((x) => x.id == b.id);
    Get.snackbar('Silindi', b.title,
        snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(12));
  }

  Future<void> editSettingsBookmark(BookmarkModel b) async {
    final tCtrl = TextEditingController(text: b.title);
    final uCtrl = TextEditingController(text: b.url);
    try {
      final ok = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Kısayol düzenle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tCtrl,
                decoration: const InputDecoration(labelText: 'Ad'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: uCtrl,
                decoration: const InputDecoration(labelText: 'Link'),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('İptal')),
            FilledButton(
                onPressed: () => Get.back(result: true),
                child: const Text('Kaydet')),
          ],
        ),
      );
      if (ok == true) {
        final title = tCtrl.text.trim();
        var url = uCtrl.text.trim();
        if (title.isEmpty || url.isEmpty) return;
        if (!url.contains('://')) url = 'https://$url';
        final i = settingsBookmarks.indexWhere((x) => x.id == b.id);
        if (i >= 0) {
          settingsBookmarks[i] = BookmarkModel(id: b.id, title: title, url: url);
          settingsBookmarks.refresh();
        }
      }
    } finally {
      tCtrl.dispose();
      uCtrl.dispose();
    }
  }

  // ——— Tab 6 Duyurular ———
  void addAnnouncement() {
    final title = announcementTitleController.text.trim();
    final content = announcementContentController.text.trim();
    if (title.isEmpty || content.isEmpty) {
      Get.snackbar('Uyarı', 'Başlık ve içerik zorunludur.',
          snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(12));
      return;
    }
    announcements.add(SettingsAnnouncementModel(
      id: 'an-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      content: content,
    ));
    announcementTitleController.clear();
    announcementContentController.clear();
    Get.snackbar('Eklendi', title,
        snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(12));
  }

  void deleteAnnouncement(SettingsAnnouncementModel a) {
    announcements.removeWhere((x) => x.id == a.id);
    Get.snackbar('Silindi', a.title,
        snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(12));
  }

  Future<void> editAnnouncement(SettingsAnnouncementModel a) async {
    final tCtrl = TextEditingController(text: a.title);
    final cCtrl = TextEditingController(text: a.content);
    try {
      final ok = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Duyuru düzenle'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: tCtrl,
                  decoration: const InputDecoration(labelText: 'Başlık'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: cCtrl,
                  minLines: 3,
                  maxLines: 8,
                  decoration: const InputDecoration(
                    labelText: 'İçerik',
                    alignLabelWithHint: true,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('İptal')),
            FilledButton(
                onPressed: () => Get.back(result: true),
                child: const Text('Kaydet')),
          ],
        ),
      );
      if (ok == true) {
        final title = tCtrl.text.trim();
        final content = cCtrl.text.trim();
        if (title.isEmpty || content.isEmpty) return;
        final i = announcements.indexWhere((x) => x.id == a.id);
        if (i >= 0) {
          announcements[i] = SettingsAnnouncementModel(
            id: a.id,
            title: title,
            content: content,
          );
          announcements.refresh();
        }
      }
    } finally {
      tCtrl.dispose();
      cCtrl.dispose();
    }
  }
}
