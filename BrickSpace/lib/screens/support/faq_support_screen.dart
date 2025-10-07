import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FAQSupportScreen extends StatefulWidget {
  const FAQSupportScreen({super.key});

  @override
  State<FAQSupportScreen> createState() => _FAQSupportScreenState();
}

class _FAQSupportScreenState extends State<FAQSupportScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedUserType = 'Buyer';
  final Map<String, bool> _expandedItems = {};

  final List<Map<String, dynamic>> _supportOptions = [
    {
      'title': 'Visit our website',
      'icon': Icons.language,
      'action': () {},
    },
    {
      'title': 'Email us',
      'icon': Icons.email,
      'action': () {},
    },
    {
      'title': 'Terms of service',
      'icon': Icons.description,
      'action': () {},
    },
  ];

  final List<Map<String, dynamic>> _faqItems = [
    {
      'question': 'What is Rise Real Estate?',
      'answer': '',
      'isExpanded': false,
    },
    {
      'question': 'Why choose buy in Rise?',
      'answer': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
      'isExpanded': true,
    },
    {
      'question': 'How do I create an account?',
      'answer': 'To create an account, simply click on the "Register" button and fill in your details. You will receive an OTP to verify your email address.',
      'isExpanded': false,
    },
    {
      'question': 'How do I search for properties?',
      'answer': 'You can search for properties using the search bar on the home screen. You can filter by location, price range, property type, and other criteria.',
      'isExpanded': false,
    },
    {
      'question': 'How do I contact an agent?',
      'answer': 'You can contact an agent by clicking on their profile or using the "Start Chat" button on their profile page.',
      'isExpanded': false,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Login / FAQ',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'FAQ & Support',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF212121),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Find answer to your problem using this app.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF757575),
              ),
            ),
            const SizedBox(height: 24),
            // Support options
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: _supportOptions.map((option) {
                  return ListTile(
                    leading: Icon(
                      option['icon'],
                      color: const Color(0xFF2E7D32),
                    ),
                    title: Text(
                      option['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF212121),
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF757575),
                      size: 16,
                    ),
                    onTap: option['action'],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            // Search bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
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
                  const Icon(
                    Icons.search,
                    color: Color(0xFF757575),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: "Try find 'how to'",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Color(0xFF757575),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // User type selection
            Row(
              children: [
                Expanded(
                  child: _buildUserTypeButton('Buyer', _selectedUserType == 'Buyer'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildUserTypeButton('Estate Agent', _selectedUserType == 'Estate Agent'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // FAQ Items
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: _faqItems.map((item) {
                  final isExpanded = _expandedItems[item['question']] ?? item['isExpanded'];
                  return ExpansionTile(
                    title: Text(
                      item['question'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF212121),
                      ),
                    ),
                    trailing: Icon(
                      isExpanded ? Icons.remove : Icons.add,
                      color: const Color(0xFF757575),
                    ),
                    initiallyExpanded: item['isExpanded'],
                    onExpansionChanged: (expanded) {
                      setState(() {
                        _expandedItems[item['question']] = expanded;
                      });
                    },
                    children: [
                      if (item['answer'].isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            item['answer'],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF757575),
                              height: 1.5,
                            ),
                          ),
                        ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserTypeButton(String title, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedUserType = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2E7D32) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF2E7D32) : Colors.grey[300]!,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF757575),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
