import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../data/models/policy_model.dart';
import '../../controllers/customers_controller.dart';

class PolicyTableWidget extends GetWidget<CustomersController> {
  const PolicyTableWidget({super.key});

  static final _dateFmt = DateFormat('dd.MM.yyyy');

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final rows = controller.filteredPoliciesForTable;
      if (rows.isEmpty) {
        return Padding(
          padding: const EdgeInsets.all(48),
          child: Center(
            child: Text(
              'Bu filtrelere uygun poliçe yok',
              style: AppTextStyles.bodySecondary,
            ),
          ),
        );
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(
                    AppColors.scaffold,
                  ),
                  // Varsayılan dataRowMaxHeight (48) min'den küçük olamaz — Mus-9 menü satırları için yeterli alan
                  dataRowMinHeight: 48,
                  dataRowMaxHeight: 64,
                  columnSpacing: 16,
                  columns: const [
                    DataColumn(label: Text('Durum')),
                    DataColumn(label: Text('Şirket')),
                    DataColumn(label: Text('Poliçe Tipi')),
                    DataColumn(label: Text('Poliçe No')),
                    DataColumn(label: Text('Başlangıç')),
                    DataColumn(label: Text('Bitiş')),
                    DataColumn(label: Text('Net Prim')),
                    DataColumn(label: Text('İşlemler')),
                  ],
                  rows: rows.map((p) => _buildRow(p)).toList(),
                ),
              ),
            ),
          );
        },
      );
    });
  }

  DataRow _buildRow(PolicyModel p) {
    final days = controller.daysLeft(p);
    return DataRow(
      cells: [
        DataCell(_StatusChip(status: p.status, daysLeft: days)),
        DataCell(Text(p.company, style: AppTextStyles.body)),
        DataCell(Text(p.type, style: AppTextStyles.body)),
        DataCell(Text(p.policyNumber, style: AppTextStyles.caption)),
        DataCell(Text(_dateFmt.format(p.startDate), style: AppTextStyles.caption)),
        DataCell(Text(_dateFmt.format(p.endDate), style: AppTextStyles.caption)),
        DataCell(Text(
          '${_formatMoney(p.netPremium)} ${p.currency}',
          style: AppTextStyles.body,
        )),
        DataCell(_PolicyRowMenu(policy: p)),
      ],
    );
  }

  String _formatMoney(double v) {
    return NumberFormat.decimalPattern('tr_TR').format(v);
  }
}

class _PolicyRowMenu extends GetWidget<CustomersController> {
  final PolicyModel policy;

  const _PolicyRowMenu({required this.policy});

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
              Icon(Icons.delete_outline, size: 18, color: Colors.red),
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

class _StatusChip extends StatelessWidget {
  final String status;
  final int daysLeft;

  const _StatusChip({required this.status, required this.daysLeft});

  @override
  Widget build(BuildContext context) {
    final label = '$status · $daysLeft gün';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFD1FAE5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: const Color(0xFF065F46),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
