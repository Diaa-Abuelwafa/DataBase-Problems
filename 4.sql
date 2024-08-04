/*
	Part 02
	From The Previous Assignment insert at least 2 rows per table. 
*/

use Musician_DB

insert into Musician
values(1, 'Diaa', 01204838874, 'Alex', 'Elharam')

insert into Musician
values(2, 'Ali', 01039761874, 'Cairo', 'Surn')

insert into Instrument
values('Piano', 59)

insert into Instrument
values('Gitar', 60)

insert into Album
values(1, 'Action', '5/17/2024', 1)

insert into Album
values(2, 'Romantic', '6/17/2024', 2)

insert into Song
values('Basha', 'Ali')

insert into Song
values('Zaman', 'Mohamed')

use ITI_Wizard

insert into Students
values(1, 'Diaa', 'Ehab', 24, 'Cairo', NULL)

insert into Students
values(2, 'Mohamed', 'Ali', 20, 'Alex', NULL)

insert into Departments
values(1, 'Frontend', '1/1/2030', NULL)

insert into Departments
values(2, 'Backend', '1/1/2032', NULL)

insert into instructors
values('Mohsen', 'Alex', 24.5, 20000, 14, 1)

insert into instructors
values('Hassan', 'Giza', 24.5, 180000, 14, 2)

--=========================================================

-- 1.Insert your personal data to the student table as a new Student in department number 30.

insert into Students
values(1, 'Diaa', 'Abuelwafa', 23, 'Bhera', 30)

--=========================================================

-- 2.Insert Instructor with personal data of your friend as new Instructor in department number 30, Salary= 4000, but don’t enter any value for bonus

insert into Instructors(Name, Address, Salary, Hour_rate, Dep_ID)
values('Ali', 'Mahala', 20000, 12, 1)

--=========================================================

-- 3.Upgrade Instructor salary by 20 % of its last value.

update Instructors
set Salary += Salary * 0.1
where id = 3

--========================================================

-- Part 03

use MyCompany

select * from Employee

select Fname, Lname, Salary, Dno from Employee

select Pname, Plocation, Dnum from Project

select Fname + ' ' + Lname as fullName, Salary = salary +  0.1 * Salary from Employee

select SSN, Fname +  ' ' + Lname as 'Full Name' from Employee
where Salary > 1000

select SSN, Fname +  ' ' + Lname as 'Full Name' from Employee
where Salary * 12 > 10000

select Fname +  ' ' + Lname as 'Full Name', Salary from Employee
where sex = 'F'

select Dnum, Dname from Departments
where MGRSSN = 968574

select Pnumber, Pname, Plocation from Project
where Dnum = 10

select * from Project
where Pname like 'a%'

--========================================================

use ITI

select distinct Ins_Name from Instructor

--========================================================

select @@VERSION
select @@SERVERNAME

-- The Meaning Of Those Statements is the two statements is a global variables it givs us informations about the sql server version and server name



