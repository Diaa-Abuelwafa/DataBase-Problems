--====================== Demo ==============================
use ITI

create proc sp_name01 
as 
	select * from student

sp_name01
exec sp_name01
execute sp_name01

create proc sp_name02 @id int
as
	select * from student
	where St_Id = @id

exec sp_name02 1

declare @x int = 1

exec sp_name02 @x

create or alter proc sp_name03 @id int
with encryption
as
	begin try
		select * from student
		where St_Id = @id
	end try
	begin catch
		print 'Wrong Query'
	end catch

exec sp_name03 77

create proc sp_name04 @x int, @y int
as 
	select @x + @y

sp_name04 @y = 1, @x = 2

create or alter proc sp_name05 @table_name varchar(max), @column_name varchar(max)
as	
	execute ('select ' + @column_name + ' from ' + @table_name) 

sp_name05 student, st_fname

create table test09
(
	id int
)

insert into test09
exec sp_name05 student, st_id


create proc sp_name06 @id int, @name varchar(max) out
as
	select @name = St_Fname
	from Student
	where St_Id = @id

declare @result varchar(max)

exec sp_name06 2, @result out

print @result

create trigger tri_name01
on student
after insert
as
	print 'Hello'

insert into Student(St_Id, St_Fname, St_Lname, St_Address, St_Age)
values(17,'Diaa', 'Ehab', 'Kafr', 24)

create trigger tri_name02
on student
instead of delete, insert
as
	print 'Not Allow'

delete from Student
where st_id = 1

alter table student
disable trigger tri_name01

alter table student
enable trigger tri_name01

drop trigger tri_name01

create or alter trigger tri_name04
on topic
instead of delete
as
	select 'U Cannot delete ' + (select Top_Name from deleted)

delete from topic
where Top_Id = 1

drop trigger tri_name04

create or alter trigger tri_name05
on topic
instead of delete
as
	if format(getdate(), 'ddd') = 'Wed'
		delete from topic
		where top_id in (select top_id from deleted)

create table t_name01
(
	id int,
	name varchar(max)
)

drop trigger tri_name05

create trigger tri_name06
on topic
instead of delete
as
	insert into t_name01
	select * from deleted


delete from topic

-- delete -- LogFile , delete data only , using where, slower , continue identity, DML
-- truncate -- No LogFile , delete data and structure , no using where , falster , no continue identity, DDL

begin try
	begin transaction
		select * from student
		select * from topics
	commit transaction
end try
begin catch
	rollback transaction
end catch


create clustered index in_name01
on student(st_id)

create nonclustered index in_name02
on student(st_Fname)


SELECT St_Lname FROM student


create or alter view name01
with schemabinding
as
	select Top_Id, Top_Name from dbo.topic

create unique clustered index ix_name03
on name01(top_id)

select * from name01

-- 1. User on Server 
-- 2. User On DB
-- 3. User On Schema
-- 4. Grant and Deny

--============================ Part 01 =====================================

-- 1 -

create or alter proc sp_name10
as
	select Dept_Id, COUNT(*)
	from Student
	where dept_id is not null
	group by Dept_Id

exec sp_name10

-- 2 -
 
use MyCompany

create or alter proc sp_name11
as
	declare @result int

	select @result = COUNT(*)
	from Employee E, Project P, Works_for WF
	where E.SSN = WF.ESSn and P.Pnumber = WF.Pno and P.Pnumber = 100
	group by P.Pname

	if @result > 3
		print 'The number of employees in the project 100 is 3 or more'
	else if @result < 3
		select E.Fname, E.Lname
		from Employee E, Project P, Works_for WF
		where E.SSN = WF.ESSn and P.Pnumber = WF.Pno and P.Pnumber = 100
		print 'The following employees work for the project 100'

		
exec sp_name11

-- 3 -

create OR alter proc sp_name12 @old_num int, @new_num int, @pro_num int
as
	insert into Employee(SSN)
	values(@new_num)

	update Works_for
	set ESSN = @new_num, Pno =  @pro_num
	where ESSn = @old_num

exec sp_name12 102672, 112529, 400

--============================= Part 02 ======================================

-- 1 - 

create proc sp_name13 @start int, @end int
as
	declare @counter int = @start
	declare @result int = 0

	while(@counter <= @end)
	begin
		set @result = @result + @counter
		set @counter = @counter + 1
	end

	print @result

exec sp_name13 1, 5

-- 2 -

create proc sp_name14 @radius int
as
	print 3.14 * power(@radius, 2)

exec sp_name14 4

-- 3 - 

create proc sp_name15 @age int
as
	declare @category varchar(max)

	if @age < 18
		set @category = 'CHILD'
	else if @age >= 18 and @age < 60
		set @category = 'ADULT'
	else
		set @category = 'SENIOR'

	print @category

exec sp_name15 20

-- 4 -

create or alter proc sp_name16 @nums varchar(max)
as
	select * from string_split(@nums, ',') -- NOT Working

exec sp_name16 '5, 10, 15, 20, 25'


--============================== Part 03 ================================

use ITI

-- 1 -

create trigger tri_name10
on department
instead of insert
as
	print 'U Cannot Insert A New Record In This Table'

insert into Department(Dept_Id, Dept_Name)
values(10, 'VF')
	
-- 2 -

use MyCompany

create trigger tri_name11
on Employee
instead of insert
as
	if format(getdate(), 'mmmm') = 'March'
		insert into Employee
		select * from inserted

--================================ Part 04 ==================================
use ITI

-- 1 - 

create trigger tri_name12
on department
instead of insert
as
	print 'U Cannot Insert A New Record In This Table'

-- 2 - 

create table StudentAudit
(
	ServerUserName varchar(max),
	login_date date,
	note varchar(max)
)

-- 3 -
create trigger tri_name13
on student
after insert
as
	declare @username varchar(max) = (select St_Fname from inserted) 
	declare @id int = (select St_Id from inserted)
	insert into StudentAudit
	values(@username, getdate(), concat(@username, 'Insert New Row with Key = ', @id, ' In Table = StudentAudit'))

insert into student(St_Id, St_Fname)
values(51515, 'Saad')

select * from StudentAudit

-- 4 -
create or alter trigger tri_name14
on student
instead of delete
as
	declare @username varchar(max) = (select st_fname from deleted)
	declare @id int = (select st_id from deleted)

	insert into StudentAudit
	values(@username, getdate(), concat('Try to delete row with id = ', @id))


delete from student
where st_id = 1

select * from StudentAudit

-- 5 - 

use MyCompany

create trigger tri_name15
on Employee 
instead of insert
as
	if format(getdate(), 'mmmm') = 'March'
		insert into Employee
		select * from inserted

--================================= Part 05 ====================================

-- 1 -
 
use Route_Company

create table Departments
(
	dept_no int primary key,
	dept_name varchar(max),
	location varchar(max)
)

insert into Departments
values(1, 'Research', 'NY'),
(2, 'Accounting', 'DS')

-- 2 - 

create table Empolyee
(
	emp_no int primary key,
	emp_fname varchar(max) not null,
	emp_lname varchar(max) not null,
	dept_no int references departments(dept_no),
	salary int unique
)

insert into Empolyee
values(25348, 'Mathew', 'Smith', 2, 2500),
(10102, 'Ann', 'Jones', 2, 3000)

-- 3 -

-- By Wizard

-- 4 - 

-- By Wizard

-- 5 -

-- Error: Don't Match With PK
-- Error : No Empolyee Has Number 11111
-- Error: Because It Has A Child
-- Error: Because It Has A Child

-- 6 -

alter table Empolyee
add TelephoneNumber bigint

alter table Empolyee
drop column TelephoneNumber

-- 7 - 

create schema company

alter schema company
transfer dbo.departments

alter schema company
transfer dbo.project

create schema human

alter schema human
transfer dbo.Empolyee

-- 8 -
update P
set P.budget += 0.1 * P.budget
from human.Empolyee E, company.Project P, dbo.works_on WO
where E.emp_no = WO.emp_no and P.project_no = WO.project_no	and E.emp_no = 10102 

-- 9 - 

update D
set D.dept_name = 'Sales'
from human.Empolyee E, company.departments D
where D.dept_no = E.dept_no and E.emp_fname = 'James '

-- 10 -

create table audit_table
(
	project_no int,
	username varchar(max),
	modifieddate date,
	budget_old int,
	budget_new int
)

--==================================================================