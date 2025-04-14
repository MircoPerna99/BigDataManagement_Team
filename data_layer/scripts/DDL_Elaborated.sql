CREATE TABLE patients (
	id	CHAR(36) NOT NULL,
	birthdate	DATE NOT NULL,
	deathdate	DATE,
	ssn	VARCHAR(15) NOT NULL,
	drivers	VARCHAR(20),
	passport VARCHAR(20),
	prefix	VARCHAR(5),
	first_name VARCHAR(20) NOT NULL,
	last_name VARCHAR(20) NOT NULL,
	suffix	VARCHAR(5),
	maiden VARCHAR(20),
	marital	VARCHAR(1),
	race	INT NOT NULL,
	ethnicity INT NOT NULL,
	gender	VARCHAR(1) NOT NULL,
	birthplace	VARCHAR(100) NOT NULL,
	address	VARCHAR(50) NOT NULL,
	city INT NOT NULL,
	zip	INT,
	lat	DECIMAL(22, 20) NOT NULL,
	lon	DECIMAL(22, 20) NOT NULL,
	healthcare_expenses	DECIMAL(30, 20) NOT NULL,
	healthcare_coverage DECIMAL(30, 20) NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (race) REFERENCES Races(id),
	FOREIGN KEY (ethnicity) REFERENCES Ethnicities(id),
	FOREIGN KEY (city) REFERENCES Cities(id),
);

CREATE TABLE Cities
(
	id int NOT NULL AUTO_INCREMENT,
   	name VARCHAR(50) NOT NULL,
   	county INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (county) REFERENCES Counties(id)
)


CREATE TABLE Counties
(
	id int NOT NULL AUTO_INCREMENT,
   	name VARCHAR(50) NOT NULL,
   	state INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (state) REFERENCES States(id)
)


CREATE TABLE States
(
	id int NOT NULL AUTO_INCREMENT,
   	name VARCHAR(50) NOT NULL,
    PRIMARY KEY (id)
)


CREATE TABLE Races
(
    id int NOT NULL AUTO_INCREMENT,
   	name VARCHAR(15) NOT NULL,
    PRIMARY KEY (id)
)


CREATE TABLE Ethnicities
(
    id int NOT NULL AUTO_INCREMENT,
    name VARCHAR(15) NOT NULL,
    PRIMARY KEY (Id)
)

CREATE TABLE Payers(
	id	CHAR(36) NOT NULL,
	name	VARCHAR(50) NOT NULL,
	address	VARCHAR(50),
	city	VARCHAR(50),
	state_headquartered	CHAR(2),
	zip_code INT,
	phone	VARCHAR(20),
	amount_covered	DECIMAL(20, 2) NOT NULL,
	amount_uncovered DECIMAL(20, 2) NOT NULL,	
	revenue	DECIMAL(20, 2) NOT NULL,
	covered_encounters	INT NOT NULL,
	uncovered_encounters	INT NOT NULL,
	covered_medications	INT NOT NULL,
	uncovered_medications	INT NOT NULL,
	covered_procedures	INT NOT NULL,
	uncovered_procedures	INT NOT NULL,
	covered_immunizations	INT NOT NULL,
	uncovered_immunizations	INT NOT NULL,
	unique_customers	INT NOT NULL,
	qols_avg	DECIMAL(20, 19) NOT NULL,	
	member_months INT NOT NULL,
	PRIMARY KEY (id)
);

CREATE TABLE Organizations(
	id	CHAR(36) NOT NULL,
	name	VARCHAR(100) NOT NULL,
	address	VARCHAR(100) NOT NULL,
	city	VARCHAR(50) NOT NULL,
	state	CHAR(2) NOT NULL,
	zip_code	VARCHAR(20) NOT NULL,
	lat	DECIMAL(22, 20) NOT NULL,
	lon	DECIMAL(22, 20) NOT NULL,
	phone	VARCHAR(50),
	revenue	DECIMAL(2, 1) NOT NULL,
	utilization INT NOT NULL,
	PRIMARY KEY (id)
);

CREATE TABLE Providers(
	id	CHAR(36) NOT NULL,
	organization	CHAR(36) NOT NULL,
	first_name VARCHAR(20) NOT NULL,
	last_name VARCHAR(20) NOT NULL,
	gender	CHAR(1) NOT NULL,
	speciality	INT NOT NULL,
	address	VARCHAR(50) NOT NULL,
	city	VARCHAR(50) NOT NULL,
	state	CHAR(2) NOT NULL,
	zip_code	VARCHAR(20) NOT NULL,
	lat	DECIMAL(22, 20) NOT NULL,
	lon	DECIMAL(22, 20) NOT NULL,
	utilization INT NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (speciality) REFERENCES Specialities(id)
);

CREATE TABLE Specialities
(
    id int NOT NULL AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    PRIMARY KEY (Id)
)