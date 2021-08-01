-----UC-1 Create DataBase-----
create database payroll_service
use payroll_service
-----UC-2 Create table for DataBase payroll-----
create table employee_payroll(
EmployeeId int identity(1,1) primary key,
EmployeeName varchar(255),
EmployeeSalary float,
StartDate Date
)
-----UC-3 Insert Values to table-----
Insert into employee_payroll
(EmployeeName,EmployeeSalary,StartDate)
values('Ram Kumar','650000','2020-10-07'),('Vijay','700000','2019-05-08'),('Priya','350500','2021-01-17');

Insert into employee_payroll(EmployeeName,EmployeeSalary,StartDate)values('Asif','950500','2017-12-12');
-----UC-4 Retrieve all data from the table-----
select * from employee_payroll;
-----UC-5 Retrieve Specific Data-----
select BasicPay from employee_payroll where EmployeeName = 'Vijay';
select EmployeeSalary from employee_payroll where StartDate Between Cast('2019-01-01' as Date) and GETDATE();
-----UC-6  Alter the table to add gender column and update the values for each rows-----
Alter table employee_payroll Add Gender char(1);
update employee_payroll set Gender = 'M' where EmployeeName ='Vijay' or EmployeeName = 'Ram Kumar' or EmployeeName = 'Asif';
update employee_payroll set Gender = 'F' where EmployeeName = 'Priya';
-----UC-7.1 Use aggregate function Sum of salary-----
select sum(EmployeeSalary)as TotalSalary,Gender from employee_payroll group by Gender;
-----UC-7.2 Use aggregate function Min of salary-----
select min(EmployeeSalary)as MinimumSalary,Gender from employee_payroll group by Gender;
-----UC-7.3 Use aggregate function Max of salary-----
select max(EmployeeSalary)as MaximumSalary,Gender from employee_payroll group by Gender;
-----UC-7.4 Use aggregate function Count based on Gender-----
select count(EmployeeName)as EmployeeCount,Gender from employee_payroll group by Gender;
-----UC-8 Ability to add further more columns-----
alter table employee_payroll Add EmployeePhoneNumber bigint, EmployeeDepartment varchar(255) not null default 'HR',EmployeeAddress varchar(255) default 'chennai'
update employee_payroll set EmployeePhoneNumber = '7812453698',EmployeeAddress = 'Chennai' where EmployeeName = 'Ram Kumar';
update employee_payroll set EmployeePhoneNumber = '7214587875',EmployeeAddress = 'Banglore',EmployeeDepartment = 'Sales' where EmployeeName = 'Vijay';
update employee_payroll set EmployeePhoneNumber = '9814753647',EmployeeAddress = 'Mysore' where EmployeeName = 'Asif';
update employee_payroll set EmployeePhoneNumber = '7345787969',EmployeeAddress = 'Chennai', EmployeeDepartment = 'Customer Service' where EmployeeName = 'Priya';
-----UC-9 Ability to add salary details-----
sp_rename 'employee_payroll.EmployeeSalary','BasicPay'
alter table employee_payroll Add Deductions float,TaxablePay float,IncomeTax float,NetPay float
Update employee_payroll set Deductions = '24000' where EmployeeDepartment = 'HR'
Update employee_payroll set Deductions = '23000' where EmployeeDepartment = 'Sales'
Update employee_payroll set Deductions = '20000' where EmployeeDepartment = 'Customer Service'
Update employee_payroll set NetPay = (BasicPay-Deductions)
Update employee_payroll set TaxablePay = '1000'
Update employee_payroll set IncomeTax = '200'
-----UC-10 Add Priya to Marketing department -----
Insert into employee_payroll(EmployeeName,BasicPay,StartDate,Gender,EmployeePhoneNumber,EmployeeDepartment,EmployeeAddress,Deductions,TaxablePay,IncomeTax,NetPay)values('Priya','350500','2021-01-17','F','7345787969','Marketing','Chennai','0','0','0','0');
-----UC-11 Create table Empt Dept-----
---Company Details---
create table company
(
company_Id int identity(1,1) primary key,
company_name varchar(255)
)
Insert into company values('Xoxo'),('Vohi')
select * from company
---Employee Details---
create table Employee
(
EmployeeId int identity(1,1) primary key,
EmployeeName varchar(255),
Gender char(1),
EmployeePhoneNumber bigint,
EmployeeAddress varchar(255),
StartDate date,
CompanyId int
Foreign key(CompanyId) references Company(company_Id)
)
Insert into Employee values
('Ram Kumar','M','7812453698','Chennai','2020-10-07','1'),
('Vijay','M','7214587875','Banglore','2019-05-08','2'),
('Priya','F','7345787969','Chennai','2021-01-17','2'),
('Asif','M','9814753647','Mysore','2017-12-12','1')
select * from Employee
---Payroll table---
create table payroll
(
EmpId int, 
BasicPay float,
TaxablePay float,
IncomeTax float,
Deductions float,
NetPay float
foreign key(EmpId) references Employee(EmployeeId)
)
Insert into payroll(EmpId,BasicPay,IncomeTax,Deductions)values('1','650000','20000','24000'),
('2','700000','20000','23000'),
('3','350500','20000','20000'),
('4','950500','23000','24000')
select * from payroll
Update payroll set TaxablePay = (BasicPay-Deductions)
Update payroll set NetPay = (TaxablePay-IncomeTax)
---Dept Table---
create table department_table
(
DeptId int identity(1,1) primary key,
DeptName varchar(255)
)
insert into department_table values('Sales'),('Marketing'),('HR'),('Customer Service')
select * from department_table
-----Emp Dept table-----
create table emp_Dept
(
DeptId int,
EmpId int
foreign key(EmpId) references Employee(EmployeeId),
foreign key(DeptId) references department_table(DeptId)
)
insert into emp_Dept values
('3','1'),('1','2'),
('4','3'),('3','4'),('2','3')
select * from emp_Dept
-----UC-12 perform select queries------
select company.company_Id ,company.company_name,EmployeeId,EmployeeName,Gender,EmployeePhoneNumber,EmployeeAddress,StartDate,payroll.BasicPay,TaxablePay,IncomeTax,Deductions,NetPay,department_table.DeptName from Employee
inner join company on company.company_Id = Employee.CompanyId
inner join payroll on payroll.EmpId = Employee.EmployeeId
inner join emp_Dept on Employee.EmployeeId = emp_Dept.EmpId
inner join department_table on department_table.DeptId = emp_Dept.DeptId
---Salary for particular employee---
select Employee.EmployeeId,Employee.EmployeeName,payroll.BasicPay from payroll inner join
Employee on Employee.EmployeeId=payroll.EmpId where Employee.EmployeeName = 'Ram Kumar'
---Salary between date of joining and current date----
select Employee.EmployeeId,Employee.EmployeeName,payroll.BasicPay from payroll inner join
Employee on Employee.EmployeeId = payroll.EmpId where Employee.StartDate between Cast('2019-01-01' as Date) and GETDATE();
---Sum of salary based on gender---
select sum(payroll.BasicPay) as TotalSalary,Employee.Gender from Employee
inner join payroll on Employee.EmployeeId = payroll.EmpId group by Employee.Gender
select sum(payroll.BasicPay) as TotalSalary,Employee.Gender from Employee
inner join payroll on Employee.EmployeeId = payroll.EmpId where Employee.Gender = 'F' group by Employee.Gender
---Average of salary based on gender---
select avg(payroll.BasicPay) as averagesalary,Employee.Gender from Employee
inner join payroll on Employee.EmployeeId = payroll.EmpId group by Employee.Gender
select AVG(payroll.BasicPay) as averagesalary,Employee.Gender from Employee
inner join payroll on Employee.EmployeeId = payroll.EmpId where Employee.Gender = 'F' group by Employee.Gender
---Minimum salary based on gender---
select min(payroll.BasicPay) as minimumsalary,Employee.Gender from Employee
inner join payroll on Employee.EmployeeId = payroll.EmpId group by Employee.Gender
select min(payroll.BasicPay) as minimumsalary,Employee.Gender from Employee
inner join payroll on Employee.EmployeeId = payroll.EmpId where Employee.Gender = 'F' group by Employee.Gender
---Maximum salary based on gender---
select max(payroll.BasicPay) as maximumsalary,Employee.Gender from Employee
inner join payroll on Employee.EmployeeId = payroll.EmpId group by Employee.Gender
select max(payroll.BasicPay) as maximumsalary,Employee.Gender from Employee
inner join payroll on Employee.EmployeeId = payroll.EmpId where Employee.Gender = 'F' group by Employee.Gender



