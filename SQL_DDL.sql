-- Database Schema for Inventory and Order Management System

-- Drop tables if they exist to start fresh 
DROP TABLE IF EXISTS Inventory_Log;
DROP TABLE IF EXISTS Order_Items;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Inventory;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Customers;

-- 1. Create Customers Table
CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    shipping_address VARCHAR(255) NOT NULL
);

-- 2. Create Products Table
CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    CONSTRAINT chk_product_price CHECK (price >= 0)
);

-- 3. Create Inventory Table
CREATE TABLE Inventory (
    inventory_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL UNIQUE,
    quantity_on_hand INT NOT NULL,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_inventory_product FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE,
    CONSTRAINT chk_inventory_qty CHECK (quantity_on_hand >= 0)
);



-- 4. Create Orders Table
CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    order_status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    CONSTRAINT fk_order_customer FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE RESTRICT,
    CONSTRAINT chk_order_amount CHECK (total_amount >= 0)
);

-- 5. Create Order_Items Table
CREATE TABLE Order_Items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price_at_purchase DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_order_items_order FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    CONSTRAINT fk_order_items_product FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE RESTRICT,
    CONSTRAINT chk_order_item_qty CHECK (quantity > 0),
    CONSTRAINT chk_order_item_price CHECK (price_at_purchase >= 0),
    UNIQUE KEY uq_order_product (order_id, product_id)
);

-- 3a. Create Inventory_Log Table (Audit Trail)
CREATE TABLE Inventory_Log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    transaction_type ENUM('SALE', 'RESTOCK', 'ADJUSTMENT', 'RETURN', 'DAMAGE', 'LOSS') NOT NULL,
    quantity_change INT NOT NULL COMMENT 'Negative for decreases, positive for increases',
    quantity_before INT NOT NULL,
    quantity_after INT NOT NULL,
    order_id INT NULL COMMENT 'Links to Orders if applicable (for SALE/RETURN)',
    notes VARCHAR(500) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL COMMENT 'User who made the change',
    CONSTRAINT fk_inventory_log_product FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE,
    CONSTRAINT fk_inventory_log_order FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE SET NULL,
    INDEX idx_product_date (product_id, created_at),
    INDEX idx_transaction_type (transaction_type),
    INDEX idx_order (order_id)
);


-- Indexes for performance optimization
CREATE INDEX idx_customer_email ON Customers(email);
CREATE INDEX idx_product_category ON Products(category);
CREATE INDEX idx_order_customer ON Orders(customer_id);
CREATE INDEX idx_order_date ON Orders(order_date);
