CREATE DATABASE wcm_psql_db;
Create TABLE rangers ( 
    ranger_id SERIAL PRIMARY key,
    name VARCHAR(255),
    region VARCHAR(255)
)

Create TABLE species ( 
    species_id SERIAL PRIMARY key,
    common_name VARCHAR(255),
    scientific_name VARCHAR(255),
    discovery_date Date,
    conservation_status VARCHAR(20)
)
Create TABLE sightings ( 
    sighting_id SERIAL PRIMARY key,
    species_id INTEGER REFERENCES species(species_id),
    ranger_id INTEGER REFERENCES rangers(ranger_id),
    location VARCHAR(255),
    sighting_time TIMESTAMP WITHOUT TIME Zone,
    notes TEXT
);


INSERT INTO   rangers (name, region)  values 
('Alice Green', 'Northern Hills'),
('Bob White ', 'River Delta'),
('Carol King', 'Mountain Range');


INSERT INTO   species (common_name, scientific_name, discovery_date, conservation_status)  values 
('Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
('Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
('Red Panda', 'Ailurus fulgens','1825-01-01', 'Vulnerable'),
('Asiatic Elephant', 'Elephas maximus indicus','1758-01-01', 'Endangered');


INSERT INTO   sightings  (sighting_id ,species_id, ranger_id, location, sighting_time, notes)  values 
(1, 1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
(4, 1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);


-- Problem 1:-  Register a new ranger with provided data
-- with name = 'Derek Fox' and region = 'Coastal Plains'
Insert  into  rangers (name, region) values 
('Derek Fox', 'Coastal Plains');

-- Problem 2:- Count unique species ever sighted

Select  count( Distinct species_id) AS unique_species_count from sightings;

-- Problem 3:-  Find all sightings where the location includes "Pass". 

Select * from sightings where location ILIKE ('%Pass');

-- Problem 4:- List each ranger's name and their total number of sightings. 

Select name,count(sighting_time)as total_sightings from rangers 
Join sightings using(ranger_id) GROUP BY name;

-- Problem 5:- List species that have never been sighted.

Select common_name from  species as sp where not EXISTS 
( Select 1 from sightings si where sp.species_id = si.species_id) ;


 -- Problem 6:- Show the most recent 2 sightings.

 Select sp.common_name as common_name, si.sighting_time as sighting_time,
  ra.name as name from rangers as  ra
 join sightings as si using(ranger_id) 
 join species sp using(species_id) 
 Order BY si.sighting_time DESC limit 2;


-- Problem 7:- Update all species discovered before year 1800 to have status 'Historic'

update species set  conservation_status = 'Historic' 
where discovery_date < '1800-01-01';

-- Problem 8:- Label each sighting's time of day as 'Morning', 'Afternoon', or 'Evening'.


Select sighting_id, part_of_day(sighting_time)as time_of_day from sightings;
CREATE Function part_of_day(ts TIMESTAMP)
RETURNS VARCHAR
LANGUAGE plpgsql
AS 
$$
BEGIN
if extract(hour from ts) < 12 then
 return 'Morning';
elseif extract(HOUR from ts) < 17 THEN
return 'Afternoon';
ELSE
RETURN  'Evening';
END IF;
END;
$$;

-- Problem 9:- Delete rangers who have never sighted any species COMMENT


Select common_name from species
 where species_id not in ( select species_id from sightings);

 DELETE from rangers where ranger_id not in 
 ( Select ranger_id from sightings)








