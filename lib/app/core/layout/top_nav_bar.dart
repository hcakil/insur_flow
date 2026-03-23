import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../../../routes/app_routes.dart';

class TopNavBar extends StatelessWidget implements PreferredSizeWidget {
  const TopNavBar({super.key});

  static const _menuItems = [
    _MenuItem('Ana Sayfa', AppRoutes.home),
    _MenuItem('Müşteriler', AppRoutes.customers),
    _MenuItem('Poliçeler', AppRoutes.policies),
    _MenuItem('Talepler', AppRoutes.claims),
    _MenuItem('Kullanıcılar', AppRoutes.users),
    _MenuItem('Ayarlar', AppRoutes.settings),
  ];

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;

    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.card,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Text('InsurFlow', style: AppTextStyles.logo),
          const SizedBox(width: 40),
          if (isWide) ...[
            Expanded(
              child: Row(
                children: _menuItems
                    .map((item) => _NavButton(item: item))
                    .toList(),
              ),
            ),
          ] else ...[
            const Spacer(),
            PopupMenuButton<String>(
              icon: const Icon(Icons.menu, color: AppColors.textPrimary),
              onSelected: (route) {
                if (Get.currentRoute != route) {
                  Get.toNamed(route);
                }
              },
              itemBuilder: (_) => _menuItems
                  .map((item) => PopupMenuItem(
                        value: item.route,
                        child: Text(
                          item.label,
                          style: Get.currentRoute == item.route
                              ? AppTextStyles.body
                                  .copyWith(fontWeight: FontWeight.w600)
                              : AppTextStyles.bodySecondary,
                        ),
                      ))
                  .toList(),
            ),
          ],
          const _UserAvatar(),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final _MenuItem item;
  const _NavButton({required this.item});

  @override
  Widget build(BuildContext context) {
    final isActive = Get.currentRoute == item.route;

    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Material(
        color: isActive ? AppColors.active : Colors.transparent,
        shape: const StadiumBorder(),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: () {
            if (!isActive) {
              Get.toNamed(item.route);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              item.label,
              style: isActive
                  ? AppTextStyles.navActive
                  : AppTextStyles.navInactive,
            ),
          ),
        ),
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.activeDark,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        'RP',
        style: AppTextStyles.caption.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _MenuItem {
  final String label;
  final String route;
  const _MenuItem(this.label, this.route);
}
