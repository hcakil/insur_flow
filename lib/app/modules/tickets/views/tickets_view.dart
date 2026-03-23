import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/layout/top_nav_bar.dart';
import '../controllers/tickets_controller.dart';
import 'widgets/create_ticket_side_panel.dart';
import 'widgets/tickets_actions_filters_row.dart';
import 'widgets/tickets_table.dart';

class TicketsView extends GetView<TicketsController> {
  const TicketsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const TopNavBar(),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.sizeOf(context).width > 1100 ? 40 : 20,
                vertical: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LayoutBuilder(
                    builder: (context, c) {
                      final wide = c.maxWidth > 800;
                      if (wide) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: _titleBlock(context),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 3,
                              child: const TicketsActionsFiltersRow(),
                            ),
                          ],
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _titleBlock(context),
                          const SizedBox(height: 16),
                          const TicketsActionsFiltersRow(),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  Obx(() {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Boş liste (test)',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Switch(
                          value: controller.isListEmpty.value,
                          onChanged: (v) =>
                              controller.isListEmpty.value = v,
                        ),
                      ],
                    );
                  }),
                  const SizedBox(height: 16),
                  const Expanded(child: TicketsTable()),
                ],
              ),
            ),
          ),
          const CreateTicketSidePanel(),
        ],
      ),
    );
  }

  Widget _titleBlock(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Talepler',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                fontSize: 26,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          'Tüm destek taleplerini yönetin.',
          style: AppTextStyles.bodySecondary.copyWith(
            fontSize: 14,
            color: AppColors.textSecondary.withValues(alpha: 0.95),
          ),
        ),
      ],
    );
  }
}
