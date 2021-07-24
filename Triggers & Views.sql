CREATE VIEW ConstructorEmployeeOverFifty AS
-- Add your code here
SELECT Employee.EID , Employee.FirstName , Employee.LastName , Employee.BirthDate , Employee.Door,
Employee.Number , Employee.StreetName , Employee.City , ConstructorEmployee.CompanyName , ConstructorEmployee.SalaryPerDay
FROM employee
INNER JOIN ConstructorEmployee 
ON employee.EID = ConstructorEmployee.EID
WHERE BirthDate <= date('now' , '-50 year');
;

CREATE VIEW ApartmentNumberInNeighborhood AS
-- Add your code here
SELECT Neighborhood.NID , count(Apartment.NID)
FROM Neighborhood
LEFT JOIN Apartment 
ON (Neighborhood.NID = Apartment.NID)
GROUP BY Neighborhood.NID;
;

-- Add Triggers Here, do not forget to separate the triggers with ;


CREATE TRIGGER IF NOT EXISTS MaxManagerInsert BEFORE INSERT ON Department
BEGIN
	SELECT CASE
	WHEN new.ManagerID IN(
					SELECT Employee.EID
					From Employee JOIN (
					SELECT Employee.EID, count(Department.ManagerID) as 'count'
					FROM Department join Employee on Employee.EID=Department.ManagerID
					GROUP BY Department.ManagerID
					HAVING "count">1) as 't' on Employee.EID= t.EID)
	THEN RAISE (ABORT,'Manager Cannot manage more then 2 deparments')
	END;
End;
;

CREATE TRIGGER IF NOT EXISTS MaxManagerUpdate BEFORE UPDATE ON Department
BEGIN
	SELECT CASE
	WHEN new.ManagerID IN(
					SELECT Employee.EID
					From Employee JOIN (
					SELECT Employee.EID, count(Department.ManagerID) as 'count'
					FROM Department join Employee on Employee.EID=Department.ManagerID
					GROUP BY Department.ManagerID
					HAVING "count">1) as 't' on Employee.EID= t.EID)
	THEN RAISE (ABORT,'Manager Cannot manage more then 2 deparments')
	END;
End;

;

CREATE Trigger DeleteEmployee BEFORE DELETE ON Project
BEGIN
	DELETE FROM ProjectConstructorEmployee where ProjectConstructorEmployee.PID=old.PID;
	DELETE from ConstructorEmployee where ConstructorEmployee.EID not in (SELECT ProjectConstructorEmployee.EID from ProjectConstructorEmployee);
	DELETE from Employee where Employee.EID not in (SELECT ConstructorEmployee.EID from ConstructorEmployee);
END;
