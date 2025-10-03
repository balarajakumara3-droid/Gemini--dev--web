# Product Import Guide

This guide will help you import products into your Supabase PostgreSQL database.

## Prerequisites

1. **Supabase Project**: Make sure you have a Supabase project set up
2. **Database Credentials**: You'll need your database connection details
3. **PostgreSQL Client**: Install `psql` if not already installed

## Step 1: Get Your Database Connection Details

From your Supabase dashboard:
1. Go to **Settings** → **Database**
2. Find your **Connection string** under "Connection parameters"
3. Copy the connection string (it looks like: `postgresql://postgres:[YOUR-PASSWORD]@db.[YOUR-PROJECT-REF].supabase.co:5432/postgres`)

## Step 2: Create the Products Table

Run this command to create the products table:

```bash
psql "postgresql://postgres:YOUR_PASSWORD@YOUR_SUPABASE_HOST:5432/postgres" -f create_products_table.sql
```

Or manually run the SQL:

```sql
CREATE TABLE IF NOT EXISTS products (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    image_url TEXT,
    description TEXT,
    category VARCHAR(100),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

## Step 3: Import Products from CSV

Use the COPY command to import your products:

```bash
psql "postgresql://postgres:YOUR_PASSWORD@YOUR_SUPABASE_HOST:5432/postgres" -c "\COPY products(name,price,image_url,description,category) FROM 'products.csv' DELIMITER ',' CSV HEADER;"
```

## Step 4: Verify the Import

Check that your products were imported successfully:

```bash
psql "postgresql://postgres:YOUR_PASSWORD@YOUR_SUPABASE_HOST:5432/postgres" -c "SELECT COUNT(*) FROM products;"
```

View all products:

```bash
psql "postgresql://postgres:YOUR_PASSWORD@YOUR_SUPABASE_HOST:5432/postgres" -c "SELECT * FROM products LIMIT 10;"
```

## Step 5: Use the Product Service in Flutter

The `ProductService` class has been created to interact with your products table:

```dart
import 'package:your_app/core/services/product_service.dart';

final productService = ProductService();

// Get all products
final products = await productService.getAllProducts();

// Get products by category
final italianProducts = await productService.getProductsByCategory('Italian');

// Search products
final searchResults = await productService.searchProducts('pizza');
```

## CSV Format

Your `products.csv` file should have this format:

```csv
name,price,image_url,description,category
Margherita Pizza,12.99,https://example.com/pizza.jpg,Classic Italian pizza,Italian
Cheeseburger,8.99,https://example.com/burger.jpg,Beef patty with cheese,American
```

## Troubleshooting

### Common Issues:

1. **Connection Refused**: Check your Supabase host and credentials
2. **Table Doesn't Exist**: Run the table creation SQL first
3. **Permission Denied**: Make sure you're using the correct database user
4. **CSV Format Error**: Ensure your CSV has the exact column names and no extra spaces

### Alternative Import Methods:

1. **Supabase Dashboard**: Use the Table Editor to manually add products
2. **Supabase API**: Use the REST API to insert products programmatically
3. **Flutter App**: Use the ProductService to add products through your app

## Next Steps

1. Update your Flutter app to use the ProductService
2. Create UI components to display products
3. Implement search and filtering functionality
4. Add product management features for admins
