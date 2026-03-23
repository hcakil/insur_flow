import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/layout/top_nav_bar.dart';
import '../../tickets/views/widgets/create_ticket_side_panel.dart';
import '../controllers/home_controller.dart';
import 'widgets/support_tickets_card.dart';
import 'widgets/upcoming_policies_card.dart';
import 'widgets/bookmarks_card.dart';
import 'widgets/announcements_card.dart';
import 'widgets/news_card.dart';
import 'widgets/cross_sell_card.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: const TopNavBar(),
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 900;
              final isMedium = constraints.maxWidth > 600;

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 32 : 16,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hoş geldiniz!',
                        style: AppTextStyles.heading.copyWith(fontSize: 24)),
                    const SizedBox(height: 4),
                    Text(
                      'İşte bugünkü genel durumunuz.',
                      style: AppTextStyles.bodySecondary,
                    ),
                    const SizedBox(height: 24),
                    if (isWide)
                      _buildWideLayout()
                    else if (isMedium)
                      _buildMediumLayout()
                    else
                      _buildNarrowLayout(),
                  ],
                ),
              );
            },
          ),
          const CreateTicketSidePanel(),
        ],
      ),
    );
  }

  Widget _buildWideLayout() {
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(child: SupportTicketsCard()),
              const SizedBox(width: 20),
              const Expanded(child: UpcomingPoliciesCard()),
              const SizedBox(width: 20),
              const Expanded(child: BookmarksCard()),
            ],
          ),
        ),
        const SizedBox(height: 20),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(child: AnnouncementsCard()),
              const SizedBox(width: 20),
              const Expanded(child: NewsCard()),
              const SizedBox(width: 20),
              const Expanded(child: CrossSellCard()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMediumLayout() {
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(child: SupportTicketsCard()),
              const SizedBox(width: 16),
              const Expanded(child: UpcomingPoliciesCard()),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const BookmarksCard(),
        const SizedBox(height: 16),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(child: AnnouncementsCard()),
              const SizedBox(width: 16),
              const Expanded(child: NewsCard()),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const CrossSellCard(),
      ],
    );
  }

  Widget _buildNarrowLayout() {
    return const Column(
      children: [
        SupportTicketsCard(),
        SizedBox(height: 16),
        UpcomingPoliciesCard(),
        SizedBox(height: 16),
        BookmarksCard(),
        SizedBox(height: 16),
        AnnouncementsCard(),
        SizedBox(height: 16),
        NewsCard(),
        SizedBox(height: 16),
        CrossSellCard(),
      ],
    );
  }
}
