// lib/data/app_data.dart
import '../models/payment.dart';
import '../models/restaurant.dart'; 

final List<Map<String, dynamic>> rawPaymentData = [
  // Mobile Money / Digital Wallets
  {'id': 'PM001', 'name': 'TELEBIRR', 'iconAsset': 'assets/payments/TELEBIRR.png', 'type': 'mobileMoney', 'integrationPackage': 'telebirr_sdk'},
  {'id': 'PM002', 'name': 'CBE BIRR', 'iconAsset': 'assets/payments/CBE BIRR.jpeg', 'type': 'mobileMoney', 'integrationPackage': 'cbe_birr_api'},
  {'id': 'PM003', 'name': 'AWASH BIRR', 'iconAsset': 'assets/payments/AWASH BIRR AND AWASH BANK.jpeg', 'type': 'mobileMoney', 'integrationPackage': 'awash_birr_api'},
  {'id': 'PM004', 'name': 'MPESA', 'iconAsset': 'assets/payments/MPESA_logo.png', 'type': 'mobileMoney', 'integrationPackage': 'mpesa_api'}, 
  
  // Bank Transfer
  {'id': 'PM005', 'name': 'CBE BANK', 'iconAsset': 'assets/payments/CBE BANK.jpeg', 'type': 'bankTransfer', 'accountReference': '1000123456789'},
  {'id': 'PM006', 'name': 'AWASH BANK', 'iconAsset': 'assets/payments/AWASH BIRR AND AWASH BANK.jpeg', 'type': 'bankTransfer', 'accountReference': '01400010012345'},
  {'id': 'PM007', 'name': 'OROMIA BANK', 'iconAsset': 'assets/payments/OROMIA BANK.png', 'type': 'bankTransfer', 'accountReference': '789012345678'},
  {'id': 'PM008', 'name': 'ABYSINIA BANK', 'iconAsset': 'assets/payments/ABYSINIA BANK.png', 'type': 'bankTransfer', 'accountReference': '9876543210'},
  {'id': 'PM009', 'name': 'CBO (Cooperative Bank of Oromia)', 'iconAsset': 'assets/payments/CBO BANK.png', 'type': 'bankTransfer', 'accountReference': '123450000678'},
  {'id': 'PM010', 'name': 'ZEMEN BANK', 'iconAsset': 'assets/payments/ZEMEN BANK.png', 'type': 'bankTransfer', 'accountReference': '456789012345'},
  {'id': 'PM011', 'name': 'SINQE BANK', 'iconAsset': 'assets/payments/SINQE_BANK_logo.png', 'type': 'bankTransfer', 'accountReference': '112233445566'}, 
  
  // Cash
  {'id': 'PM012', 'name': 'Cash on Delivery', 'iconAsset': 'assets/payments/cash_icon.png', 'type': 'cashOnDelivery'},
];

// Final List of PaymentMethod Objects, ready for the Service Layer
final List<PaymentMethod> availablePaymentMethods = 
    rawPaymentData.map((data) => PaymentMethod.fromJson(data)).toList();

// ... (Other application data like rawRestaurantData and advancedRestaurantData)
