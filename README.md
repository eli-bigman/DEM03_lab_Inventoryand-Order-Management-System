# Inventory and Order Management System

## Overview
This project is a comprehensive **SQL-based Inventory and Order Management System** designed for e-commerce platforms. It handles the complete lifecycle of products from inventory tracking to order fulfillment.

The system is built using **MySQL** and demonstrates core database concepts including:
- relational schema design
- database normalization
- stored procedures for transactional logic
- triggers for automation
- views for analytics

## Entity Relationship Diagram (ERD)
!["ERD Diagram"](/Database%20ER%20diagram%20(crow's%20foot).png)

## Project Structure

- **`SQL_DDL.sql`**: (Data Definition Language)
  - Creates the database schema.
  - Defines tables: `Customers`, `Products`, `Inventory`, `Orders`, `Order_Items`.
  - Sets up Primary Keys, Foreign Keys, and Constraints.

- **`SQL_DML.sql`**: (Data Manipulation Language)
  - **Seed Data**: Populates tables with initial demo data.
  - **Business Logic**: Contains Stored Procedures (e.g., `ProcessNewOrder`) and Triggers.
  - **Analytics**: Includes queries for KPIs and Views.


## Setup Instructions

1. **Prerequisites**: Ensure you have MySQL Server and a client (like MySQL Workbench, DBeaver, or VS Code SQLTools) installed.
2. **Initialize Schema**:
   Run the content of `SQL_DDL.sql` to create the tables.
   ```sql
   source SQL_DDL.sql;
   ```
3. **Load Data & Logic**:
   Run the content of `SQL_DML.sql` to insert sample data and create the stored procedures.
   ```sql
   source SQL_DML.sql;
   ```

## Key Features

- **Automated Stock Management**: Inventory is automatically deducted when orders are processed.
- **Order Total Calculation**: Triggers automatically update the `total_amount` in the `Orders` table whenever items are modified.
- **Data Integrity**: Enforced via Foreign Keys and Check Constraints (e.g., prices cannot be negative).
- **Transactional Safety**: The `ProcessNewOrder` procedure uses transactions to ensure orders are only created if stock is available.
