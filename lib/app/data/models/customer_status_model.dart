class CustomerStatusModel {
  final String id;
  final String name;
  /// Örn: #3B82F6 veya #3cf6d1
  final String colorHex;

  CustomerStatusModel({
    required this.id,
    required this.name,
    required this.colorHex,
  });
}
