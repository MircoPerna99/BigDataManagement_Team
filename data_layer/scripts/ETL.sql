-- ETL Patients include Patients, Races, Ethnicities, Cities, Counties, States
-- ZIP lasciato a null perché non è fondamentale per la tua analisi o modello predittivo. 
CREATE TEMPORARY TABLE patients_not_cleaned AS
SELECT * FROM BigData.patients;

INSERT INTO BigData_CleanedData.States (Name)
SELECT State 
FROM patients_not_cleaned
group by State;

INSERT INTO BigData_CleanedData.Counties (Name, state)
SELECT REPLACE(p.County, ' County', ''), s.id
FROM patients_not_cleaned p
INNER JOIN BigData_CleanedData.States s
	ON s.Name = p.State
group by s.id, p.county;

INSERT INTO BigData_CleanedData.Cities (Name, county)
SELECT p.city,c.id
FROM patients_not_cleaned p
INNER JOIN BigData_CleanedData.States s
	ON s.Name = p.State
INNER JOIN BigData_CleanedData.Counties c
	ON  c.Name = REPLACE(p.County, ' County', '')
group by c.id, p.city;


INSERT INTO BigData_CleanedData.Races (Name)
SELECT p.race
FROM patients_not_cleaned p
GROUP BY p.race;

INSERT INTO BigData_CleanedData.Ethnicities (Name)
SELECT p.ethnicity
FROM patients_not_cleaned p
GROUP BY p.ethnicity;

INSERT INTO BigData_CleanedData.Patients
(id, birthdate, deathdate, ssn, drivers, passport, prefix, first_name, last_name, suffix, maiden, marital, race, ethnicity, gender, birthplace, address, city, zip, lat, lon, healthcare_expenses, healthcare_coverage)
SELECT p.id, birthdate, deathdate, ssn, IFNULL(NULLIF(drivers, ''), 'UNKNOWN') as drivers,IFNULL(NULLIF(passport, ''), 'UNKNOWN') as passport,IFNULL(NULLIF(prefix, ''), 'NO') as prefix, `first`, `last`, IFNULL(NULLIF(suffix, ''), 'NOONE') as suffix, IFNULL(NULLIF(maiden, ''), 'NOONE') as maiden,IFNULL(NULLIF(marital, ''), '-') as marital, r.id as race, e.id as ethnicity, gender, birthplace, address, ci.id as city, zip, lat, lon, healthcare_expenses, healthcare_coverage
FROM patients_not_cleaned p
INNER JOIN BigData_CleanedData.States s
	ON s.Name = p.State
INNER JOIN BigData_CleanedData.Counties c
	ON c.Name = REPLACE(p.County, ' County', '') and c.state = s.id
INNER JOIN BigData_CleanedData.Cities ci 
	on ci.Name = p.city  and ci.county = c.id
INNER JOIN BigData_CleanedData.Races r 
	ON r.Name = p.race
INNER JOIN BigData_CleanedData.Ethnicities e 
	ON e.Name = p.Ethnicity;

DROP TABLE patients_not_cleaned;




-- ETL Organization
DROP TABLE organizations_not_cleaned;
DROP TABLE temp_massachusetts_cities;
DROP TABLE cities_to_insert;
DROP TABLE cities_and_county_to_insert;
DROP TABLE temp_city_abbreviations;



CREATE TEMPORARY TABLE organizations_not_cleaned AS
SELECT * FROM BigData.Organizations ;

CREATE TEMPORARY TABLE temp_massachusetts_cities (
    city VARCHAR(100),
    county VARCHAR(100)
);

INSERT INTO temp_massachusetts_cities (city, county) VALUES
  ('Alford', 'Berkshire'),
  ('Aquinnah', 'Dukes'),
  ('Abington', 'Plymouth'),
  ('Acton', 'Middlesex'),
  ('Acushnet', 'Bristol'),
  ('Adams', 'Berkshire'),
  ('Agawam', 'Hampden'),
  ('Amesbury', 'Essex'),
  ('Amherst', 'Hampshire'),
  ('Andover', 'Essex'),
  ('Arlington', 'Middlesex'),
  ('Ashburnham', 'Worcester'),
  ('Ashby', 'Middlesex'),
  ('Ashfield', 'Franklin'),
  ('Ashland', 'Middlesex'),
  ('Athol', 'Worcester'),
  ('Attleboro', 'Bristol'),
  ('Auburn', 'Worcester'),
  ('Avon', 'Norfolk'),
  ('Ayer', 'Middlesex'),
  ('Barnstable', 'Barnstable'),
  ('Barre', 'Worcester'),
  ('Becket', 'Berkshire'),
  ('Bedford', 'Middlesex'),
  ('Belchertown', 'Hampshire'),
  ('Bellingham', 'Norfolk'),
  ('Belmont', 'Middlesex'),
  ('Berkley', 'Bristol'),
  ('Berlin', 'Worcester'),
  ('Bernardston', 'Franklin'),
  ('Beverly', 'Essex'),
  ('Billerica', 'Middlesex'),
  ('Blackstone', 'Worcester'),
  ('Blandford', 'Hampden'),
  ('Bolton', 'Worcester'),
  ('Boston', 'Suffolk'),
  ('Boxborough', 'Middlesex'),
  ('Boxford', 'Essex'),
  ('Boylston', 'Worcester'),
  ('Braintree', 'Norfolk'),
  ('Brewster', 'Barnstable'),
  ('Bridgewater', 'Plymouth'),
  ('Brimfield', 'Hampden'),
  ('Brockton', 'Plymouth'),
  ('Brookfield', 'Worcester'),
  ('Brookline', 'Norfolk'),
  ('Buckland', 'Franklin'),
  ('Burlington', 'Middlesex'),
  ('Cambridge', 'Middlesex'),
  ('Canton', 'Norfolk'),
  ('Carlisle', 'Middlesex'),
  ('Carver', 'Plymouth'),
  ('Charlemont', 'Franklin'),
  ('Charlton', 'Worcester'),
  ('Chatham', 'Barnstable'),
  ('Chelmsford', 'Middlesex'),
  ('Chelsea', 'Suffolk'),
  ('Cheshire', 'Berkshire'),
  ('Chester', 'Hampden'),
  ('Chesterfield', 'Hampshire'),
  ('Chicopee', 'Hampden'),
  ('Chilmark', 'Dukes'),
  ('Clarksburg', 'Berkshire'),
  ('Clinton', 'Worcester'),
  ('Cohasset', 'Norfolk'),
  ('Colrain', 'Franklin'),
  ('Concord', 'Middlesex'),
  ('Conway', 'Franklin'),
  ('Cummington', 'Hampshire'),
  ('Dalton', 'Berkshire'),
  ('Danvers', 'Essex'),
  ('Dartmouth', 'Bristol'),
  ('Dedham', 'Norfolk'),
  ('Deerfield', 'Franklin'),
  ('Dennis', 'Barnstable'),
  ('Dighton', 'Bristol'),
  ('Douglas', 'Worcester'),
  ('Dover', 'Norfolk'),
  ('Dracut', 'Middlesex'),
  ('Dudley', 'Worcester'),
  ('Dunstable', 'Middlesex'),
  ('Duxbury', 'Plymouth'),
  ('East Bridgewater', 'Plymouth'),
  ('East Brookfield', 'Worcester'),
  ('East Longmeadow', 'Hampden'),
  ('Eastham', 'Barnstable'),
  ('Easthampton', 'Hampshire'),
  ('Easton', 'Bristol'),
  ('Edgartown', 'Dukes'),
  ('Egremont', 'Berkshire'),
  ('Erving', 'Franklin'),
  ('Essex', 'Essex'),
  ('Everett', 'Middlesex'),
  ('Fairhaven', 'Bristol'),
  ('Fall River', 'Bristol'),
  ('Falmouth', 'Barnstable'),
  ('Fitchburg', 'Worcester'),
  ('Florida', 'Berkshire'),
  ('Foxborough', 'Norfolk'),
  ('Framingham', 'Middlesex'),
  ('Franklin', 'Norfolk'),
  ('Freetown', 'Bristol'),
  ('Gardner', 'Worcester'),
  ('Georgetown', 'Essex'),
  ('Gill', 'Franklin'),
  ('Gloucester', 'Essex'),
  ('Goshen', 'Hampshire'),
  ('Gosnold', 'Dukes'),
  ('Grafton', 'Worcester'),
  ('Granby', 'Hampshire'),
  ('Granville', 'Hampden'),
  ('Great Barrington', 'Berkshire'),
  ('Greenfield', 'Franklin'),
  ('Groton', 'Middlesex'),
  ('Groveland', 'Essex'),
  ('Hadley', 'Hampshire'),
  ('Halifax', 'Plymouth'),
  ('Hamilton', 'Essex'),
  ('Hampden', 'Hampden'),
  ('Hancock', 'Berkshire'),
  ('Hanover', 'Plymouth'),
  ('Hanson', 'Plymouth'),
  ('Hardwick', 'Worcester'),
  ('Harvard', 'Worcester'),
  ('Harwich', 'Barnstable'),
  ('Hatfield', 'Hampshire'),
  ('Haverhill', 'Essex'),
  ('Hawley', 'Franklin'),
  ('Heath', 'Franklin'),
  ('Hingham', 'Plymouth'),
  ('Hinsdale', 'Berkshire'),
  ('Holbrook', 'Norfolk'),
  ('Holden', 'Worcester'),
  ('Holland', 'Hampden'),
  ('Holliston', 'Middlesex'),
  ('Holyoke', 'Hampden'),
  ('Hopedale', 'Worcester'),
  ('Hopkinton', 'Middlesex'),
  ('Hubbardston', 'Worcester'),
  ('Hudson', 'Middlesex'),
  ('Hull', 'Plymouth'),
  ('Huntington', 'Hampshire'),
  ('Ipswich', 'Essex'),
  ('Indian Orchard','Hampden'),
  ('Kingston', 'Plymouth'),
  ('Lakeville', 'Plymouth'),
  ('Lancaster', 'Worcester'),
  ('Lanesborough', 'Berkshire'),
  ('Lawrence', 'Essex'),
  ('Lee', 'Berkshire'),
  ('Leicester', 'Worcester'),
  ('Lenox', 'Berkshire'),
  ('Leominster', 'Worcester'),
  ('Leverett', 'Franklin'),
  ('Lexington', 'Middlesex'),
  ('Leyden', 'Franklin'),
  ('Lincoln', 'Middlesex'),
  ('Littleton', 'Middlesex'),
  ('Longmeadow', 'Hampden'),
  ('Lowell', 'Middlesex'),
  ('Ludlow', 'Hampden'),
  ('Lunenburg', 'Worcester'),
  ('Lynn', 'Essex'),
  ('Lynnfield', 'Essex'),
  ('Malden', 'Middlesex'),
  ('Manchester-by-the-Sea', 'Essex'),
  ('Mansfield', 'Bristol'),
  ('Marblehead', 'Essex'),
  ('Marion', 'Plymouth'),
  ('Marlborough', 'Middlesex'),
  ('Marshfield', 'Plymouth'),
  ('Mashpee', 'Barnstable'),
  ('Mattapoisett', 'Plymouth'),
  ('Maynard', 'Middlesex'),
  ('Medfield', 'Norfolk'),
  ('Medford', 'Middlesex'),
  ('Medway', 'Norfolk'),
  ('Melrose', 'Middlesex'),
  ('Mendon', 'Worcester'),
  ('Merrimac', 'Essex'),
  ('Methuen', 'Essex'),
  ('Middleborough', 'Plymouth'),
  ('Middlefield', 'Hampshire'),
  ('Middleton', 'Essex'),
  ('Milford', 'Worcester'),
  ('Millbury', 'Worcester'),
  ('Millis', 'Norfolk'),
  ('Millville', 'Worcester'),
  ('Milton', 'Norfolk'),
  ('Monroe', 'Franklin'),
  ('Monson', 'Hampden'),
  ('Montague', 'Franklin'),
  ('Monterey', 'Berkshire'),
  ('Montgomery', 'Hampden'),
  ('Mount Washington', 'Berkshire'),
  ('Nahant', 'Essex'),
  ('Nantucket', 'Nantucket'),
  ('Natick', 'Middlesex'),
  ('Needham', 'Norfolk'),
  ('New Ashford', 'Berkshire'),
  ('New Bedford', 'Bristol'),
  ('New Braintree', 'Worcester'),
  ('New Marlborough', 'Berkshire'),
  ('New Salem', 'Franklin'),
  ('Newbury', 'Essex'),
  ('Newburyport', 'Essex'),
  ('Newton', 'Middlesex'),
  ('Norfolk', 'Norfolk'),
  ('North Adams', 'Berkshire'),
  ('Northampton', 'Hampshire'),
  ('North Andover', 'Essex'),
  ('North Attleborough', 'Bristol'),
  ('Northborough', 'Worcester'),
  ('Northbridge', 'Worcester'),
  ('North Brookfield', 'Worcester'),
  ('Northfield', 'Franklin'),
  ('Norton', 'Bristol'),
  ('Norwell', 'Plymouth'),
  ('Norwood', 'Norfolk'),
  ('Oak Bluffs', 'Dukes'),
  ('Oakham', 'Worcester'),
  ('Orange', 'Franklin'),
  ('Orleans', 'Barnstable'),
  ('Otis', 'Berkshire'),
  ('Oxford', 'Worcester'),
  ('Palmer', 'Hampden'),
  ('Paxton', 'Worcester'),
  ('Peabody', 'Essex'),
  ('Pelham', 'Hampshire'),
  ('Pembroke', 'Plymouth'),
  ('Pepperell', 'Middlesex'),
  ('Peru', 'Berkshire'),
  ('Petersham', 'Worcester'),
  ('Phillipston', 'Worcester'),
  ('Pittsfield', 'Berkshire'),
  ('Plainfield', 'Hampshire'),
  ('Plainville', 'Norfolk'),
  ('Plymouth', 'Plymouth'),
  ('Plympton', 'Plymouth'),
  ('Princeton', 'Worcester'),
  ('Provincetown', 'Barnstable'),
  ('Quincy', 'Norfolk'),
  ('Randolph', 'Norfolk'),
  ('Raynham', 'Bristol'),
  ('Reading', 'Middlesex'),
  ('Rehoboth', 'Bristol'),
  ('Revere', 'Suffolk'),
  ('Richmond', 'Berkshire'),
  ('Rochester', 'Plymouth'),
  ('Rockland', 'Plymouth'),
  ('Rockport', 'Essex'),
  ('Rowe', 'Franklin'),
  ('Rowley', 'Essex'),
  ('Royalston', 'Worcester'),
  ('Russell', 'Hampden'),
  ('Rutland', 'Worcester'),
  ('Salem', 'Essex'),
  ('Salisbury', 'Essex'),
  ('Sandisfield', 'Berkshire'),
  ('Sandwich', 'Barnstable'),
  ('Saugus', 'Essex'),
  ('Savoy', 'Berkshire'),
  ('Scituate', 'Plymouth'),
  ('Seekonk', 'Bristol'),
  ('Sharon', 'Norfolk'),
  ('Sheffield', 'Berkshire'),
  ('Shelburne', 'Franklin'),
  ('Sherborn', 'Middlesex'),
  ('Shirley', 'Middlesex'),
  ('Shrewsbury', 'Worcester'),
  ('Shutesbury', 'Franklin'),
  ('Somerset', 'Bristol'),
  ('Somerville', 'Middlesex'),
  ('Southampton', 'Hampshire'),
  ('Southborough', 'Worcester'),
  ('Southbridge', 'Worcester'),
  ('South Hadley', 'Hampshire'),
  ('Southwick', 'Hampden'),
  ('Spencer', 'Worcester'),
  ('Springfield', 'Hampden'),
  ('Sterling', 'Worcester'),
  ('Stockbridge', 'Berkshire'),
  ('Stoneham', 'Middlesex'),
  ('Stoughton', 'Norfolk'),
  ('Stow', 'Middlesex'),
  ('Sturbridge', 'Worcester'),
  ('Sudbury', 'Middlesex'),
  ('Sunderland', 'Franklin'),
  ('Sutton', 'Worcester'),
  ('Swampscott', 'Essex'),
  ('Swansea', 'Bristol'),
  ('Taunton', 'Bristol'),
  ('Templeton', 'Worcester'),
  ('Tewksbury', 'Middlesex'),
  ('Tisbury', 'Dukes'),
  ('Tolland', 'Hampden'),
  ('Topsfield', 'Essex'),
  ('Townsend', 'Middlesex'),
  ('Truro', 'Barnstable'),
  ('Tyngsborough', 'Middlesex'),
  ('Tyringham', 'Berkshire'),
  ('Upton', 'Worcester'),
  ('Uxbridge', 'Worcester'),
  ('Wakefield', 'Middlesex'),
  ('Wales', 'Hampden'),
  ('Walpole', 'Norfolk'),
  ('Waltham', 'Middlesex'),
  ('Ware', 'Hampshire'),
  ('Wareham', 'Plymouth'),
  ('Warren', 'Worcester'),
  ('Warwick', 'Franklin'),
  ('Washington', 'Berkshire'),
  ('Watertown', 'Middlesex'),
  ('Wayland', 'Middlesex'),
  ('Webster', 'Worcester'),
  ('Wellesley', 'Norfolk'),
  ('Wellfleet', 'Barnstable'),
  ('Wendell', 'Franklin'),
  ('Wenham', 'Essex'),
  ('Westborough', 'Worcester'),
  ('West Boylston', 'Worcester'),
  ('West Bridgewater', 'Plymouth'),
  ('West Brookfield', 'Worcester'),
  ('Westfield', 'Hampden'),
  ('Westford', 'Middlesex'),
  ('Westhampton', 'Hampshire'),
  ('Westminster', 'Worcester'),
  ('West Newbury', 'Essex'),
  ('Westport', 'Bristol'),
  ('West Springfield', 'Hampden'),
  ('West Stockbridge', 'Berkshire'),
  ('West Tisbury', 'Dukes'),
  ('Westwood', 'Norfolk'),
  ('Weymouth', 'Norfolk'),
  ('Whately', 'Franklin'),
  ('Whitman', 'Plymouth'),
  ('Wilbraham', 'Hampden'),
  ('Williamsburg', 'Hampshire'),
  ('Williamstown', 'Berkshire'),
  ('Wilmington', 'Middlesex'),
  ('Winchendon', 'Worcester'),
  ('Winchester', 'Middlesex'),
  ('Windsor', 'Berkshire'),
  ('Winthrop', 'Suffolk'),
  ('Woburn', 'Middlesex'),
  ('Worcester', 'Worcester'),
  ('Worthington', 'Hampshire'),
  ('Wrentham', 'Norfolk'),
  ('Yarmouth', 'Barnstable'),
('Shelburne Falls','Franklin'),
('North Falmouth','Barnstable'),
('East Wareham','Plymouth'),
('South Attleboro','Bristol'),
('West Wareham','Plymouth')
;

CREATE TEMPORARY TABLE temp_city_abbreviations (
    short_name VARCHAR(100),
    full_name VARCHAR(100)
);

INSERT INTO temp_city_abbreviations (short_name, full_name) VALUES
  ('W CONCORD', 'Concord'),
  ('INDIAN ORCHARD', 'Springfield'),
  ('MARSTONS MILLS', 'Barnstable'),
  ('NORTH DARTMOUTH', 'Dartmouth'),
  ('SOUTH DARTMOUTH', 'Dartmouth'),
  ('EAST BOSTON', 'Boston'),
  ('FEEDING HILLS', 'Agawam'),
  ('JAMAICA PLAIN', 'Boston'),
  ('SOUTH WEYMOUTH', 'Weymouth'),
  ('BRIGHTON', 'Boston'),
  ('E SANDWICH', 'Sandwich'),
  ('EAST WAREHAM', 'Wareham'),
  ('DORCHESTER', 'Boston'),
  ('SOUTH ATTLEBORO', 'Attleboro'),
  ('MIDDLEBORO', 'Middleborough'),
  ('WABAN', 'Newton'),
  ('HYANNIS', 'Barnstable'),
  ('BRADFORD', 'Haverhill'),
  ('WELLESLEY HILLS', 'Wellesley'),
  ('FOXBORO', 'Foxborough'),
  ('POCASSET', 'Bourne'),
  ('WESTBORO', 'Westborough'),
  ('SAGAMORE BEACH', 'Bourne'),
  ('SHELBURNE FLS', 'Shelburne Falls'),
  ('ROSLINDALE', 'Boston'),
  ('WEST WAREHAM', 'Wareham'),
  ('NO FALMOUTH', 'Falmouth'),
  ('W SPRINGFIELD', 'Springfield'),
  ('N ADAMS', 'Adams'),
  ('S ATTLEBORO', 'Attleboro'),
  ('FLORENCE', 'Northampton'),
  ('TEATICKET', 'Falmouth'),
  ('PITTSFILED', 'Pittsfield'),
  ('CEDARVILLE', 'Plymouth'),
  ('WEST ROXBURY', 'Boston'),
  ('FISKDALE', 'Sturbridge'),
  ('CENTERVILLE', 'Barnstable'),
  ('BALDWINVILLE', 'Templeton'),
  ('HARWICH PORT', 'Harwich'),
  ('Leeds', 'Northampton'),
  ('NORTH ATTLEBORO', 'North Attleborough'),
  ('S YARMOUTH', 'South Yarmouth'),
  ('SOUTHBORO', 'Southborough'),
  ('HYDE PARK', 'Boston'),
  ('DENNIS PORT', 'Dennis'),
  ('EAST HARWICH', 'Harwich'),
  ('MARLBORO', 'Marlborough'),
  ('W WAREHAM', 'Wareham'),
  ('E WAREHAM', 'Wareham'),
  ('SHELBURNE FALLS', 'Shelburne Falls');



CREATE TEMPORARY TABLE cities_to_insert AS
	SELECT CONCAT(UCASE(SUBSTRING(n.city, 1, 1)), LOWER(SUBSTRING(n.city, 2))) AS city
	FROM(
			SELECT CASE
				    WHEN t.short_name is null  THEN o.city
				    ELSE t.full_name
				END as city
			FROM organizations_not_cleaned o 
			LEFT JOIN temp_city_abbreviations t
			ON o.city = t.short_name
	) as n
	where CONCAT(UCASE(SUBSTRING(n.city, 1, 1)), LOWER(SUBSTRING(n.city, 2))) not in 
	(
	SELECT c.name FROM BigData_CleanedData.Cities c
	);

	

CREATE TEMPORARY TABLE cities_and_county_to_insert AS
SELECT c.city, mc.county
FROM cities_to_insert c
INNER JOIN temp_massachusetts_cities mc
	on mc.city = c.city
group by c.city, mc.county


INSERT INTO BigData_CleanedData.Counties (Name, state)
SELECT t.county , 1
FROM cities_and_county_to_insert t
LEFT JOIN  BigData_CleanedData.Counties c
	ON t.county = c.name
WHERE c.name is null
GROUP  BY t.county;


INSERT INTO BigData_CleanedData.Cities (Name, county)
SELECT t.city , c.id
FROM cities_and_county_to_insert t
INNER JOIN  BigData_CleanedData.Counties c
	ON t.county = c.name
LEFT JOIN BigData_CleanedData.Cities ci
	ON t.city = ci.name
where ci.name is null
GROUP  BY t.city,c.id;

INSERT INTO BigData_CleanedData.Organizations
(id, name, address, city, zip_code, lat, lon, phone, revenue, utilization)
SELECT o.id, o.name, address, c.id as city , zip, lat, lon, phone, revenue, utilization 
FROM BigData.organizations o
LEFT JOIN temp_city_abbreviations t 
	ON  o.city = t.short_name
INNER JOIN BigData_CleanedData.Cities c 
	ON c.Name =  o.city or  c.Name  = t.full_name
GROUP BY o.id, o.name, address, c.id, zip, lat, lon, phone, revenue, utilization;


-- ETL PROVIDERS
select count(*)
from BigData.providers p

CREATE TEMPORARY TABLE providers_not_cleaned AS
SELECT * FROM BigData.providers ;


INSERT INTO BigData_CleanedData.Specialities (name) 
SELECT speciality
FROM providers_not_cleaned
GROUP BY speciality


--5056

INSERT INTO BigData_CleanedData.Providers
(id, organization, first_name, last_name, gender, speciality, address, city, zip_code, lat, lon, utilization)
SELECT p.id, p.organization,     REGEXP_SUBSTR(SUBSTRING_INDEX(p.name, ' ', 1), '[A-Za-z]+') as first_name,    REGEXP_SUBSTR(SUBSTRING_INDEX(p.name, ' ', -1), '[A-Za-z]+')  as last_name, gender, s.id as speciality ,address, c.id as city , zip, lat, lon, utilization 
FROM BigData.providers p 
INNER JOIN BigData_CleanedData.Specialities s
	ON s.Name = p.speciality 
LEFT JOIN temp_city_abbreviations t 
	ON  p.city = t.short_name
INNER JOIN BigData_CleanedData.Cities c 
	ON c.Name =  p.city or  c.Name  = t.full_name
GROUP BY p.id, p.organization,first_name,last_name, gender, s.id,address, c.id, zip, lat, lon, utilization 

