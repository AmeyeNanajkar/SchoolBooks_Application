import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final user = state.user;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CircleAvatar(radius: 50, backgroundColor: Theme.of(context).colorScheme.primary, child: Text(user?.name[0].toUpperCase() ?? 'U', style: const TextStyle(fontSize: 36, color: Colors.white))),
                const SizedBox(height: 16),
                Text(user?.name ?? 'User', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(user?.email ?? '', style: TextStyle(color: Colors.grey[600])),
                const SizedBox(height: 24),
                _buildMenuItem(context, Icons.location_on, 'My Addresses', () => context.push('/addresses')),
                _buildMenuItem(context, Icons.favorite, 'Wishlist', () => context.push('/wishlist')),
                _buildMenuItem(context, Icons.receipt_long, 'My Orders', () => context.go('/orders')),
                _buildMenuItem(context, Icons.notifications, 'Notifications', () {}),
                _buildMenuItem(context, Icons.help, 'Help & Support', () {}),
                _buildMenuItem(context, Icons.info, 'About Us', () {}),
                const Divider(height: 32),
                _buildMenuItem(context, Icons.logout, 'Logout', () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            context.read<AuthBloc>().add(AuthLogoutRequested());
                            context.go('/login');
                          },
                          child: const Text('Logout'),
                        ),
                      ],
                    ),
                  );
                }, color: Colors.red),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, VoidCallback onTap, {Color? color}) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
        onTap: onTap,
      ),
    );
  }
}
