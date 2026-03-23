class PolicyModel {
  final String id;
  final String customerId;

  /// Dashboard / liste görünümleri için (join yoksa)
  final String? customerName;

  final String status;
  final String company;
  final String type;
  final String policyNumber;
  final DateTime startDate;
  final DateTime endDate;
  final double netPremium;
  final String currency;

  const PolicyModel({
    required this.id,
    required this.customerId,
    this.customerName,
    required this.status,
    required this.company,
    required this.type,
    required this.policyNumber,
    required this.startDate,
    required this.endDate,
    required this.netPremium,
    required this.currency,
  });

  /// Bitiş tarihi (yaklaşan poliçeler kartı vb.)
  DateTime get expiryDate => endDate;

  PolicyModel copyWith({
    String? id,
    String? customerId,
    String? customerName,
    String? status,
    String? company,
    String? type,
    String? policyNumber,
    DateTime? startDate,
    DateTime? endDate,
    double? netPremium,
    String? currency,
  }) {
    return PolicyModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      status: status ?? this.status,
      company: company ?? this.company,
      type: type ?? this.type,
      policyNumber: policyNumber ?? this.policyNumber,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      netPremium: netPremium ?? this.netPremium,
      currency: currency ?? this.currency,
    );
  }
}
