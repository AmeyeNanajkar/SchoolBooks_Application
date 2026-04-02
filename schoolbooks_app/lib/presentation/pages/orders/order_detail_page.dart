import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../blocs/orders/orders_bloc.dart';
import '../../blocs/orders/orders_event.dart';
import '../../blocs/orders/orders_state.dart';

class OrderDetailPage extends StatefulWidget {
  final String orderId;
  const OrderDetailPage({super.key, required this.orderId});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<OrdersBloc>().add(OrdersTrackRequested(orderId: widget.orderId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.local_shipping),
            onPressed: () => context.push('/order/${widget.orderId}/track'),
          ),
        ],
      ),
      body: BlocBuilder<OrdersBloc, OrdersState>(
        builder: (context, state) {
          if (state.status == OrdersStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          final order = state.selectedOrder;
          if (order == null) {
            return const Center(child: Text('Order not found'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Order #${order.orderNumber}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            _buildStatusChip(order.status.name),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Placed on ${_formatDate(order.createdAt)}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Items', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...order.items.map((item) => Card(
                      child: ListTile(
                        leading: const Icon(Icons.book),
                        title: Text(item.bookTitle),
                        subtitle: Text('Qty: ${item.quantity}'),
                        trailing: Text('₹${item.totalPrice.toStringAsFixed(2)}'),
                      ),
                    )),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Delivery Address', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(order.shippingAddress.name),
                        Text(order.shippingAddress.phone),
                        Text(order.shippingAddress.fullAddress),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Subtotal'), Text('₹${order.subtotal.toStringAsFixed(2)}')]),
                        if (order.discountAmount > 0)
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Discount', style: TextStyle(color: Colors.green)), Text('-₹${order.discountAmount.toStringAsFixed(2)}', style: const TextStyle(color: Colors.green))]),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Shipping'), Text(order.shippingCost > 0 ? '₹${order.shippingCost.toStringAsFixed(2)}' : 'FREE')]),
                        const Divider(),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), Text('₹${order.totalAmount.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Theme.of(context).colorScheme.primary))]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'pending': color = Colors.orange; break;
      case 'confirmed': color = Colors.blue; break;
      case 'processing': color = Colors.purple; break;
      case 'shipped': color = Colors.indigo; break;
      case 'outForDelivery': color = Colors.teal; break;
      case 'delivered': color = Colors.green; break;
      case 'cancelled': color = Colors.red; break;
      default: color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
      child: Text(status.replaceAll(RegExp(r'([A-Z])'), ' \$1').trim(), style: TextStyle(color: color, fontWeight: FontWeight.w500)),
    );
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}
