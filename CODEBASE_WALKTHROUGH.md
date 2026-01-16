# Inventory and Order Management System - Complete Walkthrough

## Table of Contents
1. [System Overview](#system-overview)
2. [Database Architecture](#database-architecture)
3. [The Story: What Happens When an Order is Created](#the-story-what-happens-when-an-order-is-created)
4. [Triggers Deep Dive](#triggers-deep-dive)
5. [Stored Procedures Deep Dive](#stored-procedures-deep-dive)
6. [Views and Optimization](#views-and-optimization)
7. [Complete Order Flow Diagram](#complete-order-flow-diagram)

---

## System Overview

This is a **MySQL-based Inventory and Order Management System** for an e-commerce platform. The system manages:
- **Customers**: People who place orders
- **Products**: Items available for purchase
- **Inventory**: Stock levels for each product
- **Orders**: Customer purchase records
- **Order Items**: Individual products within each order

The system uses **triggers** and **stored procedures** to automate business logic and maintain data integrity.

---

## Database Architecture

### Tables and Relationships

```
Customers (1) ──────┐
                    │
                    │ (1:Many)
                    ▼
                 Orders (1) ──────┐
                                  │
                                  │ (1:Many)
                                  ▼
Products (1) ────────────────► Order_Items
    │
    │ (1:1)
    ▼
Inventory
```

### Table Descriptions

#### 1. **Customers Table**
Stores customer information including contact details and shipping addresses.

**Key Fields:**
- `customer_id` (PK): Unique customer identifier
- `full_name`: Customer's full name
- `email`: Unique email address
- `phone`: Contact number
- `shipping_address`: Delivery address

**Constraints:**
- Email must be unique
- All fields except phone are required

---

#### 2. **Products Table**
Catalog of all products available for sale.

**Key Fields:**
- `product_id` (PK): Unique product identifier
- `product_name`: Name of the product
- `category`: Product category (Electronics, Furniture, Appliances, Apparel, Books)
- `price`: Current selling price

**Constraints:**
- Price must be >= 0 (CHECK constraint)

---

#### 3. **Inventory Table**
Tracks stock levels for each product.

**Key Fields:**
- `inventory_id` (PK): Unique inventory record identifier
- `product_id` (FK → Products, UNIQUE): One inventory record per product
- `quantity_on_hand`: Current stock level
- `last_updated`: Timestamp of last update (auto-updated)

**Constraints:**
- Each product can have only ONE inventory record (UNIQUE constraint)
- Quantity must be >= 0 (CHECK constraint)
- ON DELETE CASCADE: If product is deleted, inventory record is deleted

---

#### 4. **Orders Table**
Records of customer purchases.

**Key Fields:**
- `order_id` (PK): Unique order identifier
- `customer_id` (FK → Customers): Who placed the order
- `order_date`: When the order was placed (auto-set to current timestamp)
- `total_amount`: Total cost of the order (auto-calculated by triggers)
- `order_status`: Current status (Pending, Shipped, Delivered)

**Constraints:**
- Total amount must be >= 0
- ON DELETE RESTRICT: Cannot delete customer with existing orders

---

#### 5. **Order_Items Table**
Individual line items within each order.

**Key Fields:**
- `order_item_id` (PK): Unique order item identifier
- `order_id` (FK → Orders): Which order this item belongs to
- `product_id` (FK → Products): Which product was ordered
- `quantity`: How many units were ordered
- `price_at_purchase`: Price at the time of purchase (may differ from current price)

**Constraints:**
- Quantity must be > 0
- Price must be >= 0
- UNIQUE constraint on (order_id, product_id): Can't add same product twice to one order
- ON DELETE CASCADE: If order is deleted, all order items are deleted
- ON DELETE RESTRICT: Cannot delete product if it's in any order

---

## The Story: What Happens When an Order is Created

Let me tell you the complete story of what happens in this system when a customer places an order. There are **two different ways** an order can be created, and each has a different flow.

### Scenario 1: Manual Order Creation (Direct INSERT)

**The Setup:**
A customer walks into the store, and an employee manually creates their order by inserting records into the database.

**Step-by-Step Flow:**

#### 📋 **Step 1: Create the Order Record**
```sql
INSERT INTO Orders (customer_id, order_date, total_amount, order_status)
VALUES (1, NOW(), 0.00, 'Pending');
```

**What Happens:**
- A new order record is created
- `order_id` is auto-generated (e.g., 100)
- `total_amount` starts at 0.00
- `order_status` defaults to 'Pending'
- `order_date` is set to current timestamp
- **No triggers fire yet** - we just have an empty order

---

#### 🛒 **Step 2: Add First Product to Order**
```sql
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase)
VALUES (100, 1, 2, 1200.00);  -- 2 Laptop Pros at $1,200 each
```

**🎯 TRIGGER FIRES: `trg_update_order_total_after_insert`**

This is where the magic happens! The moment we insert an order item, this trigger automatically fires.

**What the Trigger Does:**

1. **Receives the NEW record:**
   - NEW.order_id = 100
   - NEW.product_id = 1
   - NEW.quantity = 2
   - NEW.price_at_purchase = 1200.00

2. **Calculates the order total:**
   ```sql
   UPDATE Orders
   SET total_amount = (
       SELECT COALESCE(SUM(quantity * price_at_purchase), 0)
       FROM Order_Items
       WHERE order_id = 100
   )
   WHERE order_id = 100;
   ```

3. **Updates the Orders table:**
   - Order 100's `total_amount` changes from 0.00 to **$2,400.00** (2 × $1,200)

**Current State:**
- Order 100: total_amount = $2,400.00
- Order Items: 1 item (2 Laptop Pros)

---

#### 🛒 **Step 3: Add Second Product to Order**
```sql
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase)
VALUES (100, 2, 1, 150.00);  -- 1 Wireless Headphones at $150
```

**🎯 TRIGGER FIRES AGAIN: `trg_update_order_total_after_insert`**

**What the Trigger Does:**

1. **Receives the NEW record:**
   - NEW.order_id = 100
   - NEW.product_id = 2
   - NEW.quantity = 1
   - NEW.price_at_purchase = 150.00

2. **Re-calculates the ENTIRE order total:**
   ```sql
   SELECT SUM(quantity * price_at_purchase) FROM Order_Items WHERE order_id = 100
   -- Result: (2 × 1200) + (1 × 150) = $2,550.00
   ```

3. **Updates the Orders table:**
   - Order 100's `total_amount` changes from $2,400.00 to **$2,550.00**

**Current State:**
- Order 100: total_amount = $2,550.00
- Order Items: 2 items (2 Laptop Pros + 1 Headphones)

---

#### ✏️ **Step 4: Customer Changes Their Mind - Update Quantity**
The customer decides they only want 1 laptop instead of 2.

```sql
UPDATE Order_Items
SET quantity = 1
WHERE order_id = 100 AND product_id = 1;
```

**🎯 TRIGGER FIRES: `trg_update_order_total_after_update`**

**What the Trigger Does:**

1. **Receives NEW and OLD records:**
   - OLD.quantity = 2
   - NEW.quantity = 1
   - NEW.order_id = 100

2. **Re-calculates the order total:**
   ```sql
   SELECT SUM(quantity * price_at_purchase) FROM Order_Items WHERE order_id = 100
   -- Result: (1 × 1200) + (1 × 150) = $1,350.00
   ```

3. **Updates the Orders table:**
   - Order 100's `total_amount` changes from $2,550.00 to **$1,350.00**

**Current State:**
- Order 100: total_amount = $1,350.00
- Order Items: 2 items (1 Laptop Pro + 1 Headphones)

---

#### ❌ **Step 5: Customer Removes the Headphones**
```sql
DELETE FROM Order_Items
WHERE order_id = 100 AND product_id = 2;
```

**🎯 TRIGGER FIRES: `trg_update_order_total_after_delete`**

**What the Trigger Does:**

1. **Receives the OLD record (the deleted item):**
   - OLD.order_id = 100
   - OLD.product_id = 2
   - OLD.quantity = 1
   - OLD.price_at_purchase = 150.00

2. **Re-calculates the order total (excluding deleted item):**
   ```sql
   SELECT SUM(quantity * price_at_purchase) FROM Order_Items WHERE order_id = 100
   -- Result: (1 × 1200) = $1,200.00
   ```

3. **Updates the Orders table:**
   - Order 100's `total_amount` changes from $1,350.00 to **$1,200.00**

**Final State:**
- Order 100: total_amount = $1,200.00
- Order Items: 1 item (1 Laptop Pro)
- **The order total is ALWAYS accurate** thanks to the triggers!

---

### Scenario 2: Automated Order Creation Using Stored Procedure

Now let me tell you about the **more sophisticated way** to create orders using the `ProcessNewOrder` stored procedure. This is the **recommended approach** because it handles stock management automatically.

**The Setup:**
A customer wants to buy a product through an automated system (like a website). The system needs to:
1. Check if there's enough stock
2. Reduce the inventory
3. Create the order
4. All in one atomic transaction

---

#### 🚀 **The Stored Procedure Call**
```sql
CALL ProcessNewOrder(1, 3, 2);
-- Customer 1 wants to buy 2 units of Product 3 (Ergonomic Chair)
```

**Let's follow the execution step-by-step:**

---

#### **Phase 1: Transaction Starts** 🔒
```sql
START TRANSACTION;
```
**What This Means:**
- All subsequent operations are grouped together
- If anything fails, EVERYTHING is rolled back
- No partial updates can occur
- Database locks are acquired to prevent conflicts

---

#### **Phase 2: Check Stock and Price** 📊
```sql
SELECT quantity_on_hand, price INTO v_stock, v_price
FROM Products p
JOIN Inventory i ON p.product_id = i.product_id
WHERE p.product_id = 3
FOR UPDATE;  -- CRITICAL: Locks these rows!
```

**What Happens:**
1. **Joins Products and Inventory tables:**
   - Product 3 (Ergonomic Chair): price = $300.00
   - Inventory for Product 3: quantity_on_hand = 20

2. **Stores values in variables:**
   - `v_price` = 300.00
   - `v_stock` = 20

3. **FOR UPDATE clause:**
   - **Locks the inventory row** for Product 3
   - **Prevents race conditions**: If two customers try to order the last item simultaneously, only one will succeed
   - Other transactions must wait until this transaction completes

**Current State:**
- v_price = $300.00
- v_stock = 20
- Inventory row for Product 3 is LOCKED 🔒

---

#### **Phase 3: Stock Validation** ✅
```sql
IF v_stock >= p_quantity THEN  -- Is 20 >= 2? YES!
```

**Decision Point:**
- We need 2 chairs
- We have 20 chairs in stock
- ✅ Condition is TRUE → Proceed with order
- ❌ If FALSE → Jump to ELSE block and rollback

**In Our Case:** We have enough stock, so we continue...

---

#### **Phase 4: Reduce Inventory** 📦➖
```sql
UPDATE Inventory 
SET quantity_on_hand = quantity_on_hand - 2  -- 20 - 2 = 18
WHERE product_id = 3;
```

**What Happens:**
1. **Updates the inventory record:**
   - Old quantity: 20
   - New quantity: 18
   - `last_updated` timestamp is automatically updated (ON UPDATE CURRENT_TIMESTAMP)

2. **Inventory is reduced BEFORE the order is created:**
   - This prevents overselling
   - If the order creation fails later, the transaction will rollback this change too

**Current State:**
- Inventory for Product 3: quantity_on_hand = 18
- Transaction is still ACTIVE (not committed)

---

#### **Phase 5: Create Order Record** 📝
```sql
INSERT INTO Orders (customer_id, order_date, total_amount, order_status)
VALUES (1, NOW(), 600.00, 'Pending');  -- 2 × $300 = $600

SET v_order_id = LAST_INSERT_ID();  -- Get the new order_id (e.g., 101)
```

**What Happens:**
1. **Creates a new order:**
   - customer_id = 1 (Kwame Mensah)
   - order_date = Current timestamp
   - total_amount = $600.00 (2 × $300)
   - order_status = 'Pending'

2. **Auto-generated ID is captured:**
   - MySQL generates order_id (e.g., 101)
   - `LAST_INSERT_ID()` retrieves this value
   - Stored in `v_order_id` variable for next step

**Current State:**
- New Order 101 created
- v_order_id = 101
- Transaction is still ACTIVE

---

#### **Phase 6: Create Order Item Record** 🛒
```sql
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase)
VALUES (101, 3, 2, 300.00);
```

**🎯 TRIGGER FIRES: `trg_update_order_total_after_insert`**

**What Happens:**

1. **Order item is inserted:**
   - order_id = 101
   - product_id = 3
   - quantity = 2
   - price_at_purchase = $300.00

2. **Trigger automatically updates order total:**
   ```sql
   UPDATE Orders
   SET total_amount = (
       SELECT SUM(quantity * price_at_purchase) FROM Order_Items WHERE order_id = 101
   )
   WHERE order_id = 101;
   ```
   - Calculates: 2 × $300 = $600.00
   - Updates Order 101's total_amount to $600.00

**Note:** The total was already set to $600 when we created the order, but the trigger ensures it's always correct even if we add more items later.

**Current State:**
- Order 101 exists with total_amount = $600.00
- Order_Items has 1 record for Order 101
- Inventory for Product 3 = 18
- Transaction is still ACTIVE

---

#### **Phase 7: Commit Transaction** ✅
```sql
COMMIT;
```

**What Happens:**
1. **All changes are permanently saved:**
   - Inventory reduction (20 → 18)
   - Order creation (Order 101)
   - Order item creation

2. **Locks are released:**
   - Inventory row for Product 3 is unlocked
   - Other waiting transactions can now proceed

3. **Success message is returned:**
   ```sql
   SELECT 'Order processed successfully' AS message, 101 AS new_order_id;
   ```
   - Returns: "Order processed successfully" with order_id = 101

**Final State:**
- ✅ Order 101 is created and committed
- ✅ Inventory reduced from 20 to 18
- ✅ Customer 1 has a new order for 2 Ergonomic Chairs
- ✅ Total cost: $600.00

---

### Scenario 3: What Happens When Stock is Insufficient? ❌

Let's see what happens when a customer tries to order more than available.

```sql
CALL ProcessNewOrder(1, 3, 100);
-- Customer 1 wants to buy 100 chairs, but we only have 18!
```

**The Flow:**

1. **Transaction Starts:**
   ```sql
   START TRANSACTION;
   ```

2. **Check Stock:**
   ```sql
   SELECT quantity_on_hand, price INTO v_stock, v_price
   FROM Products p JOIN Inventory i ON p.product_id = i.product_id
   WHERE p.product_id = 3 FOR UPDATE;
   ```
   - v_stock = 18
   - v_price = 300.00
   - Row is LOCKED

3. **Stock Validation FAILS:**
   ```sql
   IF v_stock >= p_quantity THEN  -- Is 18 >= 100? NO!
   ```
   - Condition is FALSE
   - Jumps to ELSE block

4. **Rollback Transaction:**
   ```sql
   ELSE
       ROLLBACK;  -- Undo everything (nothing to undo yet, but important for safety)
   ```

5. **Throw Error:**
   ```sql
   SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'Insufficient stock for product';
   ```
   - Returns error to the application
   - Error code: 45000 (user-defined error)
   - Error message: "Insufficient stock for product"

6. **Locks Released:**
   - Inventory row is unlocked
   - No changes were made to the database

**Result:**
- ❌ Order was NOT created
- ❌ Inventory was NOT changed
- ✅ Data integrity is preserved
- ✅ Customer receives clear error message

---

## Triggers Deep Dive

The system has **3 triggers** that work together to maintain order total accuracy.

### Trigger 1: `trg_update_order_total_after_insert`

**Purpose:** Automatically update order total when a new item is added to an order.

**Fires:** AFTER INSERT ON Order_Items

**SQL Code:**
```sql
CREATE TRIGGER trg_update_order_total_after_insert
AFTER INSERT ON Order_Items
FOR EACH ROW
BEGIN
    UPDATE Orders
    SET total_amount = (
        SELECT COALESCE(SUM(quantity * price_at_purchase), 0)
        FROM Order_Items
        WHERE order_id = NEW.order_id
    )
    WHERE order_id = NEW.order_id;
END
```

**How It Works:**

1. **Trigger Context:**
   - `NEW` keyword represents the newly inserted row
   - `NEW.order_id` is the order we just added an item to

2. **Calculation:**
   - `SUM(quantity * price_at_purchase)` calculates total for ALL items in the order
   - `COALESCE(..., 0)` returns 0 if no items exist (safety check)

3. **Update:**
   - Updates the `total_amount` in the Orders table
   - Only affects the specific order (WHERE order_id = NEW.order_id)

**Example:**
```sql
-- Before trigger:
Order 100: total_amount = $1,200.00
Order_Items: Product 1 (qty: 1, price: $1,200)

-- Insert new item:
INSERT INTO Order_Items VALUES (100, 2, 1, 150.00);

-- Trigger calculates:
(1 × $1,200) + (1 × $150) = $1,350.00

-- After trigger:
Order 100: total_amount = $1,350.00
```

---

### Trigger 2: `trg_update_order_total_after_update`

**Purpose:** Automatically update order total when an item quantity or price is changed.

**Fires:** AFTER UPDATE ON Order_Items

**SQL Code:**
```sql
CREATE TRIGGER trg_update_order_total_after_update
AFTER UPDATE ON Order_Items
FOR EACH ROW
BEGIN
    UPDATE Orders
    SET total_amount = (
        SELECT COALESCE(SUM(quantity * price_at_purchase), 0)
        FROM Order_Items
        WHERE order_id = NEW.order_id
    )
    WHERE order_id = NEW.order_id;
END
```

**How It Works:**

1. **Trigger Context:**
   - `OLD` represents the row before the update
   - `NEW` represents the row after the update
   - Can access both to see what changed

2. **Calculation:**
   - Same as INSERT trigger
   - Re-calculates total for ALL items in the order using updated values

3. **Update:**
   - Updates the Orders table with the new total

**Example:**
```sql
-- Before trigger:
Order 100: total_amount = $1,350.00
Order_Items: 
  - Product 1 (qty: 1, price: $1,200)
  - Product 2 (qty: 1, price: $150)

-- Update item quantity:
UPDATE Order_Items SET quantity = 3 WHERE order_id = 100 AND product_id = 2;

-- Trigger receives:
OLD.quantity = 1
NEW.quantity = 3

-- Trigger calculates:
(1 × $1,200) + (3 × $150) = $1,650.00

-- After trigger:
Order 100: total_amount = $1,650.00
```

---

### Trigger 3: `trg_update_order_total_after_delete`

**Purpose:** Automatically update order total when an item is removed from an order.

**Fires:** AFTER DELETE ON Order_Items

**SQL Code:**
```sql
CREATE TRIGGER trg_update_order_total_after_delete
AFTER DELETE ON Order_Items
FOR EACH ROW
BEGIN
    UPDATE Orders
    SET total_amount = (
        SELECT COALESCE(SUM(quantity * price_at_purchase), 0)
        FROM Order_Items
        WHERE order_id = OLD.order_id
    )
    WHERE order_id = OLD.order_id;
END
```

**How It Works:**

1. **Trigger Context:**
   - `OLD` represents the deleted row
   - `NEW` does NOT exist for DELETE triggers
   - `OLD.order_id` tells us which order the item was removed from

2. **Calculation:**
   - Sums the REMAINING items in the order
   - If no items remain, COALESCE returns 0

3. **Update:**
   - Updates the order total to reflect the removal

**Example:**
```sql
-- Before trigger:
Order 100: total_amount = $1,650.00
Order_Items: 
  - Product 1 (qty: 1, price: $1,200)
  - Product 2 (qty: 3, price: $150)

-- Delete item:
DELETE FROM Order_Items WHERE order_id = 100 AND product_id = 2;

-- Trigger receives:
OLD.order_id = 100
OLD.product_id = 2
OLD.quantity = 3
OLD.price_at_purchase = $150

-- Trigger calculates (only Product 1 remains):
(1 × $1,200) = $1,200.00

-- After trigger:
Order 100: total_amount = $1,200.00
```

---

### Why Three Separate Triggers?

**Q: Why not combine them into one trigger?**

**A:** MySQL requires separate triggers for each event type (INSERT, UPDATE, DELETE). You cannot have a single trigger that handles all three events.

**Benefits of This Design:**

1. **Automatic Accuracy:**
   - Order totals are ALWAYS correct
   - No manual calculation needed
   - Eliminates human error

2. **Data Integrity:**
   - Impossible to have mismatched totals
   - Changes are immediate and atomic

3. **Simplicity:**
   - Application code doesn't need to calculate totals
   - One less thing to worry about

4. **Historical Accuracy:**
   - `price_at_purchase` preserves the price at order time
   - Even if product price changes later, order total stays correct

---

## Stored Procedures Deep Dive

### Procedure: `ProcessNewOrder`

**Purpose:** Handle the complete order creation process including stock validation, inventory updates, and order creation in a single atomic transaction.

**Parameters:**
- `p_customer_id` (INT): The customer placing the order
- `p_product_id` (INT): The product to order
- `p_quantity` (INT): How many units to order

**Full SQL Code:**
```sql
CREATE PROCEDURE ProcessNewOrder(
    IN p_customer_id INT,
    IN p_product_id INT,
    IN p_quantity INT
)
BEGIN
    DECLARE v_price DECIMAL(10,2);
    DECLARE v_stock INT;
    DECLARE v_order_id INT;

    START TRANSACTION;

    -- 1. Check current stock and price
    SELECT quantity_on_hand, price INTO v_stock, v_price
    FROM Products p
    JOIN Inventory i ON p.product_id = i.product_id
    WHERE p.product_id = p_product_id
    FOR UPDATE;

    -- 2. Check if enough stock exists
    IF v_stock >= p_quantity THEN
        -- a. Reduce Inventory
        UPDATE Inventory 
        SET quantity_on_hand = quantity_on_hand - p_quantity
        WHERE product_id = p_product_id;

        -- b. Create Order Record
        INSERT INTO Orders (customer_id, order_date, total_amount, order_status)
        VALUES (p_customer_id, NOW(), (v_price * p_quantity), 'Pending');
        
        -- Get the generated Order ID
        SET v_order_id = LAST_INSERT_ID();

        -- c. Create Order Item Record
        INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase)
        VALUES (v_order_id, p_product_id, p_quantity, v_price);

        -- Commit transaction
        COMMIT;
        SELECT 'Order processed successfully' AS message, v_order_id AS new_order_id;
    ELSE
        -- Not enough stock, rollback
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient stock for product';
    END IF;
END
```

---

### Key Features of `ProcessNewOrder`

#### 1. **Transaction Safety** 🔒

**What it does:**
- Wraps all operations in a transaction
- Either ALL operations succeed, or NONE do
- No partial updates possible

**Why it matters:**
```sql
-- Bad scenario without transactions:
1. Inventory reduced: ✅
2. Order created: ✅
3. Order item creation: ❌ ERROR!
Result: Lost inventory, no order = BAD!

-- Good scenario with transactions:
1. Inventory reduced: ✅
2. Order created: ✅
3. Order item creation: ❌ ERROR!
4. ROLLBACK triggered: ↩️
Result: Everything undone = GOOD!
```

---

#### 2. **Row Locking with FOR UPDATE** 🔐

**What it does:**
```sql
SELECT ... FROM Inventory WHERE product_id = 3 FOR UPDATE;
```
- Locks the inventory row
- Prevents other transactions from reading or modifying it
- Released when transaction commits or rolls back

**Why it matters:**
```
Without FOR UPDATE:
┌─────────────┬─────────────┐
│ Customer A  │ Customer B  │
├─────────────┼─────────────┤
│ Check stock │             │
│ Stock: 1    │             │
│             │ Check stock │
│             │ Stock: 1    │
│ Buy 1 item  │             │
│ Stock: 0    │             │
│             │ Buy 1 item  │
│             │ Stock: -1 ❌│
└─────────────┴─────────────┘

With FOR UPDATE:
┌─────────────┬─────────────┐
│ Customer A  │ Customer B  │
├─────────────┼─────────────┤
│ Check stock │             │
│ (LOCKED 🔒) │             │
│ Stock: 1    │             │
│             │ Check stock │
│             │ (WAITING...) │
│ Buy 1 item  │             │
│ Stock: 0    │             │
│ COMMIT ✅   │             │
│             │ Stock: 0    │
│             │ Error: No   │
│             │ stock! ✅   │
└─────────────┴─────────────┘
```

---

#### 3. **Stock Validation** ✅

**What it does:**
```sql
IF v_stock >= p_quantity THEN
    -- Process order
ELSE
    -- Reject order
END IF;
```

**Business Logic:**
- Only create order if sufficient stock exists
- Prevent overselling
- Provide clear error messages

**Error Handling:**
```sql
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Insufficient stock for product';
```
- Returns a MySQL error
- Application can catch and display to user
- Transaction is rolled back automatically

---

#### 4. **Price Capture** 💰

**What it does:**
```sql
SELECT price INTO v_price FROM Products WHERE product_id = 3;
-- Later...
INSERT INTO Order_Items (..., price_at_purchase) VALUES (..., v_price);
```

**Why it matters:**
- Captures price at the moment of purchase
- Historical accuracy preserved
- If product price changes later, old orders remain accurate

**Example:**
```
Day 1: Laptop costs $1,200
Customer orders: price_at_purchase = $1,200

Day 2: Laptop price drops to $999

Old order still shows: $1,200 ✅ (correct historical price)
New orders will show: $999 ✅ (correct current price)
```

---

#### 5. **Integration with Triggers** 🔗

**What happens:**
```sql
-- Procedure creates order item:
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase)
VALUES (v_order_id, p_product_id, p_quantity, v_price);

-- Trigger AUTOMATICALLY fires:
trg_update_order_total_after_insert
  ↓
  Updates Orders.total_amount
```

**Result:**
- Procedure doesn't need to calculate total
- Trigger handles it automatically
- Separation of concerns
- Reusable logic

---

### Limitations of `ProcessNewOrder`

**Current Limitations:**

1. **Single Product Only:**
   - Can only order one product at a time
   - Multi-product orders require multiple procedure calls

2. **No Discount Support:**
   - Uses current product price
   - Cannot apply promotional codes or discounts

3. **Simple Stock Management:**
   - No reserved stock for pending orders
   - No back-order functionality

4. **Limited Error Information:**
   - Doesn't tell you HOW MUCH stock is available
   - Just says "insufficient stock"

**Potential Improvements:**

```sql
-- Enhanced version could accept multiple products:
CALL ProcessNewOrder(
    1,  -- customer_id
    '[{"product_id": 1, "quantity": 2}, {"product_id": 2, "quantity": 1}]'  -- JSON array
);

-- Or with discount:
CALL ProcessNewOrder(
    1,  -- customer_id
    3,  -- product_id
    2,  -- quantity
    0.10  -- 10% discount
);
```

---

## Views and Optimization

### View: `CustomerSalesSummary`

**Purpose:** Pre-calculate customer lifetime value and order statistics for quick reporting.

**SQL Code:**
```sql
CREATE OR REPLACE VIEW CustomerSalesSummary AS
SELECT 
    c.customer_id,
    c.full_name,
    c.email,
    COUNT(o.order_id) AS total_orders,
    COALESCE(SUM(o.total_amount), 0) AS total_lifetime_value
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name, c.email;
```

**What It Shows:**
```
customer_id | full_name      | email                        | total_orders | total_lifetime_value
------------|----------------|------------------------------|--------------|---------------------
1           | Kwame Mensah   | kwame.mensah@gmail.com       | 3            | $2,595.00
2           | Ama Osei       | ama.osei@yahoo.com           | 2            | $300.00
3           | Kofi Agyeman   | kofi.agyeman@outlook.com     | 2            | $1,200.00
```

**How to Use:**
```sql
-- Find top 10 customers by lifetime value:
SELECT * FROM CustomerSalesSummary
ORDER BY total_lifetime_value DESC
LIMIT 10;

-- Find customers who never ordered:
SELECT * FROM CustomerSalesSummary
WHERE total_orders = 0;

-- Find VIP customers (more than 5 orders):
SELECT * FROM CustomerSalesSummary
WHERE total_orders > 5;
```

**Benefits:**

1. **Performance:**
   - Complex aggregation is pre-calculated
   - Faster than running the JOIN and GROUP BY every time
   - MySQL can optimize view queries

2. **Simplicity:**
   - Hide complex SQL from application developers
   - Simple SELECT instead of complex joins

3. **Consistency:**
   - Everyone uses the same calculation
   - No variation in how "lifetime value" is computed

4. **Reusability:**
   - Use in reports, dashboards, analytics
   - Building block for more complex queries

**Note:** This is a **virtual view** (not materialized), so it's always up-to-date with current data.

---

## Complete Order Flow Diagram

Let me summarize everything with a visual flow:

```
┌─────────────────────────────────────────────────────────────────────────┐
│                     ORDER CREATION COMPLETE FLOW                        │
└─────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────┐
│ METHOD 1: STORED PROCEDURE (Recommended for automated systems)         │
└─────────────────────────────────────────────────────────────────────────┘

    CALL ProcessNewOrder(customer_id, product_id, quantity)
              ↓
    ┌─────────────────────┐
    │ START TRANSACTION   │
    └──────────┬──────────┘
               ↓
    ┌─────────────────────────────────┐
    │ 1. Check Stock & Price          │
    │    SELECT ... FOR UPDATE 🔒     │
    │    - Locks inventory row        │
    │    - Gets current stock level   │
    │    - Gets product price         │
    └──────────┬──────────────────────┘
               ↓
         ┌─────────────┐
         │ Stock >= Qty?│
         └─────┬────┬───┘
               │    │
          YES  │    │  NO
               ↓    ↓
    ┌──────────────────┐   ┌──────────────────┐
    │ 2. Reduce Stock  │   │ ROLLBACK         │
    │    UPDATE        │   │ SIGNAL ERROR     │
    │    Inventory     │   │ "Insufficient    │
    │                  │   │  stock"          │
    └────────┬─────────┘   └──────────────────┘
             ↓                      ↓
    ┌──────────────────┐         RETURN
    │ 3. Create Order  │         ERROR
    │    INSERT INTO   │
    │    Orders        │
    └────────┬─────────┘
             ↓
    ┌──────────────────────────┐
    │ 4. Create Order Item     │
    │    INSERT INTO           │
    │    Order_Items           │
    └────────┬─────────────────┘
             ↓
    ┌──────────────────────────────────┐
    │ 🎯 TRIGGER FIRES AUTOMATICALLY   │
    │ trg_update_order_total_after_    │
    │ insert                           │
    │                                  │
    │ - Calculates sum of all items   │
    │ - Updates Orders.total_amount   │
    └────────┬─────────────────────────┘
             ↓
    ┌──────────────────┐
    │ COMMIT           │
    │ - Save changes   │
    │ - Release locks  │
    └────────┬─────────┘
             ↓
    ┌──────────────────┐
    │ RETURN SUCCESS   │
    │ "Order processed │
    │  successfully"   │
    │ + order_id       │
    └──────────────────┘


┌─────────────────────────────────────────────────────────────────────────┐
│ METHOD 2: MANUAL INSERT (For manual order entry)                       │
└─────────────────────────────────────────────────────────────────────────┘

    INSERT INTO Orders (customer_id, total_amount, order_status)
    VALUES (1, 0.00, 'Pending')
              ↓
    ┌──────────────────┐
    │ Order Created    │
    │ total_amount=0   │
    └────────┬─────────┘
             ↓
    INSERT INTO Order_Items (order_id, product_id, quantity, price)
    VALUES (order_id, 1, 2, 1200.00)
              ↓
    ┌──────────────────────────────────┐
    │ 🎯 TRIGGER FIRES                 │
    │ trg_update_order_total_after_    │
    │ insert                           │
    └────────┬─────────────────────────┘
             ↓
    ┌──────────────────┐
    │ Order Updated    │
    │ total_amount=    │
    │ 2 × $1,200 =     │
    │ $2,400           │
    └────────┬─────────┘
             ↓
    INSERT INTO Order_Items (order_id, product_id, quantity, price)
    VALUES (order_id, 2, 1, 150.00)
              ↓
    ┌──────────────────────────────────┐
    │ 🎯 TRIGGER FIRES AGAIN           │
    │ trg_update_order_total_after_    │
    │ insert                           │
    └────────┬─────────────────────────┘
             ↓
    ┌──────────────────┐
    │ Order Updated    │
    │ total_amount=    │
    │ $2,400 + $150 =  │
    │ $2,550           │
    └────────┬─────────┘
             ↓
    ┌──────────────────┐
    │ Final Order      │
    │ - 2 Laptops      │
    │ - 1 Headphones   │
    │ - Total: $2,550  │
    └──────────────────┘


┌─────────────────────────────────────────────────────────────────────────┐
│ TRIGGER LIFECYCLE: All Possible Events                                 │
└─────────────────────────────────────────────────────────────────────────┘

┌──────────────────┐
│ INSERT Order     │
│ Item             │
└────────┬─────────┘
         ↓
    🎯 trg_update_order_total_after_insert
         ↓
    UPDATE Orders.total_amount


┌──────────────────┐
│ UPDATE Order     │
│ Item Quantity    │
└────────┬─────────┘
         ↓
    🎯 trg_update_order_total_after_update
         ↓
    UPDATE Orders.total_amount


┌──────────────────┐
│ DELETE Order     │
│ Item             │
└────────┬─────────┘
         ↓
    🎯 trg_update_order_total_after_delete
         ↓
    UPDATE Orders.total_amount


┌─────────────────────────────────────────────────────────────────────────┐
│ DATA INTEGRITY RULES                                                    │
└─────────────────────────────────────────────────────────────────────────┘

1. CASCADE DELETE: Order → Order_Items
   - Delete Order → All Order_Items deleted automatically

2. RESTRICT DELETE: Customer → Orders
   - Cannot delete customer with existing orders

3. RESTRICT DELETE: Product → Order_Items
   - Cannot delete product if it's in any order

4. CASCADE DELETE: Product → Inventory
   - Delete Product → Inventory record deleted automatically

5. CHECK CONSTRAINTS:
   - Product.price >= 0
   - Inventory.quantity_on_hand >= 0
   - Order.total_amount >= 0
   - Order_Item.quantity > 0
   - Order_Item.price_at_purchase >= 0

6. UNIQUE CONSTRAINTS:
   - Customer.email (must be unique)
   - Inventory.product_id (one inventory record per product)
   - Order_Items(order_id, product_id) (can't add same product twice)

7. AUTO TIMESTAMPS:
   - Orders.order_date (defaults to NOW())
   - Inventory.last_updated (auto-updates on change)
```

---

## Summary: The Complete Story

### When an Order is Created, Here's What Happens:

#### **Using ProcessNewOrder Procedure:**

1. **🔒 Transaction begins** - Database locks are acquired
2. **📊 Stock is checked** - FOR UPDATE locks the inventory row
3. **✅ Validation occurs** - If stock < quantity → ERROR and rollback
4. **📦 Inventory is reduced** - quantity_on_hand decreases
5. **📝 Order is created** - New record in Orders table
6. **🛒 Order item is created** - New record in Order_Items table
7. **🎯 Trigger fires automatically** - total_amount is calculated and updated
8. **💾 Transaction commits** - All changes saved, locks released
9. **✉️ Success message returned** - Application receives order_id

#### **Using Manual INSERT:**

1. **📝 Order is created** - With total_amount = 0
2. **🛒 First order item added** → 🎯 Trigger fires → Total updated
3. **🛒 Second order item added** → 🎯 Trigger fires → Total recalculated
4. **🛒 Third order item added** → 🎯 Trigger fires → Total recalculated
5. **...** and so on for each item

**Every modification (INSERT/UPDATE/DELETE) to order items triggers automatic recalculation!**

---

## Key Takeaways

### ✅ **Advantages of This Design:**

1. **Automatic Total Calculation** - Never manually compute order totals
2. **Data Integrity** - Impossible to have incorrect totals
3. **Transaction Safety** - All-or-nothing operations prevent data corruption
4. **Concurrency Control** - FOR UPDATE prevents race conditions
5. **Historical Accuracy** - price_at_purchase preserves historical data
6. **Audit Trail** - Timestamps track when changes occurred
7. **Referential Integrity** - Foreign keys prevent orphaned records

### ⚠️ **Things to Be Aware Of:**

1. **Trigger Overhead** - Every order item change causes an UPDATE to Orders
2. **Lock Contention** - FOR UPDATE can cause waiting during high traffic
3. **Single Product Limitation** - ProcessNewOrder handles one product at a time
4. **No Inventory Reservation** - Stock isn't reserved during checkout process
5. **Simple Error Messages** - Limited details about what went wrong

---

## Real-World Usage Examples

### Example 1: Customer Places Web Order
```sql
-- Customer adds items to cart, then checks out
CALL ProcessNewOrder(5, 1, 1);  -- Add laptop
CALL ProcessNewOrder(5, 2, 1);  -- Add headphones
CALL ProcessNewOrder(5, 7, 1);  -- Add mouse

-- Result: Customer has 3 separate orders (limitation of current design)
-- Better: Enhance procedure to accept multiple products
```

### Example 2: Admin Creates Bulk Order
```sql
-- Start a new order
INSERT INTO Orders (customer_id, order_status) VALUES (10, 'Pending');
SET @order_id = LAST_INSERT_ID();

-- Add multiple items
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase)
SELECT @order_id, product_id, quantity, price
FROM (
    SELECT 1 AS product_id, 2 AS quantity, 1200.00 AS price UNION
    SELECT 3, 1, 300.00 UNION
    SELECT 7, 1, 60.00
) items;

-- Triggers fire for EACH insert, final total is calculated
```

### Example 3: Customer Changes Mind
```sql
-- Reduce quantity
UPDATE Order_Items 
SET quantity = 1 
WHERE order_id = 100 AND product_id = 1;
-- Trigger fires, total is reduced

-- Remove item completely
DELETE FROM Order_Items 
WHERE order_id = 100 AND product_id = 2;
-- Trigger fires, total is recalculated
```

### Example 4: View Customer Analytics
```sql
-- Top 10 customers
SELECT * FROM CustomerSalesSummary
ORDER BY total_lifetime_value DESC
LIMIT 10;

-- Customers who haven't ordered yet
SELECT * FROM CustomerSalesSummary
WHERE total_orders = 0;

-- Average order value per customer
SELECT 
    full_name,
    total_lifetime_value / NULLIF(total_orders, 0) AS avg_order_value
FROM CustomerSalesSummary
WHERE total_orders > 0
ORDER BY avg_order_value DESC;
```

---

## Conclusion

This Inventory and Order Management System demonstrates **robust database design** with:

- ✅ **Automated business logic** via triggers
- ✅ **Transaction safety** via stored procedures  
- ✅ **Data integrity** via constraints and foreign keys
- ✅ **Performance optimization** via views and indexes
- ✅ **Audit capabilities** via timestamps
- ✅ **Concurrency control** via row locking

The system ensures that order totals are **always accurate**, inventory levels are **never oversold**, and data remains **consistent** even under concurrent access.

**Every time an order is created**, whether through the automated procedure or manual entry, a carefully orchestrated dance of transactions, triggers, and constraints works together to maintain data integrity and business rules.

---

**🎓 Educational Note:**

This codebase is an excellent example of:
- Trigger-based automation
- Transaction management  
- Stored procedure design
- Referential integrity
- Business logic in database layer
- Defensive programming with constraints

Study it well, and you'll understand core database concepts that power real-world e-commerce systems! 🚀
