import 'package:get/get.dart';
import '../controllers/policies_controller.dart';

class PoliciesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PoliciesController>(() => PoliciesController());
  }
}
