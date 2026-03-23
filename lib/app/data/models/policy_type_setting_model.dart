class PolicyTypeSettingModel {
  final String id;
  final String name;
  final bool isActive;

  PolicyTypeSettingModel({
    required this.id,
    required this.name,
    this.isActive = true,
  });

  PolicyTypeSettingModel copyWith({String? id, String? name, bool? isActive}) {
    return PolicyTypeSettingModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
    );
  }
}
