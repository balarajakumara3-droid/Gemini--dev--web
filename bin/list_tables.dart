import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

Future<void> main() async {
  print('Listing all tables...');
  
  try {
    // Initialize Supabase
    await Supabase.initialize(
      url: 'https://jndmejkpnefigtjpbzmn.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpuZG1lamtwbmVmaWd0anBiem1uIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTkxMjMzNTgsImV4cCI6MjA3NDY5OTM1OH0.u7cVWlEx8SKzNboAxDc7XPdV0XZ4YBwmWSQjSM_2Z1k',
    );
    
    final supabase = Supabase.instance.client;
    print('Supabase initialized successfully');
    
    // Try to list tables
    print('Getting table list...');
    
    // This is a simplified approach - in a real scenario, you might need to query 
    // the information schema or use Supabase's API to get table names
    final tableNames = [
      'products', 'Products', 'product', 'Product',
      'items', 'Items', 'food_items', 'Food_Items'
    ];
    
    for (final tableName in tableNames) {
      try {
        final response = await supabase
            .from(tableName)
            .select('id')
            .limit(1);
        
        if (response is List) {
          print('Table $tableName exists and has data: ${response.length} rows');
        } else {
          print('Table $tableName exists (response type: ${response.runtimeType})');
        }
      } catch (e) {
        print('Table $tableName does not exist or is inaccessible: $e');
      }
    }
    
    print('Table listing completed');
  } catch (e) {
    print('Error during table listing: $e');
    exit(1);
  }
}