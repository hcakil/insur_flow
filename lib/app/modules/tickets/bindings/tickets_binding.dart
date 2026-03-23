import 'package:get/get.dart';

import '../controllers/tickets_controller.dart';

/// [TicketsController] uygulama başında [main] içinde kalıcı kayıtlıdır.
class TicketsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<TicketsController>()) {
      Get.put(TicketsController(), permanent: true);
    }
  }
}
