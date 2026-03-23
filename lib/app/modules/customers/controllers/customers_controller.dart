import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/policy_files_helper.dart';
import '../../../data/dummy/policy_seed_data.dart';
import '../../../data/models/customer_model.dart';
import '../../../data/models/policy_model.dart';

class CustomersController extends GetxController {
  static const listFilterOptions = [
    'Tümü',
    'VIP',
    'Sadık',
    'Aktif',
  ];

  static const statusFilterOptions = [
    'Tümü',
    'Aktif',
    'Beklemede',
    'Sonlandı',
  ];

  static const daysFilterOptions = [
    'Tümü',
    '0–30 gün',
    '31–90 gün',
    '90+ gün',
  ];

  static const insuranceCompanies = [
    'Unico Sigorta',
    'Anadolu Sigorta',
    'Sompo Sigorta',
    'Axa Sigorta',
    'HDI Sigorta',
  ];

  static const policyTypes = [
    'Trafik Sigortası',
    'Kasko',
    'DASK',
    'Konut Sigortası',
    'Sağlık Sigortası',
  ];

  static const customerTypeOptions = ['Bireysel', 'Kurumsal', 'Belirsiz'];

  static const professionOptions = [
    'Sigortacı',
    'Diğer',
    'Mimar',
    'Esnaf',
    'Eksper',
    'Mühendis',
    'Bilirkişi',
    'Avukat',
    'Doktor',
    'Öğretmen',
    'Emekli',
    'Öğrenci',
    'Çiftçi',
    'İşletme Sahibi',
    'Serbest Meslek',
    'Bankacı',
    'Muhasebeci',
    'Eczacı',
    'Veteriner',
    'Pilot',
    'Mimarlık Mühendisi',
    'İnşaat Mühendisi',
  ];

  /// Form: VIP, Sadık, Öngörülemez, Bilinmiyor
  static const formStatusOptions = ['VIP', 'Sadık', 'Öngörülemez', 'Bilinmiyor'];

  static const formTagOptions = ['Aktif', 'Aktif Değil'];

  final customers = <CustomerModel>[].obs;
  final policies = <PolicyModel>[].obs;

  final selectedCustomer = Rxn<CustomerModel>();

  final listFilter = 'Tümü'.obs;
  final statusFilter = 'Tümü'.obs;
  final daysLeftFilter = 'Tümü'.obs;

  final currentPage = 1.obs;
  static const int pageSize = 5;

  final isPolicyDrawerOpen = false.obs;
  final isAnalyzingPdf = false.obs;

  final isCustomerFormDrawerOpen = false.obs;

  /// Yeni müşteri / düzenleme formu — null ise yeni kayıt modu
  final formCustomer = Rxn<CustomerModel>();

  final selectedCustomerType = 'Bireysel'.obs;
  final selectedProfession = 'Diğer'.obs;
  final selectedStatus = 'Bilinmiyor'.obs;
  final selectedTag = 'Aktif'.obs;

  late final TextEditingController custNameController;
  late final TextEditingController custTcknController;
  late final TextEditingController custBirthController;
  late final TextEditingController custPhoneController;
  late final TextEditingController custAddressController;
  late final TextEditingController custCustomerNoteController;
  late final TextEditingController custReferenceController;

  final insuranceCompany = 'Unico Sigorta'.obs;
  final policyType = 'Trafik Sigortası'.obs;

  late final TextEditingController policyNumberController;
  late final TextEditingController startDateController;
  late final TextEditingController endDateController;
  late final TextEditingController netPremiumController;
  late final TextEditingController currencyController;

  late final TextEditingController phoneController;
  late final TextEditingController plateController;
  late final TextEditingController serialController;
  late final TextEditingController modelController;
  late final TextEditingController brandController;
  late final TextEditingController tcController;
  late final TextEditingController notesController;

  final _dateFmt = DateFormat('dd.MM.yyyy');
  final _birthFmt = DateFormat('dd/MM/yyyy');

  @override
  void onInit() {
    super.onInit();
    custNameController = TextEditingController();
    custTcknController = TextEditingController();
    custBirthController = TextEditingController();
    custPhoneController = TextEditingController();
    custAddressController = TextEditingController();
    custCustomerNoteController = TextEditingController();
    custReferenceController = TextEditingController();

    policyNumberController = TextEditingController();
    startDateController = TextEditingController();
    endDateController = TextEditingController();
    netPremiumController = TextEditingController();
    currencyController = TextEditingController(text: 'TRY');

    phoneController = TextEditingController();
    plateController = TextEditingController();
    serialController = TextEditingController();
    modelController = TextEditingController();
    brandController = TextEditingController();
    tcController = TextEditingController();
    notesController = TextEditingController();

    _seedDummyData();
    selectedCustomer.value = customers.isNotEmpty ? customers.first : null;
  }

  @override
  void onClose() {
    custNameController.dispose();
    custTcknController.dispose();
    custBirthController.dispose();
    custPhoneController.dispose();
    custAddressController.dispose();
    custCustomerNoteController.dispose();
    custReferenceController.dispose();

    policyNumberController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    netPremiumController.dispose();
    currencyController.dispose();
    phoneController.dispose();
    plateController.dispose();
    serialController.dispose();
    modelController.dispose();
    brandController.dispose();
    tcController.dispose();
    notesController.dispose();
    super.onClose();
  }

  void _seedDummyData() {
    final now = DateTime.now();

    customers.assignAll([
      CustomerModel(
        id: 'C001',
        name: 'Ahmet Yılmaz',
        identityNumber: '12345678901',
        phone: '+90 532 111 22 33',
        tags: const ['VIP', 'Aktif'],
        status: 'Aktif',
        customerType: 'Bireysel',
        profession: 'Sigortacı',
        relationshipStatus: 'VIP',
        tagStatus: 'Aktif',
        reference: 'REF-2024-A1',
        birthDate: DateTime(1985, 6, 12),
        address: 'Caferağa Mah. Moda Cad. No:12 Kadıköy / İstanbul',
        customerNote: 'Yıllık poliçe yenileme hatırlatması gönderilir.',
      ),
      CustomerModel(
        id: 'C002',
        name: 'Elif Demir',
        identityNumber: '98765432109',
        phone: '+90 533 444 55 66',
        tags: const ['Sadık', 'Aktif'],
        status: 'Aktif',
        customerType: 'Bireysel',
        profession: 'Mimar',
        relationshipStatus: 'Sadık',
        tagStatus: 'Aktif',
        reference: 'REF-B2',
        birthDate: DateTime(1992, 3, 8),
        address: 'Bahçelievler, Ankara',
        customerNote: '',
      ),
      CustomerModel(
        id: 'C003',
        name: 'Mehmet Kaya',
        identityNumber: '11223344556',
        phone: '+90 534 777 88 99',
        tags: const ['VIP', 'Sadık'],
        status: 'Aktif',
        customerType: 'Kurumsal',
        profession: 'İşletme Sahibi',
        relationshipStatus: 'VIP',
        tagStatus: 'Aktif',
        reference: '',
        birthDate: DateTime(1978, 11, 1),
        address: 'Organize Sanayi Bölgesi, Kocaeli',
        customerNote: 'Kurumsal indirim uygulanır.',
      ),
      CustomerModel(
        id: 'C004',
        name: 'Ayşe Öztürk',
        identityNumber: '55667788990',
        phone: '+90 535 000 11 22',
        tags: const ['Aktif'],
        status: 'Beklemede',
        customerType: 'Bireysel',
        profession: 'Öğretmen',
        relationshipStatus: 'Öngörülemez',
        tagStatus: 'Aktif Değil',
        reference: 'REF-C4',
        birthDate: DateTime(1990, 4, 11),
        address: 'Çankaya, Ankara',
        customerNote: 'Son görüşme: telefon ile.',
      ),
      CustomerModel(
        id: 'C005',
        name: 'Burak Şahin',
        identityNumber: '66778899001',
        phone: '+90 536 333 44 55',
        tags: const ['Sadık'],
        status: 'Aktif',
        customerType: 'Bireysel',
        profession: 'Eksper',
        relationshipStatus: 'Sadık',
        tagStatus: 'Aktif',
        reference: '',
        birthDate: DateTime(1988, 7, 22),
        address: 'Alsancak, İzmir',
        customerNote: '',
      ),
      CustomerModel(
        id: 'C006',
        name: 'Zeynep Arslan',
        identityNumber: '22334455667',
        phone: '+90 537 666 77 88',
        tags: const ['VIP', 'Sadık', 'Aktif'],
        status: 'Aktif',
        customerType: 'Bireysel',
        profession: 'Mühendis',
        relationshipStatus: 'VIP',
        tagStatus: 'Aktif',
        reference: 'REF-D6',
        birthDate: DateTime(1995, 1, 30),
        address: 'Ataşehir, İstanbul',
        customerNote: 'Çoklu branş müşterisi.',
      ),
      CustomerModel(
        id: 'C007',
        name: 'Can Yurt',
        identityNumber: '33445566778',
        phone: '+90 538 999 00 11',
        tags: const ['Aktif'],
        status: 'Aktif',
        customerType: 'Belirsiz',
        profession: 'Diğer',
        relationshipStatus: 'Bilinmiyor',
        tagStatus: 'Aktif',
        reference: '',
        birthDate: null,
        address: '',
        customerNote: '',
      ),
      CustomerModel(
        id: 'C008',
        name: 'Deniz Koç',
        identityNumber: '44556677889',
        phone: '+90 539 222 33 44',
        tags: const ['VIP'],
        status: 'Sonlandı',
        customerType: 'Bireysel',
        profession: 'Avukat',
        relationshipStatus: 'VIP',
        tagStatus: 'Aktif Değil',
        reference: 'REF-E8',
        birthDate: DateTime(1982, 9, 5),
        address: 'Konak, İzmir',
        customerNote: 'Hesap kapalı.',
      ),
      CustomerModel(
        id: 'C009',
        name: 'Ece Aydın',
        identityNumber: '55667788990',
        phone: '+90 540 555 66 77',
        tags: const ['Sadık', 'Aktif'],
        status: 'Aktif',
        customerType: 'Bireysel',
        profession: 'Bankacı',
        relationshipStatus: 'Sadık',
        tagStatus: 'Aktif',
        reference: '',
        birthDate: DateTime(1993, 12, 18),
        address: 'Ümraniye, İstanbul',
        customerNote: '',
      ),
      CustomerModel(
        id: 'C010',
        name: 'Furkan Polat',
        identityNumber: '66778899001',
        phone: '+90 541 888 99 00',
        tags: const ['Aktif'],
        status: 'Aktif',
        customerType: 'Bireysel',
        profession: 'Öğrenci',
        relationshipStatus: 'Bilinmiyor',
        tagStatus: 'Aktif',
        reference: '',
        birthDate: DateTime(2001, 5, 5),
        address: 'Nilüfer, Bursa',
        customerNote: 'Genç sürücü.',
      ),
      CustomerModel(
        id: 'C011',
        name: 'Gizem Çelik',
        identityNumber: '77889900112',
        phone: '+90 542 111 22 33',
        tags: const ['VIP', 'Aktif'],
        status: 'Aktif',
        customerType: 'Bireysel',
        profession: 'Eczacı',
        relationshipStatus: 'VIP',
        tagStatus: 'Aktif',
        reference: 'REF-F11',
        birthDate: DateTime(1987, 2, 14),
        address: 'Beşiktaş, İstanbul',
        customerNote: '',
      ),
      CustomerModel(
        id: 'C012',
        name: 'Hakan Erdoğan',
        identityNumber: '88990011223',
        phone: '+90 543 444 55 66',
        tags: const ['Sadık'],
        status: 'Beklemede',
        customerType: 'Kurumsal',
        profession: 'Muhasebeci',
        relationshipStatus: 'Sadık',
        tagStatus: 'Aktif Değil',
        reference: '',
        birthDate: DateTime(1975, 10, 10),
        address: 'Etimesgut, Ankara',
        customerNote: 'Bekleyen talepler var.',
      ),
    ]);

    policies.assignAll(PolicySeedData.all(now));
  }

  List<CustomerModel> get filteredCustomers {
    var list = customers.toList();
    final f = listFilter.value;
    if (f == 'VIP') {
      list = list.where((c) => c.tags.contains('VIP')).toList();
    } else if (f == 'Sadık') {
      list = list.where((c) => c.tags.contains('Sadık')).toList();
    } else if (f == 'Aktif') {
      list = list.where((c) => c.tags.contains('Aktif')).toList();
    }
    return list;
  }

  int get totalPages => max(1, (filteredCustomers.length / pageSize).ceil());

  List<CustomerModel> get paginatedCustomers {
    final list = filteredCustomers;
    final start = (currentPage.value - 1) * pageSize;
    if (start >= list.length) return [];
    return list.skip(start).take(pageSize).toList();
  }

  void setListFilter(String value) {
    listFilter.value = value;
    currentPage.value = 1;
    _ensureSelectionValid();
    final tp = max(1, (filteredCustomers.length / pageSize).ceil());
    if (currentPage.value > tp) currentPage.value = tp;
  }

  void setStatusFilter(String value) {
    statusFilter.value = value;
  }

  void setDaysFilter(String value) {
    daysLeftFilter.value = value;
  }

  void goToPage(int page) {
    if (page < 1 || page > totalPages) return;
    currentPage.value = page;
  }

  void selectCustomer(CustomerModel c) {
    selectedCustomer.value = c;
  }

  void _ensureSelectionValid() {
    final list = filteredCustomers;
    if (list.isEmpty) {
      selectedCustomer.value = null;
      return;
    }
    final sel = selectedCustomer.value;
    if (sel == null || !list.any((e) => e.id == sel.id)) {
      selectedCustomer.value = list.first;
    }
  }

  List<PolicyModel> get policiesForSelected {
    final c = selectedCustomer.value;
    if (c == null) return [];
    return policies.where((p) => p.customerId == c.id).toList();
  }

  int daysLeft(PolicyModel p) {
    return p.endDate.difference(DateTime.now()).inDays;
  }

  List<PolicyModel> get filteredPoliciesForTable {
    var list = policiesForSelected;
    final sf = statusFilter.value;
    if (sf != 'Tümü') {
      list = list.where((p) => p.status == sf).toList();
    }
    final df = daysLeftFilter.value;
    if (df != 'Tümü') {
      list = list.where((p) {
        final d = daysLeft(p);
        if (df == '0–30 gün') return d >= 0 && d <= 30;
        if (df == '31–90 gün') return d >= 31 && d <= 90;
        if (df == '90+ gün') return d > 90;
        return true;
      }).toList();
    }
    return list;
  }

  int policyCountFor(CustomerModel c) {
    return policies.where((p) => p.customerId == c.id).length;
  }

  void openPolicyDrawer() {
    isCustomerFormDrawerOpen.value = false;
    _resetForm();
    isPolicyDrawerOpen.value = true;
  }

  void closePolicyDrawer() {
    isPolicyDrawerOpen.value = false;
  }

  void openCustomerFormDrawer(CustomerModel? customer) {
    isPolicyDrawerOpen.value = false;
    formCustomer.value = customer;
    if (customer != null) {
      _fillCustomerForm(customer);
    } else {
      _clearCustomerForm();
    }
    isCustomerFormDrawerOpen.value = true;
  }

  void closeCustomerFormDrawer() {
    isCustomerFormDrawerOpen.value = false;
    formCustomer.value = null;
  }

  void _clearCustomerForm() {
    custNameController.clear();
    custTcknController.clear();
    custBirthController.clear();
    custPhoneController.clear();
    custAddressController.clear();
    custCustomerNoteController.clear();
    custReferenceController.clear();
    selectedCustomerType.value = customerTypeOptions.first;
    selectedProfession.value = 'Diğer';
    selectedStatus.value = 'Bilinmiyor';
    selectedTag.value = 'Aktif';
  }

  void _fillCustomerForm(CustomerModel c) {
    custNameController.text = c.name;
    custTcknController.text = c.identityNumber;
    custPhoneController.text = c.phone;
    custAddressController.text = c.address;
    custCustomerNoteController.text = c.customerNote;
    custReferenceController.text = c.reference;
    selectedCustomerType.value =
        customerTypeOptions.contains(c.customerType) ? c.customerType : customerTypeOptions.first;
    selectedProfession.value =
        professionOptions.contains(c.profession) ? c.profession : 'Diğer';
    selectedStatus.value = formStatusOptions.contains(c.relationshipStatus)
        ? c.relationshipStatus
        : 'Bilinmiyor';
    selectedTag.value =
        formTagOptions.contains(c.tagStatus) ? c.tagStatus : 'Aktif';
    if (c.birthDate != null) {
      custBirthController.text = _birthFmt.format(c.birthDate!);
    } else {
      custBirthController.clear();
    }
  }

  List<String> _tagsFromForm() {
    final rs = selectedStatus.value;
    final tg = selectedTag.value;
    final tags = <String>[];
    if (rs != 'Bilinmiyor') tags.add(rs);
    if (tg == 'Aktif') tags.add('Aktif');
    return tags.isEmpty ? <String>['Aktif'] : tags;
  }

  String _operationalStatusFromForm() {
    if (selectedTag.value == 'Aktif') return 'Aktif';
    return 'Beklemede';
  }

  /// Form: Durum dropdown — 8x8 nokta renkleri (Mus-7-8)
  static Color formStatusDotColor(String status) {
    switch (status) {
      case 'VIP':
        return const Color(0xFF14B8A6);
      case 'Sadık':
        return const Color(0xFF3B82F6);
      case 'Öngörülemez':
        return const Color(0xFF93C5FD);
      case 'Bilinmiyor':
        return const Color(0xFFD1D5DB);
      default:
        return const Color(0xFFD1D5DB);
    }
  }

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
    Get.snackbar('Poliçe', 'Yenilenmeyecek olarak işaretlendi: ${p.policyNumber}');
  }

  void onPolicyCancel(PolicyModel p) {
    Get.snackbar('Poliçe', 'İptal talebi: ${p.policyNumber}');
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

  DateTime? _parseBirthDate(String raw) {
    final s = raw.trim();
    if (s.isEmpty) return null;
    try {
      final parts = s.split(RegExp(r'[./]'));
      if (parts.length != 3) return null;
      final d = int.parse(parts[0]);
      final m = int.parse(parts[1]);
      final y = int.parse(parts[2]);
      return DateTime(y, m, d);
    } catch (_) {
      return null;
    }
  }

  Future<void> pickBirthDate() async {
    final ctx = Get.context;
    if (ctx == null) return;
    final initial = _parseBirthDate(custBirthController.text) ?? DateTime(1990, 1, 1);
    final picked = await showDatePicker(
      context: ctx,
      initialDate: initial,
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      custBirthController.text = _birthFmt.format(picked);
    }
  }

  void saveCustomer() {
    final editing = formCustomer.value;
    final name = custNameController.text.trim();
    final tckn = custTcknController.text.trim();
    if (name.isEmpty || tckn.isEmpty) {
      Get.snackbar('Eksik bilgi', 'Ad Soyad ve TCKN zorunludur.');
      return;
    }
    final birth = _parseBirthDate(custBirthController.text);
    final tags = _tagsFromForm();
    final opStatus = _operationalStatusFromForm();

    if (editing == null) {
      final newId = 'C${DateTime.now().millisecondsSinceEpoch}';
      final created = CustomerModel(
        id: newId,
        name: name,
        identityNumber: tckn,
        phone: custPhoneController.text.trim(),
        tags: tags,
        status: opStatus,
        customerType: selectedCustomerType.value,
        profession: selectedProfession.value,
        relationshipStatus: selectedStatus.value,
        tagStatus: selectedTag.value,
        reference: custReferenceController.text.trim(),
        birthDate: birth,
        address: custAddressController.text.trim(),
        customerNote: custCustomerNoteController.text.trim(),
      );
      customers.add(created);
      customers.refresh();
      selectedCustomer.value = created;
      Get.snackbar('Başarılı', 'Müşteri kaydedildi.');
    } else {
      final updated = editing.copyWith(
        name: name,
        identityNumber: tckn,
        phone: custPhoneController.text.trim(),
        tags: tags,
        status: opStatus,
        customerType: selectedCustomerType.value,
        profession: selectedProfession.value,
        relationshipStatus: selectedStatus.value,
        tagStatus: selectedTag.value,
        reference: custReferenceController.text.trim(),
        birthDate: birth,
        clearBirthDate: birth == null,
        address: custAddressController.text.trim(),
        customerNote: custCustomerNoteController.text.trim(),
      );
      final idx = customers.indexWhere((e) => e.id == editing.id);
      if (idx >= 0) {
        customers[idx] = updated;
        customers.refresh();
      }
      if (selectedCustomer.value?.id == editing.id) {
        selectedCustomer.value = updated;
      }
      for (var i = 0; i < policies.length; i++) {
        if (policies[i].customerId == updated.id) {
          policies[i] = policies[i].copyWith(customerName: updated.name);
        }
      }
      policies.refresh();
      Get.snackbar('Başarılı', 'Müşteri güncellendi.');
    }
    closeCustomerFormDrawer();
    _clearCustomerForm();
  }

  void openCustomerNotebook({CustomerModel? customer}) {
    final c = customer ?? formCustomer.value ?? selectedCustomer.value;
    if (c == null) {
      Get.snackbar('Bilgi', 'Önce bir müşteri seçin.');
      return;
    }
    Get.dialog<void>(
      AlertDialog(
        title: Text('Not Defteri — ${c.name}'),
        content: SizedBox(
          width: 420,
          child: SingleChildScrollView(
            child: Text(
              c.customerNote.isEmpty ? 'Henüz not eklenmemiş.' : c.customerNote,
              style: const TextStyle(height: 1.4),
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: Get.back<void>, child: const Text('Kapat')),
        ],
      ),
    );
  }

  Future<void> deleteCustomer(CustomerModel c) async {
    final ok = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Müşteriyi sil'),
        content: Text('${c.name} kalıcı olarak silinsin mi?'),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('İptal')),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    policies.removeWhere((p) => p.customerId == c.id);
    policies.refresh();
    customers.removeWhere((e) => e.id == c.id);
    customers.refresh();
    if (selectedCustomer.value?.id == c.id) {
      selectedCustomer.value = customers.isNotEmpty ? customers.first : null;
    }
    if (formCustomer.value?.id == c.id) {
      closeCustomerFormDrawer();
    }
    Get.snackbar('Silindi', 'Müşteri kaldırıldı.');
  }

  void _resetForm() {
    insuranceCompany.value = insuranceCompanies.first;
    policyType.value = policyTypes.first;
    policyNumberController.clear();
    startDateController.clear();
    endDateController.clear();
    netPremiumController.clear();
    currencyController.text = 'TRY';
    phoneController.clear();
    plateController.clear();
    serialController.clear();
    modelController.clear();
    brandController.clear();
    tcController.clear();
    notesController.clear();
  }

  Future<void> simulatePdfUpload() async {
    if (isAnalyzingPdf.value) return;
    isAnalyzingPdf.value = true;
    await Future<void>.delayed(const Duration(seconds: 2));
    insuranceCompany.value = 'Unico Sigorta';
    policyType.value = 'Trafik Sigortası';
    policyNumberController.text = 'UN-2026-OCR-${DateTime.now().second}';
    final now = DateTime.now();
    startDateController.text = _dateFmt.format(now);
    endDateController.text = _dateFmt.format(now.add(const Duration(days: 365)));
    netPremiumController.text = '5420,50';
    currencyController.text = 'TRY';
    phoneController.text = '+90 532 999 88 77';
    plateController.text = '34 ABC 123';
    serialController.text = 'FE 123456';
    modelController.text = 'Corolla';
    brandController.text = 'Toyota';
    tcController.text = '12345678901';
    notesController.text =
        'Yapay zeka PDF analizi tamamlandı. Araç ve poliçe bilgileri otomatik dolduruldu.';
    isAnalyzingPdf.value = false;
  }

  DateTime? _parseTrDate(String raw) {
    final s = raw.trim();
    if (s.isEmpty) return null;
    try {
      final parts = s.split(RegExp(r'[./]'));
      if (parts.length != 3) return null;
      final d = int.parse(parts[0]);
      final m = int.parse(parts[1]);
      final y = int.parse(parts[2]);
      return DateTime(y, m, d);
    } catch (_) {
      return null;
    }
  }

  double? _parsePremium(String raw) {
    final s = raw.trim().replaceAll('.', '').replaceAll(',', '.');
    return double.tryParse(s);
  }

  void savePolicy() {
    final c = selectedCustomer.value;
    if (c == null) return;
    final start = _parseTrDate(startDateController.text);
    final end = _parseTrDate(endDateController.text);
    if (start == null || end == null) {
      Get.snackbar('Eksik bilgi', 'Başlangıç ve bitiş tarihlerini girin (GG.AA.YYYY).');
      return;
    }
    final premium = _parsePremium(netPremiumController.text) ?? 0;

    final newId = 'POL-${c.id}-${DateTime.now().millisecondsSinceEpoch}';
    policies.add(
      PolicyModel(
        id: newId,
        customerId: c.id,
        customerName: c.name,
        status: 'Aktif',
        company: insuranceCompany.value,
        type: policyType.value,
        policyNumber: policyNumberController.text.isEmpty
            ? 'YENİ-${newId.substring(newId.length - 4)}'
            : policyNumberController.text,
        startDate: start,
        endDate: end,
        netPremium: premium,
        currency: currencyController.text.isEmpty ? 'TRY' : currencyController.text,
      ),
    );
    policies.refresh();
    Get.snackbar('Başarılı', 'Poliçe kaydedildi.');
    closePolicyDrawer();
    _resetForm();
  }

  /// Etiket rengi (UI)
  static Color tagBackground(String tag) {
    switch (tag) {
      case 'VIP':
        return const Color(0xFF14B8A6);
      case 'Sadık':
        return const Color(0xFF3B82F6);
      case 'Öngörülemez':
        return const Color(0xFF93C5FD);
      case 'Aktif':
        return const Color(0xFF111827);
      default:
        return const Color(0xFF6B7280);
    }
  }

  static Color tagForeground(String tag) {
    if (tag == 'Öngörülemez') {
      return const Color(0xFF1F2937);
    }
    return Colors.white;
  }
}
