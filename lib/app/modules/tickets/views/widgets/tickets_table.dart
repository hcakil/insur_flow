import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../data/models/ticket_model.dart';
import '../../controllers/tickets_controller.dart';

class TicketsTable extends StatefulWidget {
  const TicketsTable({super.key});

  @override
  State<TicketsTable> createState() => _TicketsTableState();
}

class _TicketsTableState extends State<TicketsTable> {
  static final _dateTimeFmt = DateFormat('dd.MM.yyyy HH:mm');

  static const _columns = [
    DataColumn(label: Text('Talep Sahibi')),
    DataColumn(label: Text('Başlık')),
    DataColumn(label: Text('Atanan')),
    DataColumn(label: Text('Aciliyet')),
    DataColumn(label: Text('Durum')),
    DataColumn(label: Text('Oluşturulma Tarihi')),
    DataColumn(label: Text('İşlemler')),
  ];

  final ScrollController _horizontalScroll = ScrollController();
  final ScrollController _verticalScroll = ScrollController();

  @override
  void dispose() {
    _horizontalScroll.dispose();
    _verticalScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ticketsController = Get.find<TicketsController>();
    return Obx(() {
      final rows = ticketsController.displayTickets;
      final empty = rows.isEmpty;

      Widget tableCore({required List<DataRow> dataRows}) {
        return DataTable(
          headingRowColor: WidgetStateProperty.all(const Color(0xFFFAFAFA)),
          dataRowMinHeight: 52,
          dataRowMaxHeight: 72,
          horizontalMargin: 16,
          columnSpacing: 18,
          headingTextStyle: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            fontSize: 12,
          ),
          border: TableBorder(
            horizontalInside: BorderSide(
              color: AppColors.divider.withValues(alpha: 0.85),
              width: 0.8,
            ),
          ),
          columns: _columns,
          rows: dataRows,
        );
      }

      return Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.divider),
        ),
        clipBehavior: Clip.antiAlias,
        child: empty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Scrollbar(
                    controller: _horizontalScroll,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: _horizontalScroll,
                      scrollDirection: Axis.horizontal,
                      child: tableCore(dataRows: const []),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Talep bulunamadı.',
                        style: AppTextStyles.bodySecondary.copyWith(
                          fontSize: 15,
                          color:
                              AppColors.textSecondary.withValues(alpha: 0.85),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Scrollbar(
                controller: _horizontalScroll,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _horizontalScroll,
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    controller: _verticalScroll,
                    child: tableCore(
                      dataRows: rows.map(_buildRow).toList(),
                    ),
                  ),
                ),
              ),
      );
    });
  }

  DataRow _buildRow(TicketModel t) {
    return DataRow(
      cells: [
        DataCell(Text(t.ownerName, style: AppTextStyles.body)),
        DataCell(
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 240),
            child: Text(
              t.title,
              style: AppTextStyles.body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        DataCell(Text(t.assignedTo, style: AppTextStyles.caption)),
        DataCell(_urgencyPill(t.urgency)),
        DataCell(Text(t.status, style: AppTextStyles.caption)),
        DataCell(Text(
          _dateTimeFmt.format(t.createdAt),
          style: AppTextStyles.caption,
        )),
        DataCell(_RowActionsMenu(t)),
      ],
    );
  }

  Widget _urgencyPill(String urgency) {
    late Color bg;
    late Color fg;
    switch (urgency) {
      case 'Yüksek':
        bg = const Color(0xFFFEE2E2);
        fg = const Color(0xFFB91C1C);
        break;
      case 'Orta':
        bg = const Color(0xFFFEF3C7);
        fg = const Color(0xFFB45309);
        break;
      default:
        bg = const Color(0xFFF3F4F6);
        fg = const Color(0xFF374151);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        urgency,
        style: AppTextStyles.caption.copyWith(
          color: fg,
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }
}

class _RowActionsMenu extends GetView<TicketsController> {
  final TicketModel ticket;
  const _RowActionsMenu(this.ticket);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
      onSelected: (v) {
        switch (v) {
          case 'edit':
            controller.onEditTicket(ticket);
            break;
          case 'delete':
            controller.onDeleteTicket(ticket);
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit_outlined, size: 18),
              SizedBox(width: 8),
              Text('Düzenle'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline, size: 18, color: Colors.red),
              SizedBox(width: 8),
              Text('Sil', style: TextStyle(color: Colors.red.shade700)),
            ],
          ),
        ),
      ],
    );
  }
}
