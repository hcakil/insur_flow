import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../data/models/cross_sell_model.dart';
import '../../controllers/home_controller.dart';
import 'dashboard_card.dart';

class CrossSellCard extends GetView<HomeController> {
  const CrossSellCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      title: 'Günlük Akıllı Öneri (Cross-Sell)',
      border: Border.all(
        color: AppColors.accentBlue.withValues(alpha: 0.3),
        width: 1.5,
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.accentBlue.withValues(alpha: 0.1),
              AppColors.accent.withValues(alpha: 0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome,
                size: 14, color: AppColors.accentBlue),
            const SizedBox(width: 4),
            Text(
              'AI Destekli',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.accentBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      padding: EdgeInsets.zero,
      child: Obx(() {
        if (controller.crossSellItems.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Text('Öneri bulunmuyor',
                  style: AppTextStyles.bodySecondary),
            ),
          );
        }

        return Column(
          children: controller.crossSellItems
              .map((item) => _CrossSellTile(item: item))
              .toList(),
        );
      }),
    );
  }
}

class _CrossSellTile extends StatelessWidget {
  final CrossSellModel item;
  const _CrossSellTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.divider.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        _buildAvatar(),
        const SizedBox(width: 12),
        Expanded(child: _buildInfo()),
        const SizedBox(width: 12),
        _buildProbabilityBadge(),
        const SizedBox(width: 12),
        _buildActionButton(),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildAvatar(),
            const SizedBox(width: 12),
            Expanded(child: _buildInfo()),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildProbabilityBadge(),
            const Spacer(),
            _buildActionButton(),
          ],
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.accentBlue, AppColors.accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Text(
        item.customerName.split(' ').map((w) => w[0]).take(2).join(),
        style: AppTextStyles.caption.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(item.customerName,
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500)),
        const SizedBox(height: 2),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                  text: '${item.existingPolicy} var, ',
                  style: AppTextStyles.caption),
              TextSpan(
                text: '${item.recommendedPolicy} Satılabilir',
                style: AppTextStyles.caption
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProbabilityBadge() {
    final color =
        item.successProbability >= 80 ? AppColors.accent : AppColors.accentBlue;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '%${item.successProbability} İhtimal',
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return Material(
      color: AppColors.active,
      shape: const StadiumBorder(),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          child: Text(item.actionText, style: AppTextStyles.button),
        ),
      ),
    );
  }
}
