import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../models/property.dart';
import '../../providers/property_provider.dart';
import '../../widgets/custom_button.dart';

class PropertySharingScreen extends StatelessWidget {
  final String propertyId;
  
  const PropertySharingScreen({super.key, required this.propertyId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Property'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: Consumer<PropertyProvider>(
        builder: (context, propertyProvider, child) {
          final property = propertyProvider.getPropertyById(propertyId);
          
          if (property == null) {
            return const Center(child: Text('Property not found'));
          }
          
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPropertyCard(property),
                const SizedBox(height: 30),
                const Text(
                  'Share via',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildSharingOptions(context, property),
                const SizedBox(height: 30),
                const Text(
                  'Copy link',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildCopyLinkSection(context, property),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildPropertyCard(Property property) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              property.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  property.location,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  property.formattedPrice,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4CAF50),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSharingOptions(BuildContext context, Property property) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSocialShareOption(
              context,
              Icons.message,
              'Messages',
              () => _shareViaMessages(context, property),
            ),
            _buildSocialShareOption(
              context,
              Icons.email,
              'Email',
              () => _shareViaEmail(context, property),
            ),
            _buildSocialShareOption(
              context,
              Icons.link,
              'Copy Link',
              () => _copyLink(context, property),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSocialShareOption(
              context,
              Icons.share,
              'More',
              () => _shareViaSystem(context, property),
            ),
            _buildSocialShareOption(
              context,
              Icons.facebook,
              'Facebook',
              () => _shareViaFacebook(context, property),
            ),
            _buildSocialShareOption(
              context,
              Icons.chat,
              'WhatsApp',
              () => _shareViaWhatsApp(context, property),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildSocialShareOption(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: const Color(0xFF4CAF50), size: 30),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
  
  Widget _buildCopyLinkSection(BuildContext context, Property property) {
    final propertyLink = 'https://brickspacerealestate.co...';
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              propertyLink,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => _copyLinkToClipboard(context, 'https://brickspacerealestate.com/properties/${property.id}'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Copy',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _shareViaMessages(BuildContext context, Property property) {
    // In a real app, you would integrate with the device's messaging system
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sharing via Messages'),
        backgroundColor: Color(0xFF4CAF50),
      ),
    );
    context.pop();
  }
  
  void _shareViaEmail(BuildContext context, Property property) {
    // In a real app, you would integrate with the device's email system
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sharing via Email'),
        backgroundColor: Color(0xFF4CAF50),
      ),
    );
    context.pop();
  }
  
  void _copyLink(BuildContext context, Property property) {
    final propertyLink = 'https://brickspacerealestate.com/properties/${property.id}';
    _copyLinkToClipboard(context, propertyLink);
  }
  
  void _shareViaSystem(BuildContext context, Property property) {
    // In a real app, you would use the share package to share via system dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sharing via system dialog'),
        backgroundColor: Color(0xFF4CAF50),
      ),
    );
    context.pop();
  }
  
  void _shareViaFacebook(BuildContext context, Property property) {
    // In a real app, you would integrate with Facebook
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sharing via Facebook'),
        backgroundColor: Color(0xFF4CAF50),
      ),
    );
    context.pop();
  }
  
  void _shareViaWhatsApp(BuildContext context, Property property) {
    // In a real app, you would integrate with WhatsApp
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sharing via WhatsApp'),
        backgroundColor: Color(0xFF4CAF50),
      ),
    );
    context.pop();
  }
  
  void _copyLinkToClipboard(BuildContext context, String link) {
    // In a real app, you would use the clipboard package to copy to clipboard
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Link copied to clipboard: $link'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
    );
  }
}