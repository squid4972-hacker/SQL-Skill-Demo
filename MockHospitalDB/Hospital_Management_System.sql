-- Integrated Hospital Management System
-- Generated from Group Project 2 Report

CREATE DATABASE Hospital_DB;
SHOW DATABASES;
USE Hospital_DB;

CREATE TABLE Department (
    DeptID SMALLINT UNSIGNED PRIMARY KEY,
    DeptName VARCHAR(50) NOT NULL UNIQUE,
    ManagerID SMALLINT UNSIGNED NOT NULL UNIQUE
);

CREATE TABLE Room (
    RoomNum SMALLINT UNSIGNED PRIMARY KEY,
    RoomType VARCHAR(50) NOT NULL,
    Capacity SMALLINT UNSIGNED,
    DeptID SMALLINT UNSIGNED NOT NULL,
    FOREIGN KEY (DeptID) REFERENCES Department(DeptID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Staff (
    StaffID SMALLINT UNSIGNED PRIMARY KEY,
    StaffName VARCHAR(50) NOT NULL,
    Phone VARCHAR(15)
);

CREATE TABLE Doctor (
    StaffID SMALLINT UNSIGNED PRIMARY KEY,
    Specialization VARCHAR(50) NOT NULL,
    LicenseNum VARCHAR(20) UNIQUE,
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

ALTER TABLE Department
ADD CONSTRAINT fk_manager
FOREIGN KEY (ManagerID) REFERENCES Doctor(StaffID)
ON UPDATE CASCADE
ON DELETE RESTRICT;

CREATE TABLE Nurse (
    StaffID SMALLINT UNSIGNED PRIMARY KEY,
    ShiftType VARCHAR(20) NOT NULL,
    Certification VARCHAR(50),
    RoomNum SMALLINT UNSIGNED NOT NULL,
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (RoomNum) REFERENCES Room(RoomNum)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE Patient (
    PatientID SMALLINT UNSIGNED PRIMARY KEY,
    PatientName VARCHAR(50) NOT NULL,
    DateOfBirth DATE NOT NULL,
    DoctorID SMALLINT UNSIGNED NOT NULL,
    FOREIGN KEY (DoctorID) REFERENCES Doctor(StaffID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE EmergencyContact (
    ContactName VARCHAR(50) NOT NULL,
    PatientID SMALLINT UNSIGNED NOT NULL,
    Phone VARCHAR(15) NOT NULL,
    Relationship VARCHAR(30),
    PRIMARY KEY (ContactName, PatientID),
    FOREIGN KEY (PatientID) REFERENCES Patient(PatientID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Medication (
    MedID SMALLINT UNSIGNED PRIMARY KEY,
    MedName VARCHAR(50) NOT NULL,
    UnitCost DECIMAL(10,2) NOT NULL
);

CREATE TABLE PatientMedication (
    PatientID SMALLINT UNSIGNED NOT NULL,
    MedID SMALLINT UNSIGNED NOT NULL,
    Dosage VARCHAR(30) NOT NULL,
    Date DATE NOT NULL,
    PRIMARY KEY (PatientID, MedID, Date),
    FOREIGN KEY (PatientID) REFERENCES Patient(PatientID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (MedID) REFERENCES Medication(MedID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- Sample Data

INSERT INTO Department (DeptID, DeptName) VALUES
(10, 'Cardiology'),
(20, 'Neurology'),
(30, 'Pediatrics'),
(40, 'Orthopedics'),
(50, 'Emergency');

INSERT INTO Room (RoomNum, RoomType, Capacity, DeptID) VALUES
(101, 'ICU', 4, 10),
(102, 'General Ward', 6, 20),
(103, 'Operating Room', 2, 30),
(104, 'Recovery', 3, 40),
(105, 'Emergency Bay', 8, 50);

INSERT INTO Staff (StaffID, StaffName, Phone) VALUES
(201, 'Dr. James Carter', '5551234567'),
(202, 'Dr. Amara Osei', '5552345678'),
(205, 'Dr. Sofia Reyes', '5555678901'),
(206, 'Dr. Marcus Bell', '5556789012'),
(207, 'Dr. Elena Torres', '5557890123'),
(203, 'Nurse Linda Park', '5553456789'),
(204, 'Nurse Kevin Myles', '5554567890'),
(208, 'Nurse Rachel Kim', '5558901234'),
(209, 'Nurse David Chen', '5559012345'),
(210, 'Nurse Maria Santos', '5550123456');

INSERT INTO Doctor (StaffID, Specialization, LicenseNum) VALUES
(201, 'Cardiologist', 'LIC-10234'),
(202, 'Neurologist', 'LIC-10235'),
(205, 'Pediatrician', 'LIC-10236'),
(206, 'Orthopedic Surgeon', 'LIC-10237'),
(207, 'Emergency Physician', 'LIC-10238');

UPDATE Department SET ManagerID = 201 WHERE DeptID = 10;
UPDATE Department SET ManagerID = 202 WHERE DeptID = 20;
UPDATE Department SET ManagerID = 205 WHERE DeptID = 30;
UPDATE Department SET ManagerID = 206 WHERE DeptID = 40;
UPDATE Department SET ManagerID = 207 WHERE DeptID = 50;

INSERT INTO Nurse (StaffID, ShiftType, Certification, RoomNum) VALUES
(203, 'Morning', 'RN Certified', 101),
(204, 'Night', 'ICU Certified', 105),
(208, 'Evening', 'RN Certified', 102),
(209, 'Morning', 'Pediatric Certified', 103),
(210, 'Night', 'RN Certified', 104);

INSERT INTO Patient (PatientID, PatientName, DateOfBirth, DoctorID) VALUES
(301, 'Marcus Webb', '1985-03-14', 201),
(302, 'Priya Nair', '1992-07-22', 202),
(303, 'Tom Briggs', '2010-11-05', 205),
(304, 'Elena Vasquez', '1978-01-30', 206),
(305, 'Omar Hassan', '2001-09-18', 207);

INSERT INTO EmergencyContact (ContactName, PatientID, Phone, Relationship) VALUES
('Sarah Webb', 301, '5559001122', 'Spouse'),
('Raj Nair', 302, '5559002233', 'Parent'),
('Claire Briggs', 303, '5559003344', 'Parent'),
('Carlos Vasquez', 304, '5559004455', 'Spouse'),
('Fatima Hassan', 305, '5559005566', 'Sibling');

INSERT INTO Medication (MedID, MedName, UnitCost) VALUES
(401, 'Aspirin', 2.50),
(402, 'Metformin', 5.75),
(403, 'Lisinopril', 8.00),
(404, 'Amoxicillin', 12.30),
(405, 'Ibuprofen', 3.20);

INSERT INTO PatientMedication (PatientID, MedID, Dosage, Date) VALUES
(301, 401, '100mg daily', '2024-01-10'),
(302, 402, '500mg twice daily', '2024-02-15'),
(303, 404, '250mg three times', '2024-03-20'),
(304, 403, '10mg once daily', '2024-04-05'),
(305, 405, '400mg as needed', '2024-05-12');

-- Reporting Queries

SELECT p.PatientName, s.StaffName AS DoctorName, d.Specialization, dept.DeptName
FROM Patient p
JOIN Doctor d ON p.DoctorID = d.StaffID
JOIN Staff s ON d.StaffID = s.StaffID
JOIN Department dept ON dept.ManagerID = s.StaffID;

SELECT p.PatientName, m.MedName, pm.Dosage, pm.Date,
       s.StaffName AS DoctorName, dept.DeptName
FROM PatientMedication pm
JOIN Patient p ON pm.PatientID = p.PatientID
JOIN Medication m ON pm.MedID = m.MedID
JOIN Doctor d ON p.DoctorID = d.StaffID
JOIN Staff s ON d.StaffID = s.StaffID
JOIN Department dept ON dept.ManagerID = s.StaffID;

SELECT s.StaffName AS NurseName, n.ShiftType, r.RoomNum,
       dept.DeptName, d.Specialization AS DeptDoctorSpecialty
FROM Nurse n
JOIN Staff s ON n.StaffID = s.StaffID
JOIN Room r ON n.RoomNum = r.RoomNum
JOIN Department dept ON r.DeptID = dept.DeptID
JOIN Staff s2 ON dept.ManagerID = s2.StaffID
JOIN Doctor d ON s2.StaffID = d.StaffID;

SELECT dept.DeptName, COUNT(p.PatientID) AS TotalPatients
FROM Department dept
JOIN Staff s ON dept.ManagerID = s.StaffID
JOIN Doctor d ON s.StaffID = d.StaffID
LEFT JOIN Patient p ON d.StaffID = p.DoctorID
GROUP BY dept.DeptName;

SELECT p.PatientName, ec.ContactName, ec.Phone,
       s.StaffName AS DoctorName, d.Specialization, dept.DeptName
FROM EmergencyContact ec
JOIN Patient p ON ec.PatientID = p.PatientID
JOIN Doctor d ON p.DoctorID = d.StaffID
JOIN Staff s ON d.StaffID = s.StaffID
JOIN Department dept ON dept.ManagerID = s.StaffID;
