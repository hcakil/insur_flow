class PolicyFieldSettingModel {
  final String id;
  final String policyTypeId;
  final String fieldName;
  /// Örn: Metin, Sayı
  final String fieldType;
  final String? options;
  final bool isRequired;

  PolicyFieldSettingModel({
    required this.id,
    required this.policyTypeId,
    required this.fieldName,
    required this.fieldType,
    this.options,
    required this.isRequired,
  });

  PolicyFieldSettingModel copyWith({
    String? id,
    String? policyTypeId,
    String? fieldName,
    String? fieldType,
    String? options,
    bool? isRequired,
  }) {
    return PolicyFieldSettingModel(
      id: id ?? this.id,
      policyTypeId: policyTypeId ?? this.policyTypeId,
      fieldName: fieldName ?? this.fieldName,
      fieldType: fieldType ?? this.fieldType,
      options: options ?? this.options,
      isRequired: isRequired ?? this.isRequired,
    );
  }
}
