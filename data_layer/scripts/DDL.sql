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
	severity2 VARCHAR(20)
);



CREATE TABLE careplans(
	id CHAR(36) NOT NULL PRIMARY KEY,
	start DATE NOT NULL,
	stop DATE,
	patient	 CHAR(36) NOT NULL, -- probabilmente FK
	encounter CHAR(36) NOT NULL,-- probabilmente FK
	code BIGINT NOT NULL, -- probabilmente PK
	description VARCHAR(100),	
	reasoncode	INT,
	reasondescription VARCHAR(100)
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
	supervisingproviderid CHAR(36) NOT NULL -- probabilmente FK
);

CREATE TABLE claims(
	id	CHAR(36) NOT NULL PRIMARY KEY,
	patientid CHAR(36) NOT NULL,
	providerid CHAR(36) NOT NULL,
	primarypatientinsuranceid	VARCHAR(36) NOT NULL,-- VARCHAR perché alcuni sono uguali a 0
	secondarypatientinsuranceid	VARCHAR(36) NOT NULL,-- VARCHAR perché alcuni sono uguali a 0
	departmentid INT NOT NULL,
	patientdepartmentid	INT NOT NULL,
	diagnosis1	BIGINT NOT NULL,
	diagnosis2	BIGINT,
	diagnosis3	BIGINT,
	diagnosis4	BIGINT,
	diagnosis5	BIGINT,
	diagnosis6	BIGINT,
	diagnosis7	BIGINT,
	diagnosis8	BIGINT,
	referringproviderid	INT, -- valori tutti nulli da dare un'occhiata
	appointmentid	CHAR(36) NOT NULL, -- possibile FK
	currentillnessdate	DATE NOT NULL,
	servicedate	DATE NOT NULL,
	supervisingproviderid	CHAR(36) NOT NULL,   -- possibile FK
	status1	VARCHAR(20) NOT NULL,
	status2	VARCHAR(20),
	statusp	VARCHAR(20) NOT NULL,
	outstanding1 DECIMAL(10, 2) NOT NULL,
	outstanding2 DECIMAL(10, 2),	
	outstandingp DECIMAL(10, 2) NOT NULL,	
	lastbilleddate1	 DATE NOT NULL,
	lastbilleddate2	DATE ,
	lastbilleddatep	DATE NOT NULL,
	healthcareclaimtypeid1	INT NOT NULL,
	healthcareclaimtypeid2 INT NOT NULL 
);

CREATE TABLE conditions(
	start DATE NOT NULL,
	stop DATE,	
	patient	CHAR(36) NOT NULL,
	encounter CHAR(36) NOT NULL,
	code BIGINT NOT NULL,	
	description VARCHAR(100) NOT NULL
);

CREATE TABLE devices(
	start DATE NOT NULL,
	stop DATE,	
	patient	CHAR(36) NOT NULL,
	encounter CHAR(36) NOT NULL,
	code INT NOT NULL,	
	description VARCHAR(100) NOT NULL,
	udi VARCHAR(100) NOT NULL
);


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
	reasoncode	INT,
	reasondescription VARCHAR(100)
);

CREATE TABLE imaging_studies(
	id	CHAR(36) NOT NULL PRIMARY KEY,
	date DATE NOT NULL,
	patient	CHAR(36) NOT NULL,
	encounter	CHAR(36) NOT NULL,
	series_uid	VARCHAR(50) NOT NULL,
	bodysite_code	INT NOT NULL,
	bodysite_description VARCHAR(100) NOT NULL,
	modality_code	CHAR(2) NOT NULL,
	modality_description VARCHAR(50) NOT NULL,
	instance_uid VARCHAR(50) NOT NULL,
	sop_code VARCHAR(50) NOT NULL,	
	sop_description	VARCHAR(100) NOT NULL,	
	procedure_code INT NOT NULL
);

CREATE TABLE immunizations(
	date DATE NOT NULL,	
	patient	CHAR(36) NOT NULL,
	encounter CHAR(36) NOT NULL,
	code	INT NOT NULL, -- probabilmente PK
	description	VARCHAR(50) NOT NULL,
	base_cost	DECIMAL(10, 2) NOT NULL
);


CREATE TABLE medications(
	start	DATE NOT NULL,
	stop	DATE,
	patient	CHAR(36) NOT NULL,
	payer	CHAR(36) NOT NULL,
	encounter	CHAR(36) NOT NULL,
	code	INT NOT NULL,	
	description	VARCHAR(100) NOT NULL,
	base_cost	DECIMAL(10, 2) NOT NULL,
	payer_coverage	DECIMAL(10, 2) NOT NULL,
	dispenses	INT NOT NULL,
	totalcost	DECIMAL(10, 2) NOT NULL,
	reasoncode	INT,
	reasondescription VARCHAR(50)
);

CREATE TABLE observations(
	date	DATE NOT NULL,
	patient	CHAR(36) NOT NULL,
	encounter CHAR(36),
	category VARCHAR(50),
	code	VARCHAR(50),
	description	VARCHAR(100) NOT NULL,
	value	VARCHAR(100) NOT NULL,
	units	VARCHAR(50),
	type  VARCHAR(10)
);

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
	utilization INT NOT NULL
);

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
	birthplace	VARCHAR(50) NOT NULL,
	address	VARCHAR(50) NOT NULL,
	city	VARCHAR(50) NOT NULL,
	state	VARCHAR(50) NOT NULL,
	county	VARCHAR(50) NOT NULL,
	zip	INT,
	lat	DECIMAL(22, 20) NOT NULL,
	lon	DECIMAL(22, 20) NOT NULL,
	healthcare_expenses	DECIMAL(30, 20) NOT NULL,
	healthcare_coverage DECIMAL(30, 20) NOT NULL
);

CREATE TABLE payer_transitions(
	patient	CHAR(36) NOT NULL,
	memberid	CHAR(36),
	start_year	DATE NOT NULL,
	end_year	DATE NOT NULL,
	payer	CHAR(36) NOT NULL,
	secondary_payer	CHAR(36),
	ownership	CHAR(15),
	ownername CHAR(50)
);

CREATE TABLE payers(
	id	CHAR(36) NOT NULL,
	name	VARCHAR(50) NOT NULL,
	address	VARCHAR(50),
	city	VARCHAR(50),
	state_headquartered	CHAR(2),
	zip	INT,
	phone	VARCHAR(20),
	amount_covered	DECIMAL(10, 2) NOT NULL,
	amount_uncovered DECIMAL(10, 2) NOT NULL,	
	revenue	DECIMAL(10, 2) NOT NULL,
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
	member_months INT NOT NULL
);


CREATE TABLE procedures(
	start	DATE NOT NULL,
	stop	DATE NOT NULL,
	patient	CHAR(36) NOT NULL,
	encounter	CHAR(36) NOT NULL,
	code	INT NOT NULL,
	description	VARCHAR(100),
	base_cost	DECIMAL(10, 2) NOT NULL,
	reasoncode	INT,
	reasondescription VARCHAR(100)
);

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
	utilization INT NOT NULL
);

CREATE TABLE supplies(
	date	DATE NOT NULL,
	patient	CHAR(36) NOT NULL,
	encounter	CHAR(36) NOT NULL,
	code	INT NOT NULL,
	description	VARCHAR(100) NOT NULL,
	quantity INT NOT NULL
);
