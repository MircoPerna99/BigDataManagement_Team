CREATE TABLE patients (
	id	CHAR(36) NOT NULL,
	birthdate	DATE NOT NULL,
	deathdate	DATE,
	ssn	VARCHAR(15) NOT NULL,
	drivers	VARCHAR(20),
	passport VARCHAR(20),
	prefix	VARCHAR(5),
	first	VARCHAR(20) NOT NULL,
	last	VARCHAR(20) NOT NULL,
	suffix	VARCHAR(5),
	maiden VARCHAR(20),
	marital	VARCHAR(1),
	race	VARCHAR(15) NOT NULL,
	ethnicity	VARCHAR(15) NOT NULL,
	gender	VARCHAR(1) NOT NULL,
	birthplace	VARCHAR(100) NOT NULL,
	address	VARCHAR(50) NOT NULL,
	city	VARCHAR(50) NOT NULL,
	state	VARCHAR(50) NOT NULL,
	county	VARCHAR(50) NOT NULL,
	zip	INT,
	lat	DECIMAL(22, 20) NOT NULL,
	lon	DECIMAL(22, 20) NOT NULL,
	healthcare_expenses	DECIMAL(30, 20) NOT NULL,
	healthcare_coverage DECIMAL(30, 20) NOT NULL,
	PRIMARY KEY (id)
);

SELECT *
FROM patients p 

CREATE TABLE organizations(
	id	CHAR(36) NOT NULL,
	name	VARCHAR(100) NOT NULL,
	address	VARCHAR(100) NOT NULL,
	city	VARCHAR(50) NOT NULL,
	state	CHAR(2) NOT NULL,
	zip	VARCHAR(20) NOT NULL,
	lat	DECIMAL(22, 20) NOT NULL,
	lon	DECIMAL(22, 20) NOT NULL,
	phone	VARCHAR(50),
	revenue	DECIMAL(2, 1) NOT NULL,
	utilization INT NOT NULL,
	PRIMARY KEY (id)
);

SELECT *
FROM organizations o 

CREATE TABLE providers(
	id	CHAR(36) NOT NULL,
	organization	CHAR(36) NOT NULL,
	name	VARCHAR(50) NOT NULL,
	gender	CHAR(1) NOT NULL,
	speciality	VARCHAR(50) NOT NULL,
	address	VARCHAR(50) NOT NULL,
	city	VARCHAR(50) NOT NULL,
	state	CHAR(2) NOT NULL,
	zip	VARCHAR(20) NOT NULL,
	lat	DECIMAL(22, 20) NOT NULL,
	lon	DECIMAL(22, 20) NOT NULL,
	utilization INT NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (organization)  REFERENCES organizations(id)
);

select*
from providers p 

CREATE TABLE encounters(
	id	CHAR(36) NOT NULL PRIMARY KEY,
	start	DATE NOT NULL,
	stop	DATE NOT NULL,
	patient	CHAR(36) NOT NULL,
	organization CHAR(36) NOT NULL,
	provider CHAR(36) NOT NULL,
	payer CHAR(36) NOT NULL,
	encounterclass	VARCHAR(20) NOT NULL,
	code	INT NOT NULL,	
	description	VARCHAR(100) NOT NULL,
	base_encounter_cost	DECIMAL(10, 2) NOT NULL,
	total_claim_cost	DECIMAL(10, 2) NOT NULL,
	payer_coverage	DECIMAL(10, 2) NOT NULL,
	reasoncode	BIGINT,
	reasondescription VARCHAR(100),
	FOREIGN KEY (patient) REFERENCES patients(id),
	FOREIGN KEY (organization) REFERENCES organizations(id),
	FOREIGN KEY (provider) REFERENCES providers(id)
);




SELECT*
FROM encounters e 


CREATE TABLE allergies ( -- possibile problema nei dati manca l'id come guid
	start DATE NOT NULL,
	stop DATE,
	patient	 CHAR(36) NOT NULL, -- probabilmente FK
	encounter CHAR(36) NOT NULL,-- probabilmente FK
	code BIGINT NOT NULL, -- probabilmente PK
	`system` VARCHAR(100) NOT NULL,
	description	VARCHAR(100) NOT NULL,
	type VARCHAR(100) NOT NULL,
	category VARCHAR(100) NOT NULL,
	reaction1 INT,
	description1 VARCHAR(100),	
	severity1	VARCHAR(20),
	reaction2	INT,	
	description2 VARCHAR(100),
	severity2 VARCHAR(20),
	FOREIGN KEY (patient) REFERENCES patients(id),
	FOREIGN KEY (encounter) REFERENCES encounters(id)
);

select*
from allergies a 



CREATE TABLE conditions(
	start DATE NOT NULL,
	stop DATE,	
	patient	CHAR(36) NOT NULL,
	encounter CHAR(36) NOT NULL,
	code BIGINT NOT NULL,	
	description VARCHAR(100) NOT NULL,
	FOREIGN KEY (patient) REFERENCES patients(id),
	FOREIGN KEY (encounter) REFERENCES encounters(id)
);

select*
from conditions c 

CREATE TABLE careplans(
	id CHAR(36) NOT NULL,
	start DATE NOT NULL,
	stop DATE,
	patient	 CHAR(36) NOT NULL, -- probabilmente FK
	encounter CHAR(36) NOT NULL,-- probabilmente FK
	code BIGINT NOT NULL, -- probabilmente PK
	description VARCHAR(100),	
	reasoncode	BIGINT,
	reasondescription VARCHAR(100),
	PRIMARY KEY(id),
	FOREIGN KEY (patient) REFERENCES patients(id),
	FOREIGN KEY (encounter) REFERENCES encounters(id)
);

SELECT *
FROM careplans c 

DROP TABLE devices;
CREATE TABLE devices(
	start DATE NOT NULL,
	stop DATE,	
	patient	CHAR(36) NOT NULL,
	encounter CHAR(36) NOT NULL,
	code INT NOT NULL,	
	description VARCHAR(100) NOT NULL,
	udi VARCHAR(100) NOT NULL,
	FOREIGN KEY (patient) REFERENCES patients(id),
	FOREIGN KEY (encounter) REFERENCES encounters(id)
);

select*
from devices d 

CREATE TABLE immunizations(
	date DATE NOT NULL,	
	patient	CHAR(36) NOT NULL,
	encounter CHAR(36) NOT NULL,
	code	INT NOT NULL, -- probabilmente PK
	description	 TEXT NOT NULL,
	base_cost	DECIMAL(10, 2) NOT NULL,
	FOREIGN KEY (patient) REFERENCES patients(id),
	FOREIGN KEY (encounter) REFERENCES encounters(id)
);

select*
from immunizations i 

CREATE TABLE payers(
	id	CHAR(36) NOT NULL,
	name	VARCHAR(50) NOT NULL,
	address	VARCHAR(50),
	city	VARCHAR(50),
	state_headquartered	CHAR(2),
	zip	INT,
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

DROP TABLE payer_transitions

CREATE TABLE payer_transitions(
	patient	CHAR(36) NOT NULL,
	memberid	CHAR(36),
	start_year	DATE NOT NULL,
	end_year	DATE NOT NULL,
	payer	CHAR(36) NOT NULL,
	secondary_payer	CHAR(36),
	ownership	CHAR(15),
	ownername CHAR(50),
	FOREIGN KEY (patient) REFERENCES patients(id),
	FOREIGN KEY (payer) REFERENCES payers(id)
);

SELECT *
FROM payer_transitions pt 


CREATE TABLE medications(
	start	DATE NOT NULL,
	stop	DATE,
	patient	CHAR(36) NOT NULL,
	payer	CHAR(36) NOT NULL,
	encounter	CHAR(36) NOT NULL,
	code	INT NOT NULL,	
	description	TEXT NOT NULL,
	base_cost	DECIMAL(10, 2) NOT NULL,
	payer_coverage	DECIMAL(10, 2) NOT NULL,
	dispenses	INT NOT NULL,
	totalcost	DECIMAL(10, 2) NOT NULL,
	reasoncode	BIGINT,
	reasondescription TEXT,
	FOREIGN KEY (patient) REFERENCES patients(id),
	FOREIGN KEY (payer) REFERENCES payers(id),
	FOREIGN KEY (encounter) REFERENCES encounters(id)
);

DROP TABLE observations

CREATE TABLE observations(
	date	DATE NOT NULL,
	patient	CHAR(36) NOT NULL,
	encounter CHAR(36),
	category VARCHAR(50),
	code	VARCHAR(50),
	description	BLOB NOT NULL,
	value	TEXT NOT NULL,
	units	VARCHAR(50),
	type  VARCHAR(10),
	FOREIGN KEY (patient) REFERENCES patients(id)
);

SELECT*
FROM observations o 


CREATE TABLE procedures(
	start	DATE NOT NULL,
	stop	DATE NOT NULL,
	patient	CHAR(36) NOT NULL,
	encounter	CHAR(36) NOT NULL,
	code	BIGINT NOT NULL,
	description	TEXT,
	base_cost	DECIMAL(10, 2) NOT NULL,
	reasoncode	INT,
	reasondescription VARCHAR(100),
	FOREIGN KEY (patient) REFERENCES patients(id),
	FOREIGN KEY (encounter) REFERENCES encounters(id)
);

SELECT*
FROM procedures o 




drop TABLE  imaging_studies
CREATE TABLE imaging_studies(
	id	CHAR(36), -- VALORI DUPLICATI ID
	date DATE NOT NULL,
	patient	CHAR(36) NOT NULL,
	encounter	CHAR(36) NOT NULL,
	series_uid	VARCHAR(50),
	bodysite_code	INT NOT NULL,
	bodysite_description VARCHAR(100) NOT NULL,
	modality_code	CHAR(2) NOT NULL,
	modality_description VARCHAR(50) NOT NULL,
	instance_uid VARCHAR(50) NOT NULL,
	sop_code VARCHAR(50) NOT NULL,	
	sop_description	VARCHAR(100) NOT NULL,	
	procedure_code BIGINT NOT NULL,
	FOREIGN KEY (patient) REFERENCES patients(id),
	FOREIGN KEY (encounter) REFERENCES encounters(id)
);

CREATE TABLE supplies(
	date	DATE NOT NULL,
	patient	CHAR(36) NOT NULL,
	encounter	CHAR(36) NOT NULL,
	code	INT NOT NULL,
	description	VARCHAR(100) NOT NULL,
	quantity INT NOT NULL,
	FOREIGN KEY (patient) REFERENCES patients(id),
	FOREIGN KEY (encounter) REFERENCES encounters(id)
);


CREATE TABLE claimsTransaction(
	id CHAR(36) NOT NULL,
	claimid CHAR(36) NOT NULL,
	chargeid INT NOT NULL,
	patientid CHAR(36) NOT NULL,
	type	VARCHAR(20) NOT NULL,
	amount	DECIMAL(10, 2),  -- 10 digits total, 2 after decimal
	method	VARCHAR(20),
	fromdate DATE NOT NULL,
	todate	 DATE NOT NULL,
	placeofservice	CHAR(36) NOT NULL,
	procedurecode	BIGINT NOT NULL,
	modifier1	VARCHAR(100),
	modifier2	VARCHAR(100),
	diagnosisref1 INT NOT NULL, -- I valori sono o vuoiti o uguali a al numero finale
	diagnosisref2 INT,-- I valori sono o vuoiti o uguali a al numero finale
	diagnosisref3 INT,-- I valori sono o vuoiti o uguali a al numero finale
	diagnosisref4 INT,-- I valori sono o vuoiti o uguali a al numero finale
	units	INT NOT NULL, -- Valori tutti uguali a uno
	departmentid INT NOT NULL,
	notes	TEXT NOT NULL,
	unitamount	DECIMAL(10, 2),
	transferoutid	INT,
	transfertype	CHAR(1),
	payments	DECIMAL(10, 2),
	adjustments VARCHAR(20),
	transfers DECIMAL(10, 2),
	outstanding	DECIMAL(10, 2),
	appointmentid CHAR(36) NOT NULL,
	linenote VARCHAR(100),
	patientinsuranceid	CHAR(36), -- probabilmente FK
	feescheduleid INT NOT NULL,
	providerid	CHAR(36) NOT NULL, -- probabilmente FK
	supervisingproviderid CHAR(36) NOT NULL, -- probabilmente FK
	PRIMARY KEY(id),
	FOREIGN KEY (patientid) REFERENCES patients(id),
	FOREIGN KEY (providerid) REFERENCES providers(id),
	FOREIGN KEY (supervisingproviderid) REFERENCES providers(id),
	FOREIGN KEY (appointmentid) REFERENCES encounters(id)
);

CREATE TABLE claims(
	id	CHAR(36) NOT NULL,
	patientid CHAR(36) NOT NULL,
	providerid CHAR(36) NOT NULL,-- FK con providers
	primarypatientinsuranceid	VARCHAR(36) NOT NULL,-- VARCHAR perché alcuni sono uguali a 0
	secondarypatientinsuranceid	VARCHAR(36) NOT NULL,-- VARCHAR perché alcuni sono uguali a 0
	departmentid INT NOT NULL, -- QUESTO è SEMPRE UGUALE A patientdepartmentid
	patientdepartmentid	INT NOT NULL, -- QUESTO è SEMPRE UGUALE A departmentid
	-- Diagnosi sono il reason code
	diagnosis1	BIGINT NOT NULL,
	diagnosis2	BIGINT,
	diagnosis3	BIGINT,
	diagnosis4	BIGINT,
	diagnosis5	BIGINT,
	diagnosis6	BIGINT,
	diagnosis7	BIGINT,
	diagnosis8	BIGINT,
	referringproviderid	INT, -- valori tutti nulli da dare un'occhiata
	appointmentid	CHAR(36) NOT NULL, -- è riferito alla encounters
	currentillnessdate	DATE NOT NULL,
	servicedate	DATE NOT NULL,
	supervisingproviderid	CHAR(36) NOT NULL,   -- FK con providers
	status1	VARCHAR(20) NOT NULL, -- CLOSED o BILLED
	status2	VARCHAR(20),-- CLOSED o BILLED o NULL
	statusp	VARCHAR(20) NOT NULL,
	outstanding1 DECIMAL(10, 2) NOT NULL, -- SEMPRE ZERO
	outstanding2 DECIMAL(10, 2),	-- ZERO O NULL
	outstandingp DECIMAL(10, 2) NOT NULL,	-- SEMPRE ZERO
	lastbilleddate1	 DATE NOT NULL,
	lastbilleddate2	DATE ,
	lastbilleddatep	DATE NOT NULL,
	healthcareclaimtypeid1	INT NOT NULL,
	healthcareclaimtypeid2 INT NOT NULL,
	PRIMARY KEY(id),
	FOREIGN KEY (patientid) REFERENCES patients(id),
	FOREIGN KEY (appointmentid) REFERENCES encounters(id),
	FOREIGN KEY (providerid) REFERENCES providers(id)
);























