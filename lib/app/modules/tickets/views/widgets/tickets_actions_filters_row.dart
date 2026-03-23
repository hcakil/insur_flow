import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../controllers/tickets_controller.dart';

/// Sağ üst: Yeni Talep + filtreler + tarih.
class TicketsActionsFiltersRow extends GetView<TicketsController> {
  const TicketsActionsFiltersRow({super.key});

  static const _border = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(color: Color(0xFFE5E7EB)),
  );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final narrow = c.maxWidth < 900;
        if (narrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _newTicketButton(),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _statusDropdown()),
                  const SizedBox(width: 10),
                  Expanded(child: _assigneeDropdown()),
                ],
              ),
              const SizedBox(height: 10),
              _dateField(context),
            ],
          );
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _newTicketButton(),
            const SizedBox(width: 10),
            SizedBox(width: 160, child: _statusDropdown()),
            const SizedBox(width: 10),
            SizedBox(width: 160, child: _assigneeDropdown()),
            const SizedBox(width: 10),
            SizedBox(width: 150, child: _dateField(context)),
          ],
        );
      },
    );
  }

  Widget _newTicketButton() {
    return FilledButton.icon(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.active,
        foregroundColor: AppColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: controller.openCreateTicketDrawer,
      icon: const Icon(Icons.add, size: 18),
      label: const Text('Yeni Talep'),
    );
  }

  Widget _statusDropdown() {
    return Obx(() {
      return DropdownButtonFormField<String>(
        value: controller.selectedStatus.value,
        decoration: const InputDecoration(
          filled: true,
          fillColor: AppColors.card,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          border: _border,
          enabledBorder: _border,
          focusedBorder: _border,
          isDense: true,
        ),
        items: controller.statusFilterOptions
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (v) {
          if (v != null) {
            controller.selectedStatus.value = v;
            controller.dummyTickets.refresh();
          }
        },
      );
    });
  }

  Widget _assigneeDropdown() {
    return Obx(() {
      return DropdownButtonFormField<String>(
        value: controller.selectedAssignee.value,
        decoration: const InputDecoration(
          filled: true,
          fillColor: AppColors.card,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          border: _border,
          enabledBorder: _border,
          focusedBorder: _border,
          isDense: true,
        ),
        items: controller.assigneeFilterOptions
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (v) {
          if (v != null) {
            controller.selectedAssignee.value = v;
            controller.dummyTickets.refresh();
          }
        },
      );
    });
  }

  Widget _dateField(BuildContext context) {
    return Obx(() {
      final d = controller.selectedDate.value;
      final label =
          d == null ? 'Tarih' : DateFormat('dd.MM.yyyy').format(d);
      return InkWell(
        onTap: () async {
          final now = DateTime.now();
          final picked = await showDatePicker(
            context: context,
            initialDate: d ?? now,
            firstDate: DateTime(now.year - 2),
            lastDate: DateTime(now.year + 2),
          );
          controller.setSelectedDate(picked);
        },
        borderRadius: BorderRadius.circular(8),
        child: InputDecorator(
          decoration: const InputDecoration(
            filled: true,
            fillColor: AppColors.card,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: _border,
            enabledBorder: _border,
            isDense: true,
          ),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 18,
                color: AppColors.textSecondary.withValues(alpha: 0.85),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.body.copyWith(
                    fontSize: 14,
                    color: d == null
                        ? AppColors.textSecondary
                        : AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (d != null)
                InkWell(
                  onTap: controller.clearDateFilter,
                  child: const Icon(Icons.close, size: 18),
                ),
            ],
          ),
        ),
      );
    });
  }
}
