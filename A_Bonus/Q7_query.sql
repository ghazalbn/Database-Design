CREATE TABLE Customers (
 name VARCHAR(255),
 industry VARCHAR(255),
 project1_id INT,
 project1_feedback TEXT,
 project2_id INT,
 project2_feedback TEXT,
 contact_person_id INT,
 contact_person_and_role VARCHAR(300),
 phone_number VARCHAR(12),
 address VARCHAR(255),
 city VARCHAR(255),
 zip VARCHAR(5)
);




--1NF--
ALTER TABLE CUSTOMERS 
ADD ID INT PRIMARY KEY IDENTITY(1,1) NOT NULL;

Go 
Exec sp_rename 'Customers.contact_person_and_role', 'contact_person', 'COLUMN';

ALTER TABLE CUSTOMERS 
ADD contactp_role VARCHAR(300);

Alter Table Customers 
Drop Column project1_id, project1_feedback, project2_id, project2_feedback;

CREATE TABLE Project(
	P_ID INT identity(1, 1) NOT NULL,
	C_ID INT FOREIGN KEY REFERENCES CUSTOMERS(ID) NOT NULL,
	FeedBack VARCHAR(255),
	PRIMARY KEY(P_ID, C_ID)
)



--2NF--
Alter Table Customers 
Drop Column contact_person, contactp_role, phone_number;

CREATE TABLE Contact_Person(
	CP_ID INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
	contact_person VARCHAR(300),
	contactp_role VARCHAR(300),
	phone_number VARCHAR(12)
)

ALTER TABLE Customers
ADD FOREIGN KEY (contact_person_id) REFERENCES Contact_Person(CP_ID)



--3NF--
CREATE TABLE Zip(
	zip_code VARCHAR(5) PRIMARY KEY,
	city VARCHAR(255),
	address VARCHAR(255)
)

Alter Table Customers 
Drop Column city, address;

ALTER TABLE Customers
ADD FOREIGN KEY (zip) REFERENCES Zip(zip_code)
