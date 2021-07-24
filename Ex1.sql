--Students:
--Name: Dor Carmi, ID: 205789662
--Name: Gil Hatav, ID: 206226581

CREATE TABLE IF NOT EXISTS "Employee" (
	"EID"			INTEGER PRIMARY KEY,
	"FirstName"		TEXT NOT NULL,
	"LastName"		TEXT NOT NULL,
	"BirthDate"		DATE NOT NULL,
	"City"			TEXT NOT NULL,
	"StreetName"	TEXT NOT NULL,
	"Number"		INTEGER NOT NULL,
	"Door"			INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS "Cell Phones" (
	"EID"			INTEGER,
	"CellNumber"	INTEGER PRIMARY KEY,
	FOREIGN KEY("EID") REFERENCES "Employee"("EID") ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS "OfficialEmployee" (
	"EID"				INTEGER PRIMARY KEY,
	"StartWorkingDate"	DATE NOT NULL,
	"Degree"			INTEGER NOT NULL,
	"Department" 		TEXT NOT NULL,
	FOREIGN KEY("EID") REFERENCES "Employee"("EID") ON DELETE CASCADE ON UPDATE CASCADE
	FOREIGN KEY ("Department") REFERENCES "Department"("DID") ON DELETE CASCADE ON UPDATE CASCADE

);

CREATE TABLE IF NOT EXISTS "Department" (
	"DID"			INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	"Name"			TEXT NOT NULL,
	"Description"	TEXT NOT NULL,
	"ManagerID"		INTEGER,
	FOREIGN KEY("ManagerID") REFERENCES "OfficialEmployee"("EID") ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS "ConstructorEmployee" (
	"EID"			INTEGER PRIMARY KEY,
	"CompanyName"	TEXT NOT NULL,
	"SalaryPerDay"	INTEGER NOT NULL,
	FOREIGN KEY("EID") REFERENCES "Employee"("EID") ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS "ProjectConstructorEmployee" (
	"PID"				INTEGER NOT NULL,
	"EID"				INTEGER NOT NULL,
	"StartWorkingDate"	DATE NOT NULL,
	"EndWorkingDate"	DATE NOT NULL,
	"JobDescription"	TEXT NOT NULL,
	PRIMARY KEY("EID","PID"),
	FOREIGN KEY("EID") REFERENCES "ConstructorEmployee"("EID") ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY("PID") REFERENCES "Project"("PID") ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS "Project" (
	"PID"				INTEGER PRIMARY KEY AUTOINCREMENT,
	"Name"				TEXT NOT NULL,
	"Description"		TEXT NOT NULL,
	"Budget"			INTEGER NOT NULL,
	"Neighborhood"		INTEGER NOT NULL,
	FOREIGN KEY("Neighborhood") REFERENCES "Neighborhood"("NID") ON UPDATE RESTRICT ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS "Neighborhood" (
	"NID"	INTEGER PRIMARY KEY AUTOINCREMENT,
	"Name"	TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS "Apartment" (
	"StreetName"		TEXT NOT NULL,
	"Number"			INTEGER NOT NULL,
	"Door"				INTEGER NOT NULL,
	"Type"				TEXT NOT NULL,
	"SizeSquareMeter"	DOUBLE NOT NULL,
	"NID"				INTEGER NOT NULL,
	PRIMARY KEY("StreetName","Number","Door"),
	FOREIGN KEY("NID") REFERENCES "Neighborhood"("NID") ON UPDATE RESTRICT ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS "Resident" (
	"RID"				INTEGER PRIMARY KEY AUTOINCREMENT,
	"FirstName"			TEXT NOT NULL,
	"LastName"			TEXT NOT NULL,
	"BirthDate"			DATE NOT NULL,
	"StreetName"		TEXT ,
	"Number"			INTEGER ,
	"Door"				INTEGER ,
	FOREIGN KEY ("Door","StreetName","Number") REFERENCES "Apartment"("Door","StreetName","Number") ON UPDATE CASCADE ON DELETE RESTRICT 
	--FOREIGN KEY("Door") REFERENCES "Apartment"("Door") ON UPDATE CASCADE ON DELETE RESTRICT,
	--FOREIGN KEY("StreetName") REFERENCES "Apartment"("StreetName") ON UPDATE CASCADE ON DELETE RESTRICT,
	--FOREIGN KEY("Number") REFERENCES "Apartment"("Number") ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS "ParkingArea" (
	"AID"				INTEGER PRIMARY KEY AUTOINCREMENT,
	"Name"				TEXT NOT NULL,
	"NID"				INTEGER,
	"PricePerHour"		INTEGER NOT NULL,
	"MaxPricePerDay"	INTEGER NOT NULL,
	FOREIGN KEY("NID") REFERENCES "Neighborhood"("NID") ON UPDATE CASCADE ON DELETE CASCADE,
	CHECK("MaxPricePerDay">"PricePerHour")
);
CREATE TABLE IF NOT EXISTS "Car" (
	"CID"				INTEGER PRIMARY KEY AUTOINCREMENT,
	"CellPhoneNumber"	INTEGER NOT NULL,
	"CreditCard"		INTEGER NOT NULL,
	"ExpirationDate"	DATE NOT NULL,
	"ThreeDigits"		INTEGER NOT NULL,
	"ID"				INTEGER NOT NULL
);
CREATE TABLE IF NOT EXISTS "CarParking" (
	"CID"			INTEGER,
	"StartTime"		DATETIME NOT NULL,
	"EndTime"		DATETIME NOT NULL,
	"AID"			INTEGER,
	"Cost"			DOUBLE NOT NULL,
	PRIMARY KEY("CID","StartTime"),
	FOREIGN KEY("CID") REFERENCES "Car"("CID") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("AID") REFERENCES "ParkingArea"("AID") ON UPDATE CASCADE ON DELETE SET NULL,
	CHECK("EndTime">="StartTime")
);


CREATE TABLE IF NOT EXISTS "TrashCan" (
	"TCID"				INTEGER PRIMARY KEY AUTOINCREMENT,
	"Catalog ID"		INTEGER NOT NULL,
	"CreationDate"		DATE NOT NULL,
	"ExpirationDate"	DATE NOT NULL,
	CHECK("ExpirationDate">"CreationDate")
);

CREATE TABLE IF NOT EXISTS "TrashCanResident" (
	"TCID"	INTEGER NOT NULL,
	"RID"	INTEGER NOT NULL,
	PRIMARY KEY("TCID","RID"),
	FOREIGN KEY("RID") REFERENCES "Resident"("RID") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("TCID") REFERENCES "TrashCan"("TCID") ON UPDATE CASCADE ON DELETE CASCADE
);






