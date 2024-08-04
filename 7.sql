--========================= Demo ==============================
use ITI

select Ins_Name, Salary
from Instructor
where Salary > (select AVG(Salary) from Instructor)


select St_Id, (select COUNT(*) from Student)
from Student

-- Using Join

select D.Dept_Name
from Student S, Department D
where D.Dept_Id = S.Dept_Id

-- Using SubQuery

select Dept_Name
from Department
where Dept_Id in (select Dept_Id from Student where Dept_Id is not null)

-- Using Join

delete from SC
from Student S, Stud_Course SC
where S.St_Id = SC.St_Id and S.St_Address = 'Alex'

-- Using SubQuery

delete from Stud_Course
where St_Id in (select St_Id from Student where St_Address = 'Alex')


-- Top

select Top(5) *
from Instructor

select top(5) *
from Instructor
order by Ins_Id desc

select Top(2) Salary
from Instructor
where salary is not null
order by Salary desc

-- Method One
select max(Salary)
from Instructor
where Salary != (select max(Salary) from Instructor)

-- Method Two
select Top(1) *
from
(select Top(2) *
from Instructor
order by Salary desc) as NewTable
order by salary

select Top(5) with ties *
from Instructor
order by Salary desc

-- Randomly Selection

select Top(3) Ins_Name
from Instructor
order by NewID()

-- Ranking Functions

select Ins_Name, Salary, Row_Number() over (order by salary desc)
from Instructor

select Ins_Name, Salary, dense_rank() over (order by salary desc) 
from Instructor

select Ins_Name, Salary, rank() over (order by salary desc)
from Instructor

-- Using Top
select Top(2) *
from student
order by st_age desc

-- Using Ranking Function
select *
from (select St_Fname, st_age, Row_Number() over (order by st_age desc) as RN
from student) as NewTable
where RN <= 2

select St_Fname, st_age, dept_id, ROW_NUMBER() over (partition by dept_id order by st_age desc)
from student

select St_Fname, st_age, NTile(3) over (order by st_age desc)
from student

create schema hr

alter schema hr
transfer student

create table hr.test
(
	id int primary key,
)

--=========================================================================

--============== Part 01 ==================================================

use ITI

-- 1
select *
from Instructor
where Salary < (select AVG(Salary) from Instructor)

-- 2
select Dept_Name
from Department
where Dept_Id = (select Dept_Id from Instructor where Salary = (select MIN(Salary) from Instructor))

-- 3
select Top(2) Salary
from Instructor
order by Salary desc

-- 4
select *
from (select *, ROW_NUMBER() over (partition by dept_id order by salary desc) as RN
from Instructor) as NewTable
where RN <= 2

-- 5
select Top(1) *, ROW_NUMBER() over (order by NEWID())
from student


--==============================

use MyCompany

-- 1
select Dname
from Departments
where Dnum = (select Dno from Employee where SSN = (select MIN(SSN) from Employee))

-- 2
select Top(1) Fname
from(select E.Fname, D.[MGRStart Date]
from Employee E, Departments D
where E.SSN = D.MGRSSN and D.[MGRStart Date] is not null and E.SSN not in (select ESSN from Dependent)) as NewTable
order by [MGRStart Date]

-- 3
select Dnum, Dname  
from Departments
where Dnum in (
select Dno
from (select Dno, AVG(Salary) as Avgerage
from Employee
where Dno is not null
group by Dno) as NewTable
where Avgerage < (select AVG(Salary) from Employee)
)

select count(*)
from Employee
where Dno in (
select Dno
from (select Dno, AVG(Salary) as Avgerage
from Employee
where Dno is not null
group by Dno) as NewTable
where Avgerage < (select AVG(Salary) from Employee)
)

-- 4
select Salary
from Employee
where SSN in (
select Top(2) SSN
from Employee
order by Salary desc)

-- 5
select E.SSN, CONCAT(E.Fname, ' ', E.Lname) as [Full Name]
from Employee E
where exists (select * from Dependent D where E.SSN = D.ESSN)

--========================================================

--======================= Part 02 ========================

use AdventureWorks2012

-- 1
select SalesOrderID, ShipDate
from Sales.SalesOrderHeader
where ShipDate between '7/28/2002' and '7/29/2014'

-- 2
select ProductID, Name 
from Production.Product
where StandardCost < 110

-- 3
select ProductID, Name
from Production.Product
where Weight is null

-- 4
select *
from Production.Product
where Color = 'silver' or color = 'black' or color = 'red'

-- 5
select *
from Production.Product
where name like 'B%'

-- 6
UPDATE Production.ProductDescription
SET Description = 'Chromoly steel_High of defects'
WHERE ProductDescriptionID = 3

select *
from Production.ProductDescription
where Description like '%[_]%'

-- 7
select distinct HireDate
from HumanResources.Employee

-- 8
select CONCAT(Name, ListPrice) as 'The [product name] is only! [List price]'
from Production.Product
where ListPrice between 100 and 120
order by ListPrice desc

--==============================================================

