# DEM03_lab_Inventoryand-Order-Management-System

## Overview
This project contains SQL scripts for an e-commerce inventory and order management system database with automated triggers and stored procedures for order processing and inventory management.

## 📚 Complete Documentation
**[📖 Read the Complete Codebase Walkthrough](CODEBASE_WALKTHROUGH.md)** - A comprehensive guide that tells the complete story of this system, including:
- How triggers work and when they fire
- The complete order creation flow
- Deep dive into the `ProcessNewOrder` stored procedure
- What happens behind the scenes at every step
- Real-world usage examples

## Contents
- **SQL_DDL.sql** - Data Definition Language scripts for creating database schema (tables, constraints, relationships)
- **SQL_DML.sql** - Data Manipulation Language scripts for inserting, updating, and querying data, including triggers, stored procedures, and views
- **extra_dummy_data.sql** - Additional test data for comprehensive testing
- **CODEBASE_WALKTHROUGH.md** - Complete documentation explaining triggers, procedures, and order flow
- **Database ER diagram (crow's foot).png** - Entity-relationship diagram

## Database Structure
The system manages:
- **Customer information** - Contact details and shipping addresses
- **Product catalog** - Products with categories and pricing
- **Inventory tracking** - Real-time stock levels with automatic updates
- **Order processing** - Orders with automated total calculation via triggers
- **Order items** - Individual line items with historical pricing

## Key Features

### 🎯 Automated Triggers
- **Auto-calculate order totals** - Triggers automatically update order totals when items are added, modified, or removed
- **Real-time updates** - No manual calculation needed, always accurate
- **3 trigger types** - Handle INSERT, UPDATE, and DELETE operations on order items

### 🔧 Stored Procedures
- **ProcessNewOrder** - Atomically process orders with stock validation, inventory reduction, and order creation
- **Transaction safety** - All-or-nothing operations prevent data corruption
- **Concurrency control** - Row-level locking prevents race conditions

### 📊 Views
- **CustomerSalesSummary** - Pre-calculated customer lifetime value and order statistics

## Usage

### Quick Start
1. **Create the database schema:**
   ```sql
   SOURCE SQL_DDL.sql;
   ```

2. **Populate with data and create triggers/procedures:**
   ```sql
   SOURCE SQL_DML.sql;
   ```

3. **Optionally add more test data:**
   ```sql
   SOURCE extra_dummy_data.sql;
   ```

### Creating Orders

**Method 1: Using Stored Procedure (Recommended)**
```sql
CALL ProcessNewOrder(customer_id, product_id, quantity);
-- Example:
CALL ProcessNewOrder(1, 3, 2);  -- Customer 1 orders 2 units of Product 3
```

**Method 2: Manual INSERT**
```sql
-- Create order
INSERT INTO Orders (customer_id, order_status) VALUES (1, 'Pending');
SET @order_id = LAST_INSERT_ID();

-- Add items (triggers automatically calculate totals)
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase)
VALUES (@order_id, 1, 2, 1200.00);
```

### What Happens When You Create an Order?

See the [complete walkthrough](CODEBASE_WALKTHROUGH.md) for detailed explanations, but in summary:

1. **Transaction begins** 🔒
2. **Stock is validated** - Ensures sufficient inventory
3. **Inventory is reduced** - quantity_on_hand decreases
4. **Order record created** - New entry in Orders table  
5. **Order items added** - Products linked to order
6. **Triggers fire automatically** - Order total calculated
7. **Transaction commits** - All changes saved ✅

**Every modification to order items triggers automatic total recalculation!**

## Learn More

For a complete understanding of how this system works, including:
- The complete story of order creation
- How triggers work internally
- Transaction management and concurrency control
- Real-world examples and use cases

👉 **[Read the Complete Walkthrough](CODEBASE_WALKTHROUGH.md)**
