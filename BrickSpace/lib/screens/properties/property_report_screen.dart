import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../models/property.dart';
import '../../providers/property_provider.dart';
import '../../widgets/custom_button.dart';

class PropertyReportScreen extends StatefulWidget {
  final String propertyId;
  
  const PropertyReportScreen({super.key, required this.propertyId});

  @override
  State<PropertyReportScreen> createState() => _PropertyReportScreenState();
}

class _PropertyReportScreenState extends State<PropertyReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  String _reportReason = 'inappropriate';
  
  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Property'),
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
          final property = propertyProvider.getPropertyById(widget.propertyId);
          
          if (property == null) {
            return const Center(child: Text('Property not found'));
          }
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPropertyHeader(property),
                const SizedBox(height: 30),
                _buildReportForm(),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildPropertyHeader(Property property) {
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
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[300],
                  child: const Icon(Icons.home, color: Colors.grey),
                );
              },
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
  
  Widget _buildReportForm() {
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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Why are you reporting this property?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildReasonSelector(),
            const SizedBox(height: 20),
            const Text(
              'Additional Details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Please provide any additional details about your report...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'By submitting this report, you acknowledge that:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '• Your report will be reviewed by our team\n• False reports may result in account restrictions\n• We will not share your identity with the property owner',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Submit Report',
              onPressed: _submitReport,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildReasonSelector() {
    final reasons = {
      'inappropriate': 'Inappropriate content',
      'fraud': 'Suspected fraud or scam',
      'duplicate': 'Duplicate listing',
      'incorrect': 'Incorrect information',
      'other': 'Other reason',
    };
    
    return Column(
      children: reasons.entries.map((entry) {
        return RadioListTile<String>(
          title: Text(entry.value),
          value: entry.key,
          groupValue: _reportReason,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _reportReason = value;
              });
            }
          },
        );
      }).toList(),
    );
  }
  
  void _submitReport() {
    if (_formKey.currentState!.validate()) {
      // In a real app, you would submit this report to your backend
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Report submitted successfully. Thank you for helping us keep our community safe.'),
          backgroundColor: Color(0xFF4CAF50),
        ),
      );
      
      // Clear form
      _descriptionController.clear();
      setState(() {
        _reportReason = 'inappropriate';
      });
      
      // Navigate back
      context.pop();
    }
  }
}