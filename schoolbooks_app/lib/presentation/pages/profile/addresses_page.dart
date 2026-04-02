import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddressesPage extends StatelessWidget {
  const AddressesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Addresses')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/addresses/add'),
        icon: const Icon(Icons.add),
        label: const Text('Add Address'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text('No addresses saved'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => context.push('/addresses/add'),
              child: const Text('Add Address'),
            ),
          ],
        ),
      ),
    );
  }
}
