import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../models/property.dart';
import '../../providers/auth_provider.dart';
import '../../providers/property_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class PropertyBookingScreen extends StatefulWidget {
  final String propertyId;
  
  const PropertyBookingScreen({super.key, required this.propertyId});

  @override
  State<PropertyBookingScreen> createState() => _PropertyBookingScreenState();
}

class _PropertyBookingScreenState extends State<PropertyBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _visitType = 'in-person';
  
  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book a Visit'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: Consumer2<PropertyProvider, AuthProvider>(
        builder: (context, propertyProvider, authProvider, child) {
          final property = propertyProvider.getPropertyById(widget.propertyId);
          
          if (property == null) {
            return const Center(child: Text('Property not found'));
          }
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPropertySummary(property),
                  const SizedBox(height: 30),
                  _buildBookingForm(property),
                  const SizedBox(height: 30),
                  _buildBookingSummary(property),
                  const SizedBox(height: 30),
                  CustomButton(
                    text: 'Confirm Booking',
                    onPressed: () => _confirmBooking(property),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildPropertySummary(Property property) {
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
  
  Widget _buildBookingForm(Property property) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Visit Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Container(
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
          child: Column(
            children: [
              _buildDateSelector(),
              const SizedBox(height: 20),
              _buildTimeSelector(),
              const SizedBox(height: 20),
              _buildVisitTypeSelector(),
              const SizedBox(height: 20),
              _buildNotesField(),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Date',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedDate == null
                      ? 'Select a date'
                      : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                  style: TextStyle(
                    fontSize: 16,
                    color: _selectedDate == null ? Colors.grey : Colors.black,
                  ),
                ),
                const Icon(Icons.calendar_today, color: Color(0xFF4CAF50)),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildTimeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Time',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _selectTime,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedTime == null
                      ? 'Select a time'
                      : '${_selectedTime!.hour}:${_selectedTime!.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 16,
                    color: _selectedTime == null ? Colors.grey : Colors.black,
                  ),
                ),
                const Icon(Icons.access_time, color: Color(0xFF4CAF50)),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildVisitTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Visit Type',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildVisitTypeOption('in-person', 'In-person'),
            const SizedBox(width: 16),
            _buildVisitTypeOption('virtual', 'Virtual Tour'),
          ],
        ),
      ],
    );
  }
  
  Widget _buildVisitTypeOption(String value, String label) {
    final isSelected = _visitType == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _visitType = value;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF4CAF50) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFF4CAF50) : Colors.grey[300]!,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Additional Notes',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        CustomTextField(
          controller: _notesController,
          label: 'Notes',
          hint: 'Any special requests or notes...',
          maxLines: 3,
          onChanged: (value) => {},
        ),
      ],
    );
  }
  
  Widget _buildBookingSummary(Property property) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Booking Summary',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryRow('Property', property.title),
          const SizedBox(height: 8),
          _buildSummaryRow(
            'Date', 
            _selectedDate == null 
                ? 'Not selected' 
                : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
          ),
          const SizedBox(height: 8),
          _buildSummaryRow(
            'Time', 
            _selectedTime == null 
                ? 'Not selected' 
                : '${_selectedTime!.hour}:${_selectedTime!.minute.toString().padLeft(2, '0')}'
          ),
          const SizedBox(height: 8),
          _buildSummaryRow(
            'Visit Type', 
            _visitType == 'in-person' ? 'In-person' : 'Virtual Tour'
          ),
          const SizedBox(height: 8),
          if (_notesController.text.isNotEmpty)
            _buildSummaryRow('Notes', _notesController.text),
        ],
      ),
    );
  }
  
  Widget _buildSummaryRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
  
  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
  
  void _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }
  
  void _confirmBooking(Property property) {
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select date and time for the visit'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    if (_formKey.currentState!.validate()) {
      // In a real app, you would send this data to your backend
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking confirmed! You will receive a confirmation email.'),
          backgroundColor: Color(0xFF4CAF50),
        ),
      );
      
      // Navigate back to property detail screen
      context.pop();
    }
  }
}