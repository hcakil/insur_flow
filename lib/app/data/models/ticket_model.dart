/// Destek talebi — Ana Sayfa ve Talepler modülü ortak modeli.
class TicketModel {
  final String id;
  final String ownerName;
  final String title;
  final String assignedTo;
  /// Örn: Yüksek, Orta, Düşük
  final String urgency;
  /// Açık, Kapalı, Beklemede
  final String status;
  final DateTime createdAt;
  /// Ana sayfa kartında "Gizlenen" sekmesi için
  final bool isHidden;

  TicketModel({
    required this.id,
    required this.ownerName,
    required this.title,
    required this.assignedTo,
    required this.urgency,
    required this.status,
    required this.createdAt,
    this.isHidden = false,
  });
}
