import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/order.dart';
import '../../../domain/entities/user.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/cart/cart_state.dart';
import '../../blocs/orders/orders_bloc.dart';
import '../../blocs/orders/orders_event.dart';
import '../../blocs/orders/orders_state.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int _currentStep = 0;
  Address? _selectedAddress;
  PaymentMethod _selectedPaymentMethod = PaymentMethod.upi;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: BlocListener<OrdersBloc, OrdersState>(
        listener: (context, state) {
          if (state.status == OrdersStatus.created) {
            context.go('/order/${state.selectedOrder!.id}');
          } else if (state.status == OrdersStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Order failed'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: _onStepContinue,
          onStepCancel: _onStepCancel,
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: details.onStepContinue,
                    child: Text(_currentStep == 2 ? 'Place Order' : 'Continue'),
                  ),
                  if (_currentStep > 0) ...[
                    const SizedBox(width: 12),
                    TextButton(
                      onPressed: details.onStepCancel,
                      child: const Text('Back'),
                    ),
                  ],
                ],
              ),
            );
          },
          steps: [
            Step(
              title: const Text('Address'),
              subtitle: _selectedAddress != null
                  ? Text(_selectedAddress!.name, overflow: TextOverflow.ellipsis)
                  : null,
              content: _buildAddressStep(),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: const Text('Payment'),
              content: _buildPaymentStep(),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: const Text('Review'),
              content: _buildReviewStep(),
              isActive: _currentStep >= 2,
              state: StepState.indexed,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Delivery Address',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        ListTile(
          leading: const Icon(Icons.add_location_alt),
          title: const Text('Add New Address'),
          onTap: () => context.push('/addresses/add'),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Home'),
          subtitle: _selectedAddress != null
              ? Text(_selectedAddress!.fullAddress, maxLines: 2, overflow: TextOverflow.ellipsis)
              : const Text('No address selected'),
          trailing: _selectedAddress != null
              ? const Icon(Icons.check_circle, color: Colors.green)
              : null,
          onTap: () async {
            final address = await context.push<Address>('/addresses');
            if (address != null) {
              setState(() => _selectedAddress = address);
            }
          },
        ),
        if (_selectedAddress != null) ...[
          const Divider(),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedAddress!.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _selectedAddress!.phone,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(_selectedAddress!.fullAddress),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPaymentStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Payment Method',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        _buildPaymentOption(
          'UPI',
          'Pay using any UPI app',
          Icons.qr_code,
          PaymentMethod.upi,
        ),
        _buildPaymentOption(
          'Net Banking',
          'Pay directly from your bank account',
          Icons.account_balance,
          PaymentMethod.netBanking,
        ),
        _buildPaymentOption(
          'Credit/Debit Card',
          'Pay using Visa, Mastercard, etc.',
          Icons.credit_card,
          PaymentMethod.creditCard,
        ),
        _buildPaymentOption(
          'Wallet',
          'Pay using Paytm, PhonePe, etc.',
          Icons.account_balance_wallet,
          PaymentMethod.wallet,
        ),
        _buildPaymentOption(
          'Cash on Delivery',
          'Pay when you receive your order',
          Icons.payments,
          PaymentMethod.cod,
        ),
      ],
    );
  }

  Widget _buildPaymentOption(String title, String subtitle, IconData icon, PaymentMethod method) {
    return Card(
      color: _selectedPaymentMethod == method
          ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
          : null,
      child: ListTile(
        leading: Icon(icon, color: _selectedPaymentMethod == method
            ? Theme.of(context).colorScheme.primary
            : null),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: _selectedPaymentMethod == method
            ? const Icon(Icons.check_circle, color: Colors.green)
            : null,
        onTap: () => setState(() => _selectedPaymentMethod = method),
      ),
    );
  }

  Widget _buildReviewStep() {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, cartState) {
        if (cartState.cart == null) {
          return const Center(child: CircularProgressIndicator());
        }
        final cart = cartState.cart!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Items'),
                        Text('${cart.itemCount}'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Subtotal'),
                        Text('₹${cart.subtotal.toStringAsFixed(2)}'),
                      ],
                    ),
                    if (cart.discountAmount > 0) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Discount'),
                          Text('-₹${cart.discountAmount.toStringAsFixed(2)}', style: const TextStyle(color: Colors.green)),
                        ],
                      ),
                    ],
                    const SizedBox(height: 8),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Shipping'),
                        Text('FREE'),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          '₹${cart.total.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_selectedAddress != null) ...[
              Text(
                'Delivery Address',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedAddress!.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(_selectedAddress!.phone),
                      const SizedBox(height: 4),
                      Text(_selectedAddress!.fullAddress),
                    ],
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  void _onStepContinue() {
    if (_currentStep == 0 && _selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a delivery address')),
      );
      return;
    }
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else {
      _placeOrder();
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _placeOrder() {
    if (_selectedAddress == null) return;
    context.read<OrdersBloc>().add(OrdersCreateRequested(
          addressId: _selectedAddress!.id,
          paymentMethod: _selectedPaymentMethod,
        ));
  }
}
