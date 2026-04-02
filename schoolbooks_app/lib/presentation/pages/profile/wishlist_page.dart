import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text('Your wishlist is empty'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => context.go('/catalog'),
              child: const Text('Browse Books'),
            ),
          ],
        ),
      ),
    );
  }
}
