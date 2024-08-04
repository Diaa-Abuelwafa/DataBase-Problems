-- Part One
-- 1- Display max and min salary for instructors

use ITI

select max(Salary)
from Instructor

select min(Salary)
from Instructor

--===============================================

-- 2- Select Average Salary for instructors

select avg(Salary)
from Instructor

--===============================================

-- Part Two

-- 1- Retrieve a list of employees and the projects they are working on ordered by department and within each department

USE MyCompany

select E.Dno, E.Fname + ' ' + E.Lname as 'Full Name', P.Pname
from Employee E, Project P, Works_for WF
where E.SSN = WF.ESSn and P.Pnumber = WF.Pno
order by E.Dno, E.Lname, E.Fname

--===============================================

-- 2- Try to update all salaries of employees who work in Project ‘Al Rabwah’ by 30%

update E
set Salary += Salary * 0.3
from Employee E, Project P, Works_for WF
where E.SSN = WF.ESSn and P.Pnumber = WF.Pno and Pname = 'Al Rabwah'

--===============================================

-- 1- In the department table insert a new department called "DEPT IT" , with id 100, employee with SSN = 112233 as a manager for this department. The start date for this manager is '1-11-2006'

select * from Departments

insert into Departments(Dname, Dnum, MGRSSN, [MGRStart Date])
values('DEPT IT', 100, 112233 , '11-1-2006')

--===============================================

-- a - First try to update her record in the department table

update Employee
set Dno =  100
where SSN = 968574

update Departments
set MGRSSN = 968574
where Dnum = 100

--===============================================

-- b - Update your record to be department 20 manager.

insert into Employee
values('Diaa', 'Ehab', 102672, '11/18/1999', 'Cairo', 'M', 12000, NULL, 20)

update Departments
set MGRSSN = 102672
where Dnum = 20

--===============================================

-- C - Update the data of employee number=102660 to be in your teamwork (he will be supervised by you) (your SSN =102672)

update Employee
set Superssn = 102672
where SSN = 102660

--===============================================

-- 3- Unfortunately the company ended the contract with  Mr.Kamel Mohamed (SSN=223344) so try to delete him from your database in case you know that you will be temporarily in his position.

delete from Employee
where SSN = 223344

update Departments
set MGRSSN = 102672
where Dnum = 10

update Employee
set Superssn = 102672
where Superssn = 223344

delete from Dependent
where ESSN = 223344

update Works_for
set ESSn = 102672
where ESSn = 223344

delete from Employee
where SSN = 223344

--===============================================

-- Part Three

-- 1 - Retrieve the names of all employees in department 10 who work more

select E.Fname + ' ' + E.Lname as 'Full Name', E.Dno
from Employee E, Project P, Works_for WF
where E.SSN = WF.ESSn and P.Pnumber = WF.Pno and E.Dno = 10 and P.Pname = 'AL Rabwah' and WF.Hours >= 10


--===============================================

-- 2 - Find the names of the employees who were directly supervised by Kamel Mohamed

select X.Fname + ' ' + X.Lname as 'Full Name', Y.Fname + ' ' + Y.Lname as 'Super Name'
from Employee X, Employee Y
where Y.SSN = X.Superssn and Y.Fname = 'Kamel' and Y.Lname = 'Mohamed'

--===============================================

-- 3 - Display All Data of the managers

select E.Fname + ' ' + E.Lname as 'Manager Name'
from Employee E, Departments D
where E.SSN = D.MGRSSN

--===============================================

-- 4 - Retrieve the names of all employees and the names of the projects they are working on, sorted by the project name.

select E.Fname + ' ' + E.Lname as 'Full Name', P.Pname
from Employee E, Project P, Works_for WF
where E.SSN = WF. ESSn and P.Pnumber = WF.Pno
order by P.Pname

--===============================================

-- 5 - For each project located in Cairo City, find the project number, the controlling department name, the department manager last name ,address and birthdate.

select Pnumber, D.Dname, E.Lname, E.Address, E.Bdate
from Project P, Departments D, Employee E
where D.Dnum = P.Dnum and E.SSN = D.MGRSSN and City = 'Cairo'

--===============================================

-- 6 - Display All Employees data and the data of their dependents even if they have no dependents.

select E.*, De.*
from Employee E right outer join Dependent De
on E.SSN = De.ESSN

--===============================================

-- Part Four

-- 1 - Display the Department id, name and id and the name of its manager.

select D.Dnum, D.Dname, E.Fname + ' ' + E.Lname as 'Manager Name'
from Employee E, Departments D
where E.SSN = D.MGRSSN

--===============================================

-- 2 - Display the name of the departments and the name of the projects under its control.

select * from Project

select D.Dname, P.Pname
from Departments D, Project P
where D.Dnum = P.Dnum

--===============================================

-- 3 - Display the full data about all the dependence associated with the name of the employee they depend on

select De.*
from Employee E, Dependent De
where E.SSN = De.ESSN

--===============================================

-- 4 - Display the Id, name and location of the projects in Cairo or Alex city

select Pname, Plocation
from Project
where City = 'Cairo' or City = 'Alex' 

--===============================================

-- 5 - Display the Projects full data of the projects with a name starting with "a" letter.

select * from Project where Pname like 'a%'

--===============================================

-- 6 - display all the employees in department 30 whose salary from 1000 to 2000 LE monthly

select * from Employee where Dno = 30 and Salary between 10000 and 20000

--===============================================

-- 7 - Retrieve the names of all employees in department 10 who work more than or equal 10 hours per week on the "AL Rabwah" project

select E.Fname + ' ' + E.Lname as 'Full Name'
from Employee E, Project P, Works_for WF
where E.SSN = WF.ESSn and P.Pnumber = WF.Pno and P.Pname = 'AL Rabwah' and WF.Hours >= 10 and E.Dno = 10

--===============================================

-- 8 - Retrieve the names of all employees and the names of the projects they are working on, sorted by the project name.

select E.Fname + ' ' + E.Lname as 'Full Name', P.Pname
from Employee E, Project P, Works_for WF
where E.SSN = WF.ESSn and P.Pnumber = WF.Pno
order by P.Pname

--===============================================

-- 9 - For each project located in Cairo City , find the project number, the controlling department name ,the department manager last name ,address and birthdate

select P.Pnumber, D.Dname, E.Lname, E.Address, E.Bdate
from Employee E, Project P, Departments D
where P.City = 'Cairo' and D.Dnum = P.Dnum and E.SSN = D.MGRSSN

--===============================================