import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../data/models/file_model.dart';

final _fileDateFmt = DateFormat('dd.MM.yyyy');

/// Mus-9 — Poliçe dosyaları modalı (controller’a bağımlı değil; döngüsel import yok)
class PolicyFilesDialog extends StatefulWidget {
  final String policyNo;
  final List<FileModel> files;

  const PolicyFilesDialog({
    super.key,
    required this.policyNo,
    required this.files,
  });

  @override
  State<PolicyFilesDialog> createState() => _PolicyFilesDialogState();
}

class _PolicyFilesDialogState extends State<PolicyFilesDialog> {
  String _category = 'police';

  Map<String, int> get _counts {
    var pol = 0, zey = 0, mak = 0;
    for (final f in widget.files) {
      switch (f.category) {
        case 'police':
          pol++;
          break;
        case 'zeyil':
          zey++;
          break;
        case 'makbuz':
          mak++;
          break;
      }
    }
    return {'police': pol, 'zeyil': zey, 'makbuz': mak};
  }

  List<FileModel> get _filtered =>
      widget.files.where((f) => f.category == _category).toList();

  @override
  Widget build(BuildContext context) {
    final maxW = min(560.0, MediaQuery.sizeOf(context).width - 40);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxW, maxHeight: MediaQuery.sizeOf(context).height * 0.78),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 8, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Poliçe Dosyaları',
                          style: AppTextStyles.heading.copyWith(fontSize: 18),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Poliçe No: ${widget.policyNo}',
                          style: AppTextStyles.caption.copyWith(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: Get.back,
                    icon: const Icon(Icons.close, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _FilterPill(
                            label: 'Poliçe',
                            count: _counts['police'] ?? 0,
                            selected: _category == 'police',
                            onTap: () => setState(() => _category = 'police'),
                          ),
                          const SizedBox(width: 8),
                          _FilterPill(
                            label: 'Zeyil',
                            count: _counts['zeyil'] ?? 0,
                            selected: _category == 'zeyil',
                            onTap: () => setState(() => _category = 'zeyil'),
                          ),
                          const SizedBox(width: 8),
                          _FilterPill(
                            label: 'Makbuz',
                            count: _counts['makbuz'] ?? 0,
                            selected: _category == 'makbuz',
                            onTap: () => setState(() => _category = 'makbuz'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Material(
                    color: AppColors.active,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => Get.snackbar('Yükle', 'Dosya yükleme yakında.'),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.upload, color: Colors.white, size: 18),
                            const SizedBox(width: 6),
                            Text('Yükle', style: AppTextStyles.button.copyWith(fontSize: 13)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: _filtered.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                      child: Center(
                        child: Text(
                          'Bu kategoride dosya yok',
                          style: AppTextStyles.bodySecondary,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                      itemCount: _filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) => _FileRow(file: _filtered[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  const _FilterPill({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? AppColors.active : AppColors.divider,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '$count',
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FileRow extends StatelessWidget {
  final FileModel file;

  const _FileRow({required this.file});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.picture_as_pdf, color: Colors.red.shade700, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.name,
                  style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${file.sizeLabel} • ${_fileDateFmt.format(file.date)}',
                  style: AppTextStyles.caption.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  file.badgeLabel,
                  style: AppTextStyles.caption.copyWith(
                    color: const Color(0xFF0369A1),
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    icon: const Icon(Icons.download_outlined, size: 20, color: AppColors.textSecondary),
                    onPressed: () => Get.snackbar('İndir', file.name),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    icon: Icon(Icons.delete_outline, size: 20, color: Colors.red.shade600),
                    onPressed: () => Get.snackbar('Sil', file.name),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
