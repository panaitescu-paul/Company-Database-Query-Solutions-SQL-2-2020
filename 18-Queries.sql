--######################################################################--
--#                                                                    #--
--#           SQL Queries for Company Database [10.AUG.2020]           #--
--#                    Author: Paul Panaitescu                         #--
--#                                                                    #--
--######################################################################--


--|---------------------------|--
--|     List of Queries       |--
--|---------------------------|--

--  1: Retrieve the name and address of all employees who work for the "Research" department
--  2: Retrieve the name of each employee who has a dependent with the same gender as the employee
--  3: Retrieve the names of employees who have no dependents
--  4: Retrieve the names of all employees who are managers and who have at least one dependent
--  5: Retrieve the Social Security numbers of all employees who work on project numbers 1, 2, or 3
--  6: Retrieve the sum of the salaries of all employees, the maximum salary, the minimum salary, and the average salary
--  7: Retrieve the sum of the salaries of all employees of the "Research" department,
--  as well as the maximum salary, the minimum salary, and the average salary in this department
--  8: Retrieve the total number of employees in the company
--  9: Retrieve the total number of employees in the "Research" department
--  10: Retrieve the number of distinct salary values in the database
--  11: Retrieve the names of all employees who have two or more dependents
--  12: Retrieve for each department, the number of employees it has, and their average salary according to their gender
--  13: Retrieve for each project, its number, its name, and the number of employees who work on that project
--  14: Retrieve for each department, its department number, the combined salary in that department, and the number of employees who work in that department
--  15: Retrieve for each project on which more than two employees work,
--  the project number, the project name, and the number of employees who work on the project
--  16: Retrieve for each project, the project number, the project name,
--  and the number of employees from the 'administration' who work on the project
--  17: Retrive the total number of employees whose salaries exceed $32000 in each department which more than two employees
--  18: Create a view that contains the info about a project name, number of employees working on it, and total salary of them


--|--------------------------------|--
--|     Solutions for Queries      |--
--|--------------------------------|--

----------------------------------------------------------------------------------------------------------------
--  1: Retrieve the name and address of all employees who work for the "Research" department
----------------------------------------------------------------------------------------------------------------
--  1.1.
USE Company;
SELECT Fname, Address
FROM Employee, Department
WHERE Employee.Dno = Department.Dnumber AND Department.Dname = 'Research';

--  1.2.
USE Company;
SELECT Fname, Address
	FROM Employee
	INNER JOIN Department ON  Department.Dnumber = Employee.Dno
		AND Department.Dname = 'Research'

----------------------------------------------------------------------------------------------------------------
--  2: Retrieve the name of each employee who has a dependent with the same gender as the employee
----------------------------------------------------------------------------------------------------------------
--  2.
USE Company;
SELECT Fname, Lname, Dependent_name
	FROM Employee
	INNER JOIN Dependent ON Dependent.Essn = Employee.Ssn
	WHERE Employee.sex = Dependent.Sex

----------------------------------------------------------------------------------------------------------------
--  3: Retrieve the names of employees who have no dependents
----------------------------------------------------------------------------------------------------------------
--  3.
USE Company;
SELECT  Fname, Lname
	FROM Employee
    WHERE Employee.Ssn NOT IN (
		SELECT Essn
        FROM Dependent
    )

----------------------------------------------------------------------------------------------------------------
--  4: Retrieve the names of all employees who are managers and who have at least one dependent
----------------------------------------------------------------------------------------------------------------
--  4.1.
USE Company;
SELECT Fname, Lname
	FROM Employee
    INNER JOIN Department ON Department.Mgr_ssn = Employee.Ssn
	WHERE Ssn IN (
		SELECT Essn 
			FROM Dependent 
			GROUP BY Essn
			HAVING COUNT(*) >= 1
        );

--  4.2.
USE Company;
SELECT Fname, Lname
	FROM Employee
    INNER JOIN Department ON Department.Mgr_ssn = Employee.Ssn
    INNER JOIN Dependent ON Dependent.Essn = Employee.Ssn
		GROUP BY Dependent.Essn
		HAVING COUNT(*) >= 1;

----------------------------------------------------------------------------------------------------------------
--  5: Retrieve the Social Security numbers of all employees who work on project numbers 1, 2, or 3
----------------------------------------------------------------------------------------------------------------
--  5.1.
USE Company;
SELECT Ssn
	FROM Employee
	INNER JOIN Works_on ON Works_on.Essn = Employee.Ssn
	WHERE Works_on.Pno IN (1, 2, 3)

--  5.2.
USE Company;
SELECT Ssn
	FROM Employee, Works_on
	WHERE Works_on.Essn = Employee.Ssn 
		AND Works_on.Pno IN (1, 2, 3)

--  5.3.
USE Company;
SELECT Ssn
	FROM Employee
	WHERE Ssn IN (
		SELECT Essn
			FROM Works_on
			WHERE Pno IN (1,2,3)
        )

----------------------------------------------------------------------------------------------------------------
--  6: Retrieve the sum of the salaries of all employees, the maximum salary, the minimum salary, and the average salary
----------------------------------------------------------------------------------------------------------------
--  6.
USE Company;
SELECT SUM(Salary) AS 'Sum of the salary',
			MAX(Salary) AS 'MAX',
			MIN(Salary) AS 'MIN',
			AVG(Salary) AS 'AVG'
	FROM Employee

----------------------------------------------------------------------------------------------------------------
--  7: Retrieve the sum of the salaries of all employees of the "Research" department,
--  as well as the maximum salary, the minimum salary, and the average salary in this department
----------------------------------------------------------------------------------------------------------------
-- 7.1.
USE Company;
SELECT SUM(Salary) AS 'Sum of the salary',
			MAX(Salary) AS 'MAX',
			MIN(Salary) AS 'MIN',
			AVG(Salary) AS 'AVG'
	FROM Employee
    INNER JOIN Department ON Department.Dnumber = Employee.Dno
		AND Department.Dname = 'Research'

-- 7.2.
USE Company;
SELECT SUM(Salary) AS 'Sum of the salary',
			MAX(Salary) AS 'MAX',
			MIN(Salary) AS 'MIN',
			AVG(Salary) AS 'AVG'
	FROM Employee, Department
	WHERE Department.Dnumber = Employee.Dno AND Department.Dname = 'Research'

----------------------------------------------------------------------------------------------------------------
--  8: Retrieve the total number of employees in the company
----------------------------------------------------------------------------------------------------------------
--  8.1.
USE Company;
SELECT COUNT(*) AS 'Total Number of employees'
	FROM Employee

--  8.2.
USE Company;
SELECT COUNT(Ssn) AS 'Total Number of employees'
	FROM Employee

----------------------------------------------------------------------------------------------------------------
--  9: Retrieve the total number of employees in the "Research" department
----------------------------------------------------------------------------------------------------------------
--  9.1.
USE Company;
SELECT COUNT(Ssn) AS 'Total Number of employees'
	FROM Employee
    INNER JOIN Department ON Department.Dnumber = Employee.Dno
		AND Department.Dname = 'Research';

--  9.2.
USE Company;
SELECT COUNT(Ssn) AS 'Total Number of employees'
	FROM Employee, Department
   WHERE Department.Dnumber = Employee.Dno AND Department.Dname = 'Research';

----------------------------------------------------------------------------------------------------------------
--  10: Retrieve the number of distinct salary values in the database
----------------------------------------------------------------------------------------------------------------
--  10.
USE Company;
SELECT DISTINCT Salary
	FROM Employee

----------------------------------------------------------------------------------------------------------------
--  11: Retrieve the names of all employees who have two or more dependents
----------------------------------------------------------------------------------------------------------------
--  11.1.
USE Company;
SELECT Fname, Lname
	FROM Employee
	INNER JOIN Dependent ON Dependent.Essn = Employee.Ssn
		GROUP BY Dependent.Essn
		HAVING COUNT(*) >= 2;

--  11.2.
USE Company;
SELECT Fname, Lname
	FROM Employee, Dependent
	WHERE Dependent.Essn = Employee.Ssn
		GROUP BY Dependent.Essn
		HAVING COUNT(*) >= 2;

----------------------------------------------------------------------------------------------------------------
--  12: Retrieve for each department, the number of employees it has, and their average salary according to their gender
----------------------------------------------------------------------------------------------------------------
--  12.
USE Company;
SELECT Employee.Dno, COUNT(*) AS 'Number of employes', AVG(Salary), Employee.Sex
	FROM Employee, Department
    GROUP BY Employee.Dno, Employee.Sex

----------------------------------------------------------------------------------------------------------------
--  13: Retrieve for each project, its number, its name, and the number of employees who work on that project
----------------------------------------------------------------------------------------------------------------
--  13.1.
USE Company;
SELECT Pnumber, Pname, COUNT(Employee.Ssn)  AS 'Number on employees'
	FROM Project
    INNER JOIN Works_on ON Works_on.Pno = Project.Pnumber
    INNER JOIN Employee ON Employee.Ssn = Works_on.Essn
		GROUP BY Project.Pnumber

--  13.2.
USE Company;
SELECT Pnumber, Pname, COUNT(Employee.Ssn)  AS 'Number on employees'
	FROM Project, Works_on, Employee
	WHERE Works_on.Pno = Project.Pnumber AND Employee.Ssn = Works_on.Essn
		GROUP BY Project.Pnumber

----------------------------------------------------------------------------------------------------------------
--  14: Retrieve for each department, its department number, the combined salary in that department, and the number of employees who work in that department
----------------------------------------------------------------------------------------------------------------
--  14.1.
USE Company;
SELECT Department.Dnumber, SUM(Employee.Salary), COUNT(Employee.Ssn)
	FROM Department
    INNER JOIN Employee ON Employee.Dno = Department.Dnumber
		GROUP BY Department.Dnumber

--  14.2.
USE Company;
SELECT Dno, SUM(Salary), COUNT(*) AS Number_of_employees
	FROM Employee GROUP BY Dno;

----------------------------------------------------------------------------------------------------------------
--  15: Retrieve for each project on which more than two employees work,
--the project number, the project name, and the number of employees who work on the project
----------------------------------------------------------------------------------------------------------------
--  15.1.
USE Company;
SELECT Pname, Pnumber, COUNT(Works_on.Essn)
	FROM Project
    INNER JOIN Works_on ON Works_on.Pno = Project.Pnumber
		GROUP BY Project.Pnumber
        HAVING COUNT(Works_on.Essn) > 2;
   
--  15.2.
USE company;
	SELECT Pnumber, Pname, COUNT(*) AS Number_of_employees
	FROM Project, Works_on WHERE Pnumber = Pno
		GROUP BY Pnumber, Pname
		HAVING COUNT(*) > 2;

----------------------------------------------------------------------------------------------------------------
--  16: Retrieve for each project, the project number, the project name,
--and the number of employees from the 'administration' who work on the project
----------------------------------------------------------------------------------------------------------------
--  16.
USE Company;
	SELECT Pnumber, Pname, COUNT(Works_on.Essn)
	FROM  Project
		INNER JOIN Department ON Department.Dnumber = Project.Dnum
			AND Department.Dname = 'Administration'
		INNER JOIN Works_on ON Works_on.Pno = Project.Pnumber
		GROUP BY Project.Pnumber;

----------------------------------------------------------------------------------------------------------------
--  17: Retrieve the total number of employees whose salaries exceed $32000 in each department which more than two employees
----------------------------------------------------------------------------------------------------------------
--  17.1.
USE Company;
SELECT Department.Dname, COUNT(Employee.Ssn) AS 'Total Number of Employees'
	FROM Department
    INNER JOIN Employee ON Employee.Dno = Department.Dnumber
		WHERE Employee.Salary > 32000  AND Department.Dnumber IN (
			SELECT Dno
				FROM Employee
                GROUP BY Dno
				HAVING COUNT(Dno) > 2
           	)
		GROUP BY Employee.Dno;

--  17.2.
USE company;
SELECT Department.Dname, COUNT(Employee.Ssn) AS 'Total Number of Employees'
	FROM Department, Employee
	WHERE Dnumber = Dno AND Salary > 32000 AND Dno IN (SELECT Dno
		FROM Employee GROUP BY Dno
		HAVING COUNT(*) > 2) GROUP BY Dnumber;

----------------------------------------------------------------------------------------------------------------
--  18: Create a view that contains the info about a project name, number of employees working on it, and total salary of them
----------------------------------------------------------------------------------------------------------------
--  18.
USE Company;
CREATE VIEW Info AS
SELECT Pname, COUNT(Works_on.Essn), SUM(Employee.Salary)
	FROM Project
		INNER JOIN Works_on ON Works_on.Pno = Project.Pnumber
		INNER JOIN Employee ON Employee.Ssn = Works_on.Essn
			GROUP BY Pname

----------------------------------------------------------------------------------------------------------------
