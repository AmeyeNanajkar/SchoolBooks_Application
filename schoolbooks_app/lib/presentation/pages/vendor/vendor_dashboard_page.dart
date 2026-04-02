import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VendorDashboardPage extends StatelessWidget {
  const VendorDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vendor Dashboard')),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome, Vendor!', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _buildStatCard(context, 'Total Sales', '₹0', Icons.attach_money, Colors.green)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard(context, 'Orders', '0', Icons.shopping_bag, Colors.blue)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildStatCard(context, 'Products', '0', Icons.inventory, Colors.orange)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard(context, 'Rating', '0.0', Icons.star, Colors.amber)),
              ],
            ),
            const SizedBox(height: 24),
            Text('Quick Actions', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildActionCard(context, Icons.inventory_2, 'Manage Inventory', 'Add, update or remove books', () => context.push('/vendor/inventory')),
            _buildActionCard(context, Icons.receipt, 'Orders', 'View and manage orders', () {}),
            _buildActionCard(context, Icons.analytics, 'Analytics', 'View sales reports', () {}),
            _buildActionCard(context, Icons.local_offer, 'Offers', 'Manage discounts and offers', () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            Text(title, style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(radius: 30, child: Icon(Icons.store, size: 32)),
                SizedBox(height: 8),
                Text('Vendor Portal', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('vendor@schoolbooks.in'),
              ],
            ),
          ),
          ListTile(leading: const Icon(Icons.dashboard), title: const Text('Dashboard'), onTap: () {}),
          ListTile(leading: const Icon(Icons.inventory_2), title: const Text('Inventory'), onTap: () => context.push('/vendor/inventory')),
          ListTile(leading: const Icon(Icons.receipt_long), title: const Text('Orders'), onTap: () {}),
          ListTile(leading: const Icon(Icons.analytics), title: const Text('Analytics'), onTap: () {}),
          const Divider(),
          ListTile(leading: const Icon(Icons.logout), title: const Text('Logout'), onTap: () => context.go('/')),
        ],
      ),
    );
  }
}
