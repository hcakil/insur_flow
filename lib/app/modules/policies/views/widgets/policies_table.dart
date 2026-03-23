import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../data/models/policy_model.dart';
import '../../controllers/policies_controller.dart';

class PoliciesTable extends StatefulWidget {
  const PoliciesTable({super.key});

  @override
  State<PoliciesTable> createState() => _PoliciesTableState();
}

class _PoliciesTableState extends State<PoliciesTable> {
  static final _dateFmt = DateFormat('dd.MM.yyyy');
  static final _moneyFmt = NumberFormat.decimalPattern('tr_TR');

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
    final policiesController = Get.find<PoliciesController>();
    return Obx(() {
      final rows = policiesController.filteredPolicies;
      if (rows.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(48),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.divider),
          ),
          child: Center(
            child: Text(
              'Filtrelere uygun poliçe bulunamadı',
              style: AppTextStyles.bodySecondary,
            ),
          ),
        );
      }

      return Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Scrollbar(
                controller: _horizontalScroll,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _horizontalScroll,
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: SingleChildScrollView(
                      controller: _verticalScroll,
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(
                          const Color(0xFFF9FAFB),
                        ),
                        dataRowMinHeight: 48,
                        dataRowMaxHeight: 64,
                        horizontalMargin: 16,
                        columnSpacing: 18,
                        headingTextStyle: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          fontSize: 12,
                        ),
                        border: TableBorder(
                          horizontalInside: BorderSide(
                            color: AppColors.divider.withValues(alpha: 0.7),
                            width: 0.8,
                          ),
                        ),
                        columns: const [
                          DataColumn(label: Text('Durum')),
                          DataColumn(label: Text('Müşteri')),
                          DataColumn(label: Text('Şirket')),
                          DataColumn(label: Text('Poliçe Tipi')),
                          DataColumn(label: Text('Poliçe No')),
                          DataColumn(label: Text('Başlangıç')),
                          DataColumn(label: Text('Bitiş')),
                          DataColumn(label: Text('Net Prim')),
                          DataColumn(label: Text('İşlemler')),
                        ],
                        rows: rows.map(_buildRow).toList(),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }

  DataRow _buildRow(PolicyModel p) {
    return DataRow(
      cells: [
        DataCell(_statusPill(p.status)),
        DataCell(Text(p.customerName ?? '—', style: AppTextStyles.body)),
        DataCell(_greyPill(p.company)),
        DataCell(_greyPill(p.type)),
        DataCell(Text(p.policyNumber, style: AppTextStyles.caption)),
        DataCell(Text(_dateFmt.format(p.startDate), style: AppTextStyles.caption)),
        DataCell(Text(_dateFmt.format(p.endDate), style: AppTextStyles.caption)),
        DataCell(Text(
          '${_moneyFmt.format(p.netPremium)} ${p.currency}',
          style: AppTextStyles.body,
        )),
        DataCell(_PolicyActionsMenu(policy: p)),
      ],
    );
  }

  Widget _statusPill(String status) {
    final isActive = status == 'Aktif';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFD1FAE5) : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: AppTextStyles.caption.copyWith(
          color: isActive ? const Color(0xFF065F46) : AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _greyPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _PolicyActionsMenu extends GetView<PoliciesController> {
  final PolicyModel policy;

  const _PolicyActionsMenu({required this.policy});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'İşlemler',
      padding: EdgeInsets.zero,
      icon: const Icon(Icons.more_vert, color: AppColors.textSecondary, size: 22),
      offset: const Offset(0, 36),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onSelected: (value) {
        switch (value) {
          case 'edit':
            controller.onPolicyEdit(policy);
            break;
          case 'renew':
            controller.onPolicyRenew(policy);
            break;
          case 'norenew':
            controller.onPolicyNoRenew(policy);
            break;
          case 'cancel':
            controller.onPolicyCancel(policy);
            break;
          case 'files':
            controller.showPolicyFilesDialog(policy.policyNumber);
            break;
          case 'delete':
            controller.onPolicyDelete(policy);
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit_outlined, size: 18, color: AppColors.textPrimary),
              SizedBox(width: 10),
              Text('Düzenle'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'renew',
          child: Row(
            children: [
              Icon(Icons.autorenew, size: 18, color: AppColors.textPrimary),
              SizedBox(width: 10),
              Text('Yenile'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'norenew',
          child: Row(
            children: [
              Icon(Icons.block, size: 18, color: AppColors.textPrimary),
              SizedBox(width: 10),
              Text('Yenilenmeyecek'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'cancel',
          child: Row(
            children: [
              Icon(Icons.cancel_outlined, size: 18, color: AppColors.textPrimary),
              SizedBox(width: 10),
              Text('İptal Et'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'files',
          child: Row(
            children: [
              Icon(Icons.folder_outlined, size: 18, color: AppColors.textPrimary),
              SizedBox(width: 10),
              Text('Dosyalar'),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              const Icon(Icons.delete_outline, size: 18, color: Colors.red),
              const SizedBox(width: 10),
              Text(
                'Sil',
                style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
