// lib/screens/checkout/payment_method_screen.dart

import 'package:flutter/material.dart';
import '../../services/restaurant_service.dart'; 
import '../../models/payment.dart';             

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  List<PaymentMethod> _methods = [];
  bool _isLoading = true;
  String? _selectedMethodId; 

  @override
  void initState() {
    super.initState();
    _loadPaymentMethods();
  }

  void _loadPaymentMethods() async {
    try {
      final service = RestaurantService();
      final methods = await service.fetchAvailablePaymentMethods();
      setState(() {
        _methods = methods;
        _isLoading = false;
        _selectedMethodId = methods.isNotEmpty ? methods.first.id : null;
      });
    } catch (e) {
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
        backgroundColor: Colors.deepOrange,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _methods.isEmpty
              ? const Center(child: Text('No payment methods available.'))
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100), 
                  itemCount: _methods.length,
                  itemBuilder: (context, index) {
                    return _buildPaymentTile(_methods[index]);
                  },
                ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _selectedMethodId != null ? () {
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

  Widget _buildPaymentTile(PaymentMethod method) {
    final isSelected = method.id == _selectedMethodId;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      color: isSelected ? Colors.deepOrange.shade50 : Colors.white,
      child: ListTile(
        // The logo is dynamically loaded here
        leading: Image.asset(
          method.iconAsset,
          width: 50,
          height: 50,
          fit: BoxFit.contain,
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
  
  void _proceedToPayment(PaymentMethod selectedMethod) {
    // Final payment confirmation logic
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Initiated'),
        content: Text('Starting payment via ${selectedMethod.name}. Integration package: ${selectedMethod.integrationPackage ?? 'N/A'}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
