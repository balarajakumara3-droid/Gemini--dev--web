import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  String _selectedLanguage = 'English';
  String _selectedTheme = 'System';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notifications Section
            _buildSectionTitle('Notifications'),
            _buildMenuSection(
              context,
              [
                _buildSwitchTile(
                  context,
                  'Enable Notifications',
                  'Receive notifications about new properties and updates',
                  _notificationsEnabled,
                  (value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                  },
                ),
                _buildSwitchTile(
                  context,
                  'Email Notifications',
                  'Get notified via email about new properties',
                  _emailNotifications,
                  (value) {
                    setState(() {
                      _emailNotifications = value;
                    });
                  },
                ),
                _buildSwitchTile(
                  context,
                  'Push Notifications',
                  'Receive push notifications on your device',
                  _pushNotifications,
                  (value) {
                    setState(() {
                      _pushNotifications = value;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // App Preferences Section
            _buildSectionTitle('App Preferences'),
            _buildMenuSection(
              context,
              [
                _buildListTile(
                  context,
                  'Language',
                  _selectedLanguage,
                  Icons.language,
                  () => _showLanguageDialog(context),
                ),
                _buildListTile(
                  context,
                  'Theme',
                  _selectedTheme,
                  Icons.palette,
                  () => _showThemeDialog(context),
                ),
                _buildListTile(
                  context,
                  'Currency',
                  'USD',
                  Icons.attach_money,
                  () {
                    // Handle currency selection
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Privacy & Security Section
            _buildSectionTitle('Privacy & Security'),
            _buildMenuSection(
              context,
              [
                _buildListTile(
                  context,
                  'Privacy Policy',
                  '',
                  Icons.privacy_tip,
                  () {
                    // Handle privacy policy
                  },
                ),
                _buildListTile(
                  context,
                  'Terms of Service',
                  '',
                  Icons.description,
                  () {
                    // Handle terms of service
                  },
                ),
                _buildListTile(
                  context,
                  'Data & Privacy',
                  '',
                  Icons.security,
                  () {
                    // Handle data privacy
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Support Section
            _buildSectionTitle('Support'),
            _buildMenuSection(
              context,
              [
                _buildListTile(
                  context,
                  'Help Center',
                  '',
                  Icons.help,
                  () {
                    // Handle help center
                  },
                ),
                _buildListTile(
                  context,
                  'Contact Support',
                  '',
                  Icons.support_agent,
                  () {
                    // Handle contact support
                  },
                ),
                _buildListTile(
                  context,
                  'Report a Bug',
                  '',
                  Icons.bug_report,
                  () {
                    // Handle bug report
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // About Section
            _buildSectionTitle('About'),
            _buildMenuSection(
              context,
              [
                _buildListTile(
                  context,
                  'App Version',
                  '1.0.0',
                  Icons.info,
                  null,
                ),
                _buildListTile(
                  context,
                  'Rate App',
                  '',
                  Icons.star,
                  () {
                    // Handle rate app
                  },
                ),
                _buildListTile(
                  context,
                  'Share App',
                  '',
                  Icons.share,
                  () {
                    // Handle share app
                  },
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Sign Out Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showSignOutDialog(context);
                },
                icon: const Icon(Icons.logout),
                label: const Text('Sign Out'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: items,
      ),
    );
  }

  Widget _buildListTile(BuildContext context, String title, String subtitle, IconData icon, VoidCallback? onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
      trailing: onTap != null ? const Icon(Icons.chevron_right) : null,
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile(BuildContext context, String title, String subtitle, bool value, Function(bool) onChanged) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final languages = ['English', 'Spanish', 'French', 'German', 'Italian'];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.map((language) {
            return RadioListTile<String>(
              title: Text(language),
              value: language,
              groupValue: _selectedLanguage,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedLanguage = value;
                  });
                  Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    final themes = ['System', 'Light', 'Dark'];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: themes.map((theme) {
            return RadioListTile<String>(
              title: Text(theme),
              value: theme,
              groupValue: _selectedTheme,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedTheme = value;
                  });
                  Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle sign out
              context.go('/auth/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
