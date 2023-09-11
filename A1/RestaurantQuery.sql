/*Soale 1 */

CREATE DATABASE Restaurant;

/*1*/
CREATE TABLE Administrator(
	AdminSSN int primary key NOT NULL, 
	FName varchar(100),
	LName varchar(100),
	UserName varchar(100) NOT NULL,
	Pass varchar(100) NOT NULL,
	PhoneNo bigInt,
	AdminAddress varchar(256),
	City varchar(100),
	Country varchar(100),
);

/*2*/
CREATE TABLE Customer(
	CustomerSSN int primary key NOT NULL, 
	FName varchar(100),
	LName varchar(100),
	Email varchar(100),
	PhoneNo bigInt,
	CustomerAddress varchar(256),
);

/*3*/
CREATE TABLE Waiter(
	WaiterSSN int primary key NOT NULL, 
	FName varchar(100),
	LName varchar(100),
	Email varchar(100),
	PhoneNo bigInt,
	WaiterAddress varchar(256),
	Salary Real,
	UserName varchar(100) NOT NULL,
	Pass varchar(100) NOT NULL,
);

/*4*/
CREATE TABLE Chef(
	ChefSSN int primary key NOT NULL, 
	FName varchar(100),
	LName varchar(100),
	Email varchar(100),
	PhoneNo bigInt,
	ChefAddress varchar(256),
	Salary Real,
	UserName varchar(100) NOT NULL,
	Pass varchar(100) NOT NULL,
);

/*5*/
CREATE TABLE FoodItem(
	FoodId int PRIMARY KEY NOT NULL, 
	ChefId int FOREIGN KEY REFERENCES Chef(ChefSSN) NOT NULL,
	FoodName varchar(100),
	FoodType varchar(100),
	Category varchar(100),
	Price decimal(10, 2),
);

/*6*/
CREATE TABLE Menu(
	MenuId int identity(0, 1) PRIMARY KEY NOT NULL, 
	MenueName varchar(100), 
	MenuDateFrom datetime,
	MenuDateTo datetime,
	MenuDescription varchar(256), 
	ItemsNo int,
	TotalPrice decimal(10, 2)
);
/*7*/
CREATE TABLE MenuItem(
	MenuItemId int identity(0, 1) PRIMARY KEY NOT NULL, 
	FoodId int FOREIGN KEY REFERENCES FoodItem(FoodId) NOT NULL,
	MenuId int FOREIGN KEY REFERENCES Menu(MenuId) NOT NULL,
	ItemName varchar(100),
	ItemDescription varchar(100),
	Price decimal(10, 2),
);

/*8*/
CREATE TABLE Orders(
	OrderId int identity(0, 1) PRIMARY KEY NOT NULL, 
	CustomerId int FOREIGN KEY REFERENCES Customer(CustomerSSN) NOT NULL,
	WaiterId int FOREIGN KEY REFERENCES Waiter(WaiterSSN) NOT NULL,
	OrderTime datetime,
	ReceiveTime datetime,
	ItemsNo int,
	TotalPrice decimal(10, 2)
);

/*9*/
CREATE TABLE OrderMenuItem(
	OrderMenuItemId int identity(0, 1) NOT NULL, 
	MenuItemId int FOREIGN KEY REFERENCES MenuItem(MenuItemId) NOT NULL,
	OrderId int FOREIGN KEY REFERENCES Orders(OrderId) NOT NULL,
	Quantity int,
	ItemType varchar(100),
	PreparationTime time,
	ItemPrice decimal(10, 2),
	PRIMARY KEY(OrderMenuItemId, OrderId)
);
DROP TABLE OrderMenuItem

/*10*/
CREATE TABLE Payment(
	PaymentId int PRIMARY KEY NOT NULL, 
	CustomerId int FOREIGN KEY REFERENCES Customer(CustomerSSN) NOT NULL,
	OrderId int FOREIGN KEY REFERENCES Orders(OrderId) NOT NULL,
	PaymentDate datetime,
	PaymentType char(20),
	Amount decimal(10, 2)
);


