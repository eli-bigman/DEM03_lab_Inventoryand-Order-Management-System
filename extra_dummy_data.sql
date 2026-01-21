-- Extended Seed Data for Inventory and Order Management System
-- Ghanaian-themed realistic test data
-- Adds 50+ additional records to each table


-- =============================================
-- ADDITIONAL CUSTOMERS 
-- =============================================

INSERT INTO Customers (full_name, email, phone, shipping_address) VALUES
-- Accra Region
('Abena Ofosu', 'abena.ofosu@gmail.com', '024-111-2233', 'Osu, Accra, Greater Accra Region'),
('Kwabena Darko', 'kwabena.darko@yahoo.com', '055-222-3344', 'Tema, Greater Accra Region'),
('Efua Asare', 'efua.asare@outlook.com', '024-333-4455', 'Dansoman, Accra, Greater Accra Region'),
('Kojo Owusu', 'kojo.owusu@gmail.com', '055-444-5566', 'Madina, Accra, Greater Accra Region'),
('Adjoa Appiah', 'adjoa.appiah@yahoo.com', '024-555-6677', 'Achimota, Accra, Greater Accra Region'),
('Kwesi Boakye', 'kwesi.boakye@gmail.com', '055-666-7788', 'Teshie, Accra, Greater Accra Region'),
('Ama Mensah', 'ama.mensah@outlook.com', '024-777-8899', 'Spintex, Accra, Greater Accra Region'),
('Kofi Antwi', 'kofi.antwi@gmail.com', '055-888-9900', 'Kaneshie, Accra, Greater Accra Region'),
('Akua Sarpong', 'akua.sarpong@yahoo.com', '024-999-0011', 'Circle, Accra, Greater Accra Region'),
('Yaw Kyei', 'yaw.kyei@gmail.com', '055-101-1122', 'Lapaz, Accra, Greater Accra Region'),

-- Kumasi Region
('Nana Yeboah', 'nana.yeboah@gmail.com', '024-202-2233', 'Asokwa, Kumasi, Ashanti Region'),
('Esi Frimpong', 'esi.frimpong@yahoo.com', '055-303-3344', 'Bantama, Kumasi, Ashanti Region'),
('Kwame Amoako', 'kwame.amoako@outlook.com', '024-404-4455', 'Suame, Kumasi, Ashanti Region'),
('Adwoa Ofori', 'adwoa.ofori@gmail.com', '055-505-5566', 'Kejetia, Kumasi, Ashanti Region'),
('Kwaku Agyei', 'kwaku.agyei@yahoo.com', '024-606-6677', 'Atonsu, Kumasi, Ashanti Region'),
('Abena Nyarko', 'abena.nyarko@gmail.com', '055-707-7788', 'Nhyiaeso, Kumasi, Ashanti Region'),
('Kojo Mensah', 'kojo.mensah@outlook.com', '024-808-8899', 'Anloga, Kumasi, Ashanti Region'),

-- Takoradi Region
('Ama Ansah', 'ama.ansah@gmail.com', '024-909-9900', 'Takoradi Market Circle, Western Region'),
('Kwesi Dadzie', 'kwesi.dadzie@yahoo.com', '055-010-0112', 'Sekondi, Western Region'),
('Efua Buabeng', 'efua.buabeng@gmail.com', '024-121-2223', 'Effia, Takoradi, Western Region'),

-- Tamale Region
('Abukari Mahama', 'abukari.mahama@gmail.com', '024-232-3334', 'Central Market, Tamale, Northern Region'),
('Ayisha Ibrahim', 'ayisha.ibrahim@yahoo.com', '055-343-4445', 'Lamashegu, Tamale, Northern Region'),
('Iddrisu Alhassan', 'iddrisu.alhassan@gmail.com', '024-454-5556', 'Vittin, Tamale, Northern Region'),
('Fati Zakaria', 'fati.zakaria@outlook.com', '055-565-6667', 'Kalpohin, Tamale, Northern Region'),
('Salifu Abdul', 'salifu.abdul@gmail.com', '024-676-7778', 'Choggu, Tamale, Northern Region'),

-- Cape Coast Region
('Ekow Baiden', 'ekow.baiden@gmail.com', '024-787-8889', 'Cape Coast Castle Road, Central Region'),
('Araba Quansah', 'araba.quansah@yahoo.com', '055-898-9990', 'Pedu, Cape Coast, Central Region'),
('Kodwo Essien', 'kodwo.essien@gmail.com', '024-909-0001', 'Abura, Cape Coast, Central Region'),

-- Ho Region
('Edem Agbodza', 'edem.agbodza@gmail.com', '024-010-1112', 'Ho Central, Volta Region'),
('Mawuli Kporha', 'mawuli.kporha@yahoo.com', '055-121-2223', 'Bankoe, Ho, Volta Region'),
('Dela Amedeka', 'dela.amedeka@outlook.com', '024-232-3334', 'Heve, Ho, Volta Region'),

-- Sunyani Region
('Akosua Twumasi', 'akosua.twumasi@gmail.com', '024-343-4445', 'Sunyani Market, Bono Region'),
('Kwadwo Opoku', 'kwadwo.opoku@yahoo.com', '055-454-5556', 'Fiapre, Sunyani, Bono Region'),
('Adwoa Donkor', 'adwoa.donkor@gmail.com', '024-565-6667', 'Odumase, Sunyani, Bono Region'),

-- Koforidua Region
('Emmanuel Teye', 'emmanuel.teye@gmail.com', '024-676-7778', 'Galloway, Koforidua, Eastern Region'),
('Grace Nartey', 'grace.nartey@yahoo.com', '055-787-8889', 'Adweso, Koforidua, Eastern Region'),
('Stephen Quartey', 'stephen.quartey@outlook.com', '024-898-9990', 'Oyoko, Koforidua, Eastern Region'),

-- Mixed Cities
('Ibrahim Tanko', 'ibrahim.tanko@gmail.com', '055-909-0001', 'Wa Central, Upper West Region'),
('Gifty Ampofo', 'gifty.ampofo@yahoo.com', '024-010-1213', 'Bolgatanga, Upper East Region'),
('Samuel Addai', 'samuel.addai@gmail.com', '055-121-2324', 'Techiman, Bono East Region'),
('Felicia Amoah', 'felicia.amoah@outlook.com', '024-232-3435', 'Berekum, Bono Region'),
('Richard Oppong', 'richard.oppong@gmail.com', '055-343-4546', 'Nkawkaw, Eastern Region'),
('Patience Mensah', 'patience.mensah@yahoo.com', '024-454-5657', 'Winneba, Central Region'),
('Joseph Addo', 'joseph.addo@gmail.com', '055-565-6768', 'Kasoa, Central Region'),
('Mary Ansah', 'mary.ansah@outlook.com', '024-676-7879', 'Nsawam, Eastern Region'),
('Francis Owusu', 'francis.owusu@gmail.com', '055-787-8980', 'Asamankese, Eastern Region'),
('Lydia Asante', 'lydia.asante@yahoo.com', '024-898-9091', 'Prestea, Western Region'),
('Daniel Boateng', 'daniel.boateng@gmail.com', '055-909-0102', 'Tarkwa, Western Region'),
('Rebecca Osei', 'rebecca.osei@outlook.com', '024-010-1314', 'Hohoe, Volta Region'),
('Benjamin Mensah', 'benjamin.mensah@gmail.com', '055-121-2425', 'Kpando, Volta Region'),
('Ernestina Agyei', 'ernestina.agyei@yahoo.com', '024-232-3536', 'Aflao, Volta Region'),
('Prince Asiedu', 'prince.asiedu@gmail.com', '055-343-4647', 'Ashaiman, Greater Accra Region');


-- =============================================
-- ADDITIONAL PRODUCTS 
-- =============================================

INSERT INTO Products (product_name, category, price) VALUES
-- Electronics (20 products)
('Samsung Smart TV 55"', 'Electronics', 2500.00),
('iPhone 14 Pro', 'Electronics', 4500.00),
('Dell Desktop Computer', 'Electronics', 1800.00),
('iPad Air', 'Electronics', 2200.00),
('Sony PlayStation 5', 'Electronics', 3000.00),
('Xbox Series X', 'Electronics', 2800.00),
('Canon DSLR Camera', 'Electronics', 3500.00),
('Bluetooth Speaker', 'Electronics', 250.00),
('Smartwatch Series 8', 'Electronics', 1500.00),
('HP Laptop', 'Electronics', 1400.00),
('Wireless Keyboard', 'Electronics', 120.00),
('External Hard Drive 2TB', 'Electronics', 350.00),
('USB Flash Drive 128GB', 'Electronics', 80.00),
('Webcam HD', 'Electronics', 200.00),
('Router WiFi 6', 'Electronics', 450.00),
('Power Bank 20000mAh', 'Electronics', 180.00),
('Tablet 10 inch', 'Electronics', 800.00),
('Drone with Camera', 'Electronics', 2000.00),
('VR Headset', 'Electronics', 1800.00),
('Security Camera System', 'Electronics', 1200.00),

-- Furniture (15 products)
('Executive Office Desk', 'Furniture', 1200.00),
('Leather Sofa 3-Seater', 'Furniture', 2500.00),
('Dining Table Set (6 chairs)', 'Furniture', 1800.00),
('Bookshelf Wooden', 'Furniture', 650.00),
('King Size Bed Frame', 'Furniture', 1500.00),
('Office Chair Executive', 'Furniture', 800.00),
('Coffee Table Glass Top', 'Furniture', 450.00),
('Wardrobe 3-Door', 'Furniture', 2000.00),
('TV Stand Modern', 'Furniture', 550.00),
('Study Desk with Drawers', 'Furniture', 700.00),
('Recliner Chair', 'Furniture', 1200.00),
('Bar Stool Set (4 pieces)', 'Furniture', 600.00),
('Shoe Rack Metal', 'Furniture', 250.00),
('Bedside Table', 'Furniture', 300.00),
('Garden Bench', 'Furniture', 400.00),

-- Appliances (10 products)
('Refrigerator Double Door', 'Appliances', 2800.00),
('Microwave Oven', 'Appliances', 450.00),
('Washing Machine 8kg', 'Appliances', 1800.00),
('Air Conditioner 1.5HP', 'Appliances', 2200.00),
('Blender', 'Appliances', 150.00),
('Electric Kettle', 'Appliances', 80.00),
('Toaster', 'Appliances', 120.00),
('Rice Cooker', 'Appliances', 200.00),
('Vacuum Cleaner', 'Appliances', 650.00),
('Iron Steam', 'Appliances', 180.00),

-- Apparel (10 products)
('Adidas Sneakers', 'Apparel', 300.00),
('Nike Sports Jersey', 'Apparel', 180.00),
('Polo Shirt', 'Apparel', 120.00),
('Jeans Trousers', 'Apparel', 150.00),
('Kente Cloth Traditional', 'Apparel', 500.00),
('Leather Belt', 'Apparel', 80.00),
('Baseball Cap', 'Apparel', 50.00),
('Sunglasses Ray-Ban', 'Apparel', 350.00),
('Wristwatch Casio', 'Apparel', 250.00),
('Backpack Travel', 'Apparel', 200.00),

-- Books (5 products)
('Things Fall Apart - Chinua Achebe', 'Books', 45.00),
('African History Encyclopedia', 'Books', 120.00),
('SQL Database Design', 'Books', 85.00),
('Business Management 101', 'Books', 95.00),
('Ghana Recipe Book', 'Books', 60.00);


-- =============================================
-- INVENTORY FOR NEW PRODUCTS
-- =============================================

INSERT INTO Inventory (product_id, quantity_on_hand) VALUES
-- Electronics (Product IDs 9-28)
(9, 25), (10, 30), (11, 15), (12, 20), (13, 10),
(14, 12), (15, 8), (16, 45), (17, 35), (18, 40),
(19, 60), (20, 50), (21, 80), (22, 55), (23, 30),
(24, 40), (25, 18), (26, 15), (27, 12), (28, 20),

-- Furniture (Product IDs 29-43)
(29, 10), (30, 5), (31, 8), (32, 20), (33, 12),
(34, 15), (35, 25), (36, 6), (37, 18), (38, 22),
(39, 10), (40, 15), (41, 30), (42, 28), (43, 12),

-- Appliances (Product IDs 44-53)
(44, 8), (45, 35), (46, 12), (47, 15), (48, 50),
(49, 60), (50, 40), (51, 45), (52, 25), (53, 38),

-- Apparel (Product IDs 54-63)
(54, 40), (55, 55), (56, 70), (57, 65), (58, 15),
(59, 80), (60, 90), (61, 45), (62, 50), (63, 35),

-- Books (Product IDs 64-68)
(64, 100), (65, 50), (66, 75), (67, 60), (68, 80);


-- =============================================
-- INVENTORY LOG (AUDIT TRAIL) FOR NEW PRODUCTS
-- =============================================

INSERT INTO Inventory_Log (product_id, transaction_type, quantity_change, quantity_before, quantity_after, notes, created_by, created_at) VALUES
-- Electronics (Product IDs 9-28)
(9, 'RESTOCK', 25, 0, 25, 'Initial stock setup', 'SYSTEM', NOW()),
(10, 'RESTOCK', 30, 0, 30, 'Initial stock setup', 'SYSTEM', NOW()),
(11, 'RESTOCK', 15, 0, 15, 'Initial stock setup', 'SYSTEM', NOW()),
(12, 'RESTOCK', 20, 0, 20, 'Initial stock setup', 'SYSTEM', NOW()),
(13, 'RESTOCK', 10, 0, 10, 'Initial stock setup', 'SYSTEM', NOW()),
(14, 'RESTOCK', 12, 0, 12, 'Initial stock setup', 'SYSTEM', NOW()),
(15, 'RESTOCK', 8, 0, 8, 'Initial stock setup', 'SYSTEM', NOW()),
(16, 'RESTOCK', 45, 0, 45, 'Initial stock setup', 'SYSTEM', NOW()),
(17, 'RESTOCK', 35, 0, 35, 'Initial stock setup', 'SYSTEM', NOW()),
(18, 'RESTOCK', 40, 0, 40, 'Initial stock setup', 'SYSTEM', NOW()),
(19, 'RESTOCK', 60, 0, 60, 'Initial stock setup', 'SYSTEM', NOW()),
(20, 'RESTOCK', 50, 0, 50, 'Initial stock setup', 'SYSTEM', NOW()),
(21, 'RESTOCK', 80, 0, 80, 'Initial stock setup', 'SYSTEM', NOW()),
(22, 'RESTOCK', 55, 0, 55, 'Initial stock setup', 'SYSTEM', NOW()),
(23, 'RESTOCK', 30, 0, 30, 'Initial stock setup', 'SYSTEM', NOW()),
(24, 'RESTOCK', 40, 0, 40, 'Initial stock setup', 'SYSTEM', NOW()),
(25, 'RESTOCK', 18, 0, 18, 'Initial stock setup', 'SYSTEM', NOW()),
(26, 'RESTOCK', 15, 0, 15, 'Initial stock setup', 'SYSTEM', NOW()),
(27, 'RESTOCK', 12, 0, 12, 'Initial stock setup', 'SYSTEM', NOW()),
(28, 'RESTOCK', 20, 0, 20, 'Initial stock setup', 'SYSTEM', NOW()),

-- Furniture (Product IDs 29-43)
(29, 'RESTOCK', 10, 0, 10, 'Initial stock setup', 'SYSTEM', NOW()),
(30, 'RESTOCK', 5, 0, 5, 'Initial stock setup', 'SYSTEM', NOW()),
(31, 'RESTOCK', 8, 0, 8, 'Initial stock setup', 'SYSTEM', NOW()),
(32, 'RESTOCK', 20, 0, 20, 'Initial stock setup', 'SYSTEM', NOW()),
(33, 'RESTOCK', 12, 0, 12, 'Initial stock setup', 'SYSTEM', NOW()),
(34, 'RESTOCK', 15, 0, 15, 'Initial stock setup', 'SYSTEM', NOW()),
(35, 'RESTOCK', 25, 0, 25, 'Initial stock setup', 'SYSTEM', NOW()),
(36, 'RESTOCK', 6, 0, 6, 'Initial stock setup', 'SYSTEM', NOW()),
(37, 'RESTOCK', 18, 0, 18, 'Initial stock setup', 'SYSTEM', NOW()),
(38, 'RESTOCK', 22, 0, 22, 'Initial stock setup', 'SYSTEM', NOW()),
(39, 'RESTOCK', 10, 0, 10, 'Initial stock setup', 'SYSTEM', NOW()),
(40, 'RESTOCK', 15, 0, 15, 'Initial stock setup', 'SYSTEM', NOW()),
(41, 'RESTOCK', 30, 0, 30, 'Initial stock setup', 'SYSTEM', NOW()),
(42, 'RESTOCK', 28, 0, 28, 'Initial stock setup', 'SYSTEM', NOW()),
(43, 'RESTOCK', 12, 0, 12, 'Initial stock setup', 'SYSTEM', NOW()),

-- Appliances (Product IDs 44-53)
(44, 'RESTOCK', 8, 0, 8, 'Initial stock setup', 'SYSTEM', NOW()),
(45, 'RESTOCK', 35, 0, 35, 'Initial stock setup', 'SYSTEM', NOW()),
(46, 'RESTOCK', 12, 0, 12, 'Initial stock setup', 'SYSTEM', NOW()),
(47, 'RESTOCK', 15, 0, 15, 'Initial stock setup', 'SYSTEM', NOW()),
(48, 'RESTOCK', 50, 0, 50, 'Initial stock setup', 'SYSTEM', NOW()),
(49, 'RESTOCK', 60, 0, 60, 'Initial stock setup', 'SYSTEM', NOW()),
(50, 'RESTOCK', 40, 0, 40, 'Initial stock setup', 'SYSTEM', NOW()),
(51, 'RESTOCK', 45, 0, 45, 'Initial stock setup', 'SYSTEM', NOW()),
(52, 'RESTOCK', 25, 0, 25, 'Initial stock setup', 'SYSTEM', NOW()),
(53, 'RESTOCK', 38, 0, 38, 'Initial stock setup', 'SYSTEM', NOW()),

-- Apparel (Product IDs 54-63)
(54, 'RESTOCK', 40, 0, 40, 'Initial stock setup', 'SYSTEM', NOW()),
(55, 'RESTOCK', 55, 0, 55, 'Initial stock setup', 'SYSTEM', NOW()),
(56, 'RESTOCK', 70, 0, 70, 'Initial stock setup', 'SYSTEM', NOW()),
(57, 'RESTOCK', 65, 0, 65, 'Initial stock setup', 'SYSTEM', NOW()),
(58, 'RESTOCK', 15, 0, 15, 'Initial stock setup', 'SYSTEM', NOW()),
(59, 'RESTOCK', 80, 0, 80, 'Initial stock setup', 'SYSTEM', NOW()),
(60, 'RESTOCK', 90, 0, 90, 'Initial stock setup', 'SYSTEM', NOW()),
(61, 'RESTOCK', 45, 0, 45, 'Initial stock setup', 'SYSTEM', NOW()),
(62, 'RESTOCK', 50, 0, 50, 'Initial stock setup', 'SYSTEM', NOW()),
(63, 'RESTOCK', 35, 0, 35, 'Initial stock setup', 'SYSTEM', NOW()),

-- Books (Product IDs 64-68)
(64, 'RESTOCK', 100, 0, 100, 'Initial stock setup', 'SYSTEM', NOW()),
(65, 'RESTOCK', 50, 0, 50, 'Initial stock setup', 'SYSTEM', NOW()),
(66, 'RESTOCK', 75, 0, 75, 'Initial stock setup', 'SYSTEM', NOW()),
(67, 'RESTOCK', 60, 0, 60, 'Initial stock setup', 'SYSTEM', NOW()),
(68, 'RESTOCK', 80, 0, 80, 'Initial stock setup', 'SYSTEM', NOW());


-- =============================================
-- ADDITIONAL ORDERS 
-- =============================================

INSERT INTO Orders (customer_id, order_date, total_amount, order_status) VALUES
-- October 2023 Orders
(6, '2023-10-02 08:30:00', 0.00, 'Delivered'),
(7, '2023-10-03 11:45:00', 0.00, 'Delivered'),
(8, '2023-10-04 14:20:00', 0.00, 'Delivered'),
(9, '2023-10-06 09:15:00', 0.00, 'Delivered'),
(10, '2023-10-07 16:30:00', 0.00, 'Delivered'),
(11, '2023-10-08 10:00:00', 0.00, 'Delivered'),
(12, '2023-10-09 13:45:00', 0.00, 'Delivered'),
(13, '2023-10-10 15:20:00', 0.00, 'Shipped'),
(14, '2023-10-11 08:50:00', 0.00, 'Shipped'),
(15, '2023-10-12 12:30:00', 0.00, 'Delivered'),

-- November 2023 Orders
(16, '2023-11-01 09:00:00', 0.00, 'Delivered'),
(17, '2023-11-02 14:15:00', 0.00, 'Delivered'),
(18, '2023-11-03 11:30:00', 0.00, 'Shipped'),
(19, '2023-11-04 16:45:00', 0.00, 'Delivered'),
(20, '2023-11-05 10:20:00', 0.00, 'Delivered'),
(21, '2023-11-06 13:00:00', 0.00, 'Shipped'),
(22, '2023-11-07 15:40:00', 0.00, 'Delivered'),
(23, '2023-11-08 08:25:00', 0.00, 'Delivered'),
(24, '2023-11-09 12:10:00', 0.00, 'Shipped'),
(25, '2023-11-11 09:55:00', 0.00, 'Delivered'),
(26, '2023-11-12 14:30:00', 0.00, 'Delivered'),
(27, '2023-11-13 11:15:00', 0.00, 'Shipped'),
(28, '2023-11-14 16:00:00', 0.00, 'Delivered'),
(29, '2023-11-16 10:45:00', 0.00, 'Pending'),
(30, '2023-11-17 13:20:00', 0.00, 'Pending'),

-- December 2023 Orders
(31, '2023-12-02 09:30:00', 0.00, 'Pending'),
(32, '2023-12-03 14:00:00', 0.00, 'Pending'),
(33, '2023-12-04 11:40:00', 0.00, 'Shipped'),
(34, '2023-12-05 15:25:00', 0.00, 'Delivered'),
(35, '2023-12-06 10:10:00', 0.00, 'Delivered'),
(36, '2023-12-07 13:55:00', 0.00, 'Shipped'),
(37, '2023-12-08 08:40:00', 0.00, 'Delivered'),
(38, '2023-12-09 12:25:00', 0.00, 'Delivered'),
(39, '2023-12-10 16:10:00', 0.00, 'Shipped'),
(40, '2023-12-11 09:50:00', 0.00, 'Pending'),
(41, '2023-12-12 14:35:00', 0.00, 'Pending'),
(42, '2023-12-13 11:20:00', 0.00, 'Delivered'),
(43, '2023-12-14 15:05:00', 0.00, 'Shipped'),
(44, '2023-12-15 10:50:00', 0.00, 'Delivered'),
(45, '2023-12-16 13:35:00', 0.00, 'Delivered'),

-- January 2024 Orders
(46, '2024-01-02 09:15:00', 0.00, 'Delivered'),
(47, '2024-01-03 14:40:00', 0.00, 'Delivered'),
(48, '2024-01-04 11:25:00', 0.00, 'Shipped'),
(49, '2024-01-05 16:10:00', 0.00, 'Delivered'),
(50, '2024-01-06 10:55:00', 0.00, 'Delivered'),
(1, '2024-01-07 13:40:00', 0.00, 'Shipped'),
(2, '2024-01-08 08:25:00', 0.00, 'Delivered'),
(3, '2024-01-09 12:10:00', 0.00, 'Pending'),
(4, '2024-01-10 15:55:00', 0.00, 'Pending'),
(5, '2024-01-11 09:40:00', 0.00, 'Delivered'),
(6, '2024-01-12 14:25:00', 0.00, 'Shipped'),
(7, '2024-01-13 11:10:00', 0.00, 'Delivered'),
(8, '2024-01-14 15:55:00', 0.00, 'Delivered');


-- =============================================
-- ORDER ITEMS FOR NEW ORDERS
-- (Triggers will auto-calculate order totals)
-- =============================================

-- Order 6: Samsung TV
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(6, 9, 1, 2500.00);

-- Order 7: iPhone + Wireless Headphones
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(7, 10, 1, 4500.00),
(7, 2, 1, 150.00);

-- Order 8: Leather Sofa
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(8, 30, 1, 2500.00);

-- Order 9: Dell Desktop + Monitor
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(9, 11, 1, 1800.00);

-- Order 10: PlayStation 5 + Gaming Mouse
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(10, 13, 1, 3000.00),
(10, 7, 1, 60.00);

-- Order 11: Dining Table Set
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(11, 31, 1, 1800.00);

-- Order 12: Refrigerator + Microwave
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(12, 44, 1, 2800.00),
(12, 45, 1, 450.00);

-- Order 13: Washing Machine
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(13, 46, 1, 1800.00);

-- Order 14: King Size Bed + Mattress
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(14, 33, 1, 1500.00);

-- Order 15: iPad Air + Smartwatch
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(15, 12, 1, 2200.00),
(15, 17, 1, 1500.00);

-- Order 16: Canon Camera + Memory Card
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(16, 15, 1, 3500.00);

-- Order 17: Executive Office Desk + Chair
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(17, 29, 1, 1200.00),
(17, 34, 1, 800.00);

-- Order 18: Air Conditioner
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(18, 47, 1, 2200.00);

-- Order 19: Adidas Sneakers + Running Shoes
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(19, 54, 2, 300.00);

-- Order 20: Kente Cloth
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(20, 58, 1, 500.00);

-- Order 21: Bluetooth Speaker + Power Bank
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(21, 16, 1, 250.00),
(21, 24, 1, 180.00);

-- Order 22: Bookshelf + Books (3 books)
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(22, 32, 1, 650.00),
(22, 64, 1, 45.00),
(22, 65, 1, 120.00);

-- Order 23: Vacuum Cleaner + Blender
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(23, 52, 1, 650.00),
(23, 48, 1, 150.00);

-- Order 24: Tablet + Wireless Keyboard
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(24, 25, 1, 800.00),
(24, 19, 1, 120.00);

-- Order 25: TV Stand + Coffee Table
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(25, 37, 1, 550.00),
(25, 35, 1, 450.00);

-- Order 26: HP Laptop + External Hard Drive
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(26, 18, 1, 1400.00),
(26, 20, 1, 350.00);

-- Order 27: Wardrobe
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(27, 36, 1, 2000.00);

-- Order 28: Nike Jersey + Jeans
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(28, 55, 2, 180.00),
(28, 57, 1, 150.00);

-- Order 29: Security Camera System + Router
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(29, 28, 1, 1200.00),
(29, 23, 1, 450.00);

-- Order 30: Recliner Chair
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(30, 39, 1, 1200.00);

-- Order 31: Xbox Series X
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(31, 14, 1, 2800.00);

-- Order 32: Rice Cooker + Electric Kettle + Toaster
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(32, 51, 1, 200.00),
(32, 49, 1, 80.00),
(32, 50, 1, 120.00);

-- Order 33: Drone with Camera
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(33, 26, 1, 2000.00);

-- Order 34: Study Desk + Bedside Table
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(34, 38, 1, 700.00),
(34, 42, 1, 300.00);

-- Order 35: VR Headset
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(35, 27, 1, 1800.00);

-- Order 36: Bar Stool Set
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(36, 40, 1, 600.00);

-- Order 37: Sunglasses + Watch + Belt
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(37, 61, 1, 350.00),
(37, 62, 1, 250.00),
(37, 59, 1, 80.00);

-- Order 38: Standing Desk + Ergonomic Chair
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(38, 8, 1, 450.00),
(38, 3, 1, 300.00);

-- Order 39: Backpack + Baseball Cap
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(39, 63, 2, 200.00),
(39, 60, 1, 50.00);

-- Order 40: Webcam + USB Flash Drive
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(40, 22, 1, 200.00),
(40, 21, 2, 80.00);

-- Order 41: Garden Bench + Shoe Rack
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(41, 43, 1, 400.00),
(41, 41, 1, 250.00);

-- Order 42: Iron + Coffee Maker
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(42, 53, 1, 180.00),
(42, 4, 1, 80.00);

-- Order 43: SQL Book + Business Book + Ghana Recipe Book
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(43, 66, 1, 85.00),
(43, 67, 1, 95.00),
(43, 68, 1, 60.00);

-- Order 44: Polo Shirts (5 pieces)
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(44, 56, 5, 120.00);

-- Order 45: Laptop Pro + Gaming Mouse + Headphones
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(45, 1, 1, 1200.00),
(45, 7, 1, 60.00),
(45, 2, 1, 150.00);

-- Order 46: Samsung TV + TV Stand
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(46, 9, 1, 2500.00),
(46, 37, 1, 550.00);

-- Order 47: Refrigerator
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(47, 44, 1, 2800.00);

-- Order 48: Things Fall Apart Book + African History
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(48, 64, 2, 45.00),
(48, 65, 1, 120.00);

-- Order 49: iPhone 14 Pro
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(49, 10, 1, 4500.00);

-- Order 50: Dining Table Set + Bar Stool
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(50, 31, 1, 1800.00),
(50, 40, 1, 600.00);

-- Order 51: PlayStation 5 + Extra Controller
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(51, 13, 1, 3000.00);

-- Order 52: Washing Machine + Iron
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(52, 46, 1, 1800.00),
(52, 53, 1, 180.00);

-- Order 53: Python Programming Book
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(53, 6, 3, 45.00);

-- Order 54: Canon Camera
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(54, 15, 1, 3500.00);

-- Order 55: Executive Desk + Chair + Bookshelf
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(55, 29, 1, 1200.00),
(55, 34, 1, 800.00),
(55, 32, 1, 650.00);

-- Order 56: Air Conditioner
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(56, 47, 1, 2200.00);

-- Order 57: Kente Cloth (2 pieces)
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(57, 58, 2, 500.00);

-- Order 58: Dell Desktop + Monitor
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
(58, 11, 1, 1800.00);


-- =============================================
-- VERIFICATION QUERIES
-- =============================================

-- Count total records in each table
SELECT 'Total Customers' AS Metric, COUNT(*) AS Count FROM Customers
UNION ALL
SELECT 'Total Products', COUNT(*) FROM Products
UNION ALL
SELECT 'Total Inventory Records', COUNT(*) FROM Inventory
UNION ALL
SELECT 'Total Orders', COUNT(*) FROM Orders
UNION ALL
SELECT 'Total Order Items', COUNT(*) FROM Order_Items;

