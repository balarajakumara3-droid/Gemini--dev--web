import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class CategorySlider extends StatelessWidget {
  const CategorySlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'name': 'Offers', 'icon': Icons.local_offer},
      {'name': 'Indian', 'icon': Icons.dinner_dining},
      {'name': 'Chinese', 'icon': Icons.ramen_dining},
      {'name': 'Italian', 'icon': Icons.local_pizza},
      {'name': 'Desserts', 'icon': Icons.icecream},
      {'name': 'Healthy', 'icon': Icons.spa},
      {'name': 'Breakfast', 'icon': Icons.free_breakfast},
    ];

    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Column(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    categories[index]['icon'] as IconData,
                    color: AppTheme.primaryColor,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  categories[index]['name'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}