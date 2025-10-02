// lib/data/app_data.dart

import '../models/payment.dart';
import '../models/restaurant.dart'; // Required if you are also defining restaurant data here

// --- RAW PAYMENT DATA (Updated with all provided logos) ---

final List<Map<String, dynamic>> rawPaymentData = [
  // Mobile Money / Digital Wallets
  {
    'id': 'PM001',
    'name': 'TELEBIRR',
    'iconAsset': 'assets/payments/TELEBIRR.png',
    'type': 'mobileMoney',
    'integrationPackage': 'telebirr_inapp_sdk', // Use this for backend API calls
  },
  {
    'id': 'PM002',
    'name': 'CBE BIRR',
    'iconAsset': 'assets/payments/CBE BIRR.jpeg',
    'type': 'mobileMoney',
    'integrationPackage': 'cbe_birr_api',
  },
  {
    'id': 'PM003',
    'name': 'MPESA',
    'iconAsset': 'assets/payments/MPESA_logo.png', // Placeholder (logo not provided)
    'type': 'mobileMoney',
    'integrationPackage': 'mpesa_api_flutter',
  },
  
  // Bank Transfer (Bank payments often handled via direct transfer or USSD API)
  {
    'id': 'PM004',
    'name': 'CBE BANK',
    'iconAsset': 'assets/payments/CBE BANK.jpeg',
    'type': 'bankTransfer',
    'accountReference': '1000123456789',
  },
  {
    'id': 'PM005',
    'name': 'AWASH BANK',
    'iconAsset': 'assets/payments/AWASH BIRR AND AWASH BANK.jpeg', // Using the provided Awash logo
    'type': 'bankTransfer',
    'accountReference': '01400010012345',
  },
  {
    'id': 'PM006',
    'name': 'OROMIA BANK',
    'iconAsset': 'assets/payments/OROMIA BANK.png',
    'type': 'bankTransfer',
    'accountReference': '789012345678',
  },
  {
    'id': 'PM007',
    'name': 'ABYSINIA BANK',
    'iconAsset': 'assets/payments/ABYSINIA BANK.png',
    'type': 'bankTransfer',
    'accountReference': '9876543210',
  },
  {
    'id': 'PM008',
    'name': 'CBO (Cooperative Bank of Oromia)',
    'iconAsset': 'assets/payments/CBO BANK.png',
    'type': 'bankTransfer',
    'accountReference': '123450000678',
  },
  {
    'id': 'PM009',
    'name': 'ZEMEN BANK',
    'iconAsset': 'assets/payments/ZEMEN BANK.png',
    'type': 'bankTransfer',
    'accountReference': '456789012345',
  },
  {
    'id': 'PM010',
    'name': 'SINQE BANK',
    'iconAsset': 'assets/payments/SINQE_BANK_logo.png', // Placeholder (logo not provided)
    'type': 'bankTransfer',
    'accountReference': '112233445566',
  },
  {
    'id': 'PM011',
    'name': 'Cash on Delivery',
    'iconAsset': 'assets/payments/cash_icon.png', // Placeholder
    'type': 'cashOnDelivery',
  },
];

// Final List of PaymentMethod Objects (Deserialization)
final List<PaymentMethod> availablePaymentMethods = 
    rawPaymentData.map((data) => PaymentMethod.fromJson(data)).toList();

// ... (Other application data, like rawRestaurantData)
