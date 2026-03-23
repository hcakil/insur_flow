import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/models/ticket_model.dart';

class TicketsController extends GetxController {
  static const kAllStatuses = 'Tüm Durumlar';
  static const kAllAssignees = 'Tüm Atamalar';
  static const assignee1 = 'İsim 1';
  static const assignee2 = 'İsim 2';

  final selectedStatus = kAllStatuses.obs;
  final selectedAssignee = kAllAssignees.obs;
  final selectedDate = Rxn<DateTime>();

  /// Test: zorunlu boş liste görünümü
  final isListEmpty = false.obs;

  final isCreateTicketDrawerOpen = false.obs;

  final dummyTickets = <TicketModel>[].obs;

  final _dateFmt = DateFormat('dd.MM.yyyy');

  List<String> get statusFilterOptions =>
      const [kAllStatuses, 'Açık', 'Kapalı', 'Beklemede'];

  List<String> get assigneeFilterOptions =>
      const [kAllAssignees, assignee1, assignee2];

  List<TicketModel> get filteredTickets {
    Iterable<TicketModel> list = dummyTickets;

    if (selectedStatus.value != kAllStatuses) {
      list = list.where((t) => t.status == selectedStatus.value);
    }
    if (selectedAssignee.value != kAllAssignees) {
      list = list.where((t) => t.assignedTo == selectedAssignee.value);
    }
    final d = selectedDate.value;
    if (d != null) {
      list = list.where((t) {
        return t.createdAt.year == d.year &&
            t.createdAt.month == d.month &&
            t.createdAt.day == d.day;
      });
    }

    return list.toList();
  }

  List<TicketModel> get displayTickets {
    if (isListEmpty.value) return [];
    return filteredTickets;
  }

  List<TicketModel> get activeTickets =>
      dummyTickets.where((t) => !t.isHidden).toList();

  List<TicketModel> get hiddenTickets =>
      dummyTickets.where((t) => t.isHidden).toList();

  @override
  void onInit() {
    super.onInit();
    _seedDummy();
  }

  void _seedDummy() {
    final now = DateTime.now();
    dummyTickets.assignAll([
      TicketModel(
        id: 'T-1001',
        ownerName: 'Mehmet Yılmaz',
        title: 'Poliçe yenileme teyidi',
        assignedTo: assignee1,
        urgency: 'Yüksek',
        status: 'Açık',
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      TicketModel(
        id: 'T-1002',
        ownerName: 'Ayşe Kaya',
        title: 'Hasar dosyası evrak eksikliği',
        assignedTo: assignee2,
        urgency: 'Orta',
        status: 'Beklemede',
        createdAt: now.subtract(const Duration(days: 1, hours: 3)),
      ),
      TicketModel(
        id: 'T-1003',
        ownerName: 'Can Öztürk',
        title: 'Prim iadesi sorgusu',
        assignedTo: assignee1,
        urgency: 'Düşük',
        status: 'Kapalı',
        createdAt: now.subtract(const Duration(days: 3)),
      ),
    ]);
  }

  void openCreateTicketDrawer() {
    isCreateTicketDrawerOpen.value = true;
  }

  void closeCreateTicketDrawer() {
    isCreateTicketDrawerOpen.value = false;
  }

  void setSelectedDate(DateTime? d) {
    selectedDate.value = d;
    dummyTickets.refresh();
  }

  void clearDateFilter() {
    selectedDate.value = null;
    dummyTickets.refresh();
  }

  String formatDate(DateTime d) => _dateFmt.format(d);

  void onEditTicket(TicketModel t) {
    Get.snackbar('Düzenle', t.title,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(12));
  }

  void onDeleteTicket(TicketModel t) {
    Get.dialog<void>(
      AlertDialog(
        title: const Text('Talebi sil'),
        content: Text('"${t.title}" silinsin mi?'),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('İptal')),
          TextButton(
            onPressed: () {
              dummyTickets.removeWhere((x) => x.id == t.id);
              Get.back();
              Get.snackbar('Silindi', t.id,
                  snackPosition: SnackPosition.BOTTOM,
                  margin: const EdgeInsets.all(12));
            },
            child: Text('Sil', style: TextStyle(color: Colors.red.shade700)),
          ),
        ],
      ),
    );
  }

  void addTicketFromForm({
    required String title,
    required String ownerName,
    required String assignedTo,
    required String urgency,
    String status = 'Açık',
  }) {
    final id = 'T-${DateTime.now().millisecondsSinceEpoch}';
    dummyTickets.insert(
      0,
      TicketModel(
        id: id,
        ownerName: ownerName,
        title: title,
        assignedTo: assignedTo,
        urgency: urgency,
        status: status,
        createdAt: DateTime.now(),
      ),
    );
    closeCreateTicketDrawer();
    isListEmpty.value = false;
    Get.snackbar('Talep oluşturuldu', title,
        snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(12));
  }
}
