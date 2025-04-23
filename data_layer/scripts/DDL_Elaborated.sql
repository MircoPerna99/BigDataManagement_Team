CREATE TABLE Patients (
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
	FOREIGN KEY (city) REFERENCES Cities(id)
)

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

CREATE TABLE Payer_transitions(
	patient	CHAR(36) NOT NULL,
	memberid	CHAR(36),
	start_year	DATE NOT NULL,
	end_year	DATE NOT NULL,
	payer	CHAR(36) NOT NULL,-- Da mettere  nella tabella di relazione
	secondary_payer	CHAR(36),-- Da mettere  nella tabella di relazione
	ownership	CHAR(15), -- VALORI SELF O GUARDIAN
	ownername CHAR(50),
	FOREIGN KEY (patient) REFERENCES Payers(id)
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
	FOREIGN KEY (speciality) REFERENCES Specialities(id),
	FOREIGN KEY (organization) REFERENCES Organizations(id)
);

CREATE TABLE Specialities
(
    id int NOT NULL AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    PRIMARY KEY (Id)
)


CREATE TABLE Allergies ( -- possibile problema nei dati manca l'id come guid
	code BIGINT NOT NULL, -- probabilmente PK
	`system` VARCHAR(100) NOT NULL,
	description	VARCHAR(100) NOT NULL,
	type INT NOT NULL,
	category INT NOT NULL,
	PRIMARY KEY (code),
	FOREIGN KEY (category) REFERENCES Categories_allergy(id),
	FOREIGN KEY (type) REFERENCES Types_allergy(id)
)

CREATE TABLE Types_allergy
(
    id int NOT NULL AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    PRIMARY KEY (Id)
)

CREATE TABLE Categories_allergy
(
    id int NOT NULL AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    PRIMARY KEY (Id)
)

CREATE TABLE Reactions
(
	Id INT NOT NULL,
	description VARCHAR(100),
	PRIMARY KEY (Id)
)

CREATE TABLE Severity_reaction_allergy(
    id int NOT NULL AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    PRIMARY KEY (Id)
)

CREATE TABLE Patients_Allergies(
    id int NOT NULL AUTO_INCREMENT,
	allergy BIGINT NOT NULL,
	encounter CHAR(36) NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (allergy) REFERENCES Allergies(code),
	FOREIGN KEY (encounter) REFERENCES Encounters(id)
)

CREATE TABLE Patients_Allergies_Reaction(
	id int NOT NULL AUTO_INCREMENT,
	patientAllergy int NOT NULL,
	reactionId int not null,
	SeverityId int not null,
	PRIMARY KEY (id),
	FOREIGN KEY (patientAllergy) REFERENCES Patients_Allergies(id),
	FOREIGN KEY (reactionId) REFERENCES Reactions(id),
	FOREIGN KEY (SeverityId) REFERENCES Severity_reaction_allergy(id)
)


CREATE TABLE Conditions(
	code BIGINT NOT NULL,	
	description VARCHAR(100) NOT NULL,
	PRIMARY KEY (code)
);

CREATE TABLE Conditions_Encounter(
	id int NOT NULL AUTO_INCREMENT,
	`condition` BIGINT NOT NULL,
	encounter CHAR(36) NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (`condition`) REFERENCES Conditions(code),
	FOREIGN KEY (encounter) REFERENCES Encounters(id)
)


CREATE TABLE Devices(
	id VARCHAR(100) NOT NULL, 
	type INT NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (type) REFERENCES Types_device(code)
);

CREATE TABLE Types_device(
	code INT NOT NULL,	
	description VARCHAR(100) NOT NULL,
	PRIMARY KEY (code)
)


CREATE TABLE Devices_Encounter(
	id int NOT NULL AUTO_INCREMENT,
	device  VARCHAR(100) NOT NULL,
	encounter CHAR(36) NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (device) REFERENCES Devices(id),
	FOREIGN KEY (encounter) REFERENCES Encounters(id)
)


CREATE TABLE Immunizations(
	code	INT NOT NULL, -- probabilmente PK
	description	 TEXT NOT NULL,
	base_cost	DECIMAL(10, 2) NOT NULL,
	PRIMARY KEY (code)
);


CREATE TABLE Immunizations_Encounter(
	id int NOT NULL AUTO_INCREMENT,
	immunization  INT NOT NULL,
	encounter CHAR(36) NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (immunization) REFERENCES Immunizations(code),
	FOREIGN KEY (encounter) REFERENCES Encounters(id)
)

CREATE TABLE Supplies(
	code	INT NOT NULL,
	description	VARCHAR(100) NOT NULL,
	PRIMARY KEY (code)
);


CREATE TABLE Supplies_Encounter(
	id int NOT NULL AUTO_INCREMENT,
	supply  INT NOT NULL,
	encounter CHAR(36) NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (supply) REFERENCES Supplies(code),
	FOREIGN KEY (encounter) REFERENCES Encounters(id)
)


CREATE TABLE Careplans(
	code BIGINT NOT NULL, -- probabilmente PK
	description VARCHAR(100),	
	PRIMARY KEY(code)
);

CREATE TABLE Reasons(
	code INT NOT NULL,
	description VARCHAR(100),	
	PRIMARY KEY(code)
);


CREATE TABLE Careplans_Encounter(
	id int NOT NULL AUTO_INCREMENT,
	careplan  BIGINT NOT NULL,
	reason INT NOT NULL,
	encounter CHAR(36) NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (careplan) REFERENCES Careplans(code),
	FOREIGN KEY (reason) REFERENCES Reasons(code),
	FOREIGN KEY (encounter) REFERENCES Encounters(id)
)

CREATE TABLE Observations(
	code	VARCHAR(50) PRIMARY KEY,
	description	BLOB NOT NULL,
	value	TEXT NOT NULL,
	`type` int not null,
	FOREIGN KEY (`type`) REFERENCES Observations_Type(id)
);




CREATE TABLE Observations_Unit(
	id int NOT NULL AUTO_INCREMENT,
	name VARCHAR(50),
	PRIMARY KEY (id)
)


CREATE TABLE Observations_Category(
	id int NOT NULL AUTO_INCREMENT,
	name VARCHAR(50),
	PRIMARY KEY (id)
)

CREATE TABLE Observations_Type(
	id int NOT NULL AUTO_INCREMENT,
	name VARCHAR(10),
	PRIMARY KEY (id)
)


create TABLE Observations_Unit_Used
(
	observation VARCHAR(50) NOT NULL,
	unit INT NOT NULL,
	PRIMARY KEY (observation),
	FOREIGN KEY (observation) REFERENCES Observations(code),
	FOREIGN KEY (unit) REFERENCES Observations_Unit(id)
)


CREATE TABLE Observations_Category_Used
(
	observation VARCHAR(50) NOT NULL,
	category INT NOT NULL,
	PRIMARY KEY (observation, category),
	FOREIGN KEY (observation) REFERENCES Observations(code),
	FOREIGN KEY (category) REFERENCES Observations_Category(id)
)

CREATE TABLE Observations_Encounter(
	id int NOT NULL AUTO_INCREMENT,
	observation  VARCHAR(50) NOT NULL,
	encounter CHAR(36) NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (observation) REFERENCES Observations(id),
	FOREIGN KEY (encounter) REFERENCES Encounters(id)
)

CREATE TABLE Procedures(
	code	BIGINT NOT NULL,
	description	TEXT,
	base_cost	DECIMAL(10, 2) NOT NULL,
	PRIMARY KEY(code)
);

CREATE TABLE Procedures_Encounter(
	id int NOT NULL AUTO_INCREMENT,
	`procedure` BIGINT NOT NULL,
	encounter CHAR(36) NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (`procedure`) REFERENCES Procedures(code),
	FOREIGN KEY (encounter) REFERENCES Encounters(id)
)

CREATE TABLE Medications(
	code	INT NOT NULL,	
	description	TEXT NOT NULL,
	base_cost	DECIMAL(10, 2) NOT NULL,
	PRIMARY KEY (code)
);

CREATE TABLE Medications_Payer(
	id int NOT NULL AUTO_INCREMENT,
	medication_encounter INT NOT NULL,
	payer	CHAR(36) NOT NULL,
	payer_coverage	DECIMAL(10, 2) NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (payer) REFERENCES Payers(id),
	FOREIGN KEY (medication_encounter) REFERENCES Medications_Encounter(id)
);

CREATE TABLE Medications_Encounter(
	id int NOT NULL AUTO_INCREMENT,
	medication INT NOT NULL,
	encounter CHAR(36) NOT NULL,
	reason INT NOT NULL,
	dispenses	INT NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (medication) REFERENCES Medications(code),
	FOREIGN KEY (encounter) REFERENCES Encounters(id),
	FOREIGN KEY (reason) REFERENCES Reasons(code)
)

CREATE TABLE Encounters(
	id	CHAR(36) NOT NULL PRIMARY KEY,
	patient	CHAR(36) NOT NULL,
	organization CHAR(36) NOT NULL,
	provider CHAR(36) NOT NULL,
	payer CHAR(36) NOT NULL,
	encounterclass	INT NOT NULL,
	typeencounter INT NOT NULL,
	total_claim_cost	DECIMAL(10, 2) NOT NULL,
	payer_coverage	DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (encounterclass) REFERENCES Classes_encounter(id),
    FOREIGN KEY (typeencounter) REFERENCES Types_encounter(code),
	FOREIGN KEY (patient) REFERENCES Patients(id),
	FOREIGN KEY (organization) REFERENCES Organizations(id), -- Assuming this exists
    FOREIGN KEY (provider) REFERENCES Providers(id), -- Assuming this exists
    FOREIGN KEY (payer) REFERENCES Payers(id)
);

CREATE TABLE Classes_encounter(
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(20) NOT NULL,
    PRIMARY KEY (id)
)

CREATE TABLE Types_encounter(
	code	INT NOT NULL,	
	description	VARCHAR(100) NOT NULL,
	base_encounter_cost	DECIMAL(10, 2) NOT NULL,
	PRIMARY KEY(code)
)

CREATE TABLE Claims(
	id	CHAR(36) NOT NULL PRIMARY KEY,
	providerid CHAR(36) NOT NULL,
	departmentid INT NOT NULL,
	patientdepartmentid	INT NOT NULL,
	appointmentid	CHAR(36) NOT NULL, -- è riferito alla encounters
	currentillnessdate	DATE NOT NULL,
	servicedate	DATE NOT NULL,
	supervisingproviderid	CHAR(36) NOT NULL,   -- FK con providers
	status1	VARCHAR(20) NOT NULL, -- CLOSED o BILLED
	status2	VARCHAR(20),-- CLOSED o BILLED o NULL
	statusp	VARCHAR(20) NOT NULL,
	lastbilleddate1	 DATE NOT NULL,
	lastbilleddate2	DATE ,
	lastbilleddatep	DATE NOT NULL,
	healthcareclaimtypeid1	INT NOT NULL,
	healthcareclaimtypeid2 INT NOT NULL,
	FOREIGN KEY (appointmentid) REFERENCES Encounters(id),
	FOREIGN KEY (providerid) REFERENCES Providers(id),
	FOREIGN KEY (supervisingproviderid) REFERENCES Providers(id)
);

CREATE TABLE Patient_insurance(
	id INT NOT NULL AUTO_INCREMENT,
	claim CHAR(36) NOT NULL,
	insurance CHAR(36) NOT NULL,
	PRIMARY KEY(id),
	FOREIGN KEY (claim) REFERENCES Claims(id),
	FOREIGN KEY (insurance) REFERENCES Payers(id)
)

CREATE TABLE Diagnosis(
    id INT NOT NULL AUTO_INCREMENT,
	claim CHAR(36) NOT NULL,
	reason INT NOT NULL,
	PRIMARY KEY(id),
	FOREIGN KEY (claim) REFERENCES Claims(id),
	FOREIGN KEY (reason) REFERENCES Reasons(code)
)

CREATE TABLE claimsTransaction(
	id CHAR(36) NOT NULL,
	claimid CHAR(36) NOT NULL,
	chargeid INT NOT NULL,
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
	linenote VARCHAR(100),
	patientinsuranceid	CHAR(36), -- probabilmente FK
	feescheduleid INT NOT NULL,
	PRIMARY KEY(id),
	FOREIGN KEY (claimid) REFERENCES Claims(id)
);