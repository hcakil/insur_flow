import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../controllers/customers_controller.dart';

/// Sağdan açılan poliçe ekleme paneli (≈600px).
class AddPolicySidePanel extends GetWidget<CustomersController> {
  const AddPolicySidePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.isPolicyDrawerOpen.value) {
        return const SizedBox.shrink();
      }
      final w = MediaQuery.sizeOf(context).width;
      final panelW = min(600.0, w);

      return Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: controller.closePolicyDrawer,
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
              child: const _AddPolicyForm(),
            ),
          ),
        ],
      );
    });
  }
}

class _AddPolicyForm extends GetWidget<CustomersController> {
  const _AddPolicyForm();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Yeni Poliçe',
                  style: AppTextStyles.heading.copyWith(fontSize: 18),
                ),
              ),
              IconButton(
                onPressed: controller.closePolicyDrawer,
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
                _OcrDropzone(),
                const SizedBox(height: 24),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final wide = constraints.maxWidth > 520;
                    if (wide) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 2, child: _RequiredFieldsColumn()),
                          const SizedBox(width: 16),
                          Expanded(flex: 2, child: _TrafficDetailsColumn()),
                          const SizedBox(width: 16),
                          Expanded(flex: 2, child: _NotesColumn()),
                        ],
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _RequiredFieldsColumn(),
                        const SizedBox(height: 16),
                        _TrafficDetailsColumn(),
                        const SizedBox(height: 16),
                        _NotesColumn(),
                      ],
                    );
                  },
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
                onPressed: controller.closePolicyDrawer,
                child: Text(
                  'İptal',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Material(
                color: AppColors.active,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: controller.savePolicy,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    child: Text('Kaydet', style: AppTextStyles.button),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OcrDropzone extends GetWidget<CustomersController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final loading = controller.isAnalyzingPdf.value;
      return GestureDetector(
        onTap: loading ? null : controller.simulatePdfUpload,
        child: Container(
          height: 140,
          decoration: BoxDecoration(
            color: const Color(0xFFF0F9FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: CustomPaint(
            painter: _DashedBorderPainter(
              color: const Color(0xFF93C5FD),
              strokeWidth: 1.5,
              dashWidth: 8,
              dashSpace: 5,
            ),
            child: loading
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 32,
                          height: 32,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Yapay Zeka PDF\'i Analiz Ediyor...',
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.accentBlue,
                          ),
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_upload_outlined,
                              size: 40, color: AppColors.accentBlue.withValues(alpha: 0.8)),
                          const SizedBox(width: 16),
                          Flexible(
                            child: Text(
                              'Eski poliçe PDF\'ini buraya sürükleyin veya yükleyin',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.bodySecondary.copyWith(height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      );
    });
  }
}

/// Kesik çizgi efekti (ek border ile birlikte görsel zenginlik)
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;

  _DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashSpace,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    const radius = 12.0;
    final r = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(radius),
    );
    final path = Path()..addRRect(r);
    final dashed = Path();
    for (final metric in path.computeMetrics()) {
      double d = 0;
      while (d < metric.length) {
        final next = min(d + dashWidth, metric.length);
        dashed.addPath(
          metric.extractPath(d, next),
          Offset.zero,
        );
        d = next + dashSpace;
      }
    }
    canvas.drawPath(dashed, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RequiredFieldsColumn extends GetWidget<CustomersController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Zorunlu Alanlar', style: AppTextStyles.subheading),
        const SizedBox(height: 12),
        Obx(() => DropdownButtonFormField<String>(
              value: controller.insuranceCompany.value,
              decoration: _inputDec('Sigorta Şirketi *'),
              items: CustomersController.insuranceCompanies
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) {
                if (v != null) controller.insuranceCompany.value = v;
              },
            )),
        const SizedBox(height: 12),
        Obx(() => DropdownButtonFormField<String>(
              value: controller.policyType.value,
              decoration: _inputDec('Poliçe Tipi *'),
              items: CustomersController.policyTypes
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) {
                if (v != null) controller.policyType.value = v;
              },
            )),
        const SizedBox(height: 12),
        TextField(
          controller: controller.policyNumberController,
          decoration: _inputDec('Poliçe Numarası *'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller.startDateController,
          decoration: _inputDec('Başlangıç Tarihi (GG.AA.YYYY) *'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller.endDateController,
          decoration: _inputDec('Bitiş Tarihi (GG.AA.YYYY) *'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller.netPremiumController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: _inputDec('Net Prim *'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller.currencyController,
          decoration: _inputDec('Para Birimi'),
        ),
      ],
    );
  }

  InputDecoration _inputDec(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }
}

class _TrafficDetailsColumn extends GetWidget<CustomersController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Trafik Sigortası Detayları', style: AppTextStyles.subheading),
        const SizedBox(height: 12),
        TextField(
          controller: controller.phoneController,
          decoration: _inputDec('İletişim Numarası'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller.plateController,
          decoration: _inputDec('Plaka'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller.tcController,
          decoration: _inputDec('TC Kimlik No'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller.brandController,
          decoration: _inputDec('Marka'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller.modelController,
          decoration: _inputDec('Model'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller.serialController,
          decoration: _inputDec('Ruhsat Seri No'),
        ),
      ],
    );
  }

  InputDecoration _inputDec(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }
}

class _NotesColumn extends GetWidget<CustomersController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Notlar', style: AppTextStyles.subheading),
        const SizedBox(height: 12),
        SizedBox(
          height: 240,
          child: TextField(
            controller: controller.notesController,
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            decoration: InputDecoration(
              alignLabelWithHint: true,
              hintText: 'Poliçe ile ilgili notlarınız...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
        ),
      ],
    );
  }
}
