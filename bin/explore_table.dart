import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

Future<void> main() async {
  print('Exploring Products table structure...');
  
  try {
    // Initialize Supabase
    await Supabase.initialize(
      url: 'https://jndmejkpnefigtjpbzmn.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpuZG1lamtwbmVmaWd0anBiem1uIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTkxMjMzNTgsImV4cCI6MjA3NDY5OTM1OH0.u7cVWlEx8SKzNboAxDc7XPdV0XZ4YBwmWSQjSM_2Z1k',
    );
    
    final supabase = Supabase.instance.client;
    print('Supabase initialized successfully');
    
    // Try to get table info
    print('Getting table info...');
    
    // First, let's try to get just one row to see the structure
    final sampleResponse = await supabase
        .from('Products')
        .select()
        .limit(1);
    
    print('Sample response: $sampleResponse');
    
    if (sampleResponse is List && sampleResponse.isNotEmpty) {
      final firstRow = sampleResponse[0];
      print('First row structure:');
      if (firstRow is Map<String, dynamic>) {
        firstRow.forEach((key, value) {
          print('  $key: $value (type: ${value.runtimeType})');
        });
      }
    }
    
    print('Exploration completed successfully');
  } catch (e) {
    print('Error during exploration: $e');
    exit(1);
  }
}