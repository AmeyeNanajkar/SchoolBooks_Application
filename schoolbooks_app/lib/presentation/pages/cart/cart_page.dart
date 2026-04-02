import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/cart/cart_event.dart';
import '../../blocs/cart/cart_state.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final _couponController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(CartLoadRequested());
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state.cart != null && state.cart!.items.isNotEmpty) {
                return TextButton(
                  onPressed: () => _showClearCartDialog(),
                  child: const Text('Clear All', style: TextStyle(color: Colors.white)),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
          }
          if (state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == CartStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.cart == null || state.cart!.items.isEmpty) {
            return _buildEmptyCart();
          }
          return _buildCartContent(state);
        },
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Browse our catalog and add books to your cart',
            style: TextStyle(color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.go('/catalog'),
            icon: const Icon(Icons.menu_book),
            label: const Text('Browse Books'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(CartState state) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.cart!.items.length,
            itemBuilder: (context, index) {
              final item = state.cart!.items[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: item.book?.imageUrl != null
                            ? CachedNetworkImage(
                                imageUrl: item.book!.imageUrl!,
                                width: 80,
                                height: 100,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  width: 80,
                                  height: 100,
                                  color: Colors.grey[200],
                                ),
                                errorWidget: (context, url, error) => Container(
                                  width: 80,
                                  height: 100,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.book),
                                ),
                              )
                            : Container(
                                width: 80,
                                height: 100,
                                color: Colors.grey[200],
                                child: const Icon(Icons.book),
                              ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.book?.title ?? 'Unknown Book',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.book?.author ?? '',
                              style: TextStyle(color: Colors.grey[600], fontSize: 12),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '₹${item.book?.effectivePrice.toStringAsFixed(2) ?? '0.00'}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _buildQuantityButton(
                                  icon: Icons.remove,
                                  onPressed: item.quantity > 1
                                      ? () {
                                          context.read<CartBloc>().add(
                                                CartUpdateItemRequested(
                                                  itemId: item.id,
                                                  quantity: item.quantity - 1,
                                                ),
                                              );
                                        }
                                      : null,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    item.quantity.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                _buildQuantityButton(
                                  icon: Icons.add,
                                  onPressed: () {
                                    context.read<CartBloc>().add(
                                          CartUpdateItemRequested(
                                            itemId: item.id,
                                            quantity: item.quantity + 1,
                                          ),
                                        );
                                  },
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                                  onPressed: () {
                                    context.read<CartBloc>().add(
                                          CartRemoveItemRequested(itemId: item.id),
                                        );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        _buildCouponSection(state),
        _buildPriceSummary(state),
      ],
    );
  }

  Widget _buildQuantityButton({required IconData icon, VoidCallback? onPressed}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(4),
      ),
      child: IconButton(
        icon: Icon(icon, size: 18),
        onPressed: onPressed,
        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildCouponSection(CartState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _couponController,
              decoration: InputDecoration(
                hintText: 'Enter coupon code',
                isDense: true,
                suffixIcon: state.cart?.appliedCouponCode != null
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : null,
              ),
            ),
          ),
          const SizedBox(width: 12),
          if (state.cart?.appliedCouponCode != null)
            TextButton(
              onPressed: () {
                context.read<CartBloc>().add(CartRemoveCouponRequested());
              },
              child: const Text('Remove'),
            )
          else
            ElevatedButton(
              onPressed: state.isApplyingCoupon
                  ? null
                  : () {
                      if (_couponController.text.isNotEmpty) {
                        context.read<CartBloc>().add(
                              CartApplyCouponRequested(couponCode: _couponController.text),
                            );
                      }
                    },
              child: state.isApplyingCoupon
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Apply'),
            ),
        ],
      ),
    );
  }

  Widget _buildPriceSummary(CartState state) {
    final cart = state.cart!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
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
                  const Text('Discount', style: TextStyle(color: Colors.green)),
                  Text('-₹${cart.discountAmount.toStringAsFixed(2)}', style: const TextStyle(color: Colors.green)),
                ],
              ),
            ],
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '₹${cart.total.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.push('/checkout'),
                child: const Text('Proceed to Checkout'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCartDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text('Are you sure you want to remove all items from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<CartBloc>().add(CartClearRequested());
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
