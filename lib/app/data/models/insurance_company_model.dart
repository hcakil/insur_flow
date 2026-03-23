class InsuranceCompanyModel {
  final String id;
  final String name;
  final bool isActive;

  InsuranceCompanyModel({
    required this.id,
    required this.name,
    this.isActive = true,
  });

  InsuranceCompanyModel copyWith({String? id, String? name, bool? isActive}) {
    return InsuranceCompanyModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
    );
  }
}
