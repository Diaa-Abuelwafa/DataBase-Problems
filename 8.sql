--======================== Demo =====================================

use ITI

select St_Fname from Student
Union
select Ins_Name from Instructor

select St_Fname from Student
Union all
select Ins_Name from Instructor

select St_Fname from Student
intersect
select Ins_Name from Instructor

select St_Fname from Student
except
select Ins_Name from Instructor

select * into Table1
from student

select * into Table2
from student
where 1 = 2

insert into Table2
select * from student

-- Scalar Function
create function getname(@stu_id int)
returns varchar(20)
begin
	declare @stu_name varchar(20)

	select @stu_name = St_Fname from Student
	where st_id = @stu_id

	return @stu_name
end

select dbo.getname(1)

-- In-Line Table Valued Function
create function getnames (@dep_id int)
returns table 
as return 
(
	select St_Fname from Student
	where Dept_Id = @dep_id
)

select * from dbo.getnames(10)

-- Multistatements Table Valued Function
create function getnamebyformat(@format varchar(20))
returns @t table
(
	stu_id int,
	stu_name varchar(20)
)
as 
begin

	if @format = 'first'
		insert into @t
		select st_id, St_Fname from Student
	else if @format = 'last'
		insert into @t
		select st_id, St_Lname from Student
	else if @format = 'full'
		insert into @t
		select st_id, CONCAT(St_Fname, ' ', St_Lname) from Student
	return 
end

select * from dbo.getnamebyformat('full')

-- Standard View
create or alter view getstudetsnameview
with encryption
as 
	select st_id, St_Fname from Student

select * from getstudetsnameview

-- Partition View
create or alter view getstudentsandinstructorsnames
as
	select st_id, St_Fname from Student
	Union
	select Ins_Id, Ins_Name from Instructor

select * from getstudentsandinstructorsnames

sp_helptext 'getstudentsandinstructorsnames' -- use encryption

-- DML With Views

insert into getstudetsnameview
values(124578, 'Hossam')

insert into getstudentsandinstructorsnames(st_id, St_Fname)
values(187945, 'Mohab')

insert into getstudentsandinstructorsnames(ins_id, Ins_name)
values(41818, 'Mazen')

--===================================================================

--==================== Part 01(Functions) ===========================

-- 1 -
create or alter function getmonth(@date date)
returns varchar(10)
begin
	declare @month varchar(10)

	select @month = format(@date, 'MMMM')

	return @month
end

select dbo.getmonth(getdate())

-- 2 - 
create function getrange(@num1 int, @num2 int)
returns @T table
(
	ranges int
)
as
begin
	declare @counter int
	set @counter = @num1 + 1

	while @counter < @num2
	begin
		insert into @t 
		values(@counter)

		set @counter = @counter + 1
	end

	return 
end

select * from dbo.getrange(1, 10)

-- 3 -

create or alter function getinfo(@stu_id int)
returns table
as return 
(
	select D.Dept_Name, CONCAT(S.St_Fname, ' ', St_Lname) as 'Full Name'
	from Student S, Department D
	where D.Dept_Id = S.Dept_Id and S.St_Id = @stu_id
)

select * from dbo.getinfo(5)

-- 4 -

create or alter function getmsg(@stu_id int)
returns varchar(50)
begin
	declare @fname varchar(20)
	declare @lname varchar(20)
	declare @result varchar(50)

	select @fname = St_Fname, @lname = St_Lname
	from Student
	where St_Id = @stu_id

	if @fname is null and @lname is null
		set @result = 'First name & last name are null'
	else if @fname is null and @lname is not null
		set @result = 'first name is null'
	else if @lname is null and @fname is not null
		set @result = 'last name is null'
	else
		set @result = 'First name & last name are not null'

	return @result
end

select dbo.getmsg(1)

-- 5 -

create or alter function getinfobyformat(@format int)
returns table
as return
(
	select Dept_Name, Dept_Manager, CONVERT(date, Manager_hiredate, @format) as [Date]
	from Department
)

select * from getinfobyformat(131)

-- 6 -

create function getnamebyformat2(@string varchar(20))
returns @T table
(
	result varchar(20)
)
as
begin
	if @string = 'first name'
		insert into @T
		select ISNULL(St_Fname, 'Empty') from Student
	else if @string = 'last name'
		insert into @T
		select ISNULL(St_Lname, 'Empty') from Student
	else if @string  = 'full name'
		insert into @T
		select CONCAT(ISNULL(St_Fname, 'Empty'), ' ', ISNULL(St_Lname, 'Empty')) from Student

	return 
end

select * from getnamebyformat2('first name')

-- 7 - 

use MyCompany

select E
from Project P, Employee E, Works_for WF

create function getempolyees(@projectnum int)
returns table
as return
(
	select E.Fname
	from Employee E, Works_for WF, Project P
	where E.SSN = WF.ESSn and P.Pnumber = WF.Pno and P.Pnumber = @projectnum
)

select * from getempolyees(100)

--====================== Part 02(Views) ================================

use ITI

-- 1 -

create view studentsInfoView
as
(
	select CONCAT(S.St_Fname, ' ', S.St_Lname) as [FullName], C.Crs_Name 
	from Student S, Course C, Stud_Course SC
	where s.St_Id = SC.St_Id and C.Crs_Id = sc.Crs_Id and SC.Grade > 50
)

select * from studentsInfoView

-- 2 -

create or alter view view77
with encryption
as
(
	select I.Ins_Name
	from Department D, Instructor I
	where I.Ins_Id = D.Dept_Manager
)

-- 3 -

create or alter view insnamesview 
as
(
	select I.Ins_Name, D.Dept_Name
	from Instructor I, Department D
	where D.Dept_Id = I.Dept_Id and D.Dept_Name = 'SD' or D.Dept_Name = 'Java'
)

select * from dbo.insnamesview

-- 4 - 

use MyCompany

create or alter view projectnamesview
as
(
	select P.Pname, COUNT(*) as [Numbers]
	from Employee E, Project P, Works_for WF
	where E.SSN = WF.ESSn and P.Pnumber = WF.Pno
	group by P.Pname
)

select * from projectnamesview

--=============================

use [SD32-Company]

-- 1 -
create or alter view v_clerk
as
(
	select EmpNo, ProjectNo, Enter_Date
	from Works_on
	where Job = 'Clerk'
)

-- 2 -

create or alter view v_without_budget
with encryption
as 
(
	select ProjectNo, ProjectName
	from HR.Project
)

-- 3 -

create view v_count
as
(
	select P.ProjectName, Count(WO.Job) as [Numbers]
	from hr.Project P, dbo.Works_on WO
	where P.ProjectNo = WO.ProjectNo
	group by P.ProjectName
)

-- 4 -

create or alter view v_project_p2
as
(
	select CONCAT('emp', EmpNo) as [empolyee num], CONCAT('project', EmpNo) as [Project num]
	from v_clerk
)


-- 5 -
alter view v_without_budget
as 
(
	select * 
	from hr.Project
	where ProjectNo = 1 or ProjectNo = 2
)

-- 6 -

drop view v_clerk
drop view v_count

-- 7 -

create view view44
as
(
	select CONCAT('emp', EmpNo) as [empolyeenum], EmpLname
	from HR.Employee
	where DeptNo = 2
)

-- 8 -

select EmpLname from view44
where EmpLname like '%j%'

-- 9 -

create or alter view v_dept
as
(
	select CONCAT('department', DeptNo) as [departmentnum], DeptName
	from Department
)

--====================================================

--================== Part 03 =========================

-- 1 -

use ITI

create or alter view V1
with encryption
as

	select *
	from dbo.Student
	where St_Address = 'Cairo' or St_Address = 'Alex' with check option


--=======================

use [SD32-Company]

-- 1 -

create or alter view v_dept
as
(
	select CONCAT('department', DeptNo) as [departmentnumber], DeptName
	from Department
)

-- 2 -

insert into v_dept
values(5, 'Development')
where deptno = 4 and deptname = 'Development'

-- 3 -

create or alter view	v_2006_check
as

	select E.EmpNo, P.ProjectNo
	from HR.Employee E, Works_on WO, HR.Project P
	where E.EmpNo = WO.EmpNo and P.ProjectNo = WO.ProjectNo and	WO.Enter_Date >= '1-1-2006' and WO.Enter_Date <= '31-12-2006'
	with check option

--================================================================================================================================

