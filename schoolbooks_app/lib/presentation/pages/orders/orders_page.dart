import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../blocs/orders/orders_bloc.dart';
import '../../blocs/orders/orders_event.dart';
import '../../blocs/orders/orders_state.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  void initState() {
    super.initState();
    context.read<OrdersBloc>().add(const OrdersLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: BlocBuilder<OrdersBloc, OrdersState>(
        builder: (context, state) {
          if (state.status == OrdersStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 100,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No orders yet',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start shopping to see your orders here',
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
          return RefreshIndicator(
            onRefresh: () async {
              context.read<OrdersBloc>().add(OrdersRefreshRequested());
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                final order = state.orders[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: InkWell(
                    onTap: () => context.push('/order/${order.id}'),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Order #${order.orderNumber}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              _buildStatusChip(order.status),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${order.items.length} item(s)',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₹${order.totalAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Placed on ${_formatDate(order.createdAt)}',
                                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                              ),
                              const Icon(Icons.chevron_right),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusChip(status) {
    Color color;
    String text;
    switch (status.toString()) {
      case 'OrderStatus.pending':
        color = Colors.orange;
        text = 'Pending';
        break;
      case 'OrderStatus.confirmed':
        color = Colors.blue;
        text = 'Confirmed';
        break;
      case 'OrderStatus.processing':
        color = Colors.purple;
        text = 'Processing';
        break;
      case 'OrderStatus.shipped':
        color = Colors.indigo;
        text = 'Shipped';
        break;
      case 'OrderStatus.outForDelivery':
        color = Colors.teal;
        text = 'Out for Delivery';
        break;
      case 'OrderStatus.delivered':
        color = Colors.green;
        text = 'Delivered';
        break;
      case 'OrderStatus.cancelled':
        color = Colors.red;
        text = 'Cancelled';
        break;
      default:
        color = Colors.grey;
        text = 'Unknown';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.w500, fontSize: 12),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
