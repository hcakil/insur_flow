import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../data/models/bookmark_model.dart';
import '../../controllers/settings_controller.dart';

class BookmarksSettingsTabPanel extends GetView<SettingsController> {
  const BookmarksSettingsTabPanel({super.key});

  static const _fieldBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(color: Color(0xFFE5E7EB)),
  );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 900;
        final form = _buildForm();
        final table = const _BookmarksTable();

        if (narrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              form,
              const SizedBox(height: 20),
              SizedBox(height: 320, child: table),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 3, child: form),
            const SizedBox(width: 24),
            Expanded(flex: 7, child: table),
          ],
        );
      },
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Yeni Ekle',
          style: AppTextStyles.heading.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Ad',
          style: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller.bookmarkTitleController,
          decoration: const InputDecoration(
            hintText: 'Örn: Google',
            filled: true,
            fillColor: AppColors.white,
            border: _fieldBorder,
            enabledBorder: _fieldBorder,
            focusedBorder: _fieldBorder,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Link (URL)',
          style: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller.bookmarkUrlController,
          decoration: const InputDecoration(
            hintText: 'Örn: https://...',
            filled: true,
            fillColor: AppColors.white,
            border: _fieldBorder,
            enabledBorder: _fieldBorder,
            focusedBorder: _fieldBorder,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.active,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: controller.addSettingsBookmark,
            child: const Text('Ekle'),
          ),
        ),
      ],
    );
  }
}

class _BookmarksTable extends GetView<SettingsController> {
  const _BookmarksTable();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final list = controller.settingsBookmarks;
      return Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  const SizedBox(width: 22),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Ad',
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Link',
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 72),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.separated(
                itemCount: list.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, indent: 8, endIndent: 8),
                itemBuilder: (_, i) => _BookmarkRow(list[i]),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _BookmarkRow extends GetView<SettingsController> {
  final BookmarkModel b;
  const _BookmarkRow(this.b);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.drag_indicator,
              color: AppColors.textSecondary, size: 20),
          const SizedBox(width: 4),
          Expanded(
            flex: 2,
            child: Text(b.title, style: AppTextStyles.body),
          ),
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: () => controller.openBookmarkUrl(b.url),
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      b.url,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.accentBlue,
                        decoration: TextDecoration.underline,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.open_in_new,
                    size: 16,
                    color: AppColors.accentBlue,
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            tooltip: 'Düzenle',
            onPressed: () => controller.editSettingsBookmark(b),
            icon: const Icon(Icons.edit_outlined, size: 18),
            color: AppColors.textSecondary,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
          IconButton(
            tooltip: 'Sil',
            onPressed: () => controller.deleteSettingsBookmark(b),
            icon: Icon(Icons.delete_outline, size: 18, color: Colors.red.shade600),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }
}
