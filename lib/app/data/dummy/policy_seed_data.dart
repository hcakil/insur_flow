import '../models/policy_model.dart';

/// Müşteriler ve Poliçeler modülleri için ortak dummy poliçe listesi
class PolicySeedData {
  PolicySeedData._();

  static List<PolicyModel> all(DateTime now) {
    return [
      PolicyModel(
        id: 'POL-C001-1',
        customerId: 'C001',
        customerName: 'Ahmet Yılmaz',
        status: 'Aktif',
        company: 'Unico Sigorta',
        type: 'Trafik Sigortası',
        policyNumber: 'UN-2025-TR-9912',
        startDate: now.subtract(const Duration(days: 120)),
        endDate: now.add(const Duration(days: 45)),
        netPremium: 4850,
        currency: 'TRY',
      ),
      PolicyModel(
        id: 'POL-C001-2',
        customerId: 'C001',
        customerName: 'Ahmet Yılmaz',
        status: 'Aktif',
        company: 'Anadolu Sigorta',
        type: 'Kasko',
        policyNumber: 'AN-2025-KSK-441',
        startDate: now.subtract(const Duration(days: 200)),
        endDate: now.add(const Duration(days: 18)),
        netPremium: 22400,
        currency: 'TRY',
      ),
      PolicyModel(
        id: 'POL-C002-1',
        customerId: 'C002',
        customerName: 'Elif Demir',
        status: 'Aktif',
        company: 'Sompo Sigorta',
        type: 'DASK',
        policyNumber: 'SM-2024-DSK-220',
        startDate: now.subtract(const Duration(days: 400)),
        endDate: now.add(const Duration(days: 12)),
        netPremium: 920,
        currency: 'TRY',
      ),
      PolicyModel(
        id: 'POL-C003-1',
        customerId: 'C003',
        customerName: 'Mehmet Kaya',
        status: 'Beklemede',
        company: 'Axa Sigorta',
        type: 'Sağlık Sigortası',
        policyNumber: 'AX-2026-SG-118',
        startDate: now,
        endDate: now.add(const Duration(days: 365)),
        netPremium: 15600,
        currency: 'TRY',
      ),
      PolicyModel(
        id: 'POL-C004-1',
        customerId: 'C004',
        customerName: 'Ayşe Öztürk',
        status: 'Sonlandı',
        company: 'HDI Sigorta',
        type: 'Trafik Sigortası',
        policyNumber: 'HD-2023-TR-009',
        startDate: now.subtract(const Duration(days: 800)),
        endDate: now.subtract(const Duration(days: 30)),
        netPremium: 4100,
        currency: 'TRY',
      ),
      PolicyModel(
        id: 'POL-C005-1',
        customerId: 'C005',
        customerName: 'Burak Şahin',
        status: 'Aktif',
        company: 'Unico Sigorta',
        type: 'Konut Sigortası',
        policyNumber: 'UN-2025-KN-773',
        startDate: now.subtract(const Duration(days: 60)),
        endDate: now.add(const Duration(days: 305)),
        netPremium: 3200,
        currency: 'TRY',
      ),
    ];
  }
}
