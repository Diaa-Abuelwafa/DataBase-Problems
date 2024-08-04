-- Demo

use ITI

-- Aggregate Functions

select count(*)
from Student

select count(St_Id)
from student

select count(St_Lname)
from student

select sum(Salary)
from Instructor

select max(Salary)
from Instructor

select min(Salary)
from Instructor

select avg(Salary)
from Instructor

-- Null Fuanctions

select ISNULL(St_Fname, 'Fname'), ISNULL(St_Lname, 'Lname')
from Student

select coalesce(St_Lname, st_Fname, 'No Name')
from Student

-- Casting Function

select convert(varchar(max), salary)
from Instructor

select convert(datetime, '11/18/1999', 101)  -- With Format About Date

select cast(Salary as varchar(max))
from Instructor

select cast('11/18/1999' as datetime)

select format(getdate(), 'dd-MM-yy')
select format(getdate(), 'dddd-MMMM-yyyy')
select format(getdate(), 'dddd-MMMM-yyyyy:tt')
select format(getdate(), 'dd-MM-yy:hh:mm:ss')

select concat(Ins_Name, ' ', Ins_Degree) -- Not Included Null Like concatenate with (+)
from Instructor

-- Date and Time Functions
select Day(getdate())
select Month(getdate())
select Year(getdate())
select Eomonth(getdate())
select format(Eomonth(getdate()), 'dddd')

-- String Functions

declare @name varchar(20)
set @name = 'Ahmed'

print upper(@name)
print lower(@name)
print substring(@name, 1, 2)
print len(@name)
print reverse(@name)

print char(69)
print ascii('A')
print charindex('e', 'Ahmed', 1)

-- Math & System Functions

select power(2, 5)
select sqrt(25)
select rand()
select abs(-11)

select newid() -- Return unique number around server
select db_name() -- return the database name
select suser_name() -- return the user who login in the database

-- Group by & Having

select Dept_Id, max(Salary)
from Instructor
group by Dept_Id

select Dept_Id, max(Salary)
from Instructor
group by Dept_Id
having max(salary) > 60000 -- Having With Aggregate Function

select Dept_Id, max(Salary)
from Instructor
group by Dept_Id
having Dept_Id > 10  -- Having With Column Wich Select in with aggregate function

--======================================================================================

-- Part One

use ITI

-- 1 - Retrieve a number of students who have a value in their age.

select count(St_Age)
from Student

-- 2 - Display number of courses for each topic name

select Top_Id, count(Crs_Id)
from Course
group by Top_Id

-- 3 - Select Student first name and the data of his supervisor

select S1.St_Fname, s2.*
from Student S1, Student S2
where S2.St_Id = s1.St_super

-- 4 - Display student with the following Format (use isNull function)

select S.St_Id as 'Student ID', CONCAT(S.St_Fname, ' ', isnull(S.St_Lname, 'No Name')) as 'Student Full Name', D.Dept_Name as 'Department Name'
from student S, Department D
where D.Dept_Id = S.Dept_Id

-- 5 - Select instructor name and his salary but if there is no salary display value ‘0000’ . “use one of Null Function”

select Ins_Name, coalesce(Salary, '0000')
from Instructor

-- 6 - Select Supervisor first name and the count of students who supervises on them

select S1.St_Fname, S1.St_super, count(S1.St_Id)
from Student S1, Student S2
where S2.St_Id = S1.St_super
group by S1.St_Fname, S1.St_super

-- 7 - Display max and min salary for instructors

select max(Salary)
from Instructor

select min(Salary)
from Instructor

-- 8 - Select Average Salary for instructors

select avg(Salary)
from Instructor

--===================================================

-- Part Two

-- 1 - For each project, list the project name and the total hours per week (for all employees) spent on that project.

use MyCompany

select P.Pname, WF.Hours
from Employee E, Project P, Works_for WF
where E.SSN = WF.ESSn and P.Pnumber = WF.Pno

-- 2 - For each department, retrieve the department name and the maximum, minimum and average salary of its employees.

select D.Dname, max(E.Salary) as 'Maximum Salary', min(E.Salary) as 'Minimum Salary', avg(E.Salary) as 'Average Salary'
from Employee E, Departments D
where D.Dnum = E.Dno
group by D.Dname

-- 3 - Retrieve a list of employees and the projects they are working on ordered by department and within each department, ordered alphabetically by last name, first name.

select E.Dno, E.lname, E.Fname, P.Pname
from Employee E, Project P, Works_for WF
where E.SSN = WF.ESSn and P.Pnumber = WF.Pno and E.Dno is not null
order by E.Dno, E.Lname, E.Fname

-- 4 - Try to update all salaries of employees who work in Project ‘Al Rabwah’ by 30% 

update E
set Salary += Salary * 0.3
from Employee E, Project P, Works_for WF
where E.SSN = WF.ESSn and P.Pnumber = WF.Pno and P.Pname = 'Al Rabwah'