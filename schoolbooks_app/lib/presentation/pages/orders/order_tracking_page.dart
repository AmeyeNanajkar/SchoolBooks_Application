import 'package:flutter/material.dart';

class OrderTrackingPage extends StatelessWidget {
  final String orderId;
  const OrderTrackingPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final steps = ['Order Placed', 'Confirmed', 'Shipped', 'Out for Delivery', 'Delivered'];
    return Scaffold(
      appBar: AppBar(title: const Text('Track Order')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: steps.length,
        itemBuilder: (context, index) {
          final isCompleted = index < 3;
          final isCurrent = index == 3;
          return Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 30, height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted ? Colors.green : (isCurrent ? Colors.blue : Colors.grey[300]),
                    ),
                    child: Icon(isCompleted ? Icons.check : Icons.circle, color: Colors.white, size: 16),
                  ),
                  if (index < steps.length - 1)
                    Container(width: 2, height: 50, color: isCompleted ? Colors.green : Colors.grey[300]),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Card(
                  child: ListTile(
                    title: Text(steps[index], style: TextStyle(fontWeight: isCurrent ? FontWeight.bold : null)),
                    subtitle: isCurrent ? const Text('Estimated delivery in 2 days') : null,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
