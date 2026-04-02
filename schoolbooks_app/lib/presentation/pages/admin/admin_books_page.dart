import 'package:flutter/material.dart';

class AdminBooksPage extends StatelessWidget {
  const AdminBooksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Books')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('Add Book'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu_book_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text('No books yet'),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Add First Book'),
            ),
          ],
        ),
      ),
    );
  }
}
