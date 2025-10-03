# 🚀 Supabase Products Import Guide

## Quick Setup (3 Steps)

### Step 1: Go to Supabase Dashboard
1. Open your Supabase project dashboard
2. Go to **SQL Editor** (left sidebar)
3. Click **"New Query"**

### Step 2: Import the Data
1. Copy the contents of `import_sample_data.sql`
2. Paste it into the SQL Editor
3. Click **"Run"** button

### Step 3: Verify the Import
Run this query to check your data:
```sql
SELECT COUNT(*) FROM products;
SELECT * FROM products LIMIT 5;
```

## What This Does

✅ **Creates the products table** with all 10 columns
✅ **Inserts 20 sample products** with real food data
✅ **Adds proper indexes** for better performance
✅ **Sets up all the data** your Flutter app needs

## Expected Results

After running the import, you should see:
- **20 products** in your database
- **Categories**: Italian, American, Indian, Healthy, Thai, Japanese, etc.
- **Real images** from Unsplash
- **Proper ratings, prices, and descriptions**

## Test in Your App

1. **Hot reload** your Flutter app (press `r` in terminal)
2. **Check the home screen** - you should see real products now
3. **Tap "Test Products"** button to see the ProductTestScreen
4. **Images should load** properly from the URLs

## Troubleshooting

### If you see "No products found":
- Check your Supabase connection in `lib/core/app_config.dart`
- Make sure the table was created successfully
- Verify the data was inserted

### If images don't load:
- Check your internet connection
- The images are from Unsplash (external URLs)
- Make sure your app has internet permission

### If you get database errors:
- Make sure you're running the SQL in the correct Supabase project
- Check that you have the right permissions
- Try running the SQL in smaller chunks

## Next Steps

Once the data is imported:
1. **Test the app** - products should now show with real data
2. **Add more products** - use the Supabase dashboard to add more
3. **Customize** - modify the product data as needed
4. **Scale up** - add thousands of products for production

Your Flutter app is now connected to real Supabase data! 🎉
