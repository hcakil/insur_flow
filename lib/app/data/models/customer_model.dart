class CustomerModel {
  final String id;
  final String name;
  final String identityNumber;
  final String phone;
  final List<String> tags;
  /// Operasyonel durum (liste / filtre)
  final String status;

  final String customerType;
  final String profession;
  /// İlişki durumu: VIP, Sadık, Öngörülemez, Bilinmiyor
  final String relationshipStatus;
  /// Etiket: Aktif, Aktif Değil
  final String tagStatus;
  final String reference;
  final DateTime? birthDate;
  final String address;
  final String customerNote;

  const CustomerModel({
    required this.id,
    required this.name,
    required this.identityNumber,
    required this.phone,
    required this.tags,
    required this.status,
    this.customerType = 'Bireysel',
    this.profession = 'Diğer',
    this.relationshipStatus = 'Bilinmiyor',
    this.tagStatus = 'Aktif',
    this.reference = '',
    this.birthDate,
    this.address = '',
    this.customerNote = '',
  });

  CustomerModel copyWith({
    String? id,
    String? name,
    String? identityNumber,
    String? phone,
    List<String>? tags,
    String? status,
    String? customerType,
    String? profession,
    String? relationshipStatus,
    String? tagStatus,
    String? reference,
    DateTime? birthDate,
    bool clearBirthDate = false,
    String? address,
    String? customerNote,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      identityNumber: identityNumber ?? this.identityNumber,
      phone: phone ?? this.phone,
      tags: tags ?? this.tags,
      status: status ?? this.status,
      customerType: customerType ?? this.customerType,
      profession: profession ?? this.profession,
      relationshipStatus: relationshipStatus ?? this.relationshipStatus,
      tagStatus: tagStatus ?? this.tagStatus,
      reference: reference ?? this.reference,
      birthDate: clearBirthDate ? null : (birthDate ?? this.birthDate),
      address: address ?? this.address,
      customerNote: customerNote ?? this.customerNote,
    );
  }
}
