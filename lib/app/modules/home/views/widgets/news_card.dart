import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../controllers/home_controller.dart';
import 'dashboard_card.dart';

class NewsCard extends GetView<HomeController> {
  const NewsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      title: 'TSB Haber',
      padding: EdgeInsets.zero,
      child: Obx(() {
        if (controller.news.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Text('Haber bulunmuyor',
                  style: AppTextStyles.bodySecondary),
            ),
          );
        }

        return Column(
          children: controller.news
              .map((n) => _NewsTile(title: n.title, date: n.date))
              .toList(),
        );
      }),
    );
  }
}

class _NewsTile extends StatelessWidget {
  final String title;
  final String date;

  const _NewsTile({required this.title, required this.date});

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
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.scaffold,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.article_outlined,
                  color: AppColors.textSecondary, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppTextStyles.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(date, style: AppTextStyles.caption),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.open_in_new,
                color: AppColors.textSecondary, size: 16),
          ],
        ),
      ),
    );
  }
}
