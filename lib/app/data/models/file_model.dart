/// Poliçe dosyaları modalında kullanılan dosya satırı
class FileModel {
  final String name;
  final String sizeLabel;
  final DateTime date;

  /// Rozet metni: Poliçe, Zeyil, Makbuz vb.
  final String badgeLabel;

  /// Filtre sekmesi: 'police' | 'zeyil' | 'makbuz'
  final String category;

  const FileModel({
    required this.name,
    required this.sizeLabel,
    required this.date,
    required this.badgeLabel,
    required this.category,
  });
}
