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
