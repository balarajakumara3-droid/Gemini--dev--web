import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class MortgageCalculatorScreen extends StatefulWidget {
  const MortgageCalculatorScreen({super.key});

  @override
  State<MortgageCalculatorScreen> createState() => _MortgageCalculatorScreenState();
}

class _MortgageCalculatorScreenState extends State<MortgageCalculatorScreen> {
  final TextEditingController _homePriceController = TextEditingController();
  final TextEditingController _downPaymentController = TextEditingController();
  final TextEditingController _interestRateController = TextEditingController();
  final TextEditingController _loanTermController = TextEditingController();
  
  double _homePrice = 0;
  double _downPayment = 0;
  double _interestRate = 0;
  double _loanTerm = 30;
  
  double _monthlyPayment = 0;
  double _totalInterest = 0;
  double _totalPayment = 0;
  double _loanAmount = 0;

  @override
  void initState() {
    super.initState();
    _homePriceController.text = '500000';
    _downPaymentController.text = '100000';
    _interestRateController.text = '6.5';
    _loanTermController.text = '30';
    _calculateMortgage();
  }

  @override
  void dispose() {
    _homePriceController.dispose();
    _downPaymentController.dispose();
    _interestRateController.dispose();
    _loanTermController.dispose();
    super.dispose();
  }

  void _calculateMortgage() {
    setState(() {
      _homePrice = double.tryParse(_homePriceController.text) ?? 0;
      _downPayment = double.tryParse(_downPaymentController.text) ?? 0;
      _interestRate = double.tryParse(_interestRateController.text) ?? 0;
      _loanTerm = double.tryParse(_loanTermController.text) ?? 30;
      
      _loanAmount = _homePrice - _downPayment;
      
      if (_loanAmount > 0 && _interestRate > 0 && _loanTerm > 0) {
        final monthlyRate = _interestRate / 100 / 12;
        final numberOfPayments = _loanTerm * 12;
        
        if (monthlyRate > 0) {
          _monthlyPayment = _loanAmount * 
              (monthlyRate * pow(1 + monthlyRate, numberOfPayments)) /
              (pow(1 + monthlyRate, numberOfPayments) - 1);
        } else {
          _monthlyPayment = _loanAmount / numberOfPayments;
        }
        
        _totalPayment = _monthlyPayment * numberOfPayments;
        _totalInterest = _totalPayment - _loanAmount;
      } else {
        _monthlyPayment = 0;
        _totalPayment = 0;
        _totalInterest = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mortgage Calculator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showInfo,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Loan Details',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Home Price
                    _buildInputField(
                      label: 'Home Price',
                      controller: _homePriceController,
                      prefix: '\$',
                      onChanged: _calculateMortgage,
                    ),
                    const SizedBox(height: 16),
                    
                    // Down Payment
                    _buildInputField(
                      label: 'Down Payment',
                      controller: _downPaymentController,
                      prefix: '\$',
                      onChanged: _calculateMortgage,
                    ),
                    const SizedBox(height: 16),
                    
                    // Interest Rate
                    _buildInputField(
                      label: 'Interest Rate',
                      controller: _interestRateController,
                      suffix: '%',
                      onChanged: _calculateMortgage,
                    ),
                    const SizedBox(height: 16),
                    
                    // Loan Term
                    _buildInputField(
                      label: 'Loan Term',
                      controller: _loanTermController,
                      suffix: 'years',
                      onChanged: _calculateMortgage,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Results Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monthly Payment',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '\$${_monthlyPayment.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'per month',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Breakdown
                    Text(
                      'Payment Breakdown',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    _buildBreakdownRow('Loan Amount', '\$${_loanAmount.toStringAsFixed(2)}'),
                    _buildBreakdownRow('Monthly Payment', '\$${_monthlyPayment.toStringAsFixed(2)}'),
                    _buildBreakdownRow('Total Interest', '\$${_totalInterest.toStringAsFixed(2)}'),
                    _buildBreakdownRow('Total Payment', '\$${_totalPayment.toStringAsFixed(2)}'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Affordability Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Affordability Check',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    _buildAffordabilityCard(
                      'Recommended Income',
                      '\$${(_monthlyPayment * 12 / 0.28).toStringAsFixed(0)}',
                      '28% of gross income',
                      Colors.green,
                    ),
                    const SizedBox(height: 12),
                    
                    _buildAffordabilityCard(
                      'Maximum Income',
                      '\$${(_monthlyPayment * 12 / 0.36).toStringAsFixed(0)}',
                      '36% of gross income',
                      Colors.orange,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _saveCalculation,
                    icon: const Icon(Icons.save),
                    label: const Text('Save Calculation'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _shareCalculation,
                    icon: const Icon(Icons.share),
                    label: const Text('Share'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    String? prefix,
    String? suffix,
    required VoidCallback onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
          ],
          onChanged: (_) => onChanged(),
          decoration: InputDecoration(
            prefixText: prefix,
            suffixText: suffix,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBreakdownRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAffordabilityCard(String title, String amount, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.account_balance_wallet, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  amount,
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: color.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mortgage Calculator Info'),
        content: const Text(
          'This calculator provides estimates based on standard mortgage calculations. '
          'Actual rates and terms may vary. Consult with a mortgage professional for '
          'accurate calculations.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _saveCalculation() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Calculation saved!')),
    );
  }

  void _shareCalculation() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Calculation shared!')),
    );
  }
}
