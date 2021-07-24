import sqlite3
import csv  # Use this to read the csv file


def create_connection(db_file):
    connection = sqlite3.connect(db_file)
    return connection
    pass


def update_employee_salaries(conn, increase):
    """

    Parameters
    ----------
    conn: Connection
    increase: float
    """
    precentage = (increase + 100) / 100
    with conn:
        cur2 = conn.cursor()
        cur2.execute(
            """UPDATE ConstructorEmployee
                    SET SalaryPerDay=ConstructorEmployee.SalaryPerDay*{}
                    WHERE ConstructorEmployee.EID in (SELECT Employee.EID
                    from Employee where date('now')-Employee.BirthDate>5)
                    """.format(precentage))

    pass

def get_employee_total_salary(conn):
    """
    Parameters
    ----------
    conn: Connection

    Returns
    -------
    int
    """
    with conn:
        curr = conn.cursor()
        curr.execute("""select sum(ConstructorEmployee.SalaryPerDay)
                                from ConstructorEmployee""")
        row = curr.fetchone()

        return row[0]
    pass


def get_total_projects_budget(conn):
    """
    Parameters
    ----------
    conn: Connection

    Returns
    -------
    float
    """
    with conn:
        curr = conn.cursor()
        curr.execute("""select sum(Project.Budget)
                        from Project""")
        row = curr.fetchone()
        return row[0]
    pass


def calculate_income_from_parking(conn, year):
    """
    Parameters
    ----------
    conn: Connection
    year: int

    Returns
    -------
    float
    """
    with conn:
        curr=conn.cursor()
        startDateFormat=str(year)+"-01-01";
        endDateFromat=str((int(year)+1))+"01-01"
        curr.execute("""select sum(CarParking.Cost) from CarParking
                        where StartTime>? and StartTime<?""",(startDateFormat,endDateFromat))
        row=curr.fetchall()
        return row[0][0]

    pass


def get_most_profitable_parking_areas(conn):
    """
    Parameters
    ----------
    conn: Connection

    Returns
    -------
    list[tuple]

    """
    with conn:
        curr=conn.cursor()
        curr.execute("""Select ParkingArea.AID as ParkingAreaID, sum(CarParking.Cost) as Income
                        from ParkingArea, CarParking
                        WHERE CarParking.AID=ParkingArea.AID
                        GROUP BY ParkingAreaID
                        ORDER BY Income DESC , ParkingAreaID DESC
                        limit 5
                        """)
        rows=curr.fetchall()
        return rows
    pass


def get_number_of_distinct_cars_by_area(conn):
    """
    Parameters
    ----------
    conn: Connection

    Returns
    -------
    list[tuple]

    """
    with conn:
        curr=conn.cursor()
        curr.execute("""SELECT cp.AID as ParkingAreaID,count (cp.CID) as DistinctCarsNumber
            from (SELECT DISTINCT CarParking.AID,CarParking.CID from CarParking) as cp
            group by cp.AID
            order by DistinctCarsNumber DESC""")
        return curr.fetchall()
    pass


def add_employee(conn, eid, firstname, lastname, birthdate, street_name, number, door, city):
    """
    Parameters
    ----------
    conn: Connection
    eid: int
    firstname: str
    lastname: str
    birthdate: datetime
    street_name: str
    number: int
    door: int
    city: str
    """
    with conn:
        curr=conn.cursor()
        curr.execute("""INSERT INTO Employee (EID,FirstName,LastName,BirthDate,Door,Number,StreetName,City) VALUES (?,?,?,?,?,?,?,?)""",(eid,firstname,lastname,birthdate,door,number,street_name,city))
        conn.commit()
    pass


def load_neighborhoods(conn, csv_path):
    """

    Parameters
    ----------
    conn: Connection
    csv_path: str
    """
    with conn:
        curr=conn.cursor()
        with open(csv_path,'r') as csvfile:
            theFileRows = csv.reader(csvfile)
            for row in theFileRows:
                curr.execute("""INSERT INTO Neighborhood (NID,Name) VALUES (?,?)""",(row[0],row[1]))
        conn.commit()
    pass


#connR = create_connection('my_db.db')
#print(update_employee_salaries(connR, 1))
#print(get_employee_total_salary(connR))
#print(get_total_projects_budget(connR))
#print(calculate_income_from_parking(connR,500))
#print(get_most_profitable_parking_areas(connR))
#print(get_number_of_distinct_cars_by_area(connR))
#add_employee(connR,'1504','a','a','2023-15-15','jfj','5','3','sdf');
#load_neighborhoods(connR,'neighborhoods.csv')


