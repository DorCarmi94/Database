SELECT DISTINCT FirstName, SalaryPerDay, Name , Description 
FROM Employee 
INNER JOIN ConstructorEmployee ON Employee.EID= ConstructorEmployee.EID 
INNER JOIN ProjectConstructorEmployee ON ConstructorEmployee.EID==ProjectConstructorEmployee.EID 
INNER JOIN Project ON ProjectConstructorEmployee.PID = Project.PID;

--Q2
SELECT DISTINCT Employee.EID ,Employee.FirstName, Employee.LastName, Employee.BirthDate, 
Employee.City , Employee.StreetName, Employee.Number , Employee.Door , Department.Name AS 'Name'
FROM Employee, Department , OfficialEmployee
WHERE (Employee.EID = OfficialEmployee.EID) AND (OfficialEmployee.Department = Department.DID)
UNION
SELECT DISTINCT Employee.EID ,Employee.FirstName, Employee.LastName, Employee.BirthDate, 
Employee.City , Employee.StreetName, Employee.Number , Employee.Door , Project.Name
FROM Employee
INNER JOIN ProjectConstructorEmployee 
ON Employee.EID = ProjectConstructorEmployee.EID
INNER JOIN Project 
ON ProjectConstructorEmployee.PID = Project.PID
WHERE ProjectConstructorEmployee.EndWorkingDate = (SELECT max(EndWorkingDate) 
FROM ProjectConstructorEmployee i 
WHERE i.EID = ProjectConstructorEmployee.EID)

--Q3
SELECT Neighborhood.Name, count( Apartment.NID) AS 'counter'
FROM Neighborhood JOIN Apartment ON Neighborhood.NID=Apartment.NID
GROUP BY Neighborhood.NID
ORDER BY  counter ASC


--Q4
SELECT Apartment.StreetName, Apartment.Number, Apartment.Door, Resident.LastName
FROM Apartment
LEFT JOIN Resident ON
Apartment.StreetName = Resident.StreetName AND
Apartment.Number = Resident.Number AND
Apartment.Door = Resident.Door
--Q5
SELECT * 
FROM ParkingArea
WHERE ParkingArea.MaxPricePerDay IN(SELECT Min (ParkingArea.MaxPricePerDay) FROM ParkingArea)
--Q6
SELECT CarParking.CID , Car.ID
FROM CarParking JOIN Car ON CarParking.CID = Car.CID
WHERE CarParking.AID = (SELECT AID 
FROM ParkingArea
WHERE ParkingArea.MaxPricePerDay IN(SELECT Min (ParkingArea.MaxPricePerDay) FROM ParkingArea)
GROUP BY ParkingArea.MaxPricePerDay) 
GROUP BY CarParking.CID
--Q7
SELECT ResidentApartJoin.RID , ResidentApartJoin.FirstName, ResidentApartJoin.LastName
FROM
	(SELECT J1.CarOwnersID as jjj, J1.CID, J1.parkA
	FROM
		(SELECT DISTINCT Car.ID as CarOwnersID, CarParking.CID, ParkingArea.NID as parkA
		FROM ParkingArea JOIN CarParking ON ParkingArea.AID= CarParking.AID JOIN Car On Car.CID=CarParking.CID)
		AS J1
		GROUP BY J1.CarOwnersID HAVING count (J1.parkA)=1)
	as ParkingCount
JOIN
	(SELECT Resident.RID, Resident.FirstName, Resident.LastName, Apartment.NID as apartmentN
	FROM Resident JOIN Apartment
	ON Apartment.StreetName=Resident.StreetName AND Apartment.Door=Resident.Door AND Apartment.Number=Resident.Number) as ResidentApartJoin
ON
	ResidentApartJoin.apartmentN = ParkingCount.parkA AND ResidentApartJoin.RID = ParkingCount.jjj


--Q8
SELECT Resident.RID , Resident.FirstName , Resident.LastName
FROM Resident
INNER JOIN(SELECT DISTINCT Car.ID as CarOwnersID, CarParking.CID, CarParking.AID
			From CarParking JOIN Car ON Car.CID = CarParking.CID) as ParkRecoerds
			On Resident.RID= ParkRecoerds.CarOwnersID
GROUP BY ParkRecoerds.CID
HAVING COUNT (ParkRecoerds.AID) = (SELECT COUNT (ParkingArea.AID) FROM ParkingArea)

--Q9
CREATE VIEW r_ngbrhd As SELECT * From Neighborhood WHERE Neighborhood.Name Like 'R%';