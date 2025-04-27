-- domanda uno
SELECT p.code , 
       COUNT(*) AS procedure_count,
       AVG(p.base_cost) AS avg_cost,
       SUM(p.base_cost) AS total_cost
FROM encounters e 
INNER JOIN procedures p ON e.id = p.encounter
WHERE p.start BETWEEN '2021-01-01' AND '2021-12-31'
GROUP  by  p.code
order by total_cost desc;


-- Domanda due
select c.reasoncode, c.reasondescription, count(*) as condiotion_count
from encounters e 
inner join careplans c on e.id = c.encounter
WHERE e.start BETWEEN '2021-01-01' AND '2021-12-31'
group by c.reasoncode, c.reasondescription 
order by condiotion_count desc



-- Domanda tre
select c.reasoncode, c.reasondescription,round(avg(TIMESTAMPDIFF(YEAR, p.birthdate, CURDATE()))) as eta_media
from encounters e 
inner join careplans c on e.id = c.encounter
inner join patients p on p.id  = e.patient
WHERE e.start BETWEEN '2021-01-01' AND '2021-12-31'
group by c.reasoncode, c.reasondescription 

-- Domanda quattro
SELECT  a.code, a.description, p.gender, count(*) as frequency
FROM allergies a 
INNER JOIN patients p 
	ON a.patient = p.id
GROUP BY a.code, a.description, p.gender
ORDER BY frequency desc

-- Domanda 5
SELECT ab.code, ab.description, ab.fascia_eta, count(*)
FROM(
SELECT i.*,  CASE
			    WHEN TIMESTAMPDIFF(YEAR, p.birthdate , CURDATE()) < 9 THEN 0
			    WHEN TIMESTAMPDIFF(YEAR, p.birthdate, CURDATE()) BETWEEN 10 AND 19 THEN 1
			    WHEN TIMESTAMPDIFF(YEAR, p.birthdate, CURDATE()) BETWEEN 20 AND 29 THEN 2
			    WHEN TIMESTAMPDIFF(YEAR, p.birthdate, CURDATE()) BETWEEN 30 AND 39 THEN 3
			    WHEN TIMESTAMPDIFF(YEAR, p.birthdate, CURDATE()) BETWEEN 40 AND 49 THEN 4
			    WHEN TIMESTAMPDIFF(YEAR, p.birthdate, CURDATE()) BETWEEN 50 AND 59 THEN 5
			    WHEN TIMESTAMPDIFF(YEAR, p.birthdate, CURDATE()) BETWEEN 60 AND 69 THEN 6
			    WHEN TIMESTAMPDIFF(YEAR, p.birthdate, CURDATE()) BETWEEN 70 AND 79 THEN 7
			    WHEN TIMESTAMPDIFF(YEAR, p.birthdate, CURDATE()) BETWEEN 80 AND 89 THEN 8
			    ELSE 9
  END AS fascia_eta
FROM immunizations i 
INNER JOIN patients p ON i.patient = p.id
) AS ab
group by ab.code, ab.description, ab.fascia_eta
order by ab.code

-- Domanda 6
SELECT c.reasoncode, c.description, ROUND(AVG(DATEDIFF(c.stop  , c.`start`))) AS giorni_diff
FROM careplans c
WHERE c.`start` BETWEEN '2021-01-01' AND '2021-12-31' AND c.stop is not null
GROUP BY c.reasoncode, c.description


-- Domanda 7
SELECT  o.id,o.name, c.reasoncode, c.reasondescription, count(*) as amount
FROM organizations o 
INNER JOIN encounters e ON e.organization = o.id
INNER JOIN careplans c ON c.encounter = e.id
WHERE e.`start` BETWEEN '2021-01-01' AND '2021-12-31'
GROUP BY o.id,o.name, c.reasoncode, c.reasondescription 
order by o.id, amount  


-- Domande 8
SELECT t.id, t.name, t.gender,t.fascia_eta, count(*) as amount
FROM(
SELECT  o.id, 
		o.name, 
		p.gender,   
         CASE
			    WHEN TIMESTAMPDIFF(YEAR, p.birthdate , CURDATE()) < 9 THEN 0
			    WHEN TIMESTAMPDIFF(YEAR, p.birthdate, CURDATE()) BETWEEN 10 AND 19 THEN 1
			    WHEN TIMESTAMPDIFF(YEAR, p.birthdate, CURDATE()) BETWEEN 20 AND 29 THEN 2
			    WHEN TIMESTAMPDIFF(YEAR, p.birthdate, CURDATE()) BETWEEN 30 AND 39 THEN 3
			    WHEN TIMESTAMPDIFF(YEAR, p.birthdate, CURDATE()) BETWEEN 40 AND 49 THEN 4
			    WHEN TIMESTAMPDIFF(YEAR, p.birthdate, CURDATE()) BETWEEN 50 AND 59 THEN 5
			    WHEN TIMESTAMPDIFF(YEAR, p.birthdate, CURDATE()) BETWEEN 60 AND 69 THEN 6
			    WHEN TIMESTAMPDIFF(YEAR, p.birthdate, CURDATE()) BETWEEN 70 AND 79 THEN 7
			    WHEN TIMESTAMPDIFF(YEAR, p.birthdate, CURDATE()) BETWEEN 80 AND 89 THEN 8
			    ELSE 9
		END AS fascia_eta
FROM organizations o 
INNER JOIN encounters e ON e.organization = o.id
INNER JOIN patients p ON p.id = e.patient
WHERE e.`start` BETWEEN '2016-01-01' AND '2021-12-31'
) as t
GROUP BY t.id, t.name, t.gender,t.fascia_eta
order by t.id, amount desc

-- Domanda 9
SELECT p.id, p.name, sum(e.payer_coverage) AS amount_coverage
FROM payers p
INNER JOIN encounters e 
	ON e.payer  = p.id
WHERE e.`start` BETWEEN '2016-01-01' AND '2021-12-31'
GROUP BY p.id, p.name
ORDER BY amount_coverage desc


-- Domanda 10
SELECT p.id, p.Name, t.fascia_eta, count(*)
FROM Organizations o 
INNER JOIN providers p 
	ON p.organization = o.id
INNER JOIN (SELECT  e.provider,
         CASE
			    WHEN TIMESTAMPDIFF(YEAR, p.birthdate , CURDATE()) < 9 THEN 0
			    WHEN TIMESTAMPDIFF(YEAR, p.birthdate, CURDATE()) BETWEEN 10 AND 19 THEN 1
			    WHEN TIMESTAMPDIFF(YEAR, p.birthdate, CURDATE()) BETWEEN 20 AND 29 THEN 2
			    WHEN TIMESTAMPDIFF(YEAR, p.birthdate, CURDATE()) BETWEEN 30 AND 39 THEN 3
			    WHEN TIMESTAMPDIFF(YEAR, p.birthdate, CURDATE()) BETWEEN 40 AND 49 THEN 4
			    WHEN TIMESTAMPDIFF(YEAR, p.birthdate, CURDATE()) BETWEEN 50 AND 59 THEN 5
			    WHEN TIMESTAMPDIFF(YEAR, p.birthdate, CURDATE()) BETWEEN 60 AND 69 THEN 6
			    WHEN TIMESTAMPDIFF(YEAR, p.birthdate, CURDATE()) BETWEEN 70 AND 79 THEN 7
			    WHEN TIMESTAMPDIFF(YEAR, p.birthdate, CURDATE()) BETWEEN 80 AND 89 THEN 8
			    ELSE 9
		END AS fascia_eta
FROM encounters e 
INNER JOIN patients p ON p.id = e.patient
WHERE e.`start` BETWEEN '2016-01-01' AND '2021-12-31'
) as t  ON t.provider = p.id
WHERE p.speciality = 'GENERAL PRACTICE' and o.name like 'PCP%'
GROUP BY p.id, p.Name, t.fascia_eta
order by p.id 




