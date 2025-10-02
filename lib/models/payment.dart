// lib/models/payment.dart
enum PaymentMethodType {
  mobileMoney,
  bankTransfer,
  card,
  digitalWallet,
  cashOnDelivery,
}

class PaymentMethod {
  final String id; 
  final String name; 
  final String iconAsset; // Path to the logo image
  final PaymentMethodType type;
  final String? accountReference; 
  final String? integrationPackage; 

  const PaymentMethod({
    required this.id,
    required this.name,
    required this.iconAsset,
    required this.type,
    this.accountReference,
    this.integrationPackage,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'] as String,
      name: json['name'] as String,
      iconAsset: json['iconAsset'] as String,
      type: PaymentMethodType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => PaymentMethodType.cashOnDelivery,
      ),
      accountReference: json['accountReference'] as String?,
      integrationPackage: json['integrationPackage'] as String?,
    );
  }
}
// Note: lib/models/restaurant.dart also contains FoodItem and Restaurant DTOs.
