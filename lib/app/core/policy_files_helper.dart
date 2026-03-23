import 'package:get/get.dart';

import '../data/models/file_model.dart';
import '../modules/customers/views/widgets/policy_files_dialog.dart';

/// Poliçe dosyaları modalı — müşteri ve poliçeler modüllerinden ortak kullanım
abstract class PolicyFilesHelper {
  PolicyFilesHelper._();

  static List<FileModel> dummyFilesFor(String policyNo) {
    return [
      FileModel(
        name: 'RIZA DÜZCAN-TRAFIK-$policyNo.pdf',
        sizeLabel: '70.1 KB',
        date: DateTime(2026, 1, 3),
        badgeLabel: 'Poliçe',
        category: 'police',
      ),
      FileModel(
        name: 'MAKBUZ-${policyNo}_ÖDEME.pdf',
        sizeLabel: '28.4 KB',
        date: DateTime(2025, 12, 15),
        badgeLabel: 'Makbuz',
        category: 'makbuz',
      ),
    ];
  }

  static void showPolicyFilesDialog(String policyNo) {
    Get.dialog<void>(
      PolicyFilesDialog(
        policyNo: policyNo,
        files: dummyFilesFor(policyNo),
      ),
      barrierDismissible: true,
    );
  }
}
