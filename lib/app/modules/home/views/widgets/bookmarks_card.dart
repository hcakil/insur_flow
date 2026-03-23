import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../controllers/home_controller.dart';
import 'dashboard_card.dart';

class BookmarksCard extends GetView<HomeController> {
  const BookmarksCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      title: 'Sık Kullanılanlar',
      padding: EdgeInsets.zero,
      child: Obx(() {
        if (controller.bookmarks.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Text('Sık kullanılan bulunmuyor',
                  style: AppTextStyles.bodySecondary),
            ),
          );
        }

        return Column(
          children: controller.bookmarks
              .map((bm) => _BookmarkTile(title: bm.title, url: bm.url))
              .toList(),
        );
      }),
    );
  }
}

class _BookmarkTile extends StatelessWidget {
  final String title;
  final String url;

  const _BookmarkTile({required this.title, required this.url});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.divider.withValues(alpha: 0.5),
            ),
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.star_rounded,
                color: AppColors.starYellow, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(title, style: AppTextStyles.body),
            ),
            const Icon(Icons.open_in_new,
                color: AppColors.textSecondary, size: 16),
          ],
        ),
      ),
    );
  }
}
