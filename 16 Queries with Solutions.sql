--######################################################################--
--#                                                                    #--
--#           SQL Queries for Company Database [10.AUG.2020]           #--
--#                    Author: Paul Panaitescu                         #--
--#                                                                    #--
--######################################################################--


--|---------------------------|--
--|     List of Queries       |--
--|---------------------------|--

--  1: Retrieve both DOB and address of all employees who goes by the name 'John'
--  2: Retrieve both DOB and address of all employees who goes by the name 'John B. Smith'
--  3: Retrieve both name and address of all employees who work for the 'Research' department
--  4: Retrieve the project number, the controlling department number, and the first name of the department manager for every project located in 'Stafford'
--  5: Retrieve the employeeís complete name and the complete name(s) of his or her immediate supervisor for each employee
--  6: Retrieve the salary of every employee 
--  7: Retrieve all distinct salary values
--  8: Retrieve all project numbers and project names where 'Jennifer Wallace' is involved in as a worker
--  9: Retrieve all project numbers and project names where 'Jennifer Wallace' is involved in
--  10: Retrieve all employees who have a 44 in their ssn
--  11: Retrieve all employees who were born in the 70s
--  12: Retrieve the salaries of every employee working on the 'Computerization' project after they are given a 10% salary increase
--  13: Retrieve the names of employees in the 'Research' department whose salary is lover than 33000 USD
--  14: Retrieve the names of employees in the 'Research' department whose salary is between 33000 USD and 44000 USD
--  15: Retrieve a list of employees and the projects they are working on, ordered by department and, 
--  within each department, ordered alphabetically by last name, then first name
--  16: Retrieve the names of all employees without supervisors


--|--------------------------------|--
--|     Solutions for Queries      |--
--|--------------------------------|--

----------------------------------------------------------------------------------------------------------------
--  1: Retrieve both DOB and address of all employees who goes by the name 'John'
----------------------------------------------------------------------------------------------------------------
--  1.
USE Company;
SELECT  Bdate, Address
	FROM Employee
		WHERE Fname = 'John';

----------------------------------------------------------------------------------------------------------------
--  2: Retrieve both DOB and address of all employees who goes by the name 'John B. Smith'
----------------------------------------------------------------------------------------------------------------
--  2.
USE Company;
SELECT  Bdate, Address
	FROM Employee
		WHERE Fname = 'John' AND Minit = 'B' AND Lname = 'Smith';

----------------------------------------------------------------------------------------------------------------
--  3: Retrieve both name and address of all employees who work for the 'Research' department
----------------------------------------------------------------------------------------------------------------
--  3.1.
USE Company;
SELECT  Fname, Minit, Lname, Address
	FROM Employee 
    WHERE Dno IN (
		SELECT Dnumber
			FROM Department
			WHERE Department.Dname = 'Research'
		)

--  3.2.
USE Company;
SELECT  Fname, Minit, Lname, Address
	FROM Employee, Department 
    WHERE Employee.Dno =  Department.Dnumber  AND Department.Dname = 'Research';

--  3.3.
USE Company;
SELECT  Fname, Minit, Lname, Address
	FROM Employee
    INNER JOIN Department ON Employee.Dno = Department.Dnumber 
    WHERE Department.Dname = 'Research';

--  3.4.
USE Company;
SELECT  Fname, Minit, Lname, Address
	FROM Employee
    INNER JOIN Department ON Employee.Dno = Department.Dnumber AND Department.Dname = 'Research'

----------------------------------------------------------------------------------------------------------------
--  4: Retrieve the project number, the controlling department number, and the first name of the department manager for every project located in 'Stafford'
----------------------------------------------------------------------------------------------------------------
--  4.1.
USE Company;
SELECT  Pnumber, Dnum, Fname
	FROM Project, Employee
    WHERE Project.Plocation = 'Stafford' AND  Employee.Ssn IN (
		SELECT Mgr_ssn
			FROM Department
			WHERE Project.Dnum = Department.Dnumber
    )
    
--  4.2.
SELECT Pnumber, Dnum, Fname 
	FROM Project
	INNER JOIN Department ON Department.Dnumber = Project.Dnum
	INNER JOIN Employee ON Employee.Ssn = Department.Mgr_ssn
	WHERE Plocation = "Stafford";

----------------------------------------------------------------------------------------------------------------
--  5: Retrieve the employeeís complete name and the complete name(s) of his or her immediate supervisor for each employee
----------------------------------------------------------------------------------------------------------------
--  5.1.
USE Company;
SELECT  CONCAT(e.Fname, ' ', e.Minit, ' ', e.Lname) AS Employee_name,
      CONCAT(s.Fname, ' ', s.Minit, ' ', s.Lname) AS Supervisor_name
FROM Employee AS e, Employee AS s
WHERE e.Super_ssn = s.Ssn;

--  5.2.
SELECT CONCAT(e.Fname, ' ', e.Minit, ' ', e.Lname) AS Employee_name,
      CONCAT(s.Fname, ' ', s.Minit, ' ', s.Lname) AS Supervisor_name
FROM Employee AS e
INNER JOIN Employee AS s ON e.Super_ssn = s.Ssn

----------------------------------------------------------------------------------------------------------------
--  6: Retrieve the salary of every employee 
----------------------------------------------------------------------------------------------------------------
--  6.
USE Company;
SELECT Salary
FROM Employee

----------------------------------------------------------------------------------------------------------------
--  7: Retrieve all distinct salary values
----------------------------------------------------------------------------------------------------------------
-- 7.
USE Company;
SELECT DISTINCT Salary
FROM Employee

----------------------------------------------------------------------------------------------------------------
--  8: Retrieve all project numbers and project names where 'Jennifer Wallace' is involved in as a worker
----------------------------------------------------------------------------------------------------------------
--  8.
USE Company;
SELECT  Pnumber, Pname
	FROM Project
	INNER JOIN Works_on ON Project.Pnumber = Works_on.Pno
	INNER JOIN Employee ON Works_on.Essn = Employee.Ssn 
	WHERE Fname = 'Jennifer' AND Lname = 'Wallace'

----------------------------------------------------------------------------------------------------------------
--  9: Retrieve all project numbers and project names where 'Jennifer Wallace' is involved in
----------------------------------------------------------------------------------------------------------------
--  9.

----------------------------------------------------------------------------------------------------------------
--  10: Retrieve all employees who have a 44 in their ssn
----------------------------------------------------------------------------------------------------------------
--  10.
USE Company;
SELECT * 
FROM Employee
WHERE Employee.Ssn LIKE '%44%';

----------------------------------------------------------------------------------------------------------------
--  11: Retrieve all employees who were born in the 70s
----------------------------------------------------------------------------------------------------------------
--  11.1.
USE Company;
SELECT *
   FROM Employee
   WHERE Bdate LIKE '%197%';

--  11.2.
USE Company;
SELECT *
   FROM Employee
   WHERE Bdate >= '1970-01-01' AND Bdate <= '1979-12-31';

--  11.3.
USE Company;
SELECT *
   FROM Employee
   WHERE Bdate BETWEEN '1970-01-01' AND  '1979-12-31';

----------------------------------------------------------------------------------------------------------------
--  12: Retrieve the salaries of every employee working on the 'Computerization' project after they are given a 10% salary increase
----------------------------------------------------------------------------------------------------------------
--  12.
USE Company;
SELECT Fname, Salary + Salary * 0.1 AS Increase_salary
	FROM Employee 
	INNER JOIN Works_on ON Works_on.Essn = Employee.Ssn
	INNER JOIN Project ON Project.Pnumber = Works_on.Pno
	WHERE Project.Pname = 'Computerization'

----------------------------------------------------------------------------------------------------------------
--  13: Retrieve the names of employees in the 'Research' department whose salary is lover than 33000 USD
----------------------------------------------------------------------------------------------------------------
--  13.
USE Company;
SELECT Fname
	FROM Employee
	INNER JOIN Department ON Department.Dnumber = Employee.Dno
	WHERE Department.Dname = 'Research' AND Employee.Salary < 33000;

----------------------------------------------------------------------------------------------------------------
--  14: Retrieve the names of employees in the 'Research' department whose salary is between 33000 USD and 44000 USD
----------------------------------------------------------------------------------------------------------------
--  14.
USE Company;
SELECT Fname
	FROM Employee
	INNER JOIN Department ON Department.Dnumber = Employee.Dno
	WHERE Department.Dname = 'Research' AND Employee.Salary BETWEEN 33000 AND 44000;

----------------------------------------------------------------------------------------------------------------
--  15: Retrieve a list of employees and the projects they are working on, ordered by department and, 
--  within each department, ordered alphabetically by last name, then first name
----------------------------------------------------------------------------------------------------------------
--  15.1.
USE Company;
SELECT  Department.Dname, Employee.Lname, Employee.Fname, Project.Pname
	FROM Employee
	INNER JOIN Works_on ON Works_on.Essn = Employee.Ssn
	INNER JOIN Project ON Project.Pnumber = Works_on.Pno
   INNER JOIN Department ON Department.Dnumber = Employee.Dno
	ORDER BY Department.Dname, Employee.Lname, Employee.Fname

--  15.2.
USE Company;
	SELECT d.Dname, e.Lname, e.Fname, P.Pname
	FROM employee e, department d, works_on w, project p
	WHERE d.Dnumber = e.Dno AND 
            e.ssn = w.Essn AND 
            w.Pno = p.Pnumber 
	ORDER BY d.Dname, e.Lname, e.Fname;

----------------------------------------------------------------------------------------------------------------
--  16: Retrieve the names of all employees without supervisors
----------------------------------------------------------------------------------------------------------------
--  16.
USE Company;
SELECT Fname
FROM Employee
WHERE Employee.Super_ssn IS NULL;

----------------------------------------------------------------------------------------------------------------
