
--======================= Demo ==============================================

create database test_db

use test_db

create table Employees
(
	SSN int primary key identity(1, 1),
	Fname varchar(20) not null,
	Lname varchar(20),
	gender char(1) default 'M',
	birthdate date,
	Dnum int, -- Edit to FK
	super_SSN int references Employees(SSN)
)

create table Departments
(
	DNum int primary key,
	Dname varchar(20) not null,
	manager_SSN int references Employees(SSN),
	hiring_date date
)

create table Department_Locations 
(
	DNum int references Departments(DNum),
	Location varchar(50) default 'cario',

	primary key (DNum, Location)
)

create table Projects
(
	PNum int primary key,
	Pname varchar(20),
	Location varchar(50),
	city varchar(20),
	Dnum int references Departments(DNum)
)

create table Dependents
(
	name varchar(20),
	birthdate date,
	gender char(1), -- or varchar
	ESSN int references Employees(SSN)
)

create table Employee_Projects 
(
	ESSN int references Employees(SSN),
	Pnum int references Projects(PNum),
	NumOfHours float,

	primary key (ESSN, Pnum)
)

alter table Employees
add foreign key(Dnum) references Departments(DNum)

alter table Employees
add test int

alter table Employees
alter column test bigint

alter table Employees
drop column test

--===========================================================================================

--=============================== Musician Database ==================================================

create database musician_db

use musician_db

create table Musician
(
	id int identity(1, 1) primary key,
	name varchar(20) not null,
	phone_number int not null,
	city varchar(20),
	street varchar(20)
)

create table instrument
(
	name varchar(20) primary key,
	instrument_key int not null,
)

create table Album
(
	id int primary key,
	tittle varchar(20),
	Date date not null,
	Mus_ID int references Musician(id)
)

create table Song
(
	tittle varchar(20) primary key,
	Aouthor varchar(20)
)

create table Album_Song
(
	Album_ID int references Album(id),
	Song_Tittle varchar(20) primary key references Song(tittle) 
)

create table mus_Song
(
	Mus_ID int references Musician(id),
	Song_Tittle varchar(20) references Song(tittle),
	primary key (Mus_ID, Song_Tittle)
)

create table Mus_Instrument
(
	Mus_ID int references Musician(id),
	Inst_Name varchar(20) references instrument(name),
	primary key (Mus_ID, Inst_Name)
)

--==================================================================

--================================ ITI Database ====================

create database iti_db

use iti_db

create table Students
(
	id int primary key identity(1, 1),
	Fname varchar(20) not null,
	Lname varchar(20) not null,
	Age int not null,
	Address varchar(20),
	dep_ID int --Edit To FK
)

create table Departments
(
	id int primary key identity(10, 10),
	name varchar(20) not null,
	Hiring_Date date,
	Ins_ID int -- Edit To FK
)

create table Instructors
(
	id int primary key identity(1, 1),
	name varchar(20) not null,
	Address varchar(20),
	Bouns money,
	salary money,
	Hour_Rate float,
	dep_ID int references Departments(id)
)


create table Courses
(
	id int primary key identity(100, 100),
	name varchar(20),
	Duration int,
	Description varchar(20),
	top_id int -- Edit To FK
)

create table Topics
(
	id int primary key identity(1, 1),
	name varchar(20)
)

create table stu_course
(
	stu_id int references Students(id),
	Course_id int references Courses(id),
	grade float,
	primary key (stu_id, Course_id)
)

create table Course_Instructor
(
	course_id int references Courses(id),
	int_id int references Instructors(id),
	evaluation float,
	primary key(course_id, int_id)
)

alter table Students
add foreign key(dep_ID) references Departments(id)


alter table Departments
add foreign key(Ins_ID) references Instructors(id)

alter table Courses
add foreign key(top_id) references Topics(id)

--===========================================================================