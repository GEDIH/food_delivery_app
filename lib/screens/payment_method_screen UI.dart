// lib/screens/checkout/payment_method_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/payment.dart';
import '../../state_management/payment_cubit.dart'; // State Manager
import '../../repositories/payment_repository.dart'; // Repository
import '../../core/app_constants.dart';

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide the Cubit and trigger the data load event
    return BlocProvider(
      create: (context) => PaymentCubit(PaymentRepository())..loadMethods(),
      child: const PaymentMethodView(),
    );
  }
}

class PaymentMethodView extends StatelessWidget {
  const PaymentMethodView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.selectPaymentTitle),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      body: BlocBuilder<PaymentCubit, PaymentState>(
        builder: (context, state) {
          if (state is PaymentLoading || state is PaymentInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PaymentError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          if (state is PaymentLoaded) {
            return _buildLoadedView(context, state);
          }
          return const Center(child: Text('Unknown State'));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // Checkout button is built here, reacting to the state
      floatingActionButton: BlocBuilder<PaymentCubit, PaymentState>(
        builder: (context, state) {
          final isEnabled = state is PaymentLoaded && state.selectedMethod != null;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: isEnabled ? () => _proceedToPayment(context, (state as PaymentLoaded).selectedMethod!) : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: AppColors.success,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(AppStrings.proceedToCheckout, style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadedView(BuildContext context, PaymentLoaded state) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: state.methods.length,
      itemBuilder: (context, index) {
        final method = state.methods[index];
        final isSelected = method == state.selectedMethod;
        
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
          child: ListTile(
            leading: Image.asset(
              method.iconAsset,
              width: 50,
              height: 50,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Icon(
                method.type.contains('mobileMoney') ? Icons.smartphone : Icons.account_balance, 
                size: 40, 
                color: isSelected ? AppColors.primary : Colors.grey[600],
              ),
            ),
            title: Text(method.name, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
            subtitle: method.accountReference != null
                ? Text('Account Ref: ${method.accountReference}', style: TextStyle(color: isSelected ? AppColors.primary : Colors.grey[600]))
                : Text(method.type.toUpperCase()),
            trailing: isSelected
                ? const Icon(Icons.check_circle, color: AppColors.success)
                : const Icon(Icons.circle_outlined, color: Colors.grey),
            onTap: () {
              // Calls the cubit method to change the state
              context.read<PaymentCubit>().selectMethod(method);
            },
          ),
        );
      },
    );
  }

  void _proceedToPayment(BuildContext context, PaymentMethod selectedMethod) {
    // Final action logic
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Confirmed'),
        content: Text('Starting transaction for: ${selectedMethod.name}.'),
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
