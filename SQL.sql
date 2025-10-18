CREATE TABLE Setting (
    SettingID SERIAL PRIMARY KEY,
    Type VARCHAR(50) NOT NULL,   -- 'Role', 'Category', 'Unit', 'Status'
    Value VARCHAR(100) NOT NULL,
    Description VARCHAR(255),
    IsActive BOOLEAN DEFAULT TRUE
);

---
-- ============================================
-- 2. Bảng Supplier
-- ============================================
CREATE TABLE Supplier (
    SupplierID SERIAL PRIMARY KEY,
    SupplierName VARCHAR(100) NOT NULL,
    ContactName VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(20),
    Address VARCHAR(255),
    IsActive BOOLEAN DEFAULT TRUE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

---
-- ============================================
-- 3. Bảng User
-- ============================================
CREATE TABLE "User" (
    UserID SERIAL PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    PasswordHash VARCHAR(255) NOT NULL,
    Gender VARCHAR(10) NOT NULL CHECK (Gender IN ('Nam', 'Nữ')),
    Phone VARCHAR(20),
    Address VARCHAR(255),
    AvatarUrl VARCHAR(500),  -- URL ảnh đại diện
    RoleID INT NOT NULL,  -- Tham chiếu Setting(Type='Role')
    IsActive BOOLEAN DEFAULT TRUE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (RoleID) REFERENCES Setting(SettingID)
);

---
-- ============================================
-- 4. Bảng Shop
-- ============================================
CREATE TABLE Shop (
    ShopID SERIAL PRIMARY KEY,
    ShopName VARCHAR(100) NOT NULL,
    Address VARCHAR(255),
    Phone VARCHAR(20),
    OwnerID INT,  -- ID của chủ shop (tham chiếu User)
    APIToken VARCHAR(255) UNIQUE NOT NULL,  -- Token API để truy cập thông tin shop
    IsActive BOOLEAN DEFAULT TRUE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (OwnerID) REFERENCES "User"(UserID)
);

---
-- ============================================
-- 5. Bảng Product (sản phẩm bán)
-- ============================================
CREATE TABLE Product (
    ProductID SERIAL PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Description VARCHAR(255),
    ImageUrl VARCHAR(500),     -- URL ảnh sản phẩm
    CategoryID INT NOT NULL,   -- Tham chiếu Setting(Type='Category')
    Price DECIMAL(10,2) NOT NULL,
    SupplierID INT,            -- Nhà cung cấp
    IsActive BOOLEAN DEFAULT TRUE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CategoryID) REFERENCES Setting(SettingID),
    FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID)
);

---
-- ============================================
-- 6. Bảng Ingredient (nguyên liệu)
-- ============================================
CREATE TABLE Ingredient (
    IngredientID SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    UnitID INT,   -- Tham chiếu Setting(Type='Unit')
    StockQuantity DECIMAL(10,2) DEFAULT 0,
    SupplierID INT,   -- Nhà cung cấp
    IsActive BOOLEAN DEFAULT TRUE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UnitID) REFERENCES Setting(SettingID),
    FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID)
);

---
-- ============================================
-- 7. Bảng Purchase Order (PO - nhập hàng từ Supplier)
-- ============================================
CREATE TABLE PurchaseOrder (
    POID SERIAL PRIMARY KEY,
    ShopID INT NOT NULL,
    SupplierID INT NOT NULL,
    CreatedBy INT NOT NULL,
    StatusID INT,   -- Tham chiếu Setting(Type='POStatus')
    RejectReason VARCHAR(500),   -- Lý do từ chối/hủy đơn hàng
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ShopID) REFERENCES Shop(ShopID),
    FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID),
    FOREIGN KEY (CreatedBy) REFERENCES "User"(UserID),
    FOREIGN KEY (StatusID) REFERENCES Setting(SettingID)
);

CREATE TABLE PurchaseOrderDetail (
    PODetailID SERIAL PRIMARY KEY,
    POID INT NOT NULL,
    IngredientID INT NOT NULL,
    Quantity DECIMAL(10,2) NOT NULL,
    ReceivedQuantity DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (POID) REFERENCES PurchaseOrder(POID) ON DELETE CASCADE,
    FOREIGN KEY (IngredientID) REFERENCES Ingredient(IngredientID)
);

---
-- ============================================
-- 8. Bảng Issue (nguyên liệu hỏng/lỗi)
-- ============================================
CREATE TABLE Issue (
    IssueID SERIAL PRIMARY KEY,
    IngredientID INT NOT NULL,
    Description VARCHAR(500),  -- Mô tả chi tiết vấn đề
    Quantity DECIMAL(10,2) NOT NULL,
    StatusID INT,  -- Tham chiếu Setting(Type='IssueStatus')
    CreatedBy INT NOT NULL,
    ConfirmedBy INT,
    RejectionReason VARCHAR(500),  -- Lý do từ chối xử lý (nếu có)
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (IngredientID) REFERENCES Ingredient(IngredientID),
    FOREIGN KEY (CreatedBy) REFERENCES "User"(UserID),
    FOREIGN KEY (ConfirmedBy) REFERENCES "User"(UserID),
    FOREIGN KEY (StatusID) REFERENCES Setting(SettingID)
);

---
-- ============================================
-- 9. Bảng Order (khách đặt sản phẩm)
-- ============================================
CREATE TABLE "Order" (
    OrderID SERIAL PRIMARY KEY,
    ShopID INT NOT NULL,
    CreatedBy INT NOT NULL,
    StatusID INT,   -- Tham chiếu Setting(Type='OrderStatus')
    CancellationReason VARCHAR(500),  -- Lý do hủy đơn (nếu có)
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ShopID) REFERENCES Shop(ShopID),
    FOREIGN KEY (CreatedBy) REFERENCES "User"(UserID),
    FOREIGN KEY (StatusID) REFERENCES Setting(SettingID)
);

CREATE TABLE OrderDetail (
    OrderDetailID SERIAL PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES "Order"(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

---
-- ============================================
-- DATA INSERTION - DỮ LIỆU MẪU
-- ============================================

-- 1. Thêm dữ liệu cho bảng Setting
INSERT INTO Setting (Type, Value, Description, IsActive) VALUES
-- Role
('Role', 'HR', 'Nhân sự - Quản lý nhân viên', TRUE),
('Role', 'Admin', 'Quản trị viên hệ thống', TRUE),
('Role', 'Inventory', 'Quản lý kho - Nhập xuất hàng', TRUE),
('Role', 'Barista', 'Pha chế - Nhân viên pha cà phê', TRUE),
('Role', 'User', 'Người dùng - Xem thông tin shop', TRUE),

-- Categorie
('Category', 'Espresso', 'Các loại cà phê espresso', TRUE),
('Category', 'Cold Brew', 'Cà phê pha lạnh', TRUE),
('Category', 'Latte', 'Cà phê sữa nghệ thuật', TRUE),
('Category', 'Frappuccino', 'Đồ uống đá xay', TRUE),
('Category', 'Tea', 'Các loại trà', TRUE),
('Category', 'Pastry', 'Bánh ngọt và bánh mì', TRUE),
('Category', 'Dessert', 'Tráng miệng', TRUE),

-- Unit
('Unit', 'kg', 'Kilogram', TRUE),
('Unit', 'g', 'Gram', TRUE),
('Unit', 'l', 'Lít', TRUE),
('Unit', 'ml', 'Mililit', TRUE),
('Unit', 'pack', 'Gói', TRUE),
('Unit', 'bottle', 'Chai', TRUE),
('Unit', 'bag', 'Bao', TRUE),

-- Purchase Order Status
('POStatus', 'Pending', 'Đơn hàng chờ xử lý', TRUE),
('POStatus', 'Approved', 'Đơn hàng đã được duyệt', TRUE),
('POStatus', 'Shipping', 'Đang giao hàng', TRUE),
('POStatus', 'Received', 'Đã nhận hàng', TRUE),
('POStatus', 'Cancelled', 'Đã hủy đơn hàng', TRUE),

-- Issue Status
('IssueStatus', 'Reported', 'Đã báo cáo sự cố', TRUE),
('IssueStatus', 'Under Investigation', 'Đang điều tra', TRUE),
('IssueStatus', 'Resolved', 'Đã giải quyết', TRUE),
('IssueStatus', 'Rejected', 'Từ chối xử lý', TRUE),

-- Order Status
('OrderStatus', 'New', 'Đơn hàng mới', TRUE),
('OrderStatus', 'Preparing', 'Đang chuẩn bị', TRUE),
('OrderStatus', 'Ready', 'Sẵn sàng', TRUE),
('OrderStatus', 'Completed', 'Đã hoàn thành', TRUE),
('OrderStatus', 'Cancelled', 'Đã hủy', TRUE);

-- Reset sequence after explicit inserts for auto-incrementing columns
SELECT setval('setting_settingid_seq', (SELECT max(SettingID) FROM Setting));

---
-- 2. Thêm dữ liệu cho bảng Suppliers
INSERT INTO Supplier (SupplierName, ContactName, Email, Phone, Address, IsActive) VALUES
('Công ty TNHH Cà phê Highlands', 'Nguyễn Văn An', 'contact@highlands.com.vn', '0901234567', '123 Đường Nguyễn Huệ, Q1, TP.HCM', TRUE),
('Trung Nguyên Coffee', 'Lê Thị Bình', 'sales@trungnguyencoffee.com', '0912345678', '456 Đường Lê Lợi, Q1, TP.HCM', TRUE),
('Công ty Sữa TH True Milk', 'Trần Minh Châu', 'wholesale@thmilk.vn', '0923456789', '789 Đường Điện Biên Phủ, Q3, TP.HCM', TRUE),
('Công ty Bánh Kẹo Kinh Đô', 'Phạm Văn Dũng', 'b2b@kinh-do.com.vn', '0934567890', '321 Đường Cách Mạng Tháng 8, Q10, TP.HCM', TRUE),
('Công ty Đường Biên Hòa', 'Hoàng Thị Lan', 'contact@bienhoasugar.com', '0945678901', '654 Đường Xô Viết Nghệ Tĩnh, Biên Hòa, Đồng Nai', TRUE);

---
-- 3. Thêm dữ liệu cho bảng User (RoleID references SettingID for Role)
-- Role IDs: HR=1, Admin=2, Inventory=3, Barista=4, User=5
INSERT INTO "User" (FullName, Email, PasswordHash, Gender, Phone, Address, RoleID, IsActive) VALUES
('Nguyễn Thị Hồng', 'hr@gmail.com', '$2a$10$Tna2uT0s8BRJ3oAiQyvUmOipacGm3ObrzS3FlDTxh5GqFu0QsBoli', 'Nữ', '0901234567', '123 Đường Lê Lợi, Q1, TP.HCM', 1, TRUE),
('Trần Minh Quân', 'admin@gmail.com', '$2a$10$Tna2uT0s8BRJ3oAiQyvUmOipacGm3ObrzS3FlDTxh5GqFu0QsBoli', 'Nam', '0912345678', '456 Đường Nguyễn Huệ, Q1, TP.HCM', 2, TRUE),
('Lê Thị Mai', 'staff@gmail.com', '$2a$10$Tna2uT0s8BRJ3oAiQyvUmOipacGm3ObrzS3FlDTxh5GqFu0QsBoli', 'Nữ', '0923456789', '789 Đường Điện Biên Phủ, Q3, TP.HCM', 3, TRUE),
('Nguyễn Văn Hùng', 'inventory.hn@coffeelux.com', '$2a$10$Tna2uT0s8BRJ3oAiQyvUmOipacGm3ObrzS3FlDTxh5GqFu0QsBoli', 'Nam', '0934567890', '321 Đường Hoàn Kiếm, Hà Nội', 3, TRUE),
('Phạm Thị Linh', 'employee01@coffeelux.com', '$2a$10$Tna2uT0s8BRJ3oAiQyvUmOipacGm3ObrzS3FlDTxh5GqFu0QsBoli', 'Nữ', '0945678901', '654 Đường Cách Mạng Tháng 8, Q10, TP.HCM', 3, TRUE),
('Hoàng Minh Tú', 'employee02@coffeelux.com', '$2a$10$Tna2uT0s8BRJ3oAiQyvUmOipacGm3ObrzS3FlDTxh5GqFu0QsBoli', 'Nam', '0956789012', '987 Đường Trần Phú, Q5, TP.HCM', 3, TRUE),
('Vũ Thị Nam', 'barista@gmail.com', '$2a$10$Tna2uT0s8BRJ3oAiQyvUmOipacGm3ObrzS3FlDTxh5GqFu0QsBoli', 'Nữ', '0967890123', '147 Đường Lý Tự Trọng, Q1, TP.HCM', 4, TRUE),
('Đỗ Văn Phong', 'cashier02@coffeelux.com', '$2a$10$Tna2uT0s8BRJ3oAiQyvUmOipacGm3ObrzS3FlDTxh5GqFu0QsBoli', 'Nam', '0978901234', '258 Đường Võ Thị Sáu, Q3, TP.HCM', 4, TRUE),
('Trần Văn Bình', 'user@gmail.com', '$2a$10$Tna2uT0s8BRJ3oAiQyvUmOipacGm3ObrzS3FlDTxh5GqFu0QsBoli', 'Nam', '0989012345', '369 Đường Hai Bà Trưng, Q1, TP.HCM', 5, TRUE);

---
-- 4. Thêm dữ liệu cho bảng Shops với API Token dạng JWT
INSERT INTO Shop (ShopName, Address, Phone, OwnerID, APIToken, IsActive) VALUES
('CoffeeLux - Chi nhánh Quận 1', '123 Đường Đồng Khởi, P. Bến Nghé, Q1, TP.HCM', '02838234567', 2, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaG9wX2lkIjoiYTFiMmMzZDQtZTVmNi00Nzg5LTkwYWItYmNkZWYxMjM0NTY3IiwiaWF0IjoxNzI5MjMwMDAwfQ.a8f3b2c1d4e5f6g7h8i9j0k1', TRUE),
('CoffeeLux - Chi nhánh Quận 3', '456 Đường Võ Văn Tần, P.6, Q3, TP.HCM', '02838345678', 2, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaG9wX2lkIjoiYjJjM2Q0ZTUtZjZnNy01ODkwLWExYi1jZGVmMjM0NTY3ODkiLCJpYXQiOjE3MjkyMzAwMDB9.b9g4c3d2e5f6g7h8i9j0k1l2', TRUE),
('CoffeeLux - Chi nhánh Hà Nội', '789 Đường Hoàn Kiếm, P. Hàng Trống, Q. Hoàn Kiếm, HN', '02438456789', 2, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaG9wX2lkIjoiYzNkNGU1ZjYtZzdoOC02OTAxLWIyYy1kZWYzNDU2Nzg5MDEiLCJpYXQiOjE3MjkyMzAwMDB9.c0h5d4e6f7g8h9i0j1k2l3m4', TRUE),
('CoffeeLux - Chi nhánh Đà Nẵng', '321 Đường Trần Phú, P. Thạch Thang, Q. Hải Châu, ĐN', '02363567890', 2, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaG9wX2lkIjoiZDRlNWY2ZzctaDhpOS03MDEyLWMzZC1lZjQ1Njc4OTAxMjMiLCJpYXQiOjE3MjkyMzAwMDB9.d1i6e7f8g9h0i1j2k3l4m5n6', TRUE);

---
-- 5. Thêm dữ liệu cho bảng Products (CategoryID references SettingID for Category, SupplierID references Suppliers)
-- Category IDs: Espresso=6, Cold Brew=7, Latte=8, Frappuccino=9, Tea=10, Pastry=11, Dessert=12
INSERT INTO Product (ProductName, Description, CategoryID, Price, SupplierID, IsActive) VALUES
-- Espresso Products
('Americano', 'Cà phê đen truyền thống', 6, 35000.00, 1, TRUE),
('Espresso', 'Cà phê espresso đậm đà', 6, 30000.00, 1, TRUE),
('Double Espresso', 'Espresso tăng cường', 6, 45000.00, 1, TRUE),

-- Cold Brew Products
('Cold Brew Original', 'Cà phê pha lạnh nguyên chất', 7, 45000.00, 2, TRUE),
('Cold Brew Vanilla', 'Cà phê lạnh vị vanilla', 7, 50000.00, 2, TRUE),

-- Latte Products
('Caffe Latte', 'Cà phê sữa nghệ thuật', 8, 55000.00, 1, TRUE),
('Vanilla Latte', 'Latte vị vanilla', 8, 60000.00, 1, TRUE),
('Caramel Latte', 'Latte vị caramel', 8, 65000.00, 1, TRUE),

-- Frappuccino Products
('Chocolate Frappuccino', 'Đá xay chocolate', 9, 70000.00, 3, TRUE),
('Coffee Frappuccino', 'Đá xay cà phê', 9, 65000.00, 3, TRUE),

-- Tea Products
('Green Tea Latte', 'Trà xanh sữa', 10, 50000.00, 2, TRUE),
('Earl Grey Tea', 'Trà Earl Grey', 10, 40000.00, 2, TRUE),

-- Pastry Products
('Croissant', 'Bánh sừng bò bơ', 11, 25000.00, 4, TRUE),
('Chocolate Muffin', 'Bánh muffin chocolate', 11, 30000.00, 4, TRUE),
('Blueberry Scone', 'Bánh scone việt quất', 11, 35000.00, 4, TRUE),

-- Dessert Products
('Tiramisu', 'Bánh tiramisu Ý', 12, 65000.00, 4, TRUE),
('Cheesecake', 'Bánh phô mai New York', 12, 70000.00, 4, TRUE);

---
-- 6. Thêm dữ liệu cho bảng Ingredients (UnitID references SettingID for Unit, SupplierID references Suppliers)
-- Unit IDs: kg=13, g=14, l=15, ml=16, pack=17, bottle=18, bag=19
INSERT INTO Ingredient (Name, UnitID, StockQuantity, SupplierID, IsActive) VALUES
-- Coffee beans and powder
('Cà phê Arabica hạt', 13, 50.00, 1, TRUE),      -- kg
('Cà phê Robusta hạt', 13, 30.00, 2, TRUE),      -- kg
('Cà phê Espresso xay', 13, 20.00, 1, TRUE),     -- kg

-- Dairy products
('Sữa tươi nguyên kem', 16, 100.00, 3, TRUE),    -- ml
('Sữa đặc có đường', 19, 50.00, 3, TRUE),        -- bag
('Kem tươi', 16, 25.00, 3, TRUE),                -- ml
('Sữa hạnh nhân', 16, 30.00, 3, TRUE),           -- ml

-- Sweeteners
('Đường trắng', 13, 25.00, 5, TRUE),             -- kg
('Đường nâu', 13, 15.00, 5, TRUE),               -- kg
('Mật ong', 18, 20.00, 5, TRUE),                 -- bottle

-- Syrups and flavors
('Syrup Vanilla', 18, 15.00, 4, TRUE),           -- bottle
('Syrup Caramel', 18, 12.00, 4, TRUE),           -- bottle
('Syrup Hazelnut', 18, 10.00, 4, TRUE),          -- bottle

-- Baking ingredients
('Bột mì đa dụng', 13, 40.00, 4, TRUE),          -- kg
('Bột chocolate', 13, 8.00, 4, TRUE),            -- kg
('Bột nở', 17, 20.00, 4, TRUE),                  -- pack
('Trứng gà', 17, 50.00, 4, TRUE),                -- pack
('Bơ lạt', 13, 15.00, 4, TRUE),                  -- kg

-- Tea leaves
('Lá trà xanh', 17, 25.00, 2, TRUE),             -- pack
('Lá trà Earl Grey', 17, 20.00, 2, TRUE),        -- pack
('Lá trà Oolong', 17, 15.00, 2, TRUE);           -- pack

---
-- 7. Thêm dữ liệu cho bảng PurchaseOrders (StatusID references SettingID for POStatus)
-- POStatus IDs: Pending=20, Approved=21, Shipping=22, Received=23, Cancelled=24
INSERT INTO PurchaseOrder (ShopID, SupplierID, CreatedBy, StatusID) VALUES
(1, 1, 3, 23), -- Received - Created by Inventory HCM
(1, 3, 3, 22), -- Shipping - Created by Inventory HCM
(2, 2, 4, 21), -- Approved - Created by Inventory HN
(3, 4, 4, 20), -- Pending - Created by Inventory HN
(4, 5, 3, 23); -- Received - Created by Inventory HCM

-- 8. Thêm dữ liệu cho bảng PurchaseOrderDetails
INSERT INTO PurchaseOrderDetail (POID, IngredientID, Quantity, ReceivedQuantity) VALUES
-- PO 1 (Received)
(1, 1, 20.00, 20.00),    -- Cà phê Arabica
(1, 4, 50.00, 50.00),    -- Sữa tươi
(1, 7, 10.00, 10.00),    -- Đường trắng

-- PO 2 (Shipping)
(2, 4, 30.00, 0.00),     -- Sữa tươi
(2, 5, 20.00, 0.00),     -- Sữa đặc
(2, 6, 15.00, 0.00),     -- Kem tươi

-- PO 3 (Approved)
(3, 2, 15.00, 0.00),     -- Cà phê Robusta
(3, 3, 10.00, 0.00),     -- Espresso xay

-- PO 4 (Pending)
(4, 13, 30.00, 0.00),    -- Bột mì
(4, 15, 15.00, 0.00),    -- Bột nở
(4, 16, 40.00, 0.00),    -- Trứng

-- PO 5 (Received)
(5, 8, 20.00, 20.00),    -- Đường nâu
(5, 9, 15.00, 15.00);    -- Mật ong

---
-- 9. Thêm dữ liệu cho bảng Issues (StatusID references SettingID for IssueStatus)
-- IssueStatus IDs: Reported=25, Under Investigation=26, Resolved=27, Rejected=28
INSERT INTO Issue (IngredientID, Description, Quantity, StatusID, CreatedBy, ConfirmedBy) VALUES
(1, 'Cà phê Arabica bị ẩm mốc, có mùi lạ không thể sử dụng', 2.50, 27, 5, 3),     -- Resolved
(4, 'Sữa tươi đã hết hạn sử dụng 2 ngày, cần xử lý gấp', 5.00, 25, 6, NULL),      -- Reported
(7, 'Đường trắng bị vón cục do để nơi ẩm ướt', 1.00, 26, 5, 4),                   -- Under Investigation
(13, 'Bột mì phát hiện có mọt, cần loại bỏ toàn bộ', 3.00, 27, 7, 3),             -- Resolved
(6, 'Kem tươi bị tách nước, không đủ độ sánh', 2.00, 25, 6, NULL);                -- Reported

---
-- 10. Thêm dữ liệu cho bảng Orders (StatusID references SettingID for OrderStatus)
-- OrderStatus IDs: New=29, Preparing=30, Ready=31, Completed=32, Cancelled=33
INSERT INTO "Order" (ShopID, CreatedBy, StatusID) VALUES
(1, 5, 32), -- Completed - Barista 01
(1, 6, 31), -- Ready - Barista 02
(2, 7, 30), -- Preparing - Barista 03
(1, 5, 32), -- Completed - Barista 01
(3, 6, 29), -- New - Barista 02
(2, 8, 32), -- Completed - Barista 04
(4, 7, 30), -- Preparing - Barista 03
(1, 5, 31); -- Ready - Barista 01

-- 11. Thêm dữ liệu cho bảng OrderDetails
INSERT INTO OrderDetail (OrderID, ProductID, Quantity, Price) VALUES
-- Order 1 (Completed)
(1, 1, 2, 35000.00),     -- 2 Americano
(1, 13, 1, 25000.00),    -- 1 Croissant

-- Order 2 (Ready)
(2, 6, 1, 55000.00),     -- 1 Caffe Latte
(2, 14, 1, 30000.00),    -- 1 Chocolate Muffin

-- Order 3 (Preparing)
(3, 9, 1, 70000.00),     -- 1 Chocolate Frappuccino
(3, 16, 1, 65000.00),    -- 1 Tiramisu

-- Order 4 (Completed)
(4, 4, 1, 45000.00),     -- 1 Cold Brew Original
(4, 11, 1, 50000.00),    -- 1 Green Tea Latte

-- Order 5 (New)
(5, 2, 1, 30000.00),     -- 1 Espresso
(5, 15, 1, 35000.00),    -- 1 Blueberry Scone

-- Order 6 (Completed)
(6, 8, 1, 65000.00),     -- 1 Caramel Latte
(6, 17, 1, 70000.00),    -- 1 Cheesecake

-- Order 7 (Preparing)
(7, 5, 1, 50000.00),     -- 1 Cold Brew Vanilla
(7, 12, 1, 40000.00),    -- 1 Earl Grey Tea

-- Order 8 (Ready)
(8, 10, 1, 65000.00),    -- 1 Coffee Frappuccino
(8, 13, 2, 25000.00);    -- 2 Croissant

---
-- ============================================
-- TEST DATA VERIFICATION QUERIES (PostgreSQL Syntax)
-- ============================================
/*
-- Kiểm tra dữ liệu đã insert:

-- 1. Xem tất cả settings
SELECT * FROM Setting ORDER BY Type, SettingID;

-- 2. Xem users với role names
SELECT u.*, s.Value as RoleName
FROM Users u
JOIN Setting s ON u.RoleID = s.SettingID
WHERE s.Type = 'Role';

-- 3. Xem products với category và supplier
SELECT p.ProductName, p.Price,
       c.Value as Category,
       s.SupplierName
FROM Products p
JOIN Setting c ON p.CategoryID = c.SettingID
LEFT JOIN Suppliers s ON p.SupplierID = s.SupplierID
ORDER BY c.Value, p.ProductName;

-- 4. Xem orders với details
SELECT o.OrderID, sh.ShopName, u.FullName as CreatedBy,
       st.Value as Status, o.CreatedAt,
       p.ProductName, od.Quantity, od.Price
FROM Orders o
JOIN Shops sh ON o.ShopID = sh.ShopID
JOIN Users u ON o.CreatedBy = u.UserID
JOIN Setting st ON o.StatusID = st.SettingID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
ORDER BY o.OrderID, od.OrderDetailID;

-- 5. Xem inventory status
SELECT i.Name, i.StockQuantity,
       u.Value as Unit,
       s.SupplierName
FROM Ingredients i
JOIN Setting u ON i.UnitID = u.SettingID
LEFT JOIN Suppliers s ON i.SupplierID = s.SupplierID
ORDER BY i.Name;
*/

---
-- ============================================
-- Bảng SystemConfig - Lưu Master API Token và cấu hình hệ thống
-- ============================================
CREATE TABLE SystemConfig (
    ConfigID SERIAL PRIMARY KEY,
    ConfigKey VARCHAR(100) UNIQUE NOT NULL,  -- 'MASTER_API_TOKEN', 'SYSTEM_NAME', etc.
    ConfigValue TEXT NOT NULL,
    Description VARCHAR(255),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert Master API Token (token cho phép xem tất cả shops)
INSERT INTO SystemConfig (ConfigKey, ConfigValue, Description) VALUES 
('MASTER_API_TOKEN', 'MASTER_eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2Nlc3MiOiJhbGxfc2hvcHMiLCJpYXQiOjE3Mjk1MDAwMDB9.a1b2c3d4e5f6g7h8i9j0k1', 
 'Master API Token để xem danh sách tất cả các shop - Dành cho HR và User. Admin quản lý tại /admin/master-token');
