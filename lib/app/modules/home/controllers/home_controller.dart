import 'package:get/get.dart';
import '../../../data/models/policy_model.dart';
import '../../../data/models/bookmark_model.dart';
import '../../../data/models/news_model.dart';
import '../../../data/models/cross_sell_model.dart';

class HomeController extends GetxController {
  final selectedTicketTab = 0.obs;

  final upcomingPolicies = <PolicyModel>[].obs;

  final bookmarks = <BookmarkModel>[].obs;

  final announcements = <String>[].obs;

  final news = <NewsModel>[].obs;

  final crossSellItems = <CrossSellModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadDummyData();
  }

  void _loadDummyData() {
    final now = DateTime.now();

    upcomingPolicies.assignAll([
      PolicyModel(
        id: 'P001',
        customerId: 'dash_c1',
        customerName: 'Mehmet Demir',
        status: 'Aktif',
        company: 'Unico Sigorta',
        type: 'Kasko',
        policyNumber: 'UN-2026-KSK-001',
        startDate: now.subtract(const Duration(days: 300)),
        endDate: now.add(const Duration(days: 3)),
        netPremium: 18500,
        currency: 'TRY',
      ),
      PolicyModel(
        id: 'P002',
        customerId: 'dash_c2',
        customerName: 'Ayşe Kara',
        status: 'Aktif',
        company: 'Anadolu Sigorta',
        type: 'Trafik Sigortası',
        policyNumber: 'AN-2026-TRF-882',
        startDate: now.subtract(const Duration(days: 200)),
        endDate: now.add(const Duration(days: 5)),
        netPremium: 4200,
        currency: 'TRY',
      ),
      PolicyModel(
        id: 'P003',
        customerId: 'dash_c3',
        customerName: 'Fatma Yıldız',
        status: 'Aktif',
        company: 'Sompo Sigorta',
        type: 'DASK',
        policyNumber: 'SM-2026-DSK-441',
        startDate: now.subtract(const Duration(days: 350)),
        endDate: now.add(const Duration(days: 7)),
        netPremium: 890,
        currency: 'TRY',
      ),
    ]);

    bookmarks.assignAll([
      BookmarkModel(
        id: 'B001',
        title: 'Online Mutabakat Sistemi',
        url: 'https://example.com/mutabakat',
      ),
      BookmarkModel(
        id: 'B002',
        title: 'Kasko Değer Listesi',
        url: 'https://example.com/kasko-deger',
      ),
      BookmarkModel(
        id: 'B003',
        title: 'SBM Poliçe Sorgulama',
        url: 'https://example.com/sbm',
      ),
      BookmarkModel(
        id: 'B004',
        title: 'Hasar Dosya Takip',
        url: 'https://example.com/hasar',
      ),
    ]);

    news.assignAll([
      NewsModel(
        id: 'N001',
        title: 'Zorunlu trafik sigortası primlerinde güncelleme yapıldı',
        date: '22 Mar 2026',
        url: 'https://example.com/haber1',
      ),
      NewsModel(
        id: 'N002',
        title: 'DASK poliçe limitleri yeniden belirlendi',
        date: '21 Mar 2026',
        url: 'https://example.com/haber2',
      ),
      NewsModel(
        id: 'N003',
        title: 'Kasko hasarında yeni düzenleme yürürlüğe girdi',
        date: '20 Mar 2026',
        url: 'https://example.com/haber3',
      ),
      NewsModel(
        id: 'N004',
        title: 'Sigorta sektöründe dijital dönüşüm hız kazanıyor',
        date: '19 Mar 2026',
        url: 'https://example.com/haber4',
      ),
    ]);

    crossSellItems.assignAll([
      CrossSellModel(
        id: 'CS001',
        customerName: 'Ahmet Yılmaz',
        existingPolicy: 'Trafik Sigortası',
        recommendedPolicy: 'Kasko',
        successProbability: 85,
        actionText: 'Teklif Hazırla',
      ),
      CrossSellModel(
        id: 'CS002',
        customerName: 'Elif Arslan',
        existingPolicy: 'Konut Sigortası',
        recommendedPolicy: 'DASK',
        successProbability: 92,
        actionText: 'Teklif Hazırla',
      ),
      CrossSellModel(
        id: 'CS003',
        customerName: 'Burak Şahin',
        existingPolicy: 'Kasko',
        recommendedPolicy: 'Sağlık Sigortası',
        successProbability: 67,
        actionText: 'Teklif Hazırla',
      ),
    ]);
  }

  void switchTicketTab(int index) {
    selectedTicketTab.value = index;
  }
}
