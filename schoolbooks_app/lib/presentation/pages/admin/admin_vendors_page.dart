import 'package:flutter/material.dart';

class AdminVendorsPage extends StatelessWidget {
  const AdminVendorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Vendors')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.store_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text('No vendors yet'),
          ],
        ),
      ),
    );
  }
}
