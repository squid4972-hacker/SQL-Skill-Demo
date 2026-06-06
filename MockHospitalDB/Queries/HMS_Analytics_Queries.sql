-- Hospital Management System
-- Reporting & analytics queries only please see "HMS_Analytics_Queries.sql" for database implementation.

-- 1. Department Patient Assignment
SELECT
    p.PatientName,
    s.StaffName AS DoctorName,
    d.Specialization,
    dept.DeptName
FROM Patient p
JOIN Doctor d ON p.DoctorID = d.StaffID
JOIN Staff s ON d.StaffID = s.StaffID
JOIN Department dept ON dept.ManagerID = s.StaffID;

-- 2. Patient Medication Distribution by Department
SELECT
    p.PatientName,
    m.MedName,
    pm.Dosage,
    pm.Date,
    s.StaffName AS DoctorName,
    dept.DeptName
FROM PatientMedication pm
JOIN Patient p ON pm.PatientID = p.PatientID
JOIN Medication m ON pm.MedID = m.MedID
JOIN Doctor d ON p.DoctorID = d.StaffID
JOIN Staff s ON d.StaffID = s.StaffID
JOIN Department dept ON dept.ManagerID = s.StaffID;

-- 3. Nursing Assignment Allocation Summary
SELECT
    s.StaffName AS NurseName,
    n.ShiftType,
    r.RoomNum,
    dept.DeptName,
    d.Specialization AS DeptDoctorSpecialty
FROM Nurse n
JOIN Staff s ON n.StaffID = s.StaffID
JOIN Room r ON n.RoomNum = r.RoomNum
JOIN Department dept ON r.DeptID = dept.DeptID
JOIN Staff s2 ON dept.ManagerID = s2.StaffID
JOIN Doctor d ON s2.StaffID = d.StaffID;

-- 4. Department Patient Distribution Overview
SELECT
    dept.DeptName,
    COUNT(p.PatientID) AS TotalPatients
FROM Department dept
JOIN Staff s ON dept.ManagerID = s.StaffID
JOIN Doctor d ON s.StaffID = d.StaffID
LEFT JOIN Patient p ON d.StaffID = p.DoctorID
GROUP BY dept.DeptName;

-- 5. Patient Emergency Contact and Physician Assignment
SELECT
    p.PatientName,
    ec.ContactName,
    ec.Phone,
    s.StaffName AS DoctorName,
    d.Specialization,
    dept.DeptName
FROM EmergencyContact ec
JOIN Patient p ON ec.PatientID = p.PatientID
JOIN Doctor d ON p.DoctorID = d.StaffID
JOIN Staff s ON d.StaffID = s.StaffID
JOIN Department dept ON dept.ManagerID = s.StaffID;
