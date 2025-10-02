// lib/screens/checkout/payment_method_screen.dart

import 'package:flutter/material.dart';
import '../../services/restaurant_service.dart'; // Logic Layer
import '../../models/payment.dart';             // Data Model

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  // Store the list of payment methods and the loading state
  List<PaymentMethod> _methods = [];
  bool _isLoading = true;
  String? _selectedMethodId; // Track the currently selected method

  @override
  void initState() {
    super.initState();
    _loadPaymentMethods();
  }

  // Load data using the Service Layer
  void _loadPaymentMethods() async {
    try {
      final service = RestaurantService();
      final methods = await service.fetchAvailablePaymentMethods();
      setState(() {
        _methods = methods;
        _isLoading = false;
        // Pre-select the first method by default
        _selectedMethodId = methods.isNotEmpty ? methods.first.id : null;
      });
    } catch (e) {
      // In a real app, you'd show a user-friendly error dialog here
      print('Error loading payment methods: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Payment Method'),
        backgroundColor: Colors.deepOrange, // Food delivery theme color
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _methods.isEmpty
              ? const Center(child: Text('No payment methods available.'))
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100), // Space for checkout button
                  itemCount: _methods.length,
                  itemBuilder: (context, index) {
                    final method = _methods[index];
                    return _buildPaymentTile(method);
                  },
                ),
      // Advanced: Floating Checkout/Proceed button
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _selectedMethodId != null ? () {
            // Logic to proceed with the selected payment method
            final selected = _methods.firstWhere((m) => m.id == _selectedMethodId);
            _proceedToPayment(selected);
          } : null,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('PROCEED TO CHECKOUT', style: TextStyle(fontSize: 18, color: Colors.white)),
        ),
      ),
    );
  }

  // Helper Widget to display each payment option with its logo
  Widget _buildPaymentTile(PaymentMethod method) {
    final isSelected = method.id == _selectedMethodId;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      color: isSelected ? Colors.deepOrange.shade50 : Colors.white,
      child: ListTile(
        leading: Image.asset(
          method.iconAsset,
          width: 50,
          height: 50,
          fit: BoxFit.contain,
          // Fallback if the image path is wrong (e.g., for MPESA placeholder)
          errorBuilder: (context, error, stackTrace) => Icon(
            method.type == PaymentMethodType.mobileMoney ? Icons.smartphone : Icons.account_balance, 
            size: 40, 
            color: isSelected ? Colors.deepOrange : Colors.grey[600],
          ),
        ),
        title: Text(method.name, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        subtitle: method.accountReference != null
            ? Text('Account Ref: ${method.accountReference}', style: TextStyle(color: isSelected ? Colors.deepOrange : Colors.grey[600]))
            : Text(method.type.name.toUpperCase()),
        trailing: isSelected
            ? const Icon(Icons.check_circle, color: Colors.green)
            : const Icon(Icons.circle_outlined, color: Colors.grey),
        onTap: () {
          setState(() {
            _selectedMethodId = method.id;
          });
        },
      ),
    );
  }

  // Logic stub for handling the final payment action
  void _proceedToPayment(PaymentMethod selectedMethod) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Initiated'),
        content: Text('You are ready to pay using ${selectedMethod.name} (${selectedMethod.type.name}).'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    
    // In a real app, this is where you'd call a specific payment SDK (e.g., Telebirr SDK)
    if (selectedMethod.integrationPackage != null) {
      print('Initiating ${selectedMethod.integrationPackage} integration...');
    }
  }
}
