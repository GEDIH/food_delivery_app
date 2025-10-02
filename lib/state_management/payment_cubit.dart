// lib/state_management/payment_cubit.dart
//This layer handles all the business logic and state transitions....
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/payment.dart';
import '../repositories/payment_repository.dart';

// --- 1. STATES (The data that the UI listens to) ---
abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class PaymentInitial extends PaymentState {}
class PaymentLoading extends PaymentState {}

class PaymentLoaded extends PaymentState {
  final List<PaymentMethod> methods;
  final PaymentMethod? selectedMethod;

  const PaymentLoaded({required this.methods, this.selectedMethod});

  // Allows creating a copy of the state with a new selectedMethod
  PaymentLoaded copyWith({PaymentMethod? selectedMethod}) {
    return PaymentLoaded(
      methods: methods,
      selectedMethod: selectedMethod ?? this.selectedMethod,
    );
  }

  @override
  List<Object?> get props => [methods, selectedMethod];
}

class PaymentError extends PaymentState {
  final String message;
  const PaymentError(this.message);
  @override
  List<Object> get props => [message];
}


// --- 2. CUBIT (The logic controller) ---
class PaymentCubit extends Cubit<PaymentState> {
  final PaymentRepository _repository;

  PaymentCubit(this._repository) : super(PaymentInitial());

  // EVENT 1: Loads all payment methods when the screen opens
  Future<void> loadMethods() async {
    emit(PaymentLoading());
    try {
      final methods = await _repository.fetchPaymentMethods();
      emit(PaymentLoaded(
        methods: methods,
        selectedMethod: methods.isNotEmpty ? methods.first : null,
      ));
    } catch (e) {
      emit(PaymentError("Failed to load payment methods."));
    }
  }

  // EVENT 2: Changes the selected method based on user tap
  void selectMethod(PaymentMethod method) {
    if (state is PaymentLoaded) {
      final currentState = state as PaymentLoaded;
      emit(currentState.copyWith(selectedMethod: method));
    }
  }
}
