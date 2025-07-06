USE StationeryDB;


-- Drop existing tables if they exist (to avoid errors on re-creation)
IF OBJECT_ID('Login_Audit', 'U') IS NOT NULL DROP TABLE Login_Audit;
IF OBJECT_ID('User_t', 'U') IS NOT NULL DROP TABLE User_t;
IF OBJECT_ID('Role_t', 'U') IS NOT NULL DROP TABLE Role_t;
IF OBJECT_ID('Payment', 'U') IS NOT NULL DROP TABLE Payment;
IF OBJECT_ID('Product_Price_Audit', 'U') IS NOT NULL DROP TABLE Product_Price_Audit;
IF OBJECT_ID('Inventory_Transaction', 'U') IS NOT NULL DROP TABLE Inventory_Transaction;
IF OBJECT_ID('Employee', 'U') IS NOT NULL DROP TABLE Employee;
IF OBJECT_ID('Order_Item', 'U') IS NOT NULL DROP TABLE Order_Item;
IF OBJECT_ID('Order_T', 'U') IS NOT NULL DROP TABLE Order_T;
IF OBJECT_ID('Customer', 'U') IS NOT NULL DROP TABLE Customer;
IF OBJECT_ID('Product', 'U') IS NOT NULL DROP TABLE Product;
IF OBJECT_ID('Supplier', 'U') IS NOT NULL DROP TABLE Supplier;
IF OBJECT_ID('Category', 'U') IS NOT NULL DROP TABLE Category;




-- Customer Table
CREATE TABLE Customer (
    Customer_ID INT IDENTITY(11,1) PRIMARY KEY,
    Customer_Name VARCHAR(100) NOT NULL,
    Phone VARCHAR(20),
    Address VARCHAR(255)
);

-- Order Table
CREATE TABLE Order_T (
    Order_ID INT PRIMARY KEY,
    Customer_ID INT,
    Order_Date DATE,
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID)
);

-- Supplier Table
CREATE TABLE Supplier (
    Supplier_ID INT PRIMARY KEY,
    Supplier_Name VARCHAR(100) NOT NULL,
    Phone VARCHAR(20),
    Email VARCHAR(100),
    Address VARCHAR(255),
	City VARCHAR(50),
    State VARCHAR(50),
    Postal_Code VARCHAR(10)
);

-- Category Table
CREATE TABLE Category (
    Category_ID INT PRIMARY KEY,
    Category_Name VARCHAR(100) NOT NULL
);

-- Product Table
CREATE TABLE Product (
    Product_ID INT PRIMARY KEY,
    Product_Name VARCHAR(100) NOT NULL,
    Unit_Price DECIMAL(10, 2),
	Stock_Quantity INT,
    Category_ID INT,
    Supplier_ID INT,
    FOREIGN KEY (Category_ID) REFERENCES Category(Category_ID),
    FOREIGN KEY (Supplier_ID) REFERENCES Supplier(Supplier_ID)
);

-- Order_Item Table
CREATE TABLE Order_Item (
    Order_ID INT,
    Product_ID INT,
    Quantity INT,
	PRIMARY KEY (Order_ID, Product_ID),
    FOREIGN KEY (Order_ID) REFERENCES Order_T(Order_ID),
    FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID)
);

-- Employee Table
CREATE TABLE Employee (
    Employee_ID INT PRIMARY KEY,
    Employee_Name VARCHAR(100) NOT NULL,
    Phone VARCHAR(20),
    Email VARCHAR(100),
    Address VARCHAR(100),
    City VARCHAR(50),
    Hire_Date DATETIME DEFAULT GETDATE(),
    Salary Decimal(10, 2) NOT NULL
);

-- Inventory Transaction Table
CREATE TABLE Inventory_Transaction (
    Transaction_ID INT IDENTITY(1,1) PRIMARY KEY,
    Quantity INT,
    Transaction_Date DATETIME DEFAULT GETDATE(),
	Transaction_Type VARCHAR(50) NOT NULL,
    Employee_ID INT,
    Product_ID INT,
    FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID)
);

-- Audit Log Table
CREATE TABLE Product_Price_Audit (
    Audit_ID INT IDENTITY(1,1) PRIMARY KEY,
    Product_ID INT,
	Old_Price Decimal(10, 2),
    New_Price Decimal(10, 2),
    Change_Date DATETIME DEFAULT GETDATE(),
    Changed_By VARCHAR(50),
	FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID)
);

CREATE TABLE Role_t (
    Role_ID INT PRIMARY KEY IDENTITY(1,1),
    Role_Name VARCHAR(50) NOT NULL UNIQUE
);

-- USER TABLE (renamed to User_t)
CREATE TABLE User_t (
    User_ID INT PRIMARY KEY IDENTITY(1,1),
    Employee_ID INT NOT NULL,
    Username VARCHAR(50) NOT NULL UNIQUE,
    Password_Hash VARCHAR(255) NOT NULL,
    Role_ID INT NOT NULL,
    FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID) ON DELETE CASCADE,
    FOREIGN KEY (Role_ID) REFERENCES Role_t(Role_ID)
);

-- PAYMENT TABLE
CREATE TABLE Payment (
    Payment_ID INT PRIMARY KEY IDENTITY(1,1),
    Order_ID INT NOT NULL,
    Amount_Paid DECIMAL(10, 2) NOT NULL,
    Payment_Date DATE NOT NULL,
    Payment_Mode VARCHAR(30) NOT NULL,
    FOREIGN KEY (Order_ID) REFERENCES Order_T(Order_ID)
);

-- LOGIN_AUDIT TABLE
CREATE TABLE Login_Audit (
    Audit_ID INT PRIMARY KEY IDENTITY(1,1),
    User_ID INT NULL,
    Login_Time DATETIME NOT NULL,
    Logout_Time DATETIME NULL,
    Status VARCHAR(20) NOT NULL CHECK (Status IN ('Success', 'Failure')),
    CONSTRAINT FK_LoginAudit_User
        FOREIGN KEY (User_ID) REFERENCES User_t(User_ID)
        ON DELETE SET NULL
);
   
GO

-- Trigger: Update product stock after order
CREATE TRIGGER trg_update_product_stock
ON Order_Item
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE P
    SET P.Stock_Quantity = P.Stock_Quantity - I.Quantity
    FROM Product P
    INNER JOIN inserted I ON P.Product_ID = I.Product_ID;
END;
GO


GO

-- Trigger: Insert inventory transaction after order
CREATE TRIGGER trg_inv_trans_after_order
ON Order_Item
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Inventory_Transaction (
        Quantity, Transaction_Date, Transaction_Type, Product_ID)
    SELECT 
        I.Quantity,
        GETDATE(),
        'Sale',
        I.Product_ID
    FROM inserted I;
END;
GO

-- Trigger: Check product stock before insert
CREATE TRIGGER trg_check_product_stock
ON Order_Item
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS (
        SELECT 1
        FROM inserted I
        JOIN Product P ON I.Product_ID = P.Product_ID
        WHERE I.Quantity > P.Stock_Quantity
    )
    BEGIN
        RAISERROR ('Insufficient stock for one or more products.', 16, 1);
        RETURN;
    END

    -- Proceed with insert if no error
    INSERT INTO Order_Item (Order_ID, Product_ID, Quantity)
    SELECT Order_ID, Product_ID, Quantity
    FROM inserted;
END;
GO

-- Trigger: Set order date before insert
CREATE TRIGGER trg_set_order_date
ON Order_T
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Order_T (Order_ID, Customer_ID, Order_Date)
    SELECT 
        I.Order_ID,
        I.Customer_ID,
        ISNULL(I.Order_Date, GETDATE())
    FROM inserted I;
END;
GO

-- Trigger: Audit product price changes
CREATE TRIGGER trg_audit_product_price_change
ON Product
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Product_Price_Audit (
        Product_ID, Old_Price, New_Price, Change_Date)
    SELECT 
        D.Product_ID,
        D.Unit_Price,
        I.Unit_Price,
        GETDATE()
    FROM inserted I
    JOIN deleted D ON I.Product_ID = D.Product_ID
    WHERE I.Unit_Price <> D.Unit_Price;
END;
GO

-- Insert data into Customer Table
INSERT INTO Customer (Customer_Name, Phone, Address)
VALUES ('Ahmed Khan', '03011234567', '123 Main Road, Lahore');
INSERT INTO Customer (Customer_Name, Phone, Address)
VALUES ('Ayesha Tariq', '03019876543', '456 Canal View, Lahore');
INSERT INTO Customer (Customer_Name, Phone, Address)
VALUES ('Zain Ali', '03214567890', '789 Shahrah-e-Faisal, Lahore');
INSERT INTO Customer (Customer_Name, Phone, Address)
VALUES ('Fatima Bibi', '03321231234', 'House 32, Gulberg, Lahore');
INSERT INTO Customer (Customer_Name, Phone, Address)
VALUES ('Ali Raza', '03005554433', '10 Civic Center, Lahore');
INSERT INTO Customer (Customer_Name, Phone, Address)
VALUES ('Rabia Anwar', '03455566778', 'Plot 4, Blue Area, Lahore');
INSERT INTO Customer (Customer_Name, Phone, Address)
VALUES ('Usman Tariq', '03007778899', '17 Clifton Block, Lahore');
INSERT INTO Customer (Customer_Name, Phone, Address)
VALUES ('Sara Malik', '03338885566', 'Street 9, Satellite Town, Lahore');
INSERT INTO Customer (Customer_Name, Phone, Address)
VALUES ('Hamza Sheikh', '03119992222', 'Garden Town, Lahore');
INSERT INTO Customer (Customer_Name, Phone, Address)
VALUES ('Hiba Ahmed', '03018889944', 'Phase 4, DHA, Lahore');


-- Insert data into Order_T Table
INSERT INTO Order_T (Order_ID, Order_Date, Customer_ID)
VALUES (101, '2024-12-01', 11);
INSERT INTO Order_T (Order_ID, Order_Date, Customer_ID)
VALUES (102, '2024-12-02', 12);
INSERT INTO Order_T (Order_ID, Order_Date, Customer_ID)
VALUES (103, '2024-12-03', 13);
INSERT INTO Order_T (Order_ID, Order_Date, Customer_ID)
VALUES (104, '2024-12-04', 14);
INSERT INTO Order_T (Order_ID, Order_Date, Customer_ID)
VALUES (105, '2024-12-05', 15);
INSERT INTO Order_T (Order_ID, Order_Date, Customer_ID)
VALUES (106, '2024-12-06', 16);
INSERT INTO Order_T (Order_ID, Order_Date, Customer_ID)
VALUES (107, '2024-12-07', 17);
INSERT INTO Order_T (Order_ID, Order_Date, Customer_ID)
VALUES (108, '2024-12-08', 18);
INSERT INTO Order_T (Order_ID, Order_Date, Customer_ID)
VALUES (109, '2024-12-09', 19);
INSERT INTO Order_T (Order_ID, Order_Date, Customer_ID)
VALUES (110, '2024-12-10', 20);



-- Insert data into Supplier Table
INSERT INTO Supplier (Supplier_ID, Supplier_Name, Phone, Email, Address, City, State, Postal_Code)
VALUES (201, 'Bilal Hassan', '03034445566', 'bilal.hassan@gmail.com', 'Block B, Model Town', 'Lahore', 'Punjab', '54000');
INSERT INTO Supplier (Supplier_ID, Supplier_Name, Phone, Email, Address, City, State, Postal_Code)
VALUES (202, 'Sana Khan', '03225556677', 'sana.khan@hotmail.com', 'Street 12, F-10', 'Lahore', 'Punjab', '54000');
INSERT INTO Supplier (Supplier_ID, Supplier_Name, Phone, Email, Address, City, State, Postal_Code)
VALUES (203, 'Farhan Malik', '03114442233', 'farhan.malik@yahoo.com', 'Phase 2, Gulshan-e-Iqbal', 'Lahore', 'Punjab', '54000');
INSERT INTO Supplier (Supplier_ID, Supplier_Name, Phone, Email, Address, City, State, Postal_Code)
VALUES (204, 'Aqsa Ahmed', '03442223344', 'aqsa.ahmed@gmail.com', 'Sector G-8', 'Lahore', 'Punjab', '54000');
INSERT INTO Supplier (Supplier_ID, Supplier_Name, Phone, Email, Address, City, State, Postal_Code)
VALUES (205, 'Shahzad Ali', '03011112233', 'shahzad.ali@gmail.com', 'Jinnah Colony', 'Lahore', 'Punjab', '54000');
INSERT INTO Supplier (Supplier_ID, Supplier_Name, Phone, Email, Address, City, State, Postal_Code)
VALUES (206, 'Zara Sheikh', '03339998877', 'zara.sheikh@gmail.com', 'Clifton Block 5', 'Lahore', 'Punjab', '54000');
INSERT INTO Supplier (Supplier_ID, Supplier_Name, Phone, Email, Address, City, State, Postal_Code)
VALUES (207, 'Omar Siddiqui', '03156667788', 'omar.siddiqui@yahoo.com', 'Satellite Town', 'Lahore', 'Punjab', '54000');
INSERT INTO Supplier (Supplier_ID, Supplier_Name, Phone, Email, Address, City, State, Postal_Code)
VALUES (208, 'Nadia Jamil', '03227776655', 'nadia.jamil@gmail.com', 'Block A, DHA', 'Lahore', 'Punjab', '54000');
INSERT INTO Supplier (Supplier_ID, Supplier_Name, Phone, Email, Address, City, State, Postal_Code)
VALUES (209, 'Hamid Raza', '03027778888', 'hamid.raza@hotmail.com', 'I.I. Chundrigar Road', 'Lahore', 'Punjab', '54000');
INSERT INTO Supplier (Supplier_ID, Supplier_Name, Phone, Email, Address, City, State, Postal_Code)
VALUES (210, 'Mariam Anwar', '03443332211', 'mariam.anwar@gmail.com', 'Gulberg Greens', 'Lahore', 'Punjab', '54000');

-- Insert data into Category Table
INSERT INTO Category (Category_ID, Category_Name)
VALUES (301, 'Stationery');
INSERT INTO Category (Category_ID, Category_Name)
VALUES (302, 'Office Supplies');
INSERT INTO Category (Category_ID, Category_Name)
VALUES (303, 'Art Supplies');
INSERT INTO Category (Category_ID, Category_Name)
VALUES (304, 'School Supplies');
INSERT INTO Category (Category_ID, Category_Name)
VALUES (305, 'Notebooks');
INSERT INTO Category (Category_ID, Category_Name)
VALUES (306, 'Pens');
INSERT INTO Category (Category_ID, Category_Name)
VALUES (307, 'Markers');
INSERT INTO Category (Category_ID, Category_Name)
VALUES (308, 'Paper Products');
INSERT INTO Category (Category_ID, Category_Name)
VALUES (309, 'Adhesives');
INSERT INTO Category (Category_ID, Category_Name)
VALUES (310, 'Erasers');

-- Insert data into Product Table
INSERT INTO Product (Product_ID, Product_Name, Unit_Price, Stock_Quantity, Category_ID, Supplier_ID)
VALUES (401, 'Ballpoint Pen', 20.00, 200, 306, 201);
INSERT INTO Product (Product_ID, Product_Name, Unit_Price, Stock_Quantity, Category_ID, Supplier_ID)
VALUES (402, 'Notebook', 100.00, 150, 305, 202);
INSERT INTO Product (Product_ID, Product_Name, Unit_Price, Stock_Quantity, Category_ID, Supplier_ID)
VALUES (403, 'Permanent Marker', 50.00, 300, 307, 203);
INSERT INTO Product (Product_ID, Product_Name, Unit_Price, Stock_Quantity, Category_ID, Supplier_ID)
VALUES (404, 'Glue Stick', 60.00, 100, 309, 204);
INSERT INTO Product (Product_ID, Product_Name, Unit_Price, Stock_Quantity, Category_ID, Supplier_ID)
VALUES (405, 'Sketchbook', 200.00, 50, 303, 205);
INSERT INTO Product (Product_ID, Product_Name, Unit_Price, Stock_Quantity, Category_ID, Supplier_ID)
VALUES (406, 'Ruler', 40.00, 120, 304, 206);
INSERT INTO Product (Product_ID, Product_Name, Unit_Price, Stock_Quantity, Category_ID, Supplier_ID)
VALUES (407, 'Sharpener', 30.00, 180, 304, 207);
INSERT INTO Product (Product_ID, Product_Name, Unit_Price, Stock_Quantity, Category_ID, Supplier_ID)
VALUES (408, 'Eraser', 10.00, 250, 310, 208);
INSERT INTO Product (Product_ID, Product_Name, Unit_Price, Stock_Quantity, Category_ID, Supplier_ID)
VALUES (409, 'Sticky Notes', 80.00, 90, 308, 209);
INSERT INTO Product (Product_ID, Product_Name, Unit_Price, Stock_Quantity, Category_ID, Supplier_ID)
VALUES (410, 'Highlighter', 35.00, 300, 307, 210);
INSERT INTO Product (Product_ID, Product_Name, Unit_Price, Stock_Quantity, Category_ID, Supplier_ID)
VALUES (411, 'Binder Clips', 25.00, 200, 302, 201);
INSERT INTO Product (Product_ID, Product_Name, Unit_Price, Stock_Quantity, Category_ID, Supplier_ID)
VALUES (412, 'Fountain Pen', 300.00, 100, 306, 202);
INSERT INTO Product (Product_ID, Product_Name, Unit_Price, Stock_Quantity, Category_ID, Supplier_ID)
VALUES (413, 'Drawing Pencil Set', 120.00, 50, 303, 203);
INSERT INTO Product (Product_ID, Product_Name, Unit_Price, Stock_Quantity, Category_ID, Supplier_ID)
VALUES (414, 'Paper Ream', 500.00, 30, 308, 204);
INSERT INTO Product (Product_ID, Product_Name, Unit_Price, Stock_Quantity, Category_ID, Supplier_ID)
VALUES (415, 'Correction Tape', 70.00, 150, 309, 205);
INSERT INTO Product (Product_ID, Product_Name, Unit_Price, Stock_Quantity, Category_ID, Supplier_ID)
VALUES (416, 'Colored Markers Pack', 400.00, 20, 307, 206);
INSERT INTO Product (Product_ID, Product_Name, Unit_Price, Stock_Quantity, Category_ID, Supplier_ID)
VALUES (417, 'Compass', 150.00, 75, 304, 207);
INSERT INTO Product (Product_ID, Product_Name, Unit_Price, Stock_Quantity, Category_ID, Supplier_ID)
VALUES (418, 'Plastic File Folder', 50.00, 120, 302, 208);
INSERT INTO Product (Product_ID, Product_Name, Unit_Price, Stock_Quantity, Category_ID, Supplier_ID)
VALUES (419, 'Whiteboard', 800.00, 10, 308, 209);
INSERT INTO Product (Product_ID, Product_Name, Unit_Price, Stock_Quantity, Category_ID, Supplier_ID)
VALUES (420, 'Poster Paint Set', 600.00, 25, 303, 210);

-- Insert data into Employee Table
INSERT INTO Employee (Employee_ID, Employee_Name, Phone, Email, Address, City, Hire_Date, Salary)
VALUES (501, 'Imran Sheikh', '03012345678', 'imran.sheikh@store.com', 'Street 45, DHA', 'Lahore', '2020-01-15', 45000);
INSERT INTO Employee (Employee_ID, Employee_Name, Phone, Email, Address, City, Hire_Date, Salary)
VALUES (502, 'Ayesha Siddiq', '03123456789', 'ayesha.siddiq@store.com', 'Block C, Model Town', 'Lahore', '2019-06-12', 50000);
INSERT INTO Employee (Employee_ID, Employee_Name, Phone, Email, Address, City, Hire_Date, Salary)
VALUES (503, 'Ali Raza', '03214567890', 'ali.raza@store.com', 'Street 10, Gulberg', 'Lahore', '2021-03-22', 47000);
INSERT INTO Employee (Employee_ID, Employee_Name, Phone, Email, Address, City, Hire_Date, Salary)
VALUES (504, 'Fatima Khan', '03312345678', 'fatima.khan@store.com', 'Sector F, Johar Town', 'Lahore', '2022-11-01', 43000);
INSERT INTO Employee (Employee_ID, Employee_Name, Phone, Email, Address, City, Hire_Date, Salary)
VALUES (505, 'Usman Tariq', '03456789012', 'usman.tariq@store.com', 'Street 3, Wapda Town', 'Lahore', '2018-08-05', 48000);
INSERT INTO Employee (Employee_ID, Employee_Name, Phone, Email, Address, City, Hire_Date, Salary)
VALUES (506, 'Sara Ahmed', '03567890123', 'sara.ahmed@store.com', 'Street 2, Faisal Town', 'Lahore', '2023-05-17', 42000);
INSERT INTO Employee (Employee_ID, Employee_Name, Phone, Email, Address, City, Hire_Date, Salary)
VALUES (507, 'Hamza Malik', '03678901234', 'hamza.malik@store.com', 'Block A, Township', 'Lahore', '2020-09-10', 46000);
INSERT INTO Employee (Employee_ID, Employee_Name, Phone, Email, Address, City, Hire_Date, Salary)
VALUES (508, 'Nida Anwar', '03789012345', 'nida.anwar@store.com', 'Street 8, Cantt', 'Lahore', '2021-07-03', 49000);
INSERT INTO Employee (Employee_ID, Employee_Name, Phone, Email, Address, City, Hire_Date, Salary)
VALUES (509, 'Zain Tariq', '03890123456', 'zain.tariq@store.com', 'Street 6, Valencia Town', 'Lahore', '2022-01-25', 44000);
INSERT INTO Employee (Employee_ID, Employee_Name, Phone, Email, Address, City, Hire_Date, Salary)
VALUES (510, 'Hiba Sheikh', '03901234567', 'hiba.sheikh@store.com', 'Street 9, Phase 6 DHA', 'Lahore', '2019-04-18', 51000);


-- Insert data into Order_Item Table
INSERT INTO Order_Item (Order_ID, Product_ID, Quantity)
VALUES (101, 401, 5);
INSERT INTO Order_Item (Order_ID, Product_ID, Quantity)
VALUES (102, 402, 3);
INSERT INTO Order_Item (Order_ID, Product_ID, Quantity)
VALUES (103, 403, 10);
INSERT INTO Order_Item (Order_ID, Product_ID, Quantity)
VALUES (104, 404, 2);
INSERT INTO Order_Item (Order_ID, Product_ID, Quantity)
VALUES (105, 405, 1);
INSERT INTO Order_Item (Order_ID, Product_ID, Quantity)
VALUES (106, 406, 4);
INSERT INTO Order_Item (Order_ID, Product_ID, Quantity)
VALUES (107, 407, 8);
INSERT INTO Order_Item (Order_ID, Product_ID, Quantity)
VALUES (108, 401, 6);
INSERT INTO Order_Item (Order_ID, Product_ID, Quantity)
VALUES (109, 402, 2);
INSERT INTO Order_Item (Order_ID, Product_ID, Quantity)
VALUES (110, 403, 9);

-- Insert data into Inventory_Transaction Table
INSERT INTO Inventory_Transaction (Quantity, Transaction_Date, Transaction_Type, Employee_ID, Product_ID)
VALUES (50, '2024-11-30', 'Restock', 501, 401);
INSERT INTO Inventory_Transaction (Quantity, Transaction_Date, Transaction_Type, Employee_ID, Product_ID)
VALUES (30, '2024-12-01', 'Restock', 502, 402);
INSERT INTO Inventory_Transaction (Quantity, Transaction_Date, Transaction_Type, Employee_ID, Product_ID)
VALUES (40, '2024-12-02', 'Sale', 503, 403);
INSERT INTO Inventory_Transaction (Quantity, Transaction_Date, Transaction_Type, Employee_ID, Product_ID)
VALUES (10, '2024-12-03', 'Sale', 504, 404);
INSERT INTO Inventory_Transaction (Quantity, Transaction_Date, Transaction_Type, Employee_ID, Product_ID)
VALUES (20, '2024-12-04', 'Restock', 505, 405);
INSERT INTO Inventory_Transaction (Quantity, Transaction_Date, Transaction_Type, Employee_ID, Product_ID)
VALUES (15, '2024-12-05', 'Sale', 506, 406);
INSERT INTO Inventory_Transaction (Quantity, Transaction_Date, Transaction_Type, Employee_ID, Product_ID)
VALUES (25, '2024-12-06', 'Restock', 507, 407);
INSERT INTO Inventory_Transaction (Quantity, Transaction_Date, Transaction_Type, Employee_ID, Product_ID)
VALUES (10, '2024-12-07', 'Sale', 508, 401);
INSERT INTO Inventory_Transaction (Quantity, Transaction_Date, Transaction_Type, Employee_ID, Product_ID)
VALUES (20, '2024-12-08', 'Restock', 509, 402);
INSERT INTO Inventory_Transaction (Quantity, Transaction_Date, Transaction_Type, Employee_ID, Product_ID)
VALUES (5, '2024-12-09', 'Sale', 510, 403);

INSERT INTO Role_t (Role_Name) VALUES
('Admin'),
('Manager'),
('Salesperson');

INSERT INTO User_t (Employee_ID, Username, Password_Hash, Role_ID)
VALUES
(501, 'admin', 'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', 1),
(502, 'manager', 'hmSFeWz6jXwM9xEWQCBbgwdkM1R1d1EdgfgDCumezqU=', 2),
(503, 'sales', 'a8CmPLKckjBgIMCmu8NYzEYo2yd9wG4lNTXhJlF61jc=', 3);