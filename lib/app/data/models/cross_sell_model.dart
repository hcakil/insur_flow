class CrossSellModel {
  final String id;
  final String customerName;
  final String existingPolicy;
  final String recommendedPolicy;
  final int successProbability;
  final String actionText;

  CrossSellModel({
    required this.id,
    required this.customerName,
    required this.existingPolicy,
    required this.recommendedPolicy,
    required this.successProbability,
    required this.actionText,
  });
}
