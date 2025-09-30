import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class CheckoutScreen extends StatefulWidget {
  final double subtotal;
  final double deliveryFee;
  final double taxes;
  final double total;
  final List<Map<String, dynamic>> cartItems;

  const CheckoutScreen({
    super.key,
    required this.subtotal,
    required this.deliveryFee,
    required this.taxes,
    required this.total,
    required this.cartItems,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _currentStep = 0;
  String _selectedAddress = 'Home';
  String _selectedPayment = 'Credit Card';
  String _deliveryInstructions = '';
  
  final List<Map<String, dynamic>> _addresses = [
    {
      'type': 'Home',
      'address': '123 Main Street, Apartment 4B',
      'city': 'Mumbai, Maharashtra 400001',
      'isDefault': true,
    },
    {
      'type': 'Work',
      'address': '456 Business Park, Tower 2',
      'city': 'Mumbai, Maharashtra 400070',
      'isDefault': false,
    },
  ];
  
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'type': 'Credit Card',
      'details': '**** **** **** 1234',
      'icon': Icons.credit_card,
    },
    {
      'type': 'UPI',
      'details': 'user@paytm',
      'icon': Icons.account_balance_wallet,
    },
    {
      'type': 'Cash on Delivery',
      'details': 'Pay when food arrives',
      'icon': Icons.money,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Stepper(
              currentStep: _currentStep,
              onStepTapped: (step) {
                setState(() {
                  _currentStep = step;
                });
              },
              controlsBuilder: (context, details) {
                return Row(
                  children: [
                    if (details.stepIndex < 2)
                      ElevatedButton(
                        onPressed: details.onStepContinue,
                        child: const Text('Continue'),
                      ),
                    if (details.stepIndex == 2)
                      ElevatedButton(
                        onPressed: _placeOrder,
                        child: const Text('Place Order'),
                      ),
                    const SizedBox(width: 8),
                    if (details.stepIndex > 0)
                      TextButton(
                        onPressed: details.onStepCancel,
                        child: const Text('Back'),
                      ),
                  ],
                );
              },
              steps: [
                Step(
                  title: const Text('Delivery Address'),
                  content: _buildAddressStep(),
                  isActive: _currentStep >= 0,
                  state: _currentStep > 0 ? StepState.complete : StepState.indexed,
                ),
                Step(
                  title: const Text('Payment Method'),
                  content: _buildPaymentStep(),
                  isActive: _currentStep >= 1,
                  state: _currentStep > 1 ? StepState.complete : 
                         _currentStep == 1 ? StepState.indexed : StepState.disabled,
                ),
                Step(
                  title: const Text('Review Order'),
                  content: _buildReviewStep(),
                  isActive: _currentStep >= 2,
                  state: _currentStep == 2 ? StepState.indexed : StepState.disabled,
                ),
              ],
              onStepContinue: () {
                if (_currentStep < 2) {
                  setState(() {
                    _currentStep += 1;
                  });
                }
              },
              onStepCancel: () {
                if (_currentStep > 0) {
                  setState(() {
                    _currentStep -= 1;
                  });
                }
              },
            ),
          ),
          _buildBottomSummary(),
        ],
      ),
    );
  }

  Widget _buildAddressStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose delivery address:',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        ...(_addresses.map((address) => _buildAddressCard(address))),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Add new address - Coming Soon'),
                backgroundColor: AppTheme.primaryColor,
              ),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text('Add New Address'),
        ),
        const SizedBox(height: 20),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Delivery Instructions (Optional)',
            hintText: 'e.g., Ring doorbell, Call when arrived',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            _deliveryInstructions = value;
          },
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildAddressCard(Map<String, dynamic> address) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: RadioListTile<String>(
        value: address['type'],
        groupValue: _selectedAddress,
        onChanged: (value) {
          setState(() {
            _selectedAddress = value!;
          });
        },
        title: Text(
          address['type'],
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(address['address']),
            Text(
              address['city'],
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
            if (address['isDefault'])
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'DEFAULT',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        activeColor: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildPaymentStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose payment method:',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        ...(_paymentMethods.map((payment) => _buildPaymentCard(payment))),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Add payment method - Coming Soon'),
                backgroundColor: AppTheme.primaryColor,
              ),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text('Add Payment Method'),
        ),
      ],
    );
  }

  Widget _buildPaymentCard(Map<String, dynamic> payment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(
          payment['icon'],
          color: AppTheme.primaryColor,
        ),
        title: Text(
          payment['type'],
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(payment['details']),
        trailing: Radio<String>(
          value: payment['type'],
          groupValue: _selectedPayment,
          onChanged: (value) {
            setState(() {
              _selectedPayment = value!;
            });
          },
          activeColor: AppTheme.primaryColor,
        ),
        onTap: () {
          setState(() {
            _selectedPayment = payment['type'];
          });
        },
      ),
    );
  }

  Widget _buildReviewStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Summary:',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        
        // Order Items
        ...widget.cartItems.map((item) => Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item['image'] ?? '',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.fastfood, color: AppTheme.primaryColor),
                ),
              ),
            ),
            title: Text(item['name'] ?? ''),
            subtitle: Text('Qty: ${item['quantity']}'),
            trailing: Text('₹${((item['price'] ?? 0) * (item['quantity'] ?? 1)).toStringAsFixed(0)}'),
          ),
        )),
        
        const SizedBox(height: 16),
        
        // Delivery Details
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Delivery Details',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: AppTheme.textSecondary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _addresses.firstWhere((addr) => addr['type'] == _selectedAddress)['address'],
                        style: const TextStyle(color: AppTheme.textSecondary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.payment, size: 16, color: AppTheme.textSecondary),
                    const SizedBox(width: 8),
                    Text(
                      _selectedPayment,
                      style: const TextStyle(color: AppTheme.textSecondary),
                    ),
                  ],
                ),
                if (_deliveryInstructions.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.note, size: 16, color: AppTheme.textSecondary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _deliveryInstructions,
                          style: const TextStyle(color: AppTheme.textSecondary),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Subtotal'),
              Text('₹${widget.subtotal.toStringAsFixed(0)}'),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Delivery Fee'),
              Text('₹${widget.deliveryFee.toStringAsFixed(0)}'),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Taxes'),
              Text('₹${widget.taxes.toStringAsFixed(0)}'),
            ],
          ),
          const Divider(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '₹${widget.total.toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _placeOrder() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Order Confirmed!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              size: 64,
              color: AppTheme.successColor,
            ),
            const SizedBox(height: 16),
            const Text('Your order has been placed successfully!'),
            const SizedBox(height: 8),
            Text(
              'Order ID: #${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Estimated delivery: 25-30 minutes',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back to cart
              Navigator.of(context).pop(); // Go back to home
            },
            child: const Text('Track Order'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back to cart
              Navigator.of(context).pop(); // Go back to home
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}