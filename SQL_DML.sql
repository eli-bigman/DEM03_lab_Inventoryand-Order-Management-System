-- =============================================
-- 1. SEED DATA (Populating the database)
-- =============================================

-- Insert Customers
INSERT INTO Customers (full_name, email, phone, shipping_address) VALUES
('Kwame Mensah', 'kwame.mensah@gmail.com', '024-123-4567', 'East Legon, Accra, Greater Accra Region'),
('Ama Osei', 'ama.osei@yahoo.com', '055-234-5678', 'Adum, Kumasi, Ashanti Region'),
('Kofi Agyeman', 'kofi.agyeman@outlook.com', '024-345-6789', 'Labone, Accra, Greater Accra Region'),
('Akosua Boateng', 'akosua.boateng@gmail.com', '055-456-7890', 'Ashaiman, Greater Accra Region'),
('Yaw Asante', 'yaw.asante@gmail.com', '024-567-8901', 'Sagnarigu, Tamale, Northern Region');

-- Insert Products
INSERT INTO Products (product_name, category, price) VALUES
('Laptop Pro', 'Electronics', 1200.00),
('Wireless Headphones', 'Electronics', 150.00),
('Ergonomic Chair', 'Furniture', 300.00),
('Coffee Maker', 'Appliances', 80.00),
('Running Shoes', 'Apparel', 120.00),
('Python Programming', 'Books', 45.00),
('Gaming Mouse', 'Electronics', 60.00),
('Standing Desk', 'Furniture', 450.00);

-- Insert Inventory (Initialize stock)
INSERT INTO Inventory (product_id, quantity_on_hand) VALUES
(1, 50), -- Laptop Pro
(2, 100), -- Headphones
(3, 20), -- Chair
(4, 30), -- Coffee Maker
(5, 75), -- Shoes
(6, 200), -- Book
(7, 60), -- Mouse
(8, 15); -- Standing Desk

-- Insert Inventory Log (Initial stock entries)
INSERT INTO Inventory_Log (product_id, transaction_type, quantity_change, quantity_before, quantity_after, notes, created_by, created_at) VALUES
(1, 'RESTOCK', 50, 0, 50, 'Initial stock - Laptop Pro', 'SYSTEM', '2023-09-15 08:00:00'),
(2, 'RESTOCK', 100, 0, 100, 'Initial stock - Wireless Headphones', 'SYSTEM', '2023-09-15 08:00:00'),
(3, 'RESTOCK', 20, 0, 20, 'Initial stock - Ergonomic Chair', 'SYSTEM', '2023-09-15 08:00:00'),
(4, 'RESTOCK', 30, 0, 30, 'Initial stock - Coffee Maker', 'SYSTEM', '2023-09-15 08:00:00'),
(5, 'RESTOCK', 75, 0, 75, 'Initial stock - Running Shoes', 'SYSTEM', '2023-09-15 08:00:00'),
(6, 'RESTOCK', 200, 0, 200, 'Initial stock - Python Programming', 'SYSTEM', '2023-09-15 08:00:00'),
(7, 'RESTOCK', 60, 0, 60, 'Initial stock - Gaming Mouse', 'SYSTEM', '2023-09-15 08:00:00'),
(8, 'RESTOCK', 15, 0, 15, 'Initial stock - Standing Desk', 'SYSTEM', '2023-09-15 08:00:00');

-- Insert Orders (Some historical data)
INSERT INTO Orders (customer_id, order_date, total_amount, order_status) VALUES
(1, '2023-10-01 10:00:00', 1350.00, 'Delivered'),
(2, '2023-10-05 14:30:00', 300.00, 'Delivered'),
(1, '2023-11-10 09:15:00', 45.00, 'Shipped'),
(3, '2023-11-15 11:20:00', 1200.00, 'Pending'),
(4, '2023-12-01 16:45:00', 1280.00, 'Pending');

-- Insert Order Items
-- Order 1: Laptop + Headphones
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(1, 1, 1, 1200.00),
(1, 2, 1, 150.00);

-- Order 2: Chair
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(2, 3, 1, 300.00);

-- Order 3: Book
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(3, 6, 1, 45.00);

-- Order 4: Laptop
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(4, 1, 1, 1200.00);

-- Order 5: Laptop + Coffee Maker
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(5, 1, 1, 1200.00),
(5, 4, 1, 80.00);


-- =============================================
-- 2. BUSINESS KPIs
-- =============================================

-- KPI 1: Total Revenue
-- Calculate the total revenue from all 'Shipped' or 'Delivered' orders.
SELECT 
    SUM(total_amount) AS total_revenue
FROM Orders
WHERE order_status IN ('Shipped', 'Delivered');

-- KPI 2: Top 10 Customers
-- Find the top 10 customers by their total spending.
SELECT 
    c.full_name,
    SUM(o.total_amount) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY total_spent DESC
LIMIT 10;

-- KPI 3: Best-Selling Products
-- List the top 5 best-selling products by quantity sold.
SELECT 
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold
FROM Products p
JOIN Order_Items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 5;

-- KPI 4: Monthly Sales Trend
-- Show the total sales revenue for each month.
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS sales_month,
    SUM(total_amount) AS monthly_revenue
FROM Orders
WHERE order_status IN ('Shipped', 'Delivered')
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY sales_month;

-- =============================================
-- 3. ANALYTICAL QUERIES (Window Functions)
-- =============================================

-- Analytic 1: Sales Rank by Category
-- Rank products by total sales revenue within their category.
WITH ProductSales AS (
    SELECT 
        p.category,
        p.product_name,
        SUM(oi.quantity * oi.price_at_purchase) AS product_revenue
    FROM Products p
    JOIN Order_Items oi ON p.product_id = oi.product_id
    GROUP BY p.category, p.product_name
)

SELECT 
    category,
    product_name,
    product_revenue,
    RANK() OVER (PARTITION BY category ORDER BY product_revenue DESC) AS rank_in_category
FROM ProductSales;

-- Analytic 2: Customer Order Frequency
-- Show previous order date alongside current order date.
SELECT 
    c.full_name,
    o.order_id,
    o.order_date,
    LAG(o.order_date) OVER (PARTITION BY c.customer_id ORDER BY o.order_date) AS previous_order_date
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
ORDER BY c.customer_id, o.order_date;


-- =============================================
-- 4. PERFORMANCE OPTIMIZATION (Views & Stored Procedures)
-- =============================================

-- View: CustomerSalesSummary (total amount spent by each customer)
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

-- Stored Procedure: ProcessNewOrder (Refactored for Batch Processing)
-- Handles multiple items in a single order (Shopping Cart pattern) using JSON input.
-- Usage Example: CALL ProcessNewOrder(1, '[{"product_id": 1, "quantity": 2}, {"product_id": 3, "quantity": 1}]');

DROP PROCEDURE IF EXISTS ProcessNewOrder;

DELIMITER //

CREATE PROCEDURE ProcessNewOrder(
    IN p_customer_id INT,
    IN p_order_items JSON
)
BEGIN
    DECLARE v_order_id INT;
    DECLARE v_insufficient_stock INT DEFAULT 0;
    DECLARE v_customer_exists INT DEFAULT 0;
    DECLARE v_cart_item_count INT DEFAULT 0;
    DECLARE v_invalid_product_count INT DEFAULT 0;

    -- 1. Validate Customer Exists
    SELECT CASE 
        WHEN EXISTS (SELECT 1 FROM Customers WHERE customer_id = p_customer_id) 
        THEN 1 ELSE 0
    END
    INTO v_customer_exists;
    
    IF v_customer_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Customer ID does not exist.';
    END IF;
            
    -- 2. Create a temporary table and parse JSON data
    DROP TEMPORARY TABLE IF EXISTS TempCart;
    CREATE TEMPORARY TABLE TempCart (
        product_id INT PRIMARY KEY,
        quantity INT
    );
    
    INSERT INTO TempCart (product_id, quantity)
    SELECT product_id, quantity
    FROM JSON_TABLE(
        p_order_items,
        "$[*]" COLUMNS(
            product_id INT PATH "$.product_id",
            quantity INT PATH "$.quantity"
        )
    ) AS jt;

    -- 3. Validate Cart Content
    SELECT COUNT(*) INTO v_cart_item_count FROM TempCart;
    
    IF v_cart_item_count = 0 THEN
        DROP TEMPORARY TABLE IF EXISTS TempCart;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Order contains no items or invalid JSON.';
    END IF;

    -- 4. Check for Negative Quantities
    IF EXISTS (SELECT 1 FROM TempCart WHERE quantity <= 0) THEN
        DROP TEMPORARY TABLE IF EXISTS TempCart;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Order items must have a quantity greater than zero.';
    END IF;

    -- 5. Validate Products match valid Product IDs
    SELECT COUNT(*) INTO v_invalid_product_count
    FROM TempCart t
    LEFT JOIN Products p ON t.product_id = p.product_id
    WHERE p.product_id IS NULL;

    IF v_invalid_product_count > 0 THEN
        DROP TEMPORARY TABLE IF EXISTS TempCart;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: One or more Product IDs in the cart do not exist.';
    END IF;

    -- Start transaction
    START TRANSACTION;

    -- 6. Check for stock availability 
    -- Locks rows to prevent race conditions
    SELECT COUNT(*) INTO v_insufficient_stock
    FROM TempCart t
    LEFT JOIN Inventory i ON t.product_id = i.product_id
    WHERE i.product_id IS NULL OR i.quantity_on_hand < t.quantity
    FOR UPDATE;

    IF v_insufficient_stock > 0 THEN
        ROLLBACK;
        DROP TEMPORARY TABLE IF EXISTS TempCart;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Insufficient stock for one or more items.';
    ELSE
        -- 7. Create Order Header
        INSERT INTO Orders (customer_id, order_date, total_amount, order_status)
        VALUES (p_customer_id, NOW(), 0.00, 'Pending');
        
        SET v_order_id = LAST_INSERT_ID();

        -- 8. Insert Order Items
        INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase)
        SELECT 
            v_order_id, 
            t.product_id, 
            t.quantity, 
            p.price
        FROM TempCart t
        JOIN Products p ON t.product_id = p.product_id;

        -- 9. Update Inventory
        -- Disable trigger to prevent duplicate log entry
        SET @disable_inventory_log = 1;
        
        UPDATE Inventory i
        JOIN TempCart t ON i.product_id = t.product_id
        SET i.quantity_on_hand = i.quantity_on_hand - t.quantity;

        -- 9a. Log Inventory Changes
        INSERT INTO Inventory_Log (product_id, transaction_type, quantity_change, 
                                   quantity_before, quantity_after, order_id, created_by, notes)
        SELECT 
            i.product_id,
            'SALE',
            -t.quantity,
            i.quantity_on_hand + t.quantity, -- before deduction
            i.quantity_on_hand,              -- after deduction
            v_order_id,
            COALESCE(USER(), 'SYSTEM'),
            CONCAT('Order #', v_order_id, ' - ', p.product_name)
        FROM Inventory i
        JOIN TempCart t ON i.product_id = t.product_id
        JOIN Products p ON i.product_id = p.product_id;

        -- 10. Commit
        SET @disable_inventory_log = 0; -- Re-enable trigger
        COMMIT;
        
        SELECT 'Order processed successfully' AS message, v_order_id AS new_order_id;
    END IF;
    
    DROP TEMPORARY TABLE IF EXISTS TempCart;
END //

DELIMITER ;

-- Stored Procedure: RestockInventory
-- Adds inventory and logs the restock transaction
-- Usage Example: CALL RestockInventory(1, 50, 'Received shipment from supplier XYZ');

DROP PROCEDURE IF EXISTS RestockInventory;

DELIMITER //

CREATE PROCEDURE RestockInventory(
    IN p_product_id INT,
    IN p_quantity INT,
    IN p_notes VARCHAR(500)
)
BEGIN
    DECLARE v_old_quantity INT;
    DECLARE v_product_exists INT DEFAULT 0;
    
    -- Validate product exists
    SELECT CASE 
        WHEN EXISTS (SELECT 1 FROM Products WHERE product_id = p_product_id) 
        THEN 1 ELSE 0
    END
    INTO v_product_exists;
    
    IF v_product_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Product ID does not exist.';
    END IF;
    
    -- Validate positive quantity
    IF p_quantity <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Restock quantity must be greater than zero.';
    END IF;
    
    START TRANSACTION;
    
    -- Disable trigger to prevent duplicate log entry
    SET @disable_inventory_log = 1;
    
    -- Get current quantity
    SELECT quantity_on_hand INTO v_old_quantity
    FROM Inventory 
    WHERE product_id = p_product_id 
    FOR UPDATE;
    
    -- Update inventory
    UPDATE Inventory 
    SET quantity_on_hand = quantity_on_hand + p_quantity
    WHERE product_id = p_product_id;
    
    -- Log the restock
    INSERT INTO Inventory_Log 
    (product_id, transaction_type, quantity_change, quantity_before, quantity_after, notes, created_by)
    VALUES 
    (p_product_id, 'RESTOCK', p_quantity, v_old_quantity, v_old_quantity + p_quantity, p_notes, COALESCE(USER(), 'SYSTEM'));
    
    SET @disable_inventory_log = 0; -- Re-enable trigger
    COMMIT;
    
    SELECT 'Inventory restocked successfully' AS message, p_product_id AS product_id, p_quantity AS quantity_added;
END //

DELIMITER ;

-- =============================================
-- 5. TRIGGERS
-- =============================================

-- Trigger: Auto-calculate Order Total
-- Automatically updates the total_amount in Orders table when order items are added/updated/deleted

DROP TRIGGER IF EXISTS trg_update_order_total_after_insert;
DROP TRIGGER IF EXISTS trg_update_order_total_after_update;
DROP TRIGGER IF EXISTS trg_update_order_total_after_delete;
DROP TRIGGER IF EXISTS after_inventory_update;

DELIMITER //

-- Trigger after inserting an order item
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
END //

-- Trigger after updating an order item
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
END //

-- Trigger after deleting an order item
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
END //

DELIMITER ;


DELIMITER //

-- Trigger 1: After inserting a new inventory record (Initial Stock)
CREATE TRIGGER after_inventory_insert
AFTER INSERT ON Inventory
FOR EACH ROW
BEGIN
    INSERT INTO Inventory_Log (
        product_id,
        transaction_type,
        quantity_change,
        quantity_before,
        quantity_after,
        notes,
        created_by,
        created_at
    ) VALUES (
        NEW.product_id,
        'RESTOCK',
        NEW.quantity_on_hand,
        0,
        NEW.quantity_on_hand,
        'Initial inventory insert',
        'SYSTEM',
        NOW()
    );
END //

-- Trigger 2: After updating inventory quantity (Stock changes)
DROP TRIGGER IF EXISTS after_inventory_update;

CREATE TRIGGER after_inventory_update
AFTER UPDATE ON Inventory
FOR EACH ROW
BEGIN
    DECLARE trans_type VARCHAR(20);
    DECLARE note VARCHAR(500);
    
    -- Only log if quantity actually changed AND triggers are not temporarily disabled
    IF NEW.quantity_on_hand != OLD.quantity_on_hand AND (@disable_inventory_log IS NULL OR @disable_inventory_log = 0) THEN
        
        -- Determine transaction type based on context
        -- Ideally, the application should pass context, but for a simple trigger:
        IF NEW.quantity_on_hand > OLD.quantity_on_hand THEN
            SET trans_type = 'RESTOCK';
            SET note = 'Stock level increased';
        ELSE
            SET trans_type = 'SALE'; -- Default assumption for decrease
            SET note = 'Stock level decreased';
        END IF;

        INSERT INTO Inventory_Log (
            product_id,
            transaction_type,
            quantity_change,
            quantity_before,
            quantity_after,
            notes,
            created_by,
            created_at
        ) VALUES (
            NEW.product_id,
            trans_type,
            NEW.quantity_on_hand - OLD.quantity_on_hand,
            OLD.quantity_on_hand,
            NEW.quantity_on_hand,
            note,
            'SYSTEM',
            NOW()
        );
    END IF;
END //

DELIMITER ;
