-- =====================================================
-- BÀI TẬP: TỐI ƯU HÓA KHO DƯỢC PHẨM
-- =====================================================
-- =====================================================
-- TẠO DATABASE
-- =====================================================
CREATE DATABASE IF NOT EXISTS hospital_pharmacy_db;
USE hospital_pharmacy_db;
-- =====================================================
-- TẠO BẢNG PHARMACY_INVENTORY
-- =====================================================
CREATE TABLE Pharmacy_Inventory (
    Inventory_ID INT AUTO_INCREMENT PRIMARY KEY,

    Drug_Name VARCHAR(255),

    Batch_Number VARCHAR(50),

    Expiry_Date DATE,

    Quantity INT
);
-- =====================================================
-- CHÈN DỮ LIỆU MẪU
-- =====================================================
INSERT INTO Pharmacy_Inventory (
    Drug_Name,
    Batch_Number,
    Expiry_Date,
    Quantity
)
VALUES
('Paracetamol', 'PAR001', '2026-01-10', 500),
('Paracetamol', 'PAR002', '2025-12-01', 300),
('Amoxicillin', 'AMO001', '2025-08-15', 200),
('Vitamin C', 'VIT001', '2027-05-20', 1000),
('Paracetamol Extra', 'PAR003', '2025-06-01', 150);
-- =====================================================
-- KIỂM TRA DỮ LIỆU
-- =====================================================
SELECT * FROM Pharmacy_Inventory;
-- =====================================================
-- TẠO 2 INDEX ĐƠN RIÊNG BIỆT
-- =====================================================
-- Index 1:
--   Tăng tốc tìm kiếm theo Drug_Name
--
-- Index 2:
--   Tăng tốc tìm kiếm theo Expiry_Date
-- =====================================================
CREATE INDEX idx_drug_name
ON Pharmacy_Inventory(Drug_Name);

CREATE INDEX idx_expiry_date
ON Pharmacy_Inventory(Expiry_Date);
-- =====================================================
-- TRUY VẤN KHI DÙNG INDEX ĐƠN
-- =====================================================
-- Truy vấn tìm thuốc theo:
--   + Tên thuốc
--   + Hạn sử dụng
-- =====================================================
SELECT *
FROM Pharmacy_Inventory
WHERE Drug_Name = 'Paracetamol'
AND Expiry_Date <= '2025-12-31';
- =====================================================
-- PHÂN TÍCH TRUY VẤN VỚI EXPLAIN
-- =====================================================
-- MySQL có thể:
--   + chỉ chọn 1 index
--   HOẶC
--   + dùng Index Merge
--
-- Nhưng hiệu quả vẫn chưa tối ưu hoàn toàn
-- vì dữ liệu nằm trên 2 index riêng biệt.
-- =====================================================
EXPLAIN
SELECT *
FROM Pharmacy_Inventory
WHERE Drug_Name = 'Paracetamol'
AND Expiry_Date <= '2025-12-31';
-- =====================================================
-- XÓA 2 INDEX ĐƠN
-- =====================================================
-- Chuẩn bị chuyển sang Composite Index.
-- =====================================================
DROP INDEX idx_drug_name
ON Pharmacy_Inventory;

DROP INDEX idx_expiry_date
ON Pharmacy_Inventory;
-- =====================================================
-- TẠO COMPOSITE INDEX
-- =====================================================
CREATE INDEX idx_drug_expiry
ON Pharmacy_Inventory(Drug_Name, Expiry_Date);
-- TRUY VẤN SAU KHI CÓ COMPOSITE INDEX
-- =====================================================
-- Lúc này MySQL có thể tìm dữ liệu
-- trực tiếp trên cùng một index.
--
-- Tốc độ sẽ nhanh hơn đáng kể
-- so với nhiều index đơn.
-- =====================================================
SELECT *
FROM Pharmacy_Inventory
WHERE Drug_Name = 'Paracetamol'
AND Expiry_Date <= '2025-12-31';
-- =====================================================
-- PHÂN TÍCH BẰNG EXPLAIN
-- =====================================================
-- Kết quả thường sẽ cho thấy:
--
-- key = idx_drug_expiry
--
-- type = range hoặc ref
--
-- rows quét sẽ giảm mạnh.
--
-- Điều này chứng minh:
-- Composite Index hiệu quả hơn
-- khi truy vấn nhiều điều kiện liên quan.
-- =====================================================
EXPLAIN
SELECT *
FROM Pharmacy_Inventory
WHERE Drug_Name = 'Paracetamol'
AND Expiry_Date <= '2025-12-31';
-- =====================================================
-- VẤN ĐỀ VỚI LIKE '%keyword%'
-- =====================================================
-- Ví dụ:
-- =====================================================
SELECT *
FROM Pharmacy_Inventory
WHERE Drug_Name LIKE '%cetamol%';
-- =====================================================
-- GIẢI THÍCH HIỆN TƯỢNG INDEX BỊ "VÔ HIỆU HÓA"
-- =====================================================
-- Khi dùng:
--
--   LIKE '%keyword%'
--
-- dấu % đứng đầu chuỗi.
--
-- Điều này khiến MySQL:
--   KHÔNG biết chuỗi bắt đầu từ đâu.
--
-- Vì vậy:
--   Index không thể được sử dụng hiệu quả.
--
-- MySQL buộc phải:
--   Quét toàn bộ bảng (Full Table Scan).
--
-- Với dữ liệu hàng triệu dòng:
--   hệ thống sẽ rất chậm.
-- =====================================================

-- =====================================================
-- KIỂM TRA BẰNG EXPLAIN
-- =====================================================
-- Kết quả thường sẽ là:
--
-- type = ALL
--
-- nghĩa là:
--   MySQL đang quét toàn bộ bảng.
-- =====================================================
EXPLAIN
SELECT *
FROM Pharmacy_Inventory
WHERE Drug_Name LIKE '%cetamol%';
-- =====================================================
-- CÁCH TỐI ƯU LIKE
-- =====================================================
-- Nếu có thể,
-- nên đổi:
--
--   LIKE '%keyword%'
--
-- thành:
--
--   LIKE 'keyword%'
--
-- Ví dụ:
-- =====================================================

SELECT *
FROM Pharmacy_Inventory
WHERE Drug_Name LIKE 'Para%';
-- =====================================================
-- TỔNG KẾT
-- =====================================================
-- 1. Index giúp tăng tốc truy vấn dữ liệu.
--
-- 2. Composite Index hiệu quả hơn
--    nhiều Index đơn
--    khi truy vấn nhiều điều kiện liên quan.
--
-- 3. Thứ tự cột trong Composite Index
--    rất quan trọng.
--
-- 4. LIKE '%keyword%'
--    làm MySQL khó sử dụng Index.
--
-- 5. LIKE 'keyword%'
--    vẫn có thể tận dụng Index.
--
-- 6. FULLTEXT SEARCH là giải pháp tốt hơn
--    cho tìm kiếm văn bản lớn.
--
-- 7. Trong hệ thống bệnh viện thực tế:
--      Composite Index rất phù hợp cho:
--          + tên thuốc + hạn sử dụng
--          + bệnh nhân + ngày khám
--          + bác sĩ + ca trực
-- =====================================================