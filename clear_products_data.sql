-- Clear all data from Products table
-- Run this in your Supabase SQL Editor

DELETE FROM "Products";

-- Verify the table is empty
SELECT COUNT(*) as total_products FROM "Products";
