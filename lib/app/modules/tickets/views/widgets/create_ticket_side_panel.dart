import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../controllers/tickets_controller.dart';

/// Ana Sayfa ve Talepler ekranından tetiklenen sağdan açılan "Talep Oluştur" paneli.
class CreateTicketSidePanel extends GetView<TicketsController> {
  const CreateTicketSidePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.isCreateTicketDrawerOpen.value) {
        return const SizedBox.shrink();
      }
      final w = MediaQuery.sizeOf(context).width;
      final panelW = min(480.0, w);

      return Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: controller.closeCreateTicketDrawer,
              child: Container(color: Colors.black.withValues(alpha: 0.35)),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: panelW,
            child: Material(
              color: AppColors.card,
              elevation: 16,
              child: const _CreateTicketForm(),
            ),
          ),
        ],
      );
    });
  }
}

class _CreateTicketForm extends StatefulWidget {
  const _CreateTicketForm();

  @override
  State<_CreateTicketForm> createState() => _CreateTicketFormState();
}

class _CreateTicketFormState extends State<_CreateTicketForm> {
  final _titleCtrl = TextEditingController();
  final _ownerCtrl = TextEditingController();
  String _assigned = TicketsController.assignee1;
  String _urgency = 'Orta';

  static const _border = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(color: Color(0xFFE5E7EB)),
  );

  @override
  void dispose() {
    _titleCtrl.dispose();
    _ownerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<TicketsController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Talep Oluştur',
                  style: AppTextStyles.heading.copyWith(fontSize: 18),
                ),
              ),
              IconButton(
                onPressed: c.closeCreateTicketDrawer,
                icon: const Icon(Icons.close, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Başlık', style: AppTextStyles.caption),
                const SizedBox(height: 6),
                TextField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(
                    hintText: 'Kısa başlık',
                    filled: true,
                    fillColor: Color(0xFFFAFAFA),
                    border: _border,
                    enabledBorder: _border,
                    focusedBorder: _border,
                  ),
                ),
                const SizedBox(height: 16),
                Text('Talep Sahibi', style: AppTextStyles.caption),
                const SizedBox(height: 6),
                TextField(
                  controller: _ownerCtrl,
                  decoration: const InputDecoration(
                    hintText: 'Ad Soyad',
                    filled: true,
                    fillColor: Color(0xFFFAFAFA),
                    border: _border,
                    enabledBorder: _border,
                    focusedBorder: _border,
                  ),
                ),
                const SizedBox(height: 16),
                Text('Atanan', style: AppTextStyles.caption),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: _assigned,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFFAFAFA),
                    border: _border,
                    enabledBorder: _border,
                    focusedBorder: _border,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: [
                    TicketsController.assignee1,
                    TicketsController.assignee2,
                  ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => setState(() => _assigned = v ?? _assigned),
                ),
                const SizedBox(height: 16),
                Text('Aciliyet', style: AppTextStyles.caption),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: _urgency,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFFAFAFA),
                    border: _border,
                    enabledBorder: _border,
                    focusedBorder: _border,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: const ['Yüksek', 'Orta', 'Düşük']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => _urgency = v ?? _urgency),
                ),
              ],
            ),
          ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: c.closeCreateTicketDrawer,
                child: Text(
                  'İptal',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.active,
                  foregroundColor: AppColors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onPressed: () {
                  final title = _titleCtrl.text.trim();
                  final owner = _ownerCtrl.text.trim();
                  if (title.isEmpty || owner.isEmpty) {
                    Get.snackbar(
                      'Eksik bilgi',
                      'Başlık ve talep sahibi zorunludur.',
                      snackPosition: SnackPosition.BOTTOM,
                      margin: const EdgeInsets.all(12),
                    );
                    return;
                  }
                  c.addTicketFromForm(
                    title: title,
                    ownerName: owner,
                    assignedTo: _assigned,
                    urgency: _urgency,
                  );
                  _titleCtrl.clear();
                  _ownerCtrl.clear();
                },
                child: const Text('Oluştur'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
