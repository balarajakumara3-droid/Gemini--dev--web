import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.user;
          
          return SingleChildScrollView(
            child: Column(
              children: [
                _buildProfileHeader(user),
                const SizedBox(height: 24),
                _buildMenuOptions(authProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(dynamic user) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Profile Picture
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                child: user?.profileImage != null
                    ? ClipOval(
                        child: Image.network(
                          user!.profileImage!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.person,
                              size: 50,
                              color: AppTheme.primaryColor,
                            );
                          },
                        ),
                      )
                    : const Icon(
                        Icons.person,
                        size: 50,
                        color: AppTheme.primaryColor,
                      ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.edit,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // User Name
          Text(
            user?.name ?? 'Guest User',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          
          // User Email
          Text(
            user?.email ?? 'guest@example.com',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOptions(AuthProvider authProvider) {
    final menuItems = [
      _MenuItem(
        icon: Icons.edit_outlined,
        title: 'Edit Profile',
        subtitle: 'Update your personal information',
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Edit Profile - Coming Soon'),
              backgroundColor: AppTheme.primaryColor,
            ),
          );
        },
      ),
      _MenuItem(
        icon: Icons.location_on_outlined,
        title: 'Delivery Addresses',
        subtitle: 'Manage your delivery locations',
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Addresses - Coming Soon'),
              backgroundColor: AppTheme.primaryColor,
            ),
          );
        },
      ),
      _MenuItem(
        icon: Icons.payment_outlined,
        title: 'Payment Methods',
        subtitle: 'Manage cards and payment options',
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Payment Methods - Coming Soon'),
              backgroundColor: AppTheme.primaryColor,
            ),
          );
        },
      ),
      _MenuItem(
        icon: Icons.notifications_outlined,
        title: 'Notifications',
        subtitle: 'Manage notification preferences',
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Notifications - Coming Soon'),
              backgroundColor: AppTheme.primaryColor,
            ),
          );
        },
      ),
      _MenuItem(
        icon: Icons.help_outline,
        title: 'Help & Support',
        subtitle: 'Get help and contact support',
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Help & Support - Coming Soon'),
              backgroundColor: AppTheme.primaryColor,
            ),
          );
        },
      ),
      _MenuItem(
        icon: Icons.info_outline,
        title: 'About',
        subtitle: 'App version and information',
        onTap: () {
          _showAboutDialog();
        },
      ),
      _MenuItem(
        icon: Icons.logout,
        title: 'Sign Out',
        subtitle: 'Sign out of your account',
        onTap: () {
          _showLogoutDialog(authProvider);
        },
        isDestructive: true,
      ),
    ];

    return Column(
      children: menuItems.map((item) => _buildMenuItem(item)).toList(),
    );
  }

  Widget _buildMenuItem(_MenuItem item) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Icon(
          item.icon,
          color: item.isDestructive ? AppTheme.errorColor : AppTheme.primaryColor,
        ),
        title: Text(
          item.title,
          style: TextStyle(
            color: item.isDestructive ? AppTheme.errorColor : null,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(item.subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: item.onTap,
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'Food Delivery App',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.restaurant,
          color: Colors.white,
          size: 24,
        ),
      ),
      children: [
        const Text('A modern food delivery application built with Flutter.'),
      ],
    );
  }

  void _showLogoutDialog(AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await authProvider.logout();
                if (mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                }
              },
              child: const Text(
                'Sign Out',
                style: TextStyle(color: AppTheme.errorColor),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });
}