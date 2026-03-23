import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../data/models/user_model.dart';
import '../../controllers/users_controller.dart';

class UserTableWidget extends StatefulWidget {
  const UserTableWidget({super.key});

  @override
  State<UserTableWidget> createState() => _UserTableWidgetState();
}

class _UserTableWidgetState extends State<UserTableWidget> {
  static final _dateFmt = DateFormat('dd.MM.yyyy');

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
    final usersController = Get.find<UsersController>();
    return Obx(() {
      final rows = usersController.users;

      return Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.divider),
        ),
        clipBehavior: Clip.antiAlias,
        child: Scrollbar(
          controller: _horizontalScroll,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: _horizontalScroll,
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              controller: _verticalScroll,
              child: DataTable(
                headingRowColor:
                    WidgetStateProperty.all(const Color(0xFFFAFAFA)),
                dataRowMinHeight: 52,
                dataRowMaxHeight: 64,
                horizontalMargin: 16,
                columnSpacing: 20,
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
                columns: const [
                  DataColumn(label: Text('İsim Soyisim')),
                  DataColumn(label: Text('E-posta')),
                  DataColumn(label: Text('Rol')),
                  DataColumn(label: Text('Durum')),
                  DataColumn(label: Text('Oluşturulma')),
                  DataColumn(label: Text('İşlemler')),
                ],
                rows: rows.map(_buildRow).toList(),
              ),
            ),
          ),
        ),
      );
    });
  }

  DataRow _buildRow(UserModel u) {
    return DataRow(
      cells: [
        DataCell(Text(u.fullName, style: AppTextStyles.body)),
        DataCell(Text(u.email, style: AppTextStyles.caption)),
        DataCell(_rolePill(u.role)),
        DataCell(_statusPill(u.status)),
        DataCell(Text(
          _dateFmt.format(u.createdAt),
          style: AppTextStyles.caption,
        )),
        DataCell(_UserRowActions(u)),
      ],
    );
  }

  Widget _rolePill(String role) {
    final isAdmin = role == UsersController.roleAdmin;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isAdmin ? AppColors.active : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        role,
        style: AppTextStyles.caption.copyWith(
          color: isAdmin ? AppColors.white : AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _statusPill(String status) {
    final passive = status == 'Pasif';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: passive
              ? AppColors.textSecondary.withValues(alpha: 0.35)
              : AppColors.divider,
        ),
      ),
      child: Text(
        status,
        style: AppTextStyles.caption.copyWith(
          color: passive ? AppColors.textSecondary : AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _UserRowActions extends GetView<UsersController> {
  final UserModel user;
  const _UserRowActions(this.user);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: 'Düzenle',
          onPressed: () => controller.openUserFormDrawer(user),
          icon: const Icon(Icons.edit_outlined, size: 20),
          color: AppColors.textPrimary,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
        ),
        IconButton(
          tooltip: 'Şifre sıfırla',
          onPressed: () => controller.onResetPassword(user),
          icon: const Icon(Icons.vpn_key_outlined, size: 20),
          color: AppColors.textPrimary,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
        ),
        IconButton(
          tooltip: 'Pasife al',
          onPressed: () => controller.onDeactivate(user),
          icon: const Icon(Icons.visibility_off_outlined, size: 20),
          color: AppColors.textPrimary,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
        ),
        const SizedBox(width: 4),
        Material(
          color: Colors.red.shade600,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: () => controller.deleteUser(user),
            borderRadius: BorderRadius.circular(8),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.delete_outline, color: Colors.white, size: 18),
            ),
          ),
        ),
      ],
    );
  }
}
