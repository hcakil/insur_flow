import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/layout/top_nav_bar.dart';
import '../controllers/customers_controller.dart';
import 'widgets/add_policy_side_panel.dart';
import 'widgets/customer_detail_panel_widget.dart';
import 'widgets/customer_form_side_panel.dart';
import 'widgets/customer_list_widget.dart';

class CustomersView extends GetView<CustomersController> {
  const CustomersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: const TopNavBar(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 900;
              if (wide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const [
                    Expanded(
                      flex: 3,
                      child: CustomerListWidget(),
                    ),
                    Expanded(
                      flex: 7,
                      child: CustomerDetailPanelWidget(),
                    ),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [
                  Expanded(
                    flex: 2,
                    child: CustomerListWidget(),
                  ),
                  Expanded(
                    flex: 3,
                    child: CustomerDetailPanelWidget(),
                  ),
                ],
              );
            },
          ),
          const AddPolicySidePanel(),
          const CustomerFormSidePanel(),
        ],
      ),
    );
  }
}
