USE hospital_db;

CREATE TABLE Pharmacy_Inventory (
Inventory_ID INT AUTO_INCREMENT PRIMARY KEY,
Drug_Name VARCHAR(255),
Batch_Number VARCHAR(50),
Expiry_Date DATE,
Quantity INT
);

INSERT INTO Pharmacy_Inventory (Drug_Name, Batch_Number, Expiry_Date, Quantity)
VALUES
('Paracetamol 500mg', 'B001', '2027-01-15', 120),
('Amoxicillin 250mg', 'B002', '2026-11-20', 85),
('Vitamin C 1000mg', 'B003', '2027-05-10', 200),
('Ibuprofen 400mg', 'B004', '2026-09-18', 95),
('Cetirizine 10mg', 'B005', '2027-03-22', 150),
('Metformin 500mg', 'B006', '2028-02-14', 180),
('Aspirin 81mg', 'B007', '2026-12-01', 75),
('Omeprazole 20mg', 'B008', '2027-07-09', 110),
('Losartan 50mg', 'B009', '2028-01-30', 140),
('Azithromycin 500mg', 'B010', '2026-10-11', 60),

('Calcium D3', 'B011', '2027-06-17', 170),
('Diclofenac 50mg', 'B012', '2026-08-29', 90),
('Loratadine 10mg', 'B013', '2027-04-05', 130),
('Ciprofloxacin 500mg', 'B014', '2026-11-14', 50),
('Clarithromycin 250mg', 'B015', '2027-02-28', 70),
('Prednisolone 5mg', 'B016', '2028-03-21', 65),
('Insulin Glargine', 'B017', '2026-07-16', 40),
('Atorvastatin 20mg', 'B018', '2027-09-12', 115),
('Salbutamol Inhaler', 'B019', '2026-12-24', 55),
('Furosemide 40mg', 'B020', '2027-08-30', 88),

('Zinc Supplement', 'B021', '2028-05-08', 145),
('Dexamethasone 0.5mg', 'B022', '2027-01-19', 77),
('Pantoprazole 40mg', 'B023', '2026-10-06', 102),
('Levocetirizine 5mg', 'B024', '2027-06-25', 98),
('Albendazole 400mg', 'B025', '2028-04-13', 67),
('Hydrocortisone Cream', 'B026', '2027-11-27', 44),
('Methylprednisolone 16mg', 'B027', '2026-09-09', 58),
('Oral Rehydration Salts', 'B028', '2028-01-02', 210),
('Clopidogrel 75mg', 'B029', '2027-05-31', 83),
('Ketoconazole Cream', 'B030', '2026-08-15', 39);

CREATE INDEX Drug_Name_idx 
ON Pharmacy_Inventory(Drug_Name);

CREATE INDEX Expiry_Date_idx 
ON Pharmacy_Inventory(Expiry_Date);

EXPLAIN
SELECT *
FROM Pharmacy_Inventory
WHERE Drug_Name = 'Paracetamol 500mg'
AND Expiry_Date < '2027-01-01';

DROP INDEX Drug_Name_idx ON Pharmacy_Inventory;
DROP INDEX Expiry_Date_idx ON Pharmacy_Inventory;

CREATE INDEX Pharmacy_idx 
ON Pharmacy_Inventory(Drug_Name,Expiry_Date);

EXPLAIN
SELECT *
FROM Pharmacy_Inventory
WHERE Drug_Name = 'Paracetamol 500mg'
AND Expiry_Date < '2027-01-01';

DROP INDEX Pharmacy_idx ON Pharmacy_Inventory;
