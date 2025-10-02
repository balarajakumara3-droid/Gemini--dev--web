# Excel File Integration Guide

## 📁 How to Add Your XLSX File

### Step 1: Copy your XLSX file to the project
```bash
# Copy your Excel file to the assets/data folder
cp /path/to/your/file.xlsx assets/data/your_file.xlsx
```

### Step 2: Update the file name in the code
In `lib/features/demo/screens/excel_demo_screen.dart`, change line 15:
```dart
String _fileName = 'your_actual_file_name.xlsx'; // Change this to your file name
```

### Step 3: Access the Excel Demo Screen
Navigate to the Excel Demo screen using:
```dart
Navigator.pushNamed(context, '/excel-demo');
```

## 🔧 Using Excel Service in Your App

### Basic Usage Examples:

#### 1. Read All Data
```dart
final excelService = ExcelService();
List<Map<String, dynamic>> data = await excelService.readExcelData('your_file.xlsx');

for (var row in data) {
  print('Row data: $row');
}
```

#### 2. Read Specific Sheet
```dart
List<Map<String, dynamic>> data = await excelService.readExcelData(
  'your_file.xlsx', 
  sheetName: 'Sheet1'
);
```

#### 3. Get Sheet Names
```dart
List<String> sheets = await excelService.getSheetNames('your_file.xlsx');
print('Available sheets: $sheets');
```

#### 4. Get Column Headers
```dart
List<String> headers = await excelService.getColumnHeaders('your_file.xlsx');
print('Columns: $headers');
```

#### 5. Search in Excel Data
```dart
List<Map<String, dynamic>> results = await excelService.searchInExcel(
  'your_file.xlsx', 
  'search_term'
);
```

#### 6. Read Specific Columns Only
```dart
List<Map<String, dynamic>> data = await excelService.readSpecificColumns(
  'your_file.xlsx',
  ['Name', 'Price', 'Category'] // Only these columns
);
```

#### 7. Convert to Model Objects
```dart
// If you have a Food model
List<Food> foods = await excelService.convertToModels<Food>(
  'food_data.xlsx',
  (json) => Food.fromJson(json)
);
```

## 📊 Example Excel File Structure

Your Excel file should have headers in the first row:

| Name | Category | Price | Description | Image |
|------|----------|-------|-------------|-------|
| Pizza Margherita | Pizza | 12.99 | Classic pizza with tomato and mozzarella | pizza1.jpg |
| Cheeseburger | Burger | 8.99 | Beef patty with cheese | burger1.jpg |
| Salmon Sushi | Sushi | 15.99 | Fresh salmon sushi roll | sushi1.jpg |

## 🎯 Integration with Food Models

### Convert Excel Data to Food Items:
```dart
Future<List<Food>> loadFoodFromExcel() async {
  try {
    final excelService = ExcelService();
    List<Map<String, dynamic>> data = await excelService.readExcelData('food_menu.xlsx');
    
    return data.map((row) => Food(
      id: row['ID'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: row['Name'] ?? '',
      description: row['Description'] ?? '',
      imageUrl: row['Image'] ?? '',
      price: double.tryParse(row['Price']?.toString() ?? '0') ?? 0.0,
      category: row['Category'] ?? '',
      isVegetarian: row['Vegetarian']?.toString().toLowerCase() == 'true',
      isAvailable: row['Available']?.toString().toLowerCase() != 'false',
    )).toList();
  } catch (e) {
    print('Error loading food from Excel: $e');
    return [];
  }
}
```

### Use in Restaurant Provider:
```dart
class RestaurantProvider extends ChangeNotifier {
  List<Food> _menuItems = [];
  
  Future<void> loadMenuFromExcel(String fileName) async {
    try {
      final excelService = ExcelService();
      List<Map<String, dynamic>> data = await excelService.readExcelData(fileName);
      
      _menuItems = data.map((row) => Food.fromExcelRow(row)).toList();
      notifyListeners();
    } catch (e) {
      print('Error loading menu: $e');
    }
  }
}
```

## 🚀 Quick Start

1. **✅ Excel service created** (Already done)
2. **✅ Demo screen created** (Already done)
3. **✅ Routes updated** (Already done)
4. **✅ Dependencies added** (Already done)
5. **📁 Add your XLSX file** to `assets/data/`
6. **🔧 Update file name** in excel_demo_screen.dart
7. **🧪 Test the integration** using the demo screen

## 🔍 Testing Your Excel Integration

### Navigate to Excel Demo Screen:
```dart
// From any screen in your app
Navigator.pushNamed(context, '/excel-demo');
```

### Or add a button to your main screen:
```dart
ElevatedButton(
  onPressed: () {
    Navigator.pushNamed(context, '/excel-demo');
  },
  child: Text('View Excel Data'),
)
```

## 📝 Supported Excel Features

- ✅ Read .xlsx files
- ✅ Multiple sheets support
- ✅ Column headers detection
- ✅ Data type conversion
- ✅ Search functionality
- ✅ Specific column reading
- ✅ Model conversion
- ✅ Error handling

## ⚠️ Important Notes

1. **File Size**: Keep Excel files under 10MB for better performance
2. **Headers**: First row should contain column headers
3. **Data Types**: All data is read as strings, convert as needed
4. **Memory**: Large files may impact app performance
5. **Assets**: Remember to run `flutter pub get` after adding files

## 🐛 Troubleshooting

### Common Issues:

**File not found error:**
- Check file path: `assets/data/your_file.xlsx`
- Verify file name in code matches actual file name
- Run `flutter pub get` after adding the file

**Empty data:**
- Check if Excel file has data in first sheet
- Verify headers are in first row
- Check for hidden characters in file

**Performance issues:**
- Reduce file size
- Read specific columns only
- Implement pagination for large datasets
