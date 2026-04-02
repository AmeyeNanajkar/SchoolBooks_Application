import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Panel')),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Admin Dashboard', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _buildStatCard(context, 'Users', '0', Icons.people, Colors.blue)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard(context, 'Vendors', '0', Icons.store, Colors.green)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildStatCard(context, 'Books', '0', Icons.menu_book, Colors.orange)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard(context, 'Orders', '0', Icons.receipt, Colors.purple)),
              ],
            ),
            const SizedBox(height: 24),
            Text('Management', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildActionCard(context, Icons.people, 'Manage Users', () => context.push('/admin/users')),
            _buildActionCard(context, Icons.store, 'Manage Vendors', () => context.push('/admin/vendors')),
            _buildActionCard(context, Icons.menu_book, 'Manage Books', () => context.push('/admin/books')),
            _buildActionCard(context, Icons.category, 'Categories', () {}),
            _buildActionCard(context, Icons.local_offer, 'Offers & Coupons', () {}),
            _buildActionCard(context, Icons.analytics, 'Analytics', () {}),
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

  Widget _buildActionCard(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
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
                CircleAvatar(radius: 30, child: Icon(Icons.admin_panel_settings, size: 32)),
                SizedBox(height: 8),
                Text('Admin Portal', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('admin@schoolbooks.in'),
              ],
            ),
          ),
          ListTile(leading: const Icon(Icons.dashboard), title: const Text('Dashboard'), onTap: () {}),
          ListTile(leading: const Icon(Icons.people), title: const Text('Users'), onTap: () {}),
          ListTile(leading: const Icon(Icons.store), title: const Text('Vendors'), onTap: () => context.push('/admin/vendors')),
          ListTile(leading: const Icon(Icons.menu_book), title: const Text('Books'), onTap: () => context.push('/admin/books')),
          const Divider(),
          ListTile(leading: const Icon(Icons.logout), title: const Text('Logout'), onTap: () => context.go('/')),
        ],
      ),
    );
  }
}
