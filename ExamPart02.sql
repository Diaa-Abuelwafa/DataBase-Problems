--======================= Exam Part 02 ===============================
use Library

-- 1 -

select CONCAT(Fname, ' ', Lname) as [Full Name]
from Employee
where len(Fname) > 3

-- 2 -

select COUNT(B.Id) as '‘NO OF PROGRAMMING BOOKS'
from Book B, Category C
where C.Id = B.Id and C.Cat_name = 'Programming'

-- 3 -

select COUNT(B.Id) as 'NO_OF_BOOKS'
from Book B, Publisher P
where P.Id = B.Publisher_id and P.Name = 'HarperCollins'

-- 4 -

select Bo.User_ssn, U.User_Name
from Book B, Users U, Borrowing BO
where U.SSN = BO.User_ssn and B.Id = BO.Book_id and BO.Due_date < '7-1-2022'

-- 5 -

select CONCAT('[', B.Title, ']', ' is written by ', '[', A.Name, ']')
from Book B, Author A, Book_Author BA
where B.Id = BA.Book_id and A.Id = BA.Author_id

-- 6 -

select User_Name
from Users
where User_Name like '%A%'

-- 7 -

select Top(1) SSN
from(select U.SSN, COUNT(B.Book_id) as [Number]
from Users U, Borrowing B
where U.SSN = B.User_ssn
group by U.SSN) as NewTable
order by Number desc

-- 8 -

select U.SSN, SUM(B.Amount)
from Users U, Borrowing B
where U.SSN = B.User_ssn
group by U.SSN

-- 9 -

select C.Cat_name
from Category C, Book B, Borrowing BO
where C.Id = B.Id and B.Id = BO.Book_id and BO.Amount = (select MIN(Amount) from Borrowing)

-- 10 -

select coalesce(Email, Address, convert(varchar(max), DOB))
from Employee

-- 11 - 

select C.Cat_name, COUNT(B.Id) as 'Count Of Books'
from Book B, Category c
where C.Id = B.Id
group by C.Cat_name

-- 12 -

select B.Id
from Book B, Shelf S, Floor F
where S.Code = B.Shelf_code and F.Number = S.Floor_num and F.Number != 1 and S.Code = 'A1'

-- 13 -

select F.Number, F.Num_blocks, COUNT(E.Id)
from Floor F, Employee E
where F.Number = E.Floor_no
group by F.Number, F.Num_blocks

-- 14 -

select B.Title, U.User_Name
from Book B, Users U, Borrowing BO
where B.Id = BO.Book_id and U.SSN = BO.User_ssn and BO.Borrow_date between '3-1-2022' and '10-1-2022'

-- 15 -

select CONCAT(E1.Fname, ' ', E1.Lname) as [Full Name], CONCAT(E2.Fname, ' ', E2.Lname) as [Supervisor Name]
from Employee E1, Employee E2
where E2.Super_id = E1.Id

-- 16 -

select CONCAT(Fname, ' ', Lname) as [Full Name], ISNULL(Salary, Bouns)
from Employee

-- 17 -

select MAX(Salary) as 'Maximum Salary', MIN(Salary) as 'Minimum Salary'
from Employee

-- 18 -

create function fun_name01(@num int)
returns varchar(max)
begin
	declare @result varchar(max)

	if @num % 2 = 0
		set @result = 'Even'
	else
		set @result = 'Odd'

	return @result
end

print dbo.fun_name01(2)

-- 19 -

create or alter function fun_name02(@cat_name varchar(max))
returns table
as return 
(
	select B.Title
	from Book B, Category C
	where C.Id = B.Id and C.Cat_name = @cat_name
)

select * from dbo.fun_name02('Mathematics')

-- 20 -

create or alter function fun_name03(@phone bigint)
returns table
as return
(
	select B.Title, U.User_Name, BO.Amount, BO.Due_date
	from Users U, Book B, Borrowing BO
	where U.SSN = BO.User_ssn and B.Id = BO.Book_id and U.SSN = (select U.SSN from Users U, User_phones UP where U.SSN = UP.User_ssn and UP.Phone_num = @phone)
)

select * from fun_name03(0102302155)

-- 21 -

create or alter function fun_name04(@user_name varchar(max))
returns @T table
(
	result varchar(max)
) 
as
begin
	declare @result int

	select @result = COUNT(*)
	from Users
	where User_Name = @user_name

	if @result > 1
		insert into @T
		values(CONCAT('[', @user_name, ']', ' is repeated [', @result, '] times'))
	else if @result = 1
		insert into @T
		values(CONCAT('[', @user_name, '] is not duplicated'))
	else
		insert into @T
		values(CONCAT('[', @user_name, '] is not found'))
		return
end

select * from fun_name04('Diaa')

-- 22 -

create or alter function fun_name05(@date date)
returns varchar(max)
begin
	declare @result varchar(max)

	set @result = format(@date, 'dddd-MMMM-yyyy')

	return @result
end

print dbo.fun_name05(getdate())

-- 23 -

create proc sp_name01
as
	select C.Cat_name, COUNT(B.id)
	from Book B, Category C
	where C.Id = B.Id
	group by C.Cat_name

exec sp_name01

-- 24 -

create proc sp_name02 @old_id int, @new_id int, @floor_num int
as
	update Floor
	set MG_ID = @new_id
	where MG_ID = @old_id

exec sp_name02 3, 1, 999

-- 25 -

create or alter view AlexAndCairoEmpView
as
	select * from Employee
	where Address in ('Cairo', 'Alex')

select * from AlexAndCairoEmpView

-- 26 -

create or alter view V2
as
	select S.Code, COUNT(B.Id) as 'Number'
	from book B, Shelf S
	where S.Code = B.Shelf_code
	group by S.Code

select * from V2

-- 27 -

create view V3
as
	select top(1) code from V2 order by number desc

select * from V3

-- 28 -

create table ReturnedBooks
(
	User_SSN int,
	Book_id int references book(id),
	due_date date,
	return_date date,
	fees bigint
)


create or alter trigger tri_name01
on ReturnedBooks
instead of insert
as
	if (select Top(1) return_date from inserted) =  (select Top(1) due_date from inserted)
		insert into ReturnedBooks
		select * from inserted
	else
		print 'U must Pay a Fee'

-- 29 -

insert into floor(Number, Num_blocks, MG_ID, Hiring_Date)
values(7, 2, 20, getdate())

update floor 
set MG_ID = 12
where MG_ID = 5

update floor
set MG_ID = 5
where Number = 6


-- 30 -

create or alter view v_2006_check
with encryption
as
	select MG_ID, Number, Num_blocks, Hiring_Date
	from Floor
	where Hiring_Date between '3-1-2022' and '5-30-2022' with check option

insert into v_2006_check
values(2, 6, 2, '7-8-2023'),
(4, 7, 1, '4-8-2022')

-- Not Allow Date Out Of The Range

-- 31 -

create trigger tri_name04
on Employee
instead of update, delete, insert
as
	print 'U Cannot Take Any Action With This Table'

-- 32 -

-- A- 
insert into User_phones
values(50, 01204838874)

-- Error --> Because 50 Not in Empolyee Table

-- B -

-- Error --> Because Emp 20 Have A Child

-- C - 

-- Error --> Because Emp 1 Have A Child

-- D - 

delete from Employee
where Id = 12

-- Deleted Because It Don't Have A Child

-- E -

create clustered Index Ix_name01
on Employee(salary)

-- Not Created Because This Table already Have A clustered Index

-- 33 -

-- I Do It