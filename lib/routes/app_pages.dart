import 'package:get/get.dart';
import '../app/modules/customers/bindings/customers_binding.dart';
import '../app/modules/customers/views/customers_view.dart';
import '../app/modules/home/bindings/home_binding.dart';
import '../app/modules/policies/bindings/policies_binding.dart';
import '../app/modules/policies/views/policies_view.dart';
import '../app/modules/tickets/bindings/tickets_binding.dart';
import '../app/modules/tickets/views/tickets_view.dart';
import '../app/modules/users/bindings/users_binding.dart';
import '../app/modules/users/views/users_view.dart';
import '../app/modules/settings/bindings/settings_binding.dart';
import '../app/modules/settings/views/settings_view.dart';
import '../app/modules/home/views/home_view.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = AppRoutes.home;

  static final routes = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.customers,
      page: () => const CustomersView(),
      binding: CustomersBinding(),
    ),
    GetPage(
      name: AppRoutes.policies,
      page: () => const PoliciesView(),
      binding: PoliciesBinding(),
    ),
    GetPage(
      name: AppRoutes.claims,
      page: () => const TicketsView(),
      binding: TicketsBinding(),
    ),
    GetPage(
      name: AppRoutes.users,
      page: () => const UsersView(),
      binding: UsersBinding(),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
  ];
}
