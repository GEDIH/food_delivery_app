// lib/repositories/payment_repository.dart

import '../data/app_data.dart';
import '../models/payment.dart';

class PaymentRepository {
  
  // Fetches data from a mock source (app_data.dart)
  Future<List<PaymentMethod>> fetchPaymentMethods() async {
    // In a real app:
    // 1. Check local cache
    // 2. Fallback to API call (e.g., http.get)
    // 3. Fallback to app_data.dart (for development)
    
    await Future.delayed(const Duration(milliseconds: 500)); 
    return availablePaymentMethods;
  }
}
